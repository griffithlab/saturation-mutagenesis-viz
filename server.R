################################################################################
############################### server startup #################################
################################################################################

source("global.R")


# Here we perform 1-off tasks at the start of the app to save computational
# time rather than doing it everytime the server talks to the UI

################################################################################
##################### Load data and clean it up ################################

################# kato et al. dataset ##########################################

# Load variant/promoter dataset
kato <- fread("data/kato_et_al_db.tsv")

# If assay has "No data" convert these values to NA
kato[kato == "No data"] <- NA

# Filter to only columns/rows we would care about
# we're hard coding the transcript here
kato <- kato[,c("Transcript t1 NM_000546.5", "Protein P1 TP53_alpha  NP_000537.3",
                                  "Variant_Classification", "WAF1_Act",
                                  "MDM2_Act", "BAX_Act", "_14_3_3_s_Act", "AIP_Act",
                                  "GADD45_Act", "NOXA_Act", "p53R2_Act")]
colnames(kato) <- c("cDNA_variant", "p_variant", "Variant_Classification", "WAF1_Act",
                             "MDM2_Act", "BAX_Act", "_14_3_3_s_Act", "AIP_Act",
                             "GADD45_Act", "NOXA_Act", "p53R2_Act")

kato <- kato[kato$Variant_Classification == "Missense_Mutation" | kato$Variant_Classification == "Nonsense_Mutation",]
kato$publication <- "kato et al. 2013"

################# giacomelli et al. 2018 dataset ###############################

# read data in
giacomelli <- fread("data/giacomelli_et_al_2018.tsv")
giacomelli$Variant_Classification <- ifelse(giacomelli$AA_variant == "B", "synonymous", "non synonymous")
giacomelli$cDNA_variant <- NA

# calculate normalized score
giacomelli$score <- (giacomelli$`A549_p53WT_Nutlin-3_Z-score` +
                       giacomelli$`A549_p53NULL_Nutlin-3_Z-score` -
                       giacomelli$`A549_p53NULL_Etoposide_Z-score`)/3

a <- function(x){
  
  x <- as.numeric(x[c("A549_p53WT_Nutlin-3_Z-score", "A549_p53NULL_Nutlin-3_Z-score", "A549_p53NULL_Etoposide_Z-score")])
  x[3] <- (-1*x[3])
  sd(x)/sqrt(3)
}

giacomelli$publication <- "giacomelli et al. 2018"
giacomelli$p_variant <- paste0("p.", giacomelli$AA_wt, giacomelli$Position, giacomelli$AA_variant)
# giacomelli$sd <- apply(giacomelli, 1, a)
# giacomelli$test <- giacomelli$`A549_p53NULL_Nutlin-3_Z-score`
# giacomelli$test <- giacomelli$`A549_p53NULL_Etoposide_Z-score`
# giacomelli$test <- giacomelli$`A549_p53WT_Nutlin-3_Z-score`
# 
# ggplot(giacomelli, aes(x=test, fill=Variant_Classification)) + geom_density(alpha=.5)
#browser()
#ggplot(tmp, aes(x=AA_variant, y=Position)) + geom_tile() + scale_fill_viridis(aes(fill=`A549_p53WT_Nutlin-3_Z-score`))
#tmp <- giacomelli[,c("AA_wt", "AA_variant", "Position", "A549_p53WT_Nutlin-3_Z-score")]

####################### combine papers #########################################

# format the data for the promoter density plot
promoterDensityPlotData_kato <- suppressWarnings(melt(kato, id.vars=c("cDNA_variant", "p_variant", "Variant_Classification", "publication")))
promoterDensityPlotData_kato[promoterDensityPlotData_kato$Variant_Classification == "Nonsense_Mutation","value"] <- NA
promoterDensityPlotData_kato$Variant_Classification <- "non synonymous"
promoterDensityPlotData_kato$value <- suppressWarnings(as.numeric(as.character(promoterDensityPlotData_kato$value)))
promoterHeatmapPlotData_kato <- promoterDensityPlotData_kato
promoterDensityPlotData_kato <- as.data.frame(na.omit(promoterDensityPlotData_kato))

promoterDensityPlotData_giacomelli <- suppressWarnings(melt(giacomelli[,c("cDNA_variant", "p_variant", "Variant_Classification", "publication", "A549_p53WT_Nutlin-3_Z-score", "A549_p53NULL_Nutlin-3_Z-score", "A549_p53NULL_Etoposide_Z-score")], id.vars=c("cDNA_variant", "p_variant", "Variant_Classification", "publication")))
promoterDensityPlotData_giacomelli$value <- suppressWarnings(as.numeric(as.character(promoterDensityPlotData_giacomelli$value)))
promoterDensityPlotData_giacomelli <- as.data.frame(promoterDensityPlotData_giacomelli)
promoterHeatmapPlotData_giacomelli <- promoterDensityPlotData_giacomelli

# combine the data
promoterDensityPlotData <- rbind(promoterDensityPlotData_giacomelli, promoterDensityPlotData_kato)
promoterHeatmapPlotData <- rbind(promoterHeatmapPlotData_giacomelli, promoterHeatmapPlotData_kato)

######################## format data for heatmaps ##############################

# split out amino acid positions
promoterHeatmapPlotData$wt_aa <- gsub("p\\.\\(*([A-Z]+)([0-9]+)([A-Z]+)\\)*", "\\1", promoterHeatmapPlotData$p_variant, perl=T)
promoterHeatmapPlotData$position_aa <- gsub("p\\.\\(*([A-Z]+)([0-9]+)([A-Z]+)\\)*", "\\2", promoterHeatmapPlotData$p_variant, perl=T)
promoterHeatmapPlotData$mt_aa <- gsub("p\\.\\(*([A-Z]+)([0-9]+)([A-Z]+)\\)*", "\\3", promoterHeatmapPlotData$p_variant, perl=T)

# remove na's
promoterHeatmapPlotData <- promoterHeatmapPlotData[-which(is.na(promoterHeatmapPlotData$value)),]

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
    choices = kato$p_variant
  )
    
  # output Raw data table
  output$promoterAssayData <- DT::renderDataTable(promoterDensityPlotData[,c("cDNA_variant", "p_variant", "Variant_Classification", "publication")],
                                                  rownames=F, options=list(pageLength = 10))
  
  # output the promoter density plot
  output$promoterDensityPlot <- renderPlot({
    
    # find the x-intercept for the combination of promoter groups and variants
    variantXintercept <- promoterDensityPlotData[promoterDensityPlotData$variable %in% c(input$promoterCheckGroup_kato, input$promoterCheckGroup_giacomelli),]
    variantXintercept <- variantXintercept[variantXintercept$p_variant %in% input$variant,]
    
    # make a density plot for only the selected promoter by filtering the data
    promoterDensityPlotData <- promoterDensityPlotData[promoterDensityPlotData$variable %in% c(input$promoterCheckGroup_kato, input$promoterCheckGroup_giacomelli),]
    
    # construct the plot
    plot <- ggplot(promoterDensityPlotData, aes(value, fill=Variant_Classification)) +
           geom_density(alpha=1) + geom_vline(data=variantXintercept, aes(xintercept=value)) +
           theme_bw() +
           theme(strip.text=element_text(color="white"), strip.background=element_rect(fill="black")) +
           scale_fill_manual("Promoter Domain",
                            values=c("#EAB543", "#58B19F")) +
    facet_wrap(~variable, drop=TRUE)
    
    return(plot)
   })
  
  # heatmap plot
  output$promoterHeatmapPlot <- renderPlot({
    promoterHeatmapPlotData$position_aa <- factor(promoterHeatmapPlotData$position_aa, levels=as.character(1:394))
    promoterHeatmapPlotData <- promoterHeatmapPlotData[promoterHeatmapPlotData$variable %in% c(input$promoterCheckGroup2_kato, input$promoterCheckGroup2_giacomelli),]
    plot <- ggplot(promoterHeatmapPlotData, aes(x=mt_aa, y=position_aa, fill=value)) + geom_tile() + scale_fill_viridis() +
      facet_wrap(~variable, drop=TRUE) + theme(axis.text.y=element_blank(), axis.ticks=element_blank())
    return(plot)
  })

})
