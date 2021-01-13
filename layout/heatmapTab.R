################################################################################
################ UI describing the layout for heatmap ##########################
################################################################################

heatmapTab <- function(){
  
  selection <- lapply(yamlInputs$assay_files, function(x){x$name})
  names(selection) <- selection
  
    tabPanel("Heatmap",
             
             fluidPage(
               
               fluidRow(
                 
                 column(12,
                        
                        wellPanel(
                          
                          fluidRow(
                            
                            column(12,
                                   
                                   # The checkbox widget for the promoter domains
                                   checkboxGroupInput("assayCheckGroup2", label = h3("Assay"),
                                                      choices = selection,
                                                      selected = selection[[1]])
                                   )
                            
                          ),
                          
                          # second row to hold the density plot for kato et al.
                          fluidRow(
                            
                            # first column second row
                            column(12,
                                   
                                   # density plot for promoters
                                   plotlyOutput('promoterHeatmapPlot')
                            )
                          )
                          
                        )
                 )
                 
               )
             )
    )
}
