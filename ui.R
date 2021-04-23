################################################################################
##################### User Interface ###########################################
################################################################################

# source global R script
source("global.R")

# source includes elements for the app
source("includes/header.R")
source("includes/controlbar.R")
source("includes/body.R")
source("includes/sidebar.R")
source("includes/footer.R")

# Define the overall user interface
dashboardPage(
  header = headerINC(),
  sidebar = sidebarINC(),
  body = bodyINC(),
  controlbar = controlbarINC(),
  footer = footerINC(),
)

