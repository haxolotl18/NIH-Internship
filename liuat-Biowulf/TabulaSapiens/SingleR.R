library(rmarkdown)

args <- commandArgs(trailingOnly = TRUE)

refFile = as.character(args[1])
#refFile should always come in as an .rds file, extension not needed
#extension = as.character(args[])
#Currently don't need extension; every reference file should enter as an rds file
location = as.character(args[2])
#scRNQseq or external
testFile = as.character(args[3])
species = as.character(args[4])
imageDir <- as.character(args[5])
outputDir <- as.character(args[6])
output1 <- as.character(args[7])
output2 <- as.character(args[8])
outputName <- as.character(args[9])

print(args)

#Set directory to location of rds files

paste0("Output date of this document: ", Sys.Date())

workDir <- getwd()
setwd(workDir)
print(workDir)

print("1,2,3,4,5")

rmarkdown::render("SingleR.Rmd", output_file=paste0("PipelineTest",".html"),output_dir = workDir,
                  params = list(refFile = refFile, location = location, testFile = testFile, species = species, imageDir = imageDir,
                                outputDir = outputDir, output1 = output1, output2 = output2, outputName = outputName))

#/home/liuat/data/TabulaSapiens/