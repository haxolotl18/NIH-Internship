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


print(args)

refFile <- readRDS(file = refFile)

if (location == "external") {
  file_extension <- sub(".*\\.(.*)$", "\\1", testFile)
  if (file_extension == "rds") {
    print (file_extension)
    testFile <- readRDS(file = testFile)
  } else if (file_extension == "Robj") {
    print (file_extension)
    testFile <- load(testFile)
    testFile <- UpdateSeuratObject(tiss)
  }
}

rmarkdown::render("SingleR.Rmd")
#Run SingleR.Rmd (as in Rmd which runs SingleR comparison)
```

rmarkdown::render("SingleR.Rmd")