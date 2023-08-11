setwd("/home/liuat/data/TabulaSapiens")

zip_files <- list.files(pattern = "\\.zip$", full.names = TRUE)

unzip <- function(zip) {
  file_name <- tools::file_path_sans_ext(basename(zip))
  # Unzip the file while keeping names the same
  unzip(zip, exdir = ".", junkpaths = TRUE)
  # Rename the extracted files to the original file name
  extracted_files <- list.files(pattern = paste0("^", file_name))
  for (file in extracted_files) {
    file.rename(file, file_name)
  }
}
# Unzip all the files in the folder
lapply(zip_files, unzip_and_keep_names)