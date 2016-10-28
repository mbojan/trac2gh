#' Push issues to GitHub
#' 
#' @param object, R object
#' @param ... other arguments passed to/from other methods 
#' 
#' @export
push_gh_issues <- function(object, ...) UseMethod("push_gh_issues")

#' @rdname push_gh_issues
#' 
#' @param owner,repo character, GitHub repo and its owner, passed to \code{\link{create.issue}}
#' @param verbose logical, provide more output
#' @param sleep numeric, delay between subsequent requests, passed to \code{\link{Sys.sleep}}
#' @param retval character, one of "df", "resplist", or "dryrun", what should
#'   the function return. See Value section.
#'   
#' @return
#' Depending on \code{retval} the function will return:
#' \item{df}{Data frame with columns from \code{object} with additional column
#' \code{gh_issue_number} with IDs assigned to issues by GitHub.}
#' \item{resplist}{list of unparsed responses from \code{GET}.}
#' \item{dryrun}{no requests to GH will be sent, return just a list of data that
#' are to be pushed.}
#'   
#' @export
push_gh_issues.data.frame <- function(object, owner, repo, ...,
                                      verbose=TRUE,
                                      sleep=1, retval=c("df", "resplist", "dryrun")) {
  retval <- match.arg(retval)
  # Check variables
  vnames <- paste0(
    "gh_issue_", 
    c("title", "body", "milestone", "label")
  )
  ok <- vnames %in% names(object)
  if(any(!ok))
    stop("variables not found: ", paste(vnames[!ok], collapse=", "))
  
  # Push
  resplist <- lapply(
    seq(1, nrow(object)),
    function(i) {
      if(verbose) cat("Pushing issue", sQuote(object$gh_issue_title[i]), "... ")
      # Request content
      k <- list(
        title = object$gh_issue_title[i],
        body = object$gh_issue_body[i],
        milestone = object$gh_issue_milestone[i],
        labels = object$gh_issue_label[[i]]
      )
      if(retval=="dryrun") return(k)
      r <- github::create.issue(
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
  
  switch(
    retval,
    df = mutate_(object,
                 push_response = ~resplist,
                 push_ok = ~vapply(resplist, function(x) x$ok, logical(1)),
                 gh_issue_number = ~vapply(resplist, function(x) x$content$number, numeric(1))
    ),
    resplist = resplist,
    dryrun = resplist
  )
}
