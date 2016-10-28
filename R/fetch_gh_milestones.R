#' Fetch milestones from GH
#' 
#' @param object, R object, see Details
#' @param ... other arguments passed to/from other methods
#' 
#' @import dplyr
#' @export

fetch_gh_milestones <- function(object, ...) UseMethod("fetch_gh_milestones")


#' @rdname fetch_gh_milestones
#' 
#' @param owner,repo GitHub owner and repo name
#' @param verbose logical, whether to provide more output
#' @param sleep numeric, delay between requests, passed to \code{Sys.sleep}
#' 
#' @export
fetch_gh_milestones.data.frame <- function(object, owner, repo, ..., verbose=TRUE, sleep=1) {
  # Fetch
  r <- get_trac_milestones(owner=owner, repo=repo, ...)
  
  # Fields
  mfields <- c("title", "description", "state", "created_at", "updated_at",
               "due_on", "number")
  
  d <- lapply(r$content, "[", mfields) %>%
    lapply(lapply, null2na) %>%
    dplyr::bind_rows()
  names(d) <- paste0("gh_milestone_", names(d))
  
  object %>%
    dplyr::left_join(
      select_(d, 
              ~gh_milestone_number,
              ~gh_milestone_title,
              ~gh_milestone_description,
              ~gh_milestone_due_on
              ),
      by=c("trac_milestone_name" = "gh_milestone_title")
    ) %>%
    mutate_(
      gh_milestone_title = ~trac_milestone_name
    )
}

