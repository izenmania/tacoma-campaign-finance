#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Follow the Money :: Tacoma 2017"),
  helpText("Disclaimer: this is a work in progress concocted by someone with limited knowledge ",
           "of the ins and outs of filing laws. If you see information you know to be wrong or",
           "misleading, give a shout on twitter @izenmania, and I will endeavor to correct."),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      uiOutput("officeSelect"),
      uiOutput("positionSelect"),
      uiOutput("candidates"),
      helpText("Note: 'Max Donations' are contributions of exactly $1000, the highest ",
               "allowed for individuals and PACs. Candidate's personal fund contributions ",
               "are filed under 'other,' and not subject to this limit.")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h3("Money In, Money Out"),
      plotOutput("contPlot"),
       
      fluidRow(
        column(6,
          h4("Fundraising Summary"),
          tableOutput("summary")
        ),
       
        column(6, 
          h4("Contributors Also Supported"),
          tableOutput("alsoDonatedTable"),
          tags$style(type="text/css", "#summary tr td:first-child {font-weight:bold}")
        )
      ),
      h6(
        "Data from ",
        tags$a(href='https://www.pdc.wa.gov/', "WA Public Disclosure Commission")
      ),
      h6(
        "Dashboard by Joe Izenman / ",
        tags$a(href="https://bigdatalittledata.net", "BIGDATAlittledata.net")
      )
    )
  )
))
