#' GitHub issue formatters
#' 
#' Functions formatting GitHub issue data. They are vectorized so multiple
#' tickets can be processed.
#' 
#' @aliases gh_issue_formatters



#' @rdname gh_issue_formatters
#' 
#' @param id,description,reporter,owner,time,changetime,keywords 
#'        character Trac ticket metadata
#' 
#' @details
#' Function \code{gh_issue_body} creates the GH issue body based on Trac ticket 
#' description and other metadata. The text is transformed from MoinMoin wiki 
#' markup to Markdown using a rather rudimentary parser 
#' \code{\link{moinmoin_to_markdown}}. The body is prepended with a "header"
#' containing original metadata from Trac.
#' 
#' @return
#' \code{gh_issue_body} returns a character vector with issue body in Markdown.
#'
#'@export

gh_issue_body <- function(id, description, reporter, owner, time, changetime, type, priority, keywords) {
  # Convert description to markdown
  md <- strsplit(description, "\n", perl=TRUE) %>%
    lapply(moinmoin_to_markdown) %>%
    lapply(paste, collapse="\r\n")
  # Paste with metadata header
  paste0(
    "Trac metadata:\r\n",
    "ID: ", id, "\r\n",
    "URL: ", trac_link_ticket(id), "\r\n",
    "Owner: ", owner, "\r\n",
    "Reporter: ", reporter, "\r\n",
    "Opened: ", as.character(time), "\r\n",
    "Last modified: ", as.character(changetime), "\r\n",
    "Type: ", type, "\r\n",
    "Priority: ", priority, "\r\n",
    "Keywords: ", keywords, "\r\n",
    "\r\n",
    md
  )
}


#' @rdname gh_issue_formatters
#' 
#' @param summary character, Trac ticket summary (aka title)
#' 
#' @details
#' \code{gh_issue_title} creates issue title from Trac ticket summary prepending
#' Trac ticket id in square brackets.
#' 
#' @return
#' \code{gh_issue_title} returns a formatted issue title composed of original ticket
#' summary and id.
#' 
#' @export

gh_issue_title <- function(id, summary) {
  paste0(
    "[Trac:", id, "] ",
    summary
  )
}


#' @rdname gh_issue_formatters
#' 
#' @param number GH issue number
#' 
#' @export
gh_issue_milestone <- function(number) number



#' @rdname gh_issue_formatters
#' 
#' @param type,priority character, Trac ticket type and priority
#' 
#' @details
#' \code{gh_issue_labels} creates labels based on Trac ticket priority and type.
#' Label names are have a format \code{p:foo} and \code{t:bar} for tickets
#' of priority "foo" and type "bar".
#' 
#' @return
#' \code{gh_issue_labels} returns a list of labels for every ticket.
#' 
#' @export

gh_issue_labels <- function(type, priority) {
  stopifnot(length(type) == length(priority))
  veclist(
    paste0("t:", type),
    paste0("p:", priority)
  )
}






#' @rdname gh_issue_formatters
#' 
#' @param base_url character, base URL to Trac instance
#' 
#' @details
#' \code{trac_link_ticket} creates URL to a ticket on Trac.
#' 
#' @return
#' \code{trac_link_ticket} returns a vector of URLs.
#' 
#' @export

trac_link_ticket <- function(id, base_url=getOption("trac2gh.base_url")) {
  vapply( 
    id, 
    function(i) api_url(base_url, path=c("ticket", i)),
    character(1)
  )
}
