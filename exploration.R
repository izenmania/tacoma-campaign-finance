library(ggplot2)
library(data.table)

jurisdiction_filter <- "CITY OF TACOMA"
office_filter <- "MAYOR"
year_filter <- 2017

merrit_id <- "MERRJ  402"
lopez_id <- "LOPEE  406"
woodards_id <- "WOODV  409"

all_contributions <- fread("data/Contributions_to_Candidates_and_Political_Committees.csv")
all_contributions_2017 <- all_contributions[election_year == 2017]
rm(all_contributions)

tac_mayor_cont_2017 = all_contributions_2017[office == office_filter & jurisdiction == jurisdiction_filter]
tac_mayor_cont_2017$amount <- as.numeric(gsub('[$]', '', tac_mayor_cont_2017$amount))
tac_mayor_cont_2017$receipt_date <- as.Date(tac_mayor_cont_2017$receipt_date, "%m/%d/%Y")
tac_mayor_cont_2017 <- tac_mayor_cont_2017[order(receipt_date)]


ggplot() +
  geom_line(data=tac_mayor_cont_2017[filer_id==lopez_id], aes(receipt_date, cumsum(amount)))
