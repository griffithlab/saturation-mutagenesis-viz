################################################################################
############# global script to be sourced by both the UI and Server ############
################################################################################

# Here we perform 1-off tasks at the start of the app to save computational
# time rather than doing it everytime the server talks to the UI

# load necessary libraries
source("scripts/libraryScripts.R")
source("scripts/globalScripts.R")

# load the yaml config
yamlInputs <- read_yaml("setup/inputs.yml")

################################################################################
##################### Load data and clean it up ################################

# load assay files
assayData <- lapply(yamlInputs$assay_files, readAssayData)
assayData <- rbindlist(assayData)

# additional assayData p. notation formatting
assayData <- formatAA(assayData)

# set if synonymous or not
assayData[,"Variant_Classification" := ifelse(mt_aa == "=", "synonymous", "non synonymous")]

################################################################################
######### Master mutation data #################################################

aminoAcidPermutations <- constructDeepScan(yamlInputs$transcript_AA_length)
aminoAcidPermutations <- annoDomain(aminoAcidPermutations, yamlInputs$domain_file)

################################################################################
########## variant categories ##################################################

# predefined variant categories, LOF/GOF etc.
varCategory <- fread("data/varCategory.tsv")
varCategory <- formatAA(varCategory)

