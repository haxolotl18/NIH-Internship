library(dplyr)
library(Seurat)
library(patchwork)
library(tidyverse)
library(readr)
library(ggplot2)
library(celldex) #Like Rolodex for cell datasets; all functions call datasets
library(scRNAseq) #Single Cell RNA sequence datasets
library(SingleR) #Use to bring in SingleR() function, which compares reference and test data for gene similarity
library(scuttle) #logNormCounts function
library(biomaRt)
library(SingleCellExperiment)

user_input <- commandArgs(trailingOnly = TRUE)
refFile = as.character(args[1])
#extension = as.character(args[])
#Currently don't need extension; every reference file should enter as an rds file
location = as.character(args[2])
#scRNQseq or external
testFile = as.character(args[3])
species = as.character(args[4])

###ref_input <- readline(prompt = "Enter filename of reference dataset: ")
file_extension <- sub(".*\\.(.*)$", "\\1", ref_input)
if (file_extension == "rds") {
  print (file_extension)
  ref_data <- readRDS(file = ref_input)
} else if (file_extension == "Robj") {
  print (file_extension)
  ref_data <- load(ref_input)
  ref_data <- UpdateSeuratObject(tiss)
}
#Take user input. Determine file extension and pipe into a Seurat object.

test_input <- readline(prompt = "Will you load external data (E) or pull from internal (I): ")
if (test_input == 1) {
  print("choice 1")
  test_input2 <- readline(prompt = "Enter the filename of the test dataset: ")
  file_extension <- sub(".*\\.(.*)$", "\\1", test_input2)
  if (file_extension == "rds") {
    print (file_extension)
    test_data <- readRDS(file = test_input2)
  } else if (file_extension == "Robj") {
    print (file_extension)
    test_data <- load(test_input2)
    test_data <- UpdateSeuratObject(tiss)
  }
} else if (test_input == 2) {
  print("choice 2")
  test_input2_str <- readline(prompt = "Please enter the name of the dataset with parentheses: ")
  # Evaluate the user-provided string as a function
  test_data <- tryCatch({
    eval(parse(text = test_input2_str))
  }, error = function(e) {
    cat("Error: Invalid input. The provided string is not a valid function.\n")
    return(NULL)
  })
} else {
  print("Invalid input. Please enter either 1 or 2.")
}

ref_data <- ref_data %>%
  as.SingleCellExperiment() %>%
  logNormCounts()
#Seurat -> SCE; log normalize counts


############## Everything above is processed

if (species == "human") {
  if (length(grep("GAPDH", rownames(refFile))) == 0) {
  print("Your reference file does not seem to be from human data.")
  }
  else if (length(grep("GAPDH", rownames(testFile))) == 0) {
    print("Your test file does not seem to be from human data.")
  }
}
if (species == "mouse") {
  if (length(grep("GAPDH", rownames(refFile))) > 0) {
    print("Your reference file does not seem to be from mouse data.")
  }
  else if (length(grep("GAPDH", rownames(testFile))) > 0) {
    print("Your test file does not seem to be from mouse data.")
  }
}

pred <- SingleR(test = testFile,
                ref = refFile,
                assay.type.test = 1,
                labels = refFile$cell_ontology_class)
table(pred$labels)

