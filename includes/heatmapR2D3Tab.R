################################################################################
################ UI describing the layout for heatmap ##########################
################################################################################

heatmapTabD3 <- function(){
  
  selection <- lapply(yamlInputs$assay_files, function(x){x$name})
  names(selection) <- selection
  
             fluidPage(
               
               fluidRow(
                 h1("test"),
                 column(12,
                        
                        wellPanel(
                          
                          fluidRow(
                            
                            column(12,
                                   
                                   # The checkbox widget for the promoter domains
                                   selectInput("radior2d3", label = h3("Assay A"),
                                                      choices = selection),
                                   selectInput("radior2d31", label = h3("Assay B"),
                                                choices = selection),
                                   selectInput("heatmap_color", label = h3("Color Scale"),
                                               choices = list("viridis"="viridis", "magma"="magma", "plasma"="plasma", "inferno"="inferno"))
                                   )
                                  
                            
                          )
                          
                        )
                 )
                 
               ),
               fluidRow(div(id="test", class="test2", height="50px")),
               # second row to hold the density plot for kato et al.
               fluidRow(
                 
                 # first column second row
                 column(6,
                        
                        # density plot for promoters
                        d3Output('d3', width="100%", height="1000px")
                 ),
                 column(6,
                        
                        # density plot for promoters
                        d3Output('d31', width="100%", height="1000px")
                 )
               )
             
    )
}
