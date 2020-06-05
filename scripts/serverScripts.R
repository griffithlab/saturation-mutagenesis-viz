################################################################################
############# Server side functions ############################################
################################################################################

densityPlot <- function(input, data, data2, data3){
  
  renderPlot({
    
    # find the x-intercept for the combination of promoter groups and variants
    functionVars <- data3
    functionVars <- functionVars[Function %in% input$checkGroupFunction]$Variant
    variantXintercept <- data[data$name %in% input$assayCheckGroup,]
    variantXintercept <- variantXintercept[variantXintercept$hgvs_pro %in% c(data2[input$promoterAssayData_rows_selected]$p_variant, functionVars),]
    
    # make a density plot for only the selected promoter by filtering the data
    data <- data[data$name %in% input$assayCheckGroup,]
    
    # construct the plot
    plot <- ggplot(data, aes(score, fill=Variant_Classification)) +
      geom_density(alpha=.7) + geom_vline(data=variantXintercept, aes(xintercept=score)) +
      theme_bw() +
      theme(strip.text=element_text(color="white"), strip.background=element_rect(fill="black")) +
      scale_fill_manual("Promoter Domain",
                        values=c("#EAB543", "#58B19F")) +
      facet_wrap(~name, drop=TRUE)
    
    return(plot)
  })
  
}

heatmapPlot <- function(input, data){
  
  renderPlot({
    data$position_aa <- factor(data$position_aa, levels=as.character(1:yamlInputs$transcript_AA_length))
    data <- data[data$name %in% input$assayCheckGroup2,]
    plot <- ggplot(data, aes(x=mt_aa, y=position_aa, fill=score)) + geom_tile() + scale_fill_viridis() +
      facet_wrap(~name, drop=TRUE) + theme(axis.text.y=element_blank(), axis.ticks=element_blank()) +
      scale_y_discrete(drop=FALSE)
    return(plot)
  })
  
}

#' dataSource
#'
#' Function to render a Source in the dataset tab
#' @name dataSource
#' @rdname Server-Datasets-Tab
#' @param input shiny input object from the UI
#' @return character
#' @details Function corresponds to the Source subheader int he dataset tab
#' , it's purpose is to retrieve a text description based on the selected dataset.
dataSource <- function(input){
  
  renderUI({
    index <- which(sapply(yamlInputs$assay_files, function(x){x$name == input$assaySelect}))
    
      memo <- HTML(paste("Name: ", yamlInputs$assay_files[[index]]$name,
                         "Source: ", yamlInputs$assay_files[[index]]$source,
                       "Description: ", yamlInputs$assay_files[[index]]$description,
                        sep='<br>'))
      
      return(memo)
      
    
  })
}
