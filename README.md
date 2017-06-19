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

Download the following files into the data/ directory:

- [2017\_Contributions.csv](https://data.wa.gov/api/views/x2ji-8m9e/rows.csv?accessType=DOWNLOAD)
- [2017\_Expenditures.csv](https://data.wa.gov/api/views/wr9z-vew7/rows.csv?accessType=DOWNLOAD)
- [2017\_Tacoma\_Candidates.csv](https://data.wa.gov/api/views/dnmf-vque/rows.csv?accessType=DOWNLOAD)

Forthcoming will be a simple shell script to install this data, which can be run as a cron . The data is at a Socrata data portal, and can be acquired with R by API, but this is probably too slow for runtime loading.

## Customization

### Location

The current code is Tacoma-centric, but the PDC provides data for the entire state of Washington. The following modifications can be made to regionally refocus:

- Create a new candidates csv. The current data is a filtered view of the [Candidates and Committee Registrations](https://data.wa.gov/Politics/Candidate-and-Committee-Registrations/d27u-zvri) dataset, setting jurisdiction to a relevant subset.
- On (currently) line 27 of server.R, update the filename.
- Update descriptive text in ui.R as needed.

*Note: the code currently assumes unique office/position pairs. As written, it will not correctly handle matching office/positions in different jurisdictions. For example, expanding to Pierce County may include multiple different races for MAYOR, and these will be conflated.*