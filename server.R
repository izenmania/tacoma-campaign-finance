#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)
library(ggplot2)

# Load and process all 2017 expenditures
expenditures <- fread("data/2017_Expenditures.csv")
expenditures$expenditure_date <- as.Date(expenditures$expenditure_date, "%m/%d/%Y")
expenditures$amount <- as.numeric(gsub('[$]', '', expenditures$amount))
expenditures <- expenditures[order(expenditure_date)]

# Load and process all 2017 contributions
contributions <- fread("data/2017_Contributions.csv")
contributions$receipt_date <- as.Date(contributions$receipt_date, "%m/%d/%Y")
contributions$amount <- as.numeric(gsub('[$]', '', contributions$amount))
contributions <- contributions[order(receipt_date)]

# Load 2017 Tacoma candidate list
candidates <- fread("data/2017_Tacoma_Candidates.csv")[office != "" & candidate_committee_status == "Candidate declared"]

# Temporary values
#inputOffice = "MAYOR"
#inputPosition = NA

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  ###################
  # DATA PROCESSING #
  ###################
  
  # Reactive input from candidate radio button
  filerInput <- reactive({
    input$filer_id
  })
  
  # split contributions into those for the candidate, and those for everyone else
  candConts <- reactive({contributions[filer_id == filerInput()]})
  otherConts <- reactive({contributions[filer_id != filerInput()]})
  
  ################
  # SELECTION UI #
  ################
  
  # Generate dropdown menu of possible offices
  output$officeSelect <- renderUI({
    offices <- candidates[, .N, by=office][order(office)]
    selectInput("office", "Office", offices[,office], selected="MAYOR")
  })
  
  # Generate dropdown menu of positions for the selected office
  output$positionSelect <- renderUI({
    positions <- candidates[office==input$office, .N, by=position][order(position)]
    selectInput("position", "Position", positions[,position])
  })
  
  # Generate radio button list of candidates for the selected office/position combo
  output$candidates <- renderUI({
    if(is.null(input$office) & is.null(input$position))
      return()
    
    posCands <- candidates[
      office == input$office & ((is.na(position) & input$position == "NA" | position == input$position)), 
      .("filer_name"=paste(first_name, last_name), filer_id)
      ][order(filer_name)]
    radioButtons("filer_id", "Candidate:", choiceNames=posCands[, filer_name], choiceValues=posCands[, filer_id])
  })
  
  #####################
  # CANDIDATE DETAILS #
  #####################
  
  # Plot selected candidate's contributions and expenditures
  output$contPlot <- renderPlot({
    if(is.null(input$filer_id))
      return()
    
    if(contributions[filer_id == filerInput(), .N] == 0) {
      print("No contributions on file to this candidate")
      return()
    }
    
    print(
      ggplot() + 
        geom_line(data=contributions[filer_id == filerInput()], aes(receipt_date, cumsum(amount), color="cont", linetype="cont")) +
        geom_line(data=expenditures[filer_id == filerInput()], aes(expenditure_date, cumsum(amount), color="exp", linetype="exp")) +
        scale_x_date(limits = c(as.Date("2016-12-04"), Sys.Date())) +
        scale_y_continuous(limits=c(0, 75000)) +
        scale_color_manual(name="", values=c(cont="blue", exp="red"), labels=c("Contributions", "Expenditures")) +
        scale_linetype_manual(name="", values=c(cont=1, exp=3), labels=c("Contributions", "Expenditures")) +
        theme_minimal() +
        labs(x="Date", y="Total")
      )
    
    # List selected candidate's summary stats
    output$summary <- renderTable(t(
      candConts()[, .(
        "Total Raised"=as.integer(sum(amount)), 
        "Individuals"=as.integer(sum(code=="Individual")),
        "Businesses"=as.integer(sum(code=="Business")),
        "PACs"=sum(code=="Political Action Committee"),
        "Other"=sum(code=="Other"),
        "# of Max Donations"=sum(amount==1000)
      )])
      , rownames=TRUE, colnames=FALSE)
    
    # List crossover contributions
    output$alsoDonatedTable <- renderTable({
      setkey(candConts(), contributor_name, contributor_address)
      setkey(otherConts(), contributor_name, contributor_address)
      
      cross_donors <- otherConts()[contributor_name != ""][candConts(), nomatch=0][, .("Recipient"=paste(first(first_name), first(last_name))), by=filer_id][order(Recipient),Recipient]
      print(cross_donors)
    }, colnames=FALSE)
  })
  
  
  
})
