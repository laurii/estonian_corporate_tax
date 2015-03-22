
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(data.table)
library(lubridate)
require(rCharts)


DT <- as.data.table(readRDS('Estoninan_companies_tax_defaults_as_of_17.02.2015.rds'))
setnames(DT,c("RegistrationID", "CompanyName","TaxSumInDefault","InclTaxSumInDispute","DefaultStartDate"))

DT$DefaultInWeeks <- difftime( ymd(today()),ymd(DT$DefaultStartDate),units = "weeks")
#DT$DefaultInMonths <- month((DT$DefaultInDays))
companies <- unique(DT$CompanyName)

shinyUI(
    navbarPage(title = 'Estonia Corporates Tax Default Observer', 
               tabPanel('Companies Tax default data',    
                        fluidPage(
                            helpText("Estonia is small country having very transarant business environment."),
                            helpText("As one of the latest developments - The Government Tax authority has published the 
                                     list of companies with their tax default figures."),
                            helpText("This is public information supporting the better business evironment.
                                     This applicaiton is the visusalisation of this data."),
                            helpText("The orginal data source is here http://www.emta.ee/index.php?id=35438"),
                            
                            dataTableOutput('companies_defaults')
                            
                        )),
               tabPanel('Company searh', 
                        fluidPage(
                            
                            # Application title
                            titlePanel("Estonian Companies Tax Defaults"),
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                                sidebarPanel(
                                    helpText("Search by company name."),
                                    helpText("Add multilple choices to see the companies data"),
                                    helpText("To add company click inside the the search box"),
                                    selectInput(inputId = "company", label="Company",choices = unique(companies),selected = "TABEYO, OÜ", multiple = TRUE)
                                    #'selectInput(inputId, label, choices, selected = NULL, multiple = FALSE, selectize = TRUE, width = NULL)
                                ),
                                
                                # Show a plot of the generated distribution
                                mainPanel(
                                    dataTableOutput("companies_tax_defaults")
                                    
                                )
                            )
                        )
               ),
               tabPanel('Charts',
                        mainPanel(
                            showOutput("taxchart", "polycharts") 
                            
                        )
               )
    )
)

