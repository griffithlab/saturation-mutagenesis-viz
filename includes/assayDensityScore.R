################################################################################
################ UI describing the layout for assay scores #####################
################################################################################

# define the Assay Density plot panel
assayDensityScore <- function(){
  
  selection <- lapply(yamlInputs$assay_files, function(x){x$name})
  names(selection) <- selection
  
    fluidPage(
             
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
                            column(12
                                   

                                   
                                   )),
                          
                          
                          
                          # horizontal rule to separate promoter and variant selector
                          hr(),
                          
                          # widget to select a variant to display
                          h3("Example Variants", align="center"),
                          h3("(By Known Function)", align="center"),
                          checkboxGroupInput('checkGroupFunction', label = NULL,
                                             choices = list("Loss of Function"="LOF",
                                                            "Gain of Function"="GOF",
                                                            "Dominant Negative"="DN",
                                                            "Neomorph"="NM"))
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
}

