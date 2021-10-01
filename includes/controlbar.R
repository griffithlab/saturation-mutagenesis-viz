controlbarINC <- function(){
  
  selection <- lapply(yamlInputs$assay_files, function(x){x$name})
  names(selection) <- selection
  
  dashboardControlbar(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    controlbarMenu(
      id = "controlbarMenu",
      controlbarItem("Assays",
                     checkboxGroupInput("assayCheckGroup",
                                        label=NULL,
                                        choices = selection,
                                        selected = selection[[1]])
      )
    )
    
  )
}