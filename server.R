
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(rCharts)
library(lubridate)
library(data.table)

DT <- as.data.table(readRDS('Estoninan_companies_tax_defaults_as_of_17.02.2015.rds'))
setnames(DT,c("RegistrationID", "CompanyName","TaxSumInDefault","InclTaxSumInDispute","DefaultStartDate"))

DT$DefaultInWeeks <- difftime( ymd(today()),ymd(DT$DefaultStartDate),units = "weeks")
#DT$DefaultInMonths <- month((DT$DefaultInDays))
companies <- unique(DT$CompanyName)

shinyServer(function(input, output,session) {
    
    output$hist_defaulters <- renderPlot({
        
        bins <- seq(1, 100, length.out = input$bins + 1)
        hist(log10(DT$TaxSumInDefault),breaks = bins,col = 'darkgray', border = 'white')
    })
    
    output$companies_tax_defaults_starts_from <- renderDataTable({
        DT[,sum(TaxSumInDefault),year(x = DefaultStartDate)]
    })
 
    output$companies_tax_defaults <- renderDataTable({
        DT[CompanyName %in% input$company,]
    })    

    output$taxchart <- renderChart({
        p1 <- rPlot('DefaultInWeeks','TaxSumInDefault', data = DT, type = 'point')
        p1$addParams(dom = 'taxchart',title = "Companies tax defaults by default age in weeks")
        return(p1)
    })
    
    
    output$taxchart2 <- renderChart({
        p2 <- rPlot('DefaultInWeeks','TaxSumInDefault', data = DT, type = 'point')
        p2$addParams(dom = 'taxchart2')
        return(p2)
    })
    
    output$companies_defaults <- renderDataTable(DT,
                                                 options=list(iDisplayLength=50,                    # initial number of records
                                                              aLengthMenu=c(50,10),                  # records/page options
                                                              bLengthChange=0,                       # show/hide records per page dropdown
                                                              bFilter=0,                                    # global search box on/off
                                                              bInfo=0,                                      # information on/off (how many records filtered, etc)
                                                              bAutoWidth=0,                            # automatic column width calculation, disable if passing column width via aoColumnDefs
                                                              #bSearchable = 1,
                                                              aoColumnDefs = list(list(sWidth="300px", aTargets=c(list(0),list(1))))    # custom column size                       
                                                 )
                                                 )

    
#     output$myChart <- renderChart({
#         
#         names(iris) = gsub("\\.", "", names(iris))
#         p2 <- rPlot('SepalLength','SepalWidth', data = iris, color = "Species", type = 'point')
#         
#         p2$addParams(dom = 'myChart')
#         return(p2)
#     })
})
