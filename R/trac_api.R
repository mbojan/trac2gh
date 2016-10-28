#' Trac API
#' 
#' Accessing Statnet Trac non-interactively from R.
#' 
#' @param path,query passed to \code{\link{modify_url}}
#' @param base_url base URL, defaults to \code{trac2gh.base_url} option
#' @param ... other arguments passed to \code{\link{GET}}
#' 
#' @return Unparsed response (from \code{\link{GET}})
#' 
#' @family Trac accessors
#' 
#' @export

trac_api <- function(path=NULL, 
                     query=NULL, 
                     base_url=getOption("trac2gh.base_url"),
                     ...) {

  # Make the URL
  url <- api_url(
    base_url,
    path=path, 
    query = query
  )
  
  # Make the request
  resp <- httr::GET(
    url, 
    ...)
  
  # Catch errors
  if( httr::http_error(resp) )
    handle_errors(resp)
  
  resp
}




#' Get the Trac login cookie
#' 
#' @param path path part of URL, passed to \code{\link{modify_url}}
#' @param usr,psw,auth_type user name, password and authentication type, passed
#'   to \code{\link{authenticate}}
#' @param ... other arguments passed to \code{\link{trac_api}}
#'   
#' @details
#' Get the login cookie invisibly. Package \CRANpkg{httr} preserves cookies across
#' requests to the same website, so they will be used automatically.
#' 
#' @return The response, as returned by \code{\link{GET}}, invisibly.
#' 
#' @family Trac accessors
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' trac_login("login")
#' }
trac_login <- function(path,
                       usr=getenv("TRAC_USER"),
                       psw=getenv("TRAC_PSW"),
                       auth_type="basic",
                       ...) {
  resp <- trac_api(
    path=path, 
    config=httr::authenticate(usr, psw, type = auth_type), 
    ...)

  if( httr::http_error(resp)) 
    handle_errors(resp)
  
  invisible(resp)
}




#' Modify URL preserving existing path component
#' 
#' @param base_url base url
#' @param path path to be appended, see \code{\link{modify_url}}
#' @param ... other arguments passed to \code{\link{modify_url}}
#' 
#' @details
#' \code{api_url} works just like \code{\link{modify_url}}, but when supplied 
#' the \code{path} argument it is appended to the existing path of
#' \code{base_url} instead of replacing it.
#' 
#' @return An updated URL
#' 
#' @family Trac accessors
#' 
#' @export
api_url <- function(base_url, path=NULL, ...) {
  u <- httr::parse_url(base_url)
  p <- if(u$path == "") NULL else u$path
  httr::modify_url(u, path=c(p, path), ...)
}






# Throw Trac error
#
# @param resp offending response
#
handle_errors <- function(resp) {
  parsed <- xml2::read_html( httr::content(resp, "text"))
  msg <- xml2::xml_text( xml2::xml_find_first(parsed, "/html/head/title") )
  msg <- gsub("^[\n ]+|[\n ]+$", "", msg) # trim garbage
  stop(
    sprintf(
      "Trac request failed [%s]\n%s\n<%s>\n",
      httr::status_code(resp),
      msg,
      resp$url
    ),
    call.=FALSE
  )
}




# Get environment variable or stop
getenv <- function(vname) {
  rval <- Sys.getenv(vname)
  if( rval == "" )
    stop("variable ", vname, " is not defined in the environment")
  rval
}
