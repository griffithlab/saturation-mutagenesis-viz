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
source("includes/preloader.R")

# source custom fresh theme
source("includes/theme.R")

# Define the overall user interface
dashboardPage(
  freshTheme = mytheme,
  preloader = preloaderINC(),
  header = headerINC(),
  sidebar = sidebarINC(),
  body = bodyINC(),
  controlbar = controlbarINC(),
)

