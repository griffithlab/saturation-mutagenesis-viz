controlbarINC <- function(){
  
  selection <- lapply(yamlInputs$assay_files, function(x){x$name})
  names(selection) <- selection
  
  dashboardControlbar(
    controlbarMenu(
      id = "controlbarMenu",
      controlbarItem("test",
                     checkboxGroupInput("assayCheckGroup",
                                        label=NULL,
                                        choices = selection,
                                        selected = selection[[1]])
      )
    )
    
  )
}