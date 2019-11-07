################################################################################
############# Server side functions ############################################
################################################################################

densityPlot <- function(input, data){
  
  renderPlot({
    
    # find the x-intercept for the combination of promoter groups and variants
    variantXintercept <- data[data$variable %in% c(input$promoterCheckGroup_kato, input$promoterCheckGroup_giacomelli),]
    variantXintercept <- variantXintercept[variantXintercept$p_variant %in% input$variant,]
    
    # make a density plot for only the selected promoter by filtering the data
    data <- data[data$variable %in% c(input$promoterCheckGroup_kato, input$promoterCheckGroup_giacomelli),]
    
    # construct the plot
    plot <- ggplot(data, aes(value, fill=Variant_Classification)) +
      geom_density(alpha=1) + geom_vline(data=variantXintercept, aes(xintercept=value)) +
      theme_bw() +
      theme(strip.text=element_text(color="white"), strip.background=element_rect(fill="black")) +
      scale_fill_manual("Promoter Domain",
                        values=c("#EAB543", "#58B19F")) +
      facet_wrap(~variable, drop=TRUE)
    
    return(plot)
  })
  
}

heatmapPlot <- function(input, data){
  
  renderPlot({
    data$position_aa <- factor(data$position_aa, levels=as.character(1:394))
    data <- data[data$variable %in% c(input$promoterCheckGroup2_kato, input$promoterCheckGroup2_giacomelli),]
    plot <- ggplot(data, aes(x=mt_aa, y=position_aa, fill=value)) + geom_tile() + scale_fill_viridis() +
      facet_wrap(~variable, drop=TRUE) + theme(axis.text.y=element_blank(), axis.ticks=element_blank())
    return(plot)
  })
  
}

#' dataDescriptions
#'
#' Function to render a Description in the dataset tab
#' @name dataDescriptions
#' @rdname Server-Datasets-Tab
#' @param input shiny input object from the UI
#' @return character
#' @details Function corresponds to the Description subheader int he dataset tab
#' , it's purpose is to retrieve a text description based on the selected dataset.
dataDescriptions <- function(input){
  
  renderUI({
    
    if(input$dataset == 1){
      memo <- HTML("Arpad to fill in")
    } else if(input$dataset == 2){
      memo <- HTML("Arpad to fill in")
    }
    return(memo)
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
    
    if(input$dataset == 1){
      memo <- HTML(paste("Manuscript: The TP53 website: an integrative resource centre for the TP53 mutation database and TP53 mutant analysis",
                       "Author: What should we put here?",
                       "Year: 2017",
                       "Source: Website",
                       "Link: https://p53.fr/images/Database/UMD_variants_US.tsv.zip", sep='<br>'))
      
    } else if(input$dataset == 2){
      memo <- HTML(paste("Manuscript: Mutational processes shape the landscape of TP53 mutations in human cancer",
                       "Author: Andrew O. Giacomelli",
                       "Year: 2018",
                       "Source: Supplemental Table 3",
                       "Link: NA", sep='<br>'))
    }
    return(memo)
  })
}

#' dataColumns
#'
#' Function to render a Column description in the dataset tab
#' @name dataColumn
#' @rdname Server-Datasets-Tab
#' @param input shiny input object from the UI
#' @return character
#' @details Function corresponds to the Column Used subheader in the dataset tab
#' , it's purpose is to retrieve a text description based on the selected dataset.
dataColumns <- function(input){
  
  renderUI({
    
    if(input$dataset == 1){
      memo <- HTML("\"WAF1_Act\", \"MDM2_Act\", \"BAX_Act\", \"_14_3_3_s_Act\", \"AIP_Act\",
                       \"GADD45_Act\", \"NOXA_Act\", \"p53R2_Act\"")
    } else if(input$dataset == 2){
      memo <- HTML("\"A549_p53WT_Nutlin-3_Z-score\", \"A549_p53NULL_Nutlin-3_Z-score\", \"A549_p53NULL_Etoposide_Z-score\"")
    }
    return(memo)
  })
}

#' dataPreProcess
#'
#' Function to render a Description in the dataset tab
#' @name dataPreProcess
#' @rdname Server-Datasets-Tab
#' @param input shiny input object from the UI
#' @return character
#' @details Function corresponds to the Pre-Processing subheader in the dataset tab
#' , it's purpose is to retrieve a text description based on the selected dataset.
dataPreProcess <- function(input){
  
  renderUI({
    
    if(input$dataset == 1){
      memo <- HTML("Data was restricted to Missense and Nonsense Mutations")
    } else if(input$dataset == 2){
      memo <- HTML("None")
    }
    return(memo)
  })
}

#' dataPostProcess
#'
#' Function to render a Description in the dataset tab
#' @name dataPostProcess
#' @rdname Server-Datasets-Tab
#' @param input shiny input object from the UI
#' @return character
#' @details Function corresponds to the Post-Processing subheader in the dataset tab
#' , it's purpose is to retrieve a text description based on the selected dataset.
dataPostProcess <- function(input){
  
  renderUI({
    
    if(input$dataset == 1){
      memo <- HTML("None")
    } else if(input$dataset == 2){
      memo <- HTML("None")
    }
    return(memo)
  })
}