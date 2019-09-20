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
                        column(4,
                               
                               # well panel to hold widget
                               wellPanel(
                                 
                                 # nested row to hold checkbox widgets
                                 fluidRow(
                                   
                                   # first column of nested widget row
                                   column(6,
                                          
                                          # The checkbox widget for the promoter domains
                                          checkboxGroupInput("promoterCheckGroup_kato", label = h3("Kato et al. 2003"),
                                                             choices = list("WAF1_Act" = "WAF1_Act",
                                                                            "MDM2_Act"="MDM2_Act",
                                                                            "BAX_Act" = "BAX_Act",
                                                                            "_14_3_3_s_Act"="_14_3_3_s_Act",
                                                                            "AIP_Act"="AIP_Act",
                                                                            "GADD45_Act"="GADD45_Act",
                                                                            "NOXA_Act"="NOXA_Act",
                                                                            "p53R2_Act"="p53R2_Act"),
                                                             selected = "WAF1_Act")),
                                 
                                 # Second column of nested widget row
                                 column(6,
                                        
                                        
                                 checkboxGroupInput("promoterCheckGroup_giacomelli", label = h3("giacomelli et al. 2018"),
                                                    choices = list("p53NULL_Nutlin-3_Z-score" = "A549_p53NULL_Nutlin-3_Z-score",
                                                                   "p53NULL_Etoposide_Z-score"="A549_p53NULL_Etoposide_Z-score",
                                                                   "p53WT_Nutlin-3_Z-score" = "A549_p53WT_Nutlin-3_Z-score")))),
                                 
                                 
                                 
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
                        column(8,
                               
                               # data display
                               DT::dataTableOutput('promoterAssayData')
                               )
                        )
                    ),
                    
                    # second row to hold the density plot for kato et al.
                    fluidRow(
                      
                      # first column second row
                      column(12,
                             
                             # density plot for promoters
                             plotOutput('promoterDensityPlot')
                             )
                      ),
                    
                    # second row to hold the density plot for kato et al.
                    fluidRow(
                      
                      # first column second row
                      column(12,
                             
                             # density plot for promoters
                             hr()
                      )
                    )
                    
                    )
           )

