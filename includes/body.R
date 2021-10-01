# source the code for each tab panel
source("includes/assayDensityScore.R")
source("includes/datasetsTab.R")
source("includes/heatmapTab.R")
source("includes/heatmapR2D3Tab.R")
source("includes/scatterR2D3Tab.R")

bodyINC <- function(){
  
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      tabItem(tabName="dms_heatmap", fluidRow(heatmapTabD3())),
      tabItem(tabName="dms_density", fluidRow(assayDensityPlot())),
      tabItem(tabName="dataset", fluidRow(datasetsTab())),
      tabItem(tabName="dms_scatter", fluidRow(scatterTabD3()))
      )
  )
}