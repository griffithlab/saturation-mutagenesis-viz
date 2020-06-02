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
  colnames(assayData) <- c("name", "hgvs_pro", "score")
  return(assayData)
}

assayData <- lapply(yamlInputs$assay_files, a)
assayData <- rbindlist(assayData)

################################################################################
############# Detect if single or trio amino acid codes are present ############

# split out amino acid positions
assayData$wt_aa <- gsub("(p\\.)*\\(*([A-Za-z]+)([0-9]+)(=|[A-Za-z]+)\\)*", "\\2", assayData$hgvs_pro, perl=T)
assayData$position_aa <- gsub("(p\\.)*\\(*([A-Za-z]+)([0-9]+)(=|[A-Za-z]+)\\)*", "\\3", assayData$hgvs_pro, perl=T)
assayData$mt_aa <- gsub("(p\\.)*\\(*([A-Za-z]+)([0-9]+)(=|[A-Za-z]+)\\)*", "\\4", assayData$hgvs_pro, perl=T)

# convert to trio codes if necessary
if(all(nchar(assayData$wt_aa) == 1)){
  map <- c("A"="Ala", "B"="Asx", "C"="Cys", "D"="Asp", "E"="Glu", "F"="Phe", "G"="Gly",
           "H"="His", "I"="Ile", "K"="Lys", "L"="Leu", "M"="Met", "N"="Asn", "P"="Pro",
           "Q"="Gln", "R"="Arg", "S"="Ser", "T"="Thr", "V"="Val", "W"="Trp", "X"="Xaa",
           "Y"="Tyr", "Z"="Glx", "="="=")
  assayData[,"wt_aa" := switch(as.character(wt_aa), "A"="Ala", "B"="Asx", "C"="Cys", "D"="Asp", "E"="Glu", "F"="Phe", "G"="Gly",
                                 "H"="His", "I"="Ile", "K"="Lys", "L"="Leu", "M"="Met", "N"="Asn", "P"="Pro",
                                 "Q"="Gln", "R"="Arg", "S"="Ser", "T"="Thr", "V"="Val", "W"="Trp", "X"="Xaa",
                                 "Y"="Tyr", "Z"="Glx", "="="="), by=wt_aa]
}

if(all(nchar(assayData$mt_aa) == 1)){
  map <- c("A"="Ala", "B"="Asx", "C"="Cys", "D"="Asp", "E"="Glu", "F"="Phe", "G"="Gly",
           "H"="His", "I"="Ile", "K"="Lys", "L"="Leu", "M"="Met", "N"="Asn", "P"="Pro",
           "Q"="Gln", "R"="Arg", "S"="Ser", "T"="Thr", "V"="Val", "W"="Trp", "X"="Xaa",
           "Y"="Tyr", "Z"="Glx", "="="=")
  assayData[,"mt_aa" := switch(as.character(mt_aa), "A"="Ala", "B"="Asx", "C"="Cys", "D"="Asp", "E"="Glu", "F"="Phe", "G"="Gly",
                                 "H"="His", "I"="Ile", "K"="Lys", "L"="Leu", "M"="Met", "N"="Asn", "P"="Pro",
                                 "Q"="Gln", "R"="Arg", "S"="Ser", "T"="Thr", "V"="Val", "W"="Trp", "X"="Xaa",
                                 "Y"="Tyr", "Z"="Glx", "="="="), by=mt_aa]
}

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

# set if synonymous or not
assayData[,"Variant_Classification" := ifelse(mt_aa == "=", "synonymous", "non synonymous")]


