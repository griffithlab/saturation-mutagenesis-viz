################################################################################
##################### User Interface ###########################################
################################################################################

# source global R script
source("global.R")

# source the code for each tab panel
source("layout/assayDensityScore.R")
source("layout/datasetsTab.R")
source("layout/heatmapTab.R")
source("layout/heatmapR2D3Tab.R")
source("layout/scatterR2D3Tab.R")

# define the top navigation bar
navbarPage(yamlInputs$title, theme="bootstrap.css",
           
           # define tabs in the navbar
           assayDensityScore(),
           heatmapTab(),
           datasetsTab(),
           heatmapTabD3(),
           scatterTabD3()
           
)


