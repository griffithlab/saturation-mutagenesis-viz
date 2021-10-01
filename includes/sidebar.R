sidebarINC <- function(){
  dashboardSidebar(
    sidebarMenu(
      menuItem(tabName="dataset", text="Datasets", icon = icon("database")),
      menuItem(tabName="dms_density", text="DMS Density", icon = icon("chart-bar")),
      menuItem(tabName="dms_heatmap", text="DMS Heatmap", icon=icon("chart-bar")),
      menuItem(tabName="dms_scatter", text="DMS Scatter", icon = icon("chart-bar"))
    )
  )
}
