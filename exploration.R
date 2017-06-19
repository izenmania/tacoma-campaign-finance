library(ggplot2)
library(data.table)

jurisdiction_filter <- "CITY OF TACOMA"
office_filter <- "MAYOR"
year_filter <- 2017

merritt_id <- "MERRJ  402"
lopez_id <- "LOPEE  406"
woodards_id <- "WOODV  409"

all_contributions_2017 <- fread("data/2017_Contributions.csv")

tac_mayor_cont_2017 = all_contributions_2017[office == office_filter & jurisdiction == jurisdiction_filter]
tac_mayor_cont_2017$amount <- as.numeric(gsub('[$]', '', tac_mayor_cont_2017$amount))
tac_mayor_cont_2017$receipt_date <- as.Date(tac_mayor_cont_2017$receipt_date, "%m/%d/%Y")
tac_mayor_cont_2017 <- tac_mayor_cont_2017[order(receipt_date)]


ggplot() +
  geom_line(data=tac_mayor_cont_2017[filer_id==merrit_id], aes(receipt_date, cumsum(amount))) +
  scale_x_date(limits = c(as.Date("2016-12-04"), NA)) +
  scale_y_continuous(limits=c(0, 75000)) +
  theme_minimal() +
  labs(title = "Contributions & Expenditures", x="Date", y="Total (in 1000's)")


tac_mayor_cont_2017[filer_id == woodards_id, mean(amount)]

m_donors <- tac_mayor_cont_2017[filer_id == woodards_id & contributor_name != "", .(contributor_name, contributor_address, contributor_city, contributor_zip, contributor_employer_name, contributor_employer_city, contributor_employer_state)]

setkey(m_donors, contributor_name, contributor_address)
setkey(all_contributions_2017, contributor_name, contributor_address)

cross_donors <- all_contributions_2017[filer_id != woodards_id][m_donors, nomatch=0]

all_contributions_2017$amount <- as.numeric(gsub('[$]', '', all_contributions_2017$amount))
all_contributions_2017[filer_id == merritt_id][, .(
  "Total Raised"=sum(amount), 
  "Individuals"=sum(code=="Individual"),
  "PACs"=sum(code=="Political Action Committee"),
  "# of Max Donations"=sum(amount==1000)
  ), by=filer_id]

setkey(all_contributions_2017, contributor_name, contributor_address)
all_contributions_2017[filer_id == woodards_id & contributor_name != ""][all_contributions_2017[filer_id != woodards_id], nomatch=0][, .(first(i.filer_name)), by=i.filer_id]



candidates <- fread("data/2017_Tacoma_Candidates.csv")[office != ""]
inputOffice = "MAYOR"
inputPosition = NA

posCands <- candidates[office == inputOffice & ((is.na(position) & is.na(inputPosition) | position == inputPosition)), .(filer_name, filer_id)]
posCands[, filer_name]
posCands
candidates
inputPosition

candidates[, .N, by=office]

candidates[office=="CITY COUNCIL MEMBER", .N, by=position][order(position)]


all_contributions_2017[jurisdiction=="CITY OF TACOMA" & first_name=="PHILIP"]
