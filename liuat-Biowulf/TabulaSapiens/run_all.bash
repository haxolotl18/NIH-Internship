#!/bin/bash

module load R

Rscript SingleR.R TS_Pancreas.rds external MuraroPancreasData human /home/liuat/data/TabulaSapiens /home/liuat/data/TabulaSapiens scatterTabPred.png scatterLab.png scatter_Sap_Mur_Panc.png
