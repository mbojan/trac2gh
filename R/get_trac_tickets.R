#' Query Trac tickets
#' 
#' @param ... key=value pairs to filter tickets
#' @param base_url base URL to Trac
#'   
#' @return
#' Data frame of ticket data.
#' 
#' @family Trac accessors
#' 
#' @export

get_trac_tickets <- function(..., 
                             base_url=getOption("trac2gh.base_url")
                             ) {
  # Check arguments
  args <- list(...)
  arg_ok <- names(args) %in% trac_ticket_field_names
  if(!all(arg_ok))
    stop("unknown arguments: ", paste(names(args)[!arg_ok], collapse=", "))
  
  # Make the request
  r <- trac_api(
    path="query", 
    query=c(
      args, 
      structure( as.list(trac_ticket_field_names), 
                 names=rep("col", length(trac_ticket_field_names))),
      list(format="csv")),
    base_url=base_url
    )
  
  # Parse the CSV
  con <- textConnection( httr::content(r, "text" ) )
  df <- utils::read.csv(con, as.is=TRUE)
  names(df) <- paste0("trac_ticket_", names(df))
  df
}
