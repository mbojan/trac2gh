#' Get milestone metadata from Trac
#' 
#' @param mnames character, milestone names
#' @param ... other arguments, currently ignored
#' 
#' @details
#' \code{get_trac_milestones} fetches appropriate HTML pages from Trac and 
#' extracts neccessary data. The process is somewhat fragile with respect to the
#' user preferences set in Trac. In particular, it assumes that the time&date 
#' display is set to UTC.
#'   
#' @return 
#' Data frame of milestone data with columns \code{trac_milestone_*} where \code{*} are:
#' \item{name}{milestone name}
#' \item{description}{milestone description}
#' \item{due_date}{milestone due date, if any}
#' \item{status}{milestone status, either "open" or "closed"}
#' \item{url}{URL to the milestone in Trac}
#' 
#' @family Trac accessors
#' 
#' @export

get_trac_milestones <- function(mnames, ...) {
  mlist <- lapply( mnames, get_trac_milestone )
  dplyr::bind_rows(mlist)
}


get_trac_milestone <- function(mname, ... ) {
  # Arguments
  stopifnot( is.character(mname) && length(mname)==1  )
  
  # Fetch and parse
  mhtml <- trac_api(path=c("milestone", utils::URLencode(mname)))
  html <- httr::content(mhtml, "parsed")
  
  # Due date
  date_node <- xml2::xml_find_first(html, "//div[@class='milestone']//p[@class='date']")
  date_text <- trim_garbage( xml2::xml_text(date_node) )
  ddate <- lubridate::ymd_hms( 
    stringi::stri_extract(date_text, regex="(?<=\\()[0-9-:TZ]+(?=\\))"),
    tz = "UTC"
  )
  
  # Description
  desc_node <- xml2::xml_find_first(html, "//div[@class='milestone']/div[@class='description trac-content']/p")
  desc <- gsub("^[\n ]+|[\n ]+$", "", xml2::xml_text(desc_node)) # trim
  
  rval <- data.frame(
    name = mname,
    description = ifelse(is.na(desc), NA, desc),
    due_date = ddate,
    status = ifelse( grepl("^Completed", date_text), "closed", "open"),
    url = mhtml$url,
    stringsAsFactors = FALSE
  )
  names(rval) <- paste0("trac_milestone_", names(rval))
  rval
}
