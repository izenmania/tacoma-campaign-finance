# Tacoma Campaign Finances

This is a simple dashboard, built in R Shiny, providing a summary view of publicly disclosed contributions to, and expenditures by, candidate campaigns in the 2017 City of Tacoma election.

## Requirements

### Environment

The dashboard should run on any Shiny server. The current version was built in RStudio, and is hosted at shinyapps.io.

### R Libraries

- shiny
- data.table
- ggplot2

### Data

Create a data/ directory at the root of the project, and download the following data files into it:

- [2017\_Contributions.csv](https://data.wa.gov/api/views/x2ji-8m9e/rows.csv?accessType=DOWNLOAD)
- [2017\_Expenditures.csv](https://data.wa.gov/api/views/wr9z-vew7/rows.csv?accessType=DOWNLOAD)
- [2017\_Tacoma\_Candidates.csv](https://data.wa.gov/api/views/dnmf-vque/rows.csv?accessType=DOWNLOAD)

Forthcoming will be a simple shell script to install this data, which can be run as a cron . The data is at a Socrata data portal, and can be acquired with R by API, but this is probably too slow for runtime loading.