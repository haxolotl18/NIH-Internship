library(dplyr)
library(Seurat)
library(patchwork)
library(tidyverse)
library(readr)
library(ggplot2)
#library(celldex) #Like Rolodex for cell datasets; all functions call datasets
library(scRNAseq) #Single Cell RNA sequence datasets
library(SingleR) #Use to bring in SingleR() function, which compares reference and test data for gene similarity
library(scuttle) #logNormCounts function
library(biomaRt)
TS_lung <- readRDS(file = "TS_Lung.rds")
TS_lung <- as.SingleCellExperiment(TS_lung)
TS_lung <- logNormCounts(TS_lung)

Zil_lung <- ZilionisLungData("human")
Zil_lung <- Zil_lung[, colSums(counts(Zil_lung)) > 0]
#Zil_lung <- Zil_lung[, !is.na(Zil_lung$label)]
Zil_lung <- logNormCounts(Zil_lung)

rownames(Zil_lung) = gsub("_.*","",rownames(Zil_lung))

ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
listAttributes(ensembl)

gene_ids <- getBM(attributes = c("ensembl_gene_id", "external_gene_name"),
                  filters = "ensembl_gene_id",
                  values = TS_lung@rowRanges@partitioning@NAMES,
                  mart = ensembl)

gene_e_ids <- gene_ids$ensembl_gene_id
gene_id_names <- gene_ids$external_gene_name

TS_e_ids <- TS_lung@rowRanges@partitioning@NAMES

gene_id_to_name <- setNames(gene_id_names, gene_e_ids)

matched_gene_names <- gene_id_to_name[TS_e_ids]
TS_lung@rowRanges@partitioning@NAMES <- matched_gene_names

pred.TS.Zil <- SingleR(test = Zil_lung,
                       ref = TS_lung,
                       assay.type.test = 1,
                       labels = TS_lung$cell_ontology_class)
table(pred.TS.Zil$labels)

print("Tabula Sapiens Zilionis Lung data prediction comparison complete.")

print("About to make pred TS Zil Heatmap")
png("predTSZilHeatmap.png")
plotScoreHeatmap(pred.TS.Zil)
print("About to make pred TS Zil plotDeltaDistribution")
png("predTSZilDelta.png")
plotDeltaDistribution(pred.TS.Zil, ncol = 3)
print("About to make summary of pred TS Zil pruned labels")
summary(is.na(pred.TS.Zil$pruned.labels))