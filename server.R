################################################################################
############################### server startup #################################
################################################################################

# source necessary files
source("global.R")
source("scripts/serverScripts.R")
source("scripts/jsonScripts.R")

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
  
  #d3 testbed heatmap
  output$d3 <- renderD3({
    r2d3("scripts/r2d3/heatmapR2D3.js", d3_version = "6",
         data=heatmapDataToJson(input$radior2d3, assayData, aminoAcidPermutations),
         dependencies = "scripts/r2d3/heatmapR2D3.css",
         options=input$heatmap_color)
  })
  
  output$d31 <- renderD3({
    r2d3("scripts/r2d3/heatmapR2D3.js", d3_version = "6",
         data=heatmapDataToJson(input$radior2d31, assayData, aminoAcidPermutations),
         dependencies = "scripts/r2d3/heatmapR2D3.css",
         options=input$heatmap_color)
  })
  
  # d3 testbed scatter
  output$d3scatter <- renderD3({
    r2d3("scripts/r2d3/scatterR2D3.js", d3_version = "6",
         data=scatterToJson(input$radior2d3_a, input$radior2d3_b, assayData),
         options=input$scatter_color)
  })

})
