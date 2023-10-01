#!/bin/bash

. "/data/CCBR_Pipeliner/db/PipeDB/Conda/etc/profile.d/conda.sh"
#conda init scRNA4
conda activate scRNA4
module load R/4.2
module load python

Rscript workflow/scripts/integrationReport.R ONB_merged.rds ONB_integrated_cca.rds ONB_harmonyGroup.rds ONB_harmonySample.rds ONB_rpca.rds $PWD/integration/images $PWD/integration 0.2,0.4,0.6,0.8,1.0,1.2,1.4 ONB YES NO
