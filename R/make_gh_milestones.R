#' Create data for GitHub milestones
#' 
#' @param object R object, currently only a method for data frames
#' @param ... other arguments
#' 
#' @details
#' \code{make_gh_milestones} is a generic function that transforms supplied data
#' to structure and format necessary for creating milestones on GitHub.
#' 
#' @family Github converters
#' 
#' 
#' @export
make_gh_milestones <- function(object, ...) UseMethod("make_gh_milestones")



#' @rdname make_gh_milestones
#' @export
make_gh_milestones.default <- function(object, ...) {
  stop("dont know how to handle class:", paste(class(object), collapse=", "))  
}

#' @rdname make_gh_milestones
#' 
#' @details
#' \code{make_gh_milestones} method for data frames assumes that \code{object}
#' contains Trac milestone metadata in columns as returned by
#' \code{\link{get_trac_milestones}}.
#' 
#' @return
#' \code{make_gh_milestones} returns a data frame with columns
#' \code{gh_milestone_*} with \code{*} as:
#' \item{title}{milestone title}
#' \item{description}{milestone description}
#' \item{due_on}{milestone due date}
#' \item{state}{milestone status, either "open" or "closed"}
#' 
#' @seealso \code{\link{gh_milestone_formatters}}
#' 
#' @export
make_gh_milestones.data.frame <- function(object, ...) {
  vnames <- paste0(
    "trac_milestone_",
    c("name", "description", "url", "due_date")
  )
  vok <- vnames %in% names(object)
  if(any(!vok))
    stop("variables not found: ", paste(vnames[!vok], collapse=", "))
  dplyr::mutate_(object,
          gh_milestone_title = ~gh_milestone_title(trac_milestone_name),
          gh_milestone_description = ~gh_milestone_description(
            trac_milestone_description, 
            trac_milestone_url, 
            trac_milestone_name),
          gh_milestone_due_on = ~gh_milestone_due_on(trac_milestone_due_date),
          gh_milestone_state = ~gh_milestone_state(trac_milestone_status)
  )
}