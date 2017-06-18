#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

expenditures <- fread("data/2017_expenditures.csv")

expenditures$expenditure_date <- as.Date(expenditures$expenditure_date, "%m/%d/%Y")
expenditures$amount <- as.numeric(gsub('[$]', '', expenditures$amount))
expenditures <- expenditures[order(expenditure_date)]

contributions <- fread("data/2017_contributions.csv")
contributions$receipt_date <- as.Date(contributions$receipt_date, "%m/%d/%Y")
contributions$amount <- as.numeric(gsub('[$]', '', contributions$amount))
contributions <- contributions[order(receipt_date)]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  filerInput <- reactive({
    input$filer_id
  })
  #output$filer_id <- renderPrint({filerInput()})
  #output$conts <- renderTable({head(contributions[filer_id == input$filer_id])})
  
  output$contPlot <- renderPlot({
    print(
      ggplot() + 
        geom_line(data=contributions[filer_id == filerInput()], aes(receipt_date, cumsum(amount))) +
        geom_line(data=expenditures[filer_id == filerInput()], aes(expenditure_date, cumsum(amount)), linetype=3)
      )
  })
  
})
