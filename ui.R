###################################################################################################################
##################### User Interface ##############################################################################
###################################################################################################################

# load necessary libraries
library(shiny)
library(ggplot2)
library(reshape2)
library(DT)
    
# define the top navigation bar
navbarPage("CDI TP53 Project", theme="bootstrap.css",
               
           # define the Assay Density plot panel
           tabPanel("ACT Scores",
                    
                    # set up a fluid page to use bootstrap grid system
                    fluidPage(
                      
                      # the first row in the grid to hold input widgets and the data table
                      fluidRow(
                        
                        # the widget panel
                        column(2,
                               wellPanel(
                                 
                                 # The checkbox widget for the promoter domains
                                 checkboxGroupInput("promoterCheckGroup", label = h3("Promoter"),
                                                    choices = list("WAF1_Act" = "WAF1_Act",
                                                                   "MDM2_Act"="MDM2_Act",
                                                                   "BAX_Act" = "BAX_Act",
                                                                   "_14_3_3_s_Act"="_14_3_3_s_Act",
                                                                   "AIP_Act"="AIP_Act",
                                                                   "GADD45_Act"="GADD45_Act",
                                                                   "NOXA_Act"="NOXA_Act",
                                                                   "p53R2_Act"="p53R2_Act"),
                                                    selected = "WAF1_Act"),
                                 
                                 # horizontal rule to separate promoter and variant selector
                                 hr(),
                                 
                                 # widget to select a variant to display
                                 h3("Variant"),
                                 selectizeInput('variant', label = NULL, choices = NULL,
                                                options = list(placeholder = 'Type a variant, e.g. p.R175H',
                                                               maxOptions = 5))
                                 )
                               ),
                        
                        # second column in first row to hold the data display
                        column(10,
                               
                               # data display
                               DT::dataTableOutput('promoterAssayData')
                               )
                        )
                    ),
                    
                    # second row to hold the density plot
                    fluidRow(
                      
                      # first column second row
                      column(12,
                             
                             # density plot for promoters
                             plotOutput('promoterDensityPlot')
                             )
                      )
                    
                    )
           )

