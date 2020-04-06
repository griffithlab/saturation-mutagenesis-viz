################################################################################
##################### User Interface ###########################################
################################################################################

# source global R script
source("global.R")

# source the code for each tab panel
source("layout/assayDensityScore.R")
source("layout/datasetsTab.R")
source("layout/heatmapTab.R")

# define the top navigation bar
navbarPage(yamlInputs$title, theme="bootstrap.css",
           
           # define tabs in the navbar
           assayDensityScore(),
           heatmapTab(),
           datasetsTab()
           
)


