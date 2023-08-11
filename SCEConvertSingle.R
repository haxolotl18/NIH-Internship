#install.packages("remotes")
#remotes::install_github("theislab/zellkonverter")

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
library(zellkonverter)

args = commandArgs(trailingOnly=T)
inputFile = as.character(args[1])
outputFile = as.character(args[2])
species = as.character(args[3])

if(species == "human"){
  TS_ref <- readH5AD(inputFile)
  #Tabula Sapiens files come in as .h5ad; need this fxn from zellkonverter to utilize
  assays(TS_ref)["counts"] <- assays(TS_ref)["raw_counts"]
  #After conversion the "counts" we expect is named "raw_counts." Simple new column and rename
  TS_ref <- logNormCounts(TS_ref)
  #ensure labels are uniform
  TS_ref$cell_type = TS_ref$cell_ontology_class
  #...
  #check gene names instead of ensembl ids
  saveRDS(TS_ref, outputFile)
}else if(species=="mouse"){
  TM_ref <- load(inputFile)
  #Tabula Muris files come in as an old seurat object
  TM_ref <- UpdateSeuratObject(tiss)
  TM_ref <- as.SingleCellExperiment(TM_ref)
  #Go from Seurat to SCE
  TM_ref <- logNormCounts(TM_ref)
  
  saveRDS(TM_ref, outputFile)
}