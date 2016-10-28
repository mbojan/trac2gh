#' Create data for GitHub issues
#' 
#' @param object R object, currently only a method for data frames
#' @param ... other arguments
#' 
#' @details
#' \code{make_gh_issues} is a generic function that transforms supplied data
#' to structure and format necessary for creating issues on GitHub.
#' 
#' @family Github converters
#' 
#' @export
make_gh_issues <- function(object, ...) UseMethod("make_gh_issues")




#' @rdname make_gh_issues
#' @export
make_gh_issues.default <- function(object, ...) {
  stop("dont know how to handle class:", paste(class(object), collapse=", "))  
}




#' @rdname make_gh_issues
#' 
#' @param milestones data frame as returned by \code{\link{make_gh_milestones}}
#' 
#' @details
#' \code{make_gh_issues} method for data frames assumes that \code{object} contains
#' Trac ticket metadata in columns as returned by \code{\link{get_trac_tickets}}.
#' 
#' @return
#' \code{make_gh_issues} returns a data frame with columns \code{gh_issue_*} with \code{*} as:
#' \item{title}{issue title}
#' \item{body}{issue body}
#' \item{milestone}{milestone number}
#' \item{label}{list column with vectors of issue labels}
#' 
#' @seealso \code{\link{gh_issue_formatters}}
#' 
#' @export
make_gh_issues.data.frame <- function(object, milestones, ...) {
  # Check variables
  vnames <- paste0(
    "trac_ticket_",
    c("id", "description", "reporter", "owner", "time", "changetime", "type", 
      "priority", "keywords")
  )
  vok <- vnames %in% names(object)
  if(any(!vok))
    stop("variables not found: ", paste(vnames[!vok], collapse=", "))
  
  # Merge with milestones db
  tickets <- object %>%
    left_join( 
      select_(milestones, ~gh_milestone_title, ~gh_milestone_number),
      by = c("trac_ticket_milestone"="gh_milestone_title")
    )
  
  # Transform
  mutate_(tickets,
    gh_issue_title = ~gh_issue_title(
      id=trac_ticket_id, 
      summary=trac_ticket_summary
    ),
    gh_issue_body = ~gh_issue_body(
      id=trac_ticket_id, 
      description=trac_ticket_description, 
      reporter=trac_ticket_reporter, 
      owner=trac_ticket_owner, 
      time=trac_ticket_time, 
      changetime=trac_ticket_changetime, 
      type=trac_ticket_type, 
      priority=trac_ticket_priority, 
      keywords=trac_ticket_keywords
    ),
    gh_issue_milestone = ~gh_issue_milestone(number=gh_milestone_number),
    gh_issue_label = ~gh_issue_labels(type=trac_ticket_type, priority=trac_ticket_priority)
  )
  
}

