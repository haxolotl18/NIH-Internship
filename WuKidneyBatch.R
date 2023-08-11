library(dplyr)
library(patchwork)
library(tidyverse)
library(readr)
library(ggplot2)
#library(celldex) #Like Rolodex for cell datasets; all functions call datasets
library(scRNAseq) #Single Cell RNA sequence datasets
library(SingleR) #Use to bring in SingleR() function, which compares reference and test data for gene similarity
library(scuttle) #logNormCounts function
library(biomaRt)
library(Seurat)

#setwd("/Users/liuat/Desktop/Internship")

TM_kid <- load("TM_Kidney.Robj")
TM_kid <- UpdateSeuratObject(tiss)
TM_kid <- as.SingleCellExperiment(TM_kid)
TM_kid <- logNormCounts(TM_kid)