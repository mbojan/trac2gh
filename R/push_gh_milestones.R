#' Push milestones to GH
#' 
#' @param object R object, see Details for methods
#' @param owner,repo repository and its owner, passed to \code{\link{create.milestone}}
#' @param ... other arguments passed to \code{\link{create.milestone}}, \code{ctx} in particular
#' @param verbose logical, provide more output
#' @param sleep numeric, passed to \code{\link{Sys.sleep}}, pause between requests
#' 
#' @export

push_gh_milestones <- function(object, ...) UseMethod("push_gh_milestones")


#' @rdname push_gh_milestones
#' 
#' @details
#' Method for data frames make requests to GH API. The milestones are created
#' with data from columns of \code{object}. It is assumed, and checked, if the
#' \code{object} has columns \code{gh_milestone_*} where \code{*} are: title,
#' description, state, due_on.
#' 
#' @return
#' The method for data frames return \code{object} with the following columns added:
#' \item{push_response}{list with responses returned by \code{\link{create.milestone}}}
#' \item{push_ok}{logical, whether the request was succesfully processed}
#' \item{gh_milestone_number}{numerical, milestone number as assigned by GH}
#' 
#' 
#' @export
push_gh_milestones.data.frame <- function(object, owner, repo, ..., verbose=TRUE, sleep=1) {
  # Check variables
  vnames <- paste0(
    "gh_milestone_", 
    c("title", "description", "state", "due_on")
  )
  ok <- vnames %in% names(object)
  if(any(!ok))
    stop("variables not found: ", paste(vnames[!ok], collapse=", "))
  
  # Push
  resplist <- lapply(
    seq(1, nrow(object)),
    function(i) {
      if(verbose) cat("Pushing milestone", sQuote(object$gh_milestone_title[i]), "... ")
      # Request content
      k <- list(
        title = object$gh_milestone_title[i],
        state = object$gh_milestone_state[i],
        description = object$gh_milestone_description[i],
        due_on = strftime(object$gh_milestone_due_on[i], format="%Y-%m-%dT%H:%M:%SZ" )
      )
      r <- github::create.milestone(
        owner=owner,
        repo=repo,
        content = k,
        ...
      )
      if(verbose) {
        if(r$ok) cat("OK\n")
        else cat("ERROR\n")
      }
      Sys.sleep(sleep)
      r
    }
  )
  resplist
  
  mutate_(object,
         push_response = ~resplist,
         push_ok = ~vapply(resplist, function(x) x$ok, logical(1)),
         gh_milestone_number = ~vapply(resplist, function(x) x$content$number, numeric(1))
  )
}
