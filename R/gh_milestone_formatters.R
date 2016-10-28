#' GitHub milestone formatters
#' 
#' Functions formatting GitHub milestone data. They are vectorized so multiple
#' milestones can be processed.
#' 
#' @return
#' Unless otherwise noted, all function return character vectors.
#' 
#' @aliases gh_milestone_formatters




#' @rdname gh_milestone_formatters
#' 
#' @param title milestone title
#' 
#' @export
gh_milestone_title <- function(title) title





#' @rdname gh_milestone_formatters
#' 
#' @param description character, milestone description
#' @param url character, milestone URL in Trac
#' @param ... other arguments passed to/from other methods
#' 
#' @details
#' \code{gh_milestone_description} creates milestone description for GH by
#' concatenating Trac milestone description with Trac milestone URL.
#' 
#' @export
gh_milestone_description <- function(description, url, title, ...) {
  stopifnot( length(description) == length(url) )
  ifelse( is.na(description),
          trac_link_milestone(name=title, ...),
          paste(
            description, 
            trac_link_milestone(name=title, ...),
            sep="\r\n\r\n"
          )
  )
}  


#' @rdname gh_milestone_formatters
#' 
#' @param due_date character, milestone due date
#' 
#' @export

gh_milestone_due_on <- function(due_date) {
  structure( ifelse( is.na(due_date), "", due_date ),
             class = class(due_date) )
}

#' @rdname gh_milestone_formatters
#' 
#' @param state character, milestone state
#' 
#' @export
gh_milestone_state <- function(state) state











trac_link_milestone <- function(name, type=c("text", "shield"),
                                link_text = "View milestone on Trac",
                                base_url=getOption("trac2gh.base_url")) {
  type <- match.arg(type)
  url <- api_url(base_url, path=c("milestone", utils::URLencode(name)))
  switch(
    type,
    
    text = md_link( text=paste0("[", link_text, "]"), url=url),
    
    shield = paste0(
      "[![",
      "Trac milestone link",
      "](",
      httr::modify_url(
        "https://img.shields,io",
        path=utils::URLencode(paste("Trac Milestone", name, "blue.svg", sep="-"))
      ),
      ")](",
      url,
      ")"
    )
  )
}
