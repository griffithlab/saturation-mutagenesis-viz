################################################################################
################ UI describing the layout for datasets #########################
################################################################################

datasetsTab <- function(){
  
    tabPanel("Datasets",
             
             fluidPage(
               
               fluidRow(
                 
                 column(4,
                        
                        wellPanel(
                          
                          selectInput("dataset", label = h3("Manuscript"), 
                                      choices = list("Kato et al. 2003" = 1, "giacomelli et al. 2018" = 2, "hahn et al. 2018" = 3), 
                                      selected = 1)
                        )
                  ),
                 
                 column(8,
                        
                        h3("Description"),
                        htmlOutput("datasetsDescription"),
                        h3("Source"),
                        htmlOutput("datasetsSource"),
                        h3("Columns Used"),
                        htmlOutput("datasetsColumns"),
                        h3("Pre-Processing"),
                        htmlOutput("datasetsPreProcess"),
                        h3("Post-Processing"),
                        htmlOutput("datasetsPostProcess")
                  )
                )
              )
    )
  
}