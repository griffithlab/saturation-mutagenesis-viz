################################################################################
################ UI describing the layout for heatmap ##########################
################################################################################

scatterTabD3 <- function(){
  
  selection <- lapply(yamlInputs$assay_files, function(x){x$name})
  names(selection) <- selection
  
    tabPanel("R2D3_scatter",
             
             fluidPage(
               
               fluidRow(
                 
                 column(12,
                        
                        wellPanel(
                          
                          fluidRow(
                            
                            column(12,
                                   
                                   # The checkbox widget for the promoter domains
                                   selectInput("radior2d3_a", label = h3("Assay A"),
                                                      choices = selection),
                                   selectInput("radior2d3_b", label = h3("Assay B"),
                                                choices = selection),
                                   selectInput("scatter_color", label = h3("Color Scale"),
                                               choices = list("viridis"="viridis", "magma"="magma", "plasma"="plasma", "inferno"="inferno"))
                                   )
                                  
                            
                          )
                          
                        )
                 )
                 
               ),
               # second row to hold the density plot for kato et al.
               fluidRow(
                 
                 # first column second row
                 column(12,
                        
                        # density plot for promoters
                        d3Output('d3scatter', width="100%", height="1000px")
                 )
               )
             )
    )
}
