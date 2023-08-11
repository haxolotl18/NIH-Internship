args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  cat("No arguments provided. Please provide some words as command-line arguments.\n")
} else {
  cat("You provided the following words as command-line arguments:\n")
  
  # Print each word provided as an argument
  for (word in args) {
    cat(word, "\n")
  }
}