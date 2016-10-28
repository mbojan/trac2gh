# Tools assisting migration of stuff from Trac to GitHub

[![Build Status](https://travis-ci.org/mbojan/trac2gh.png?branch=master)](https://travis-ci.org/mbojan/trac2gh)
[![Build Status](https://ci.appveyor.com/api/projects/status/  xxx ?svg=true)](https://ci.appveyor.com/project/mbojan/trac2gh)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/trac2gh?color=2ED968)](http://cranlogs.r-pkg.org/)
[![cran version](http://www.r-pkg.org/badges/version/trac2gh)](https://cran.r-project.org/package=trac2gh)


This is R package assiting semi-automatic migration of code Subversion+Trac to GitHub.

Migrating from Trac+SVN to GitHub usually involves moving the following items:

- milestones
- tickets
- code, stored in SVN

# Highlights

- Trac pseudo-API allowing fetching data from Trac non-interactively: `trac_api()`, `get_trac_tickets()`.


# Dim lights

- There is a [Trac XML-RPC Plugin](https://trac-hacks.org/wiki/XmlRpcPlugin) that seems to allow downloading at least some that information in a machine-readable format (XML). Handling this is not yet implemented.
- User with administrative rights in Trac seems to be able to create "dumps" using [`trac-admin` command](https://trac.edgewall.org/wiki/TracAdmin). Handling such files is not yet implemented.






# Installation

``` r
devtools::install_github("mbojan/trac2gh")
```
