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
  
  # Density Tab Code
  updateSelectizeInput(
    session, 'variant', server = TRUE,
    choices = kato$p_variant
  )
  
  output$promoterDensityPlot <- densityPlot(input, assayData, aminoAcidPermutations, varCategory)
  output$promoterAssayData <- DT::renderDataTable(aminoAcidPermutations, rownames=F, options=list(pageLength = 10))
  
  # Heatmap Tab Code
  output$promoterHeatmapPlot <- heatmapPlot(input, assayData)
  
  # description Tab Code
  #output$datasetsDescription <- dataDescriptions(input)
  output$datasetsSource <- dataSource(input)
  #output$datasetsColumns <- dataColumns(input)
  #output$datasetsPreProcess <- dataPreProcess(input)
  #output$datasetsPostProcess <- dataPostProcess(input)


})
