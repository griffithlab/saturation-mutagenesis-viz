heatmapDataToJson <- function(input, data, aminoAcidPermutations){
  
  # subset data to just the dataset of interest
  data <- data[name %in% input]
  
  jsonObject_axis <- toJSON(list("aa_position"=1:yamlInputs$transcript_AA_length, "aa_mt"=unique(aminoAcidPermutations$mt)), dataframe = "columns", null = "null", na = "null",
                       auto_unbox = TRUE, digits = getOption("shiny.json.digits", 16),
                       use_signif = TRUE, force = TRUE, POSIXt = "ISO8601", UTC = TRUE,
                       rownames = FALSE, keep_vec_names = TRUE, json_verabitm = TRUE)
  
  jsonObject_values <- toJSON(data[,.(mt_aa, position_aa, score)], dataframe = "rows", null = "null", na = "null",
                              auto_unbox = TRUE, digits = getOption("shiny.json.digits", 16),
                              use_signif = TRUE, force = TRUE, POSIXt = "ISO8601", UTC = TRUE,
                              rownames = FALSE, keep_vec_names = TRUE, json_verabitm = TRUE)

  jsonObject <- toJSON(list("axis"=fromJSON(jsonObject_axis), "values"=fromJSON(jsonObject_values)))

  return(jsonObject)
}

scatterToJson <- function(input, input2, data){
  data1 <- data[name %chin% input,.(name, hgvs_pro, score)]
  data1[,name := NULL]
  colnames(data1) <- c("hgvs_pro", "score")
  data2 <- data[name %chin% input2,.(name, hgvs_pro, score)]
  data2[,name := NULL]
  colnames(data2) <- c("hgvs_pro", "score")
  
  data <- merge(data1, data2, by=c("hgvs_pro"))
  colnames(data) <- c("id", "score_x", "score_y")

  jsonObject_values <- toJSON(data, dataframe = "rows", null = "null", na = "null",
                       auto_unbox = TRUE, digits = getOption("shiny.json.digits", 16),
                       use_signif = TRUE, force = TRUE, POSIXt = "ISO8601", UTC = TRUE,
                       rownames = FALSE, keep_vec_names = TRUE, json_verabitm = TRUE)
  
  jsonObject <- toJSON(list("values"=fromJSON(jsonObject_values)))
  
  return(jsonObject)
}
