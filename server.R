################################################################################
############################### server startup #################################
################################################################################

# Here we perform 1-off tasks at the start of the app to save computational
# time rather than doing it everytime the server talks to the UI

# load back end libraries
library(data.table)
library(ggplot2)
library(DT)
library(reshape2)

################################################################################
##################### Load data and clean it up ################################

# Load variant/promoter dataset
promoterAssay <- fread("data/UMD_variants_US.tsv")

# If assay has "No data" convert these values to NA
promoterAssay[promoterAssay == "No data"] <- NA

# Filter to only columns/rows we would care about
# we're hard coding the transcript here
promoterAssay <- promoterAssay[,c("Transcript t1 NM_000546.5", "Protein P1 TP53_alpha  NP_000537.3",
                                  "Variant_Classification", "WAF1_Act",
                                  "MDM2_Act", "BAX_Act", "_14_3_3_s_Act", "AIP_Act",
                                  "GADD45_Act", "NOXA_Act", "p53R2_Act")]
colnames(promoterAssay) <- c("cDNA_variant", "p_variant", "Variant_Classification", "WAF1_Act",
                             "MDM2_Act", "BAX_Act", "_14_3_3_s_Act", "AIP_Act",
                             "GADD45_Act", "NOXA_Act", "p53R2_Act")
promoterAssay <- promoterAssay[promoterAssay$Variant_Classification == "Missense_Mutation",]

# format the data for the promoter density plot
promoterDensityPlotData <- suppressWarnings(melt(promoterAssay, id.vars=c("cDNA_variant", "p_variant", "Variant_Classification")))
promoterDensityPlotData$value <- suppressWarnings(as.numeric(as.character(promoterDensityPlotData$value)))
promoterDensityPlotData <- as.data.frame(na.omit(promoterDensityPlotData))

################################################################################
##################### Define the shiny server ##################################
################################################################################

# At this point any time the UI updates relevant code here will run so be
# computationally effecient!

# shiny server registration
shinyServer(function(input, output, session){
  
  ############################## ACT Scores Tab ################################
  
  # Here we select a variant from the data
  updateSelectizeInput(
    session, 'variant', server = TRUE,
    choices = promoterAssay$p_variant
  )
    
  # output Raw data table
  output$promoterAssayData <- DT::renderDataTable(promoterAssay[,c("cDNA_variant", "p_variant", "Variant_Classification")],
                                                  rownames=F, options=list(pageLength = 10))
  
  # output the promoter density plot
  output$promoterDensityPlot <- renderPlot({
    
    # find the x-intercept for the combination of promoter groups and variants
    variantXintercept <- promoterDensityPlotData[promoterDensityPlotData$variable %in% input$promoterCheckGroup,]
    variantXintercept <- variantXintercept[variantXintercept$p_variant %in% input$variant,]
    
    # make a density plot for only the selected promoter by filtering the data
    promoterDensityPlotData <- promoterDensityPlotData[promoterDensityPlotData$variable %in% input$promoterCheckGroup,]
    
    # construct the plot
    plot <- ggplot(promoterDensityPlotData, aes(value, fill=variable)) +
           geom_density(alpha=1) + geom_vline(data=variantXintercept, aes(xintercept=value)) +
           theme_bw() +
           theme(strip.text=element_text(color="white"), strip.background=element_rect(fill="black")) +
           scale_fill_manual("Promoter Domain",
                            values=c("#EAB543", "#58B19F", "#82589F", "#182C61",
                                     "#F97F51", "#2C3A47", "#FD7272", "#1B9CFC")) +
    facet_wrap(~variable, drop=TRUE)
    
    return(plot)
   })

})
