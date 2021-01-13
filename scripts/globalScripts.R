################################################################################
################ Global Script File ############################################

#' readAssayData
#' 
#' Function to read in files from deep mutation scan as specified in the setup yml
#' @rdname global-scripts
#' @param setupYaml list of assay data coming from the setup yml config file
#' specified by the user
#' @return data.table of read in assay data
#' @details This function will scan the assay section of yaml file in the setup
#' subdirectory and then perform minor cleanup steps to ensure consistency.
readAssayData <- function(setupYaml){
  name <- setupYaml$name
  file <- paste0("data/", setupYaml$file)
  assayData <- fread(file)
  assayData[,"name" := name]
  cols <- c("name", setupYaml$position_columns, setupYaml$data_columns)
  assayData <- assayData[,..cols]
  colnames(assayData) <- c("name", "hgvs_pro", "score")
  assayData[,score := median(score), by=.(hgvs_pro, name)]
  assayData <- unique(assayData)
  return(assayData)
}

#' constructDeepScan
#' 
#' Function to construct all possible single amino acid changes for a protein
#' @rdname global-scripts
#' @param proteinLength Integer specifying the number of amino acids in a protein.
#' @return data.table of all possible protein changes
#' @details This function takes an integer and constructs a table in p. notation
#' of all possible single amino acid changes for that protein.
constructDeepScan <- function(aminoAcidCount) {
  
  coord <- 1:aminoAcidCount
  aminoAcid <- c("Ala", "Cys", "Asp", "Glu", "Phe", "Gly", "His", "Ile", "Lys",
                 "Leu", "Met", "Asn", "Pro", "Gln", "Arg", "Ser", "Thr", "Val",
                 "Trp", "Tyr")
  
  aminoAcidPermutations <- CJ(aminoAcid, coord, aminoAcid)
  colnames(aminoAcidPermutations) <- c("wt", "coord", "mt")
  aminoAcidPermutations <- aminoAcidPermutations[wt == mt, mt := "="]
  aminoAcidPermutations[,"p_variant" := paste0("p.", wt, coord, mt)]
  aminoAcidPermutations[,`:=`(domainLongName=NA, domainShortName=NA)]
  return(aminoAcidPermutations)
}

#' formatAA
#' 
#' Function to format p.notation amino acid codes into expected format
#' 
#' @rdname global-scripts
#' @param proteinData data.table object containing the column hgvs_pro corresponging to hgvs
#' p. notation
#' @return data.table formatted to expectations
#' @details This function takes the data.table object from readAssayData and
#' formats the p. notation column to be trio codes if necessary, it also splits
#' out WT, MT, Coord from the p.notation into separate columns. Any data.table object
#' with an hgvs_pro column will be sufficient.

formatAA <- function(proteinData){
  
  # split out amino acid positions
  proteinData$wt_aa <- gsub("(p\\.)*\\(*([A-Za-z]+)([0-9]+)(=|[A-Za-z]+)\\)*", "\\2", proteinData$hgvs_pro, perl=T)
  proteinData$position_aa <- gsub("(p\\.)*\\(*([A-Za-z]+)([0-9]+)(=|[A-Za-z]+)\\)*", "\\3", proteinData$hgvs_pro, perl=T)
  proteinData$mt_aa <- gsub("(p\\.)*\\(*([A-Za-z]+)([0-9]+)(=|[A-Za-z]+)\\)*", "\\4", proteinData$hgvs_pro, perl=T)
  
  # convert to trio codes if necessary
  if(all(nchar(proteinData$wt_aa) == 1)){
    map <- c("A"="Ala", "B"="Asx", "C"="Cys", "D"="Asp", "E"="Glu", "F"="Phe", "G"="Gly",
             "H"="His", "I"="Ile", "K"="Lys", "L"="Leu", "M"="Met", "N"="Asn", "P"="Pro",
             "Q"="Gln", "R"="Arg", "S"="Ser", "T"="Thr", "V"="Val", "W"="Trp", "X"="Xaa",
             "Y"="Tyr", "Z"="Glx", "="="=")
    proteinData[,"wt_aa" := switch(as.character(wt_aa), "A"="Ala", "B"="Asx", "C"="Cys", "D"="Asp", "E"="Glu", "F"="Phe", "G"="Gly",
                                 "H"="His", "I"="Ile", "K"="Lys", "L"="Leu", "M"="Met", "N"="Asn", "P"="Pro",
                                 "Q"="Gln", "R"="Arg", "S"="Ser", "T"="Thr", "V"="Val", "W"="Trp", "X"="Xaa",
                                 "Y"="Tyr", "Z"="Glx", "="="="), by=wt_aa]
  }
  
  if(all(nchar(proteinData$mt_aa) == 1)){
    map <- c("A"="Ala", "B"="Asx", "C"="Cys", "D"="Asp", "E"="Glu", "F"="Phe", "G"="Gly",
             "H"="His", "I"="Ile", "K"="Lys", "L"="Leu", "M"="Met", "N"="Asn", "P"="Pro",
             "Q"="Gln", "R"="Arg", "S"="Ser", "T"="Thr", "V"="Val", "W"="Trp", "X"="Xaa",
             "Y"="Tyr", "Z"="Glx", "="="=")
    proteinData[,"mt_aa" := switch(as.character(mt_aa), "A"="Ala", "B"="Asx", "C"="Cys", "D"="Asp", "E"="Glu", "F"="Phe", "G"="Gly",
                                 "H"="His", "I"="Ile", "K"="Lys", "L"="Leu", "M"="Met", "N"="Asn", "P"="Pro",
                                 "Q"="Gln", "R"="Arg", "S"="Ser", "T"="Thr", "V"="Val", "W"="Trp", "X"="Xaa",
                                 "Y"="Tyr", "Z"="Glx", "="="="), by=mt_aa]
  }
  
  proteinData[,hgvs_pro := paste0("p.", wt_aa, position_aa, mt_aa)]
  
  return(proteinData)
}

#' annoDomain
#' 
#' @rdname global-scripts
#' @param aaPermutations data.table of amino acid permutations from constructDeepScan
#' @param domainFile path to file contain protein domains with column names Start, Stop
#' Name, Description
#' @return data.table with domain annotations added
#' @details This function take the data.table from constructDeepScan (which contains all possible AA mutations),
#' and will add the domain annotations from domainFile onto the output from constructDeepScan. Overlapping coordinates
#' have names and descriptions consolidated as comma separated strings.
annoDomain <- function(aaPermutations, domainFile){
  
  if(is.null(domainFile)){
    return(aaPermutations)
  } else {
    file <- paste0("data/", yamlInputs$domain_file)
    tmp <- fread(file)
    tmp <- tmp[,.(coord = as.numeric(Start):as.numeric(Stop)),by=.(Name, Description)]
    tmp <- tmp[,.(domainLongName = paste(Description, collapse=","), domainShortName = paste(Name, collapse=",")), by=.(coord)]
    aaPermutations[,`:=`(domainLongName = NULL, domainShortName = NULL)]
    tmp2 <- merge(aaPermutations, tmp, by="coord", all.x=TRUE)
    return(tmp2)
  }
}
