sidebarINC <- function(){
  dashboardSidebar(
    sidebarMenu(
      menuItem(tabName="dms_heatmap", text="DMS Heatmap", icon=icon("smile")),
      menuItem(tabName="dms_density", text="DMS Density", icon = icon("smile")),
      menuItem(tabName="dms_scatter", text="DMS Scatter", icon = icon("smile")),
      menuItem(tabName="dataset", text="Datasets", icon = icon("smile"))
    )
  )
}
