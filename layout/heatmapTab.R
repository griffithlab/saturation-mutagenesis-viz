################################################################################
################ UI describing the layout for heatmap ##########################
################################################################################

heatmapTab <- function(){
  
    tabPanel("Heatmap",
             
             fluidPage(
               
               fluidRow(
                 
                 column(12,
                        
                        wellPanel(
                          
                          fluidRow(
                            
                            column(6,
                                   
                                   # The checkbox widget for the promoter domains
                                   checkboxGroupInput("promoterCheckGroup2_kato", label = h3("Kato et al. 2003"),
                                                      choices = list("WAF1_Act" = "WAF1_Act",
                                                                     "MDM2_Act"="MDM2_Act",
                                                                     "BAX_Act" = "BAX_Act",
                                                                     "_14_3_3_s_Act"="_14_3_3_s_Act",
                                                                     "AIP_Act"="AIP_Act",
                                                                     "GADD45_Act"="GADD45_Act",
                                                                     "NOXA_Act"="NOXA_Act",
                                                                     "p53R2_Act"="p53R2_Act"),
                                                      selected = "WAF1_Act")),
                            
                            column(6,
                                   
                                   
                                   checkboxGroupInput("promoterCheckGroup2_giacomelli", label = h3("giacomelli et al. 2018"),
                                                      choices = list("p53NULL_Nutlin-3_Z-score" = "A549_p53NULL_Nutlin-3_Z-score",
                                                                     "p53NULL_Etoposide_Z-score"="A549_p53NULL_Etoposide_Z-score",
                                                                     "p53WT_Nutlin-3_Z-score" = "A549_p53WT_Nutlin-3_Z-score")))
                            
                          ),
                          
                          # second row to hold the density plot for kato et al.
                          fluidRow(
                            
                            # first column second row
                            column(12,
                                   
                                   # density plot for promoters
                                   plotOutput('promoterHeatmapPlot')
                            )
                          )
                          
                        )
                 )
                 
               )
             )
    )
}
