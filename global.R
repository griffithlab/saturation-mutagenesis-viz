################################################################################
############# global script to be sourced by both the UI and Server ############
################################################################################

# load necessary libraries
source("scripts/libraryScripts.R")

# load the yaml config
yamlInputs <- read_yaml("setup/inputs.yml")

# Here we perform 1-off tasks at the start of the app to save computational
# time rather than doing it everytime the server talks to the UI

################################################################################
##################### Load data and clean it up ################################

#################### Input Yaml Data ###########################################
a <- function(x){
  name <- x$name
  file <- paste0("data/", x$file)
  assayData <- fread(file)
  assayData[,"name" := name]
  cols <- c("name", x$position_columns, x$data_columns)
  assayData <- assayData[,..cols]
  return(assayData)
}

assayData <- lapply(yamlInputs$assay_files, a)
assayData <- rbindlist(assayData)

################################################################################
######### Master mutation data #################################################

coord <- 1:yamlInputs$transcript_AA_length
aminoAcid <- c("Ala", "Cys", "Asp", "Glu", "Phe", "Gly", "His", "Ile", "Lys",
               "Leu", "Met", "Asn", "Pro", "Gln", "Arg", "Ser", "Thr", "Val",
               "Trp", "Tyr")

aminoAcidPermutations <- CJ(aminoAcid, coord, aminoAcid)
colnames(aminoAcidPermutations) <- c("wt", "coord", "mt")
aminoAcidPermutations <- aminoAcidPermutations[wt == mt, mt := "="]
aminoAcidPermutations[,"p_variant" := paste0("p.", wt, coord, mt)]
aminoAcidPermutations[,c("wt", "mt") := NULL]
aminoAcidPermutations[,`:=`(domainLongName=NA, domainShortName=NA)]

################################################################################
########## variant categories ##################################################

# predefined variant categories, LOF/GOF etc.
varCategory <- fread("data/varCategory.tsv")

######################## format data for heatmaps ##############################

# split out amino acid positions
assayData$wt_aa <- gsub("p\\.\\(*([A-Za-z]+)([0-9]+)(=|[A-Za-z]+)\\)*", "\\1", assayData$hgvs_pro, perl=T)
assayData$position_aa <- gsub("p\\.\\(*([A-Za-z]+)([0-9]+)(=|[A-Za-z]+)\\)*", "\\2", assayData$hgvs_pro, perl=T)
assayData$mt_aa <- gsub("p\\.\\(*([A-Za-z]+)([0-9]+)(=|[A-Za-z]+)\\)*", "\\3", assayData$hgvs_pro, perl=T)

# set if synonymous or not
assayData[,"Variant_Classification" := ifelse(mt_aa == "=", "synonymous", "non synonymous")]


