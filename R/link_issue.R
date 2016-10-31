#' Linking issues in commit messages
#' 
#' Trac ticket IDs are often referenced in git commit messages as e.g. \code{#123}.
#' Assuming that tickets have been converted to issues and pushed to GitHub this function
#' can be used in a script with \code{git filter-branch} to rewrite commit messages
#' and replacing ticket references with issue references.
#' 
#' @param ticket_id character string of the form \code{#123}
#' @param db data frame mapping tickets to issues, see Details
#' 
#' @details
#' The data frame must contain columns \code{trac_ticket_id} and
#' \code{gh_issue_number} containing Trac ticket ID and corresponding GH issue
#' number.
#' 
#' If the \code{ticket_id} number is found in \code{db} it is replaced with a
#' string \code{#XXX} where \code{XXX} is the corresponding issue number.
#' Original Trac ticket ID is also displayed in square brackets. If
#' \code{ticket_id} is not found in \code{db}, the original reference is
#' replaced with trac ticket info in square brackets.
#' 
#' @return 
#' String with ticket reference replaced with GH reference (if found in
#' \code{db}).
#' 
#' @export

link_issue <- function(ticket_id, db=issues) {
  stopifnot("trac_ticket_id" %in% names(db))
  stopifnot("gh_issue_number" %in% names(db))
  ticket_id <- as.numeric( gsub("#", "", ticket_id) )
  known <- ticket_id %in% db$trac_ticket_id
  if(known) {
    s <- subset(db, trac_ticket_id == ticket_id)
    rval <- paste0(
      "#", s$gh_issue_number[1], " ",
      "[Trac:", ticket_id, "]"
    )
  } else {
    rval <- paste0(
      "[Trac:", ticket_id, "]"
    )
  }
  rval
}
