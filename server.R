################################################################################
############################### server startup #################################
################################################################################

# source necessary files
source("global.R")
source("scripts/serverScripts.R")

################################################################################
##################### Define the shiny server ##################################
################################################################################

# shiny server registration
shinyServer(function(input, output, session){
  
  # Density tab
  output$promoterDensityPlot <- densityPlot(input, assayData, aminoAcidPermutations, varCategory)
  output$promoterAssayData <- DT::renderDataTable(aminoAcidPermutations, rownames=F, options=list(pageLength = 10))
  
  # Heatmap Tab
  output$promoterHeatmapPlot <- heatmapPlot(input, assayData)
  
  # Description Tab
  output$datasetsSource <- dataSource(input)

})
