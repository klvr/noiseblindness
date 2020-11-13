# Loading and recreating matlab-data in R.

#Get the R.matlab package to read mat-data (if not installed), and load the package.
pakke <- library()
if (sum(grepl("R.matlab", pakke$results)) < 1) {
  install.packages("R.matlab", dependencies = TRUE)
  library(R.matlab)
} else {
  library(R.matlab)
}

# Download data.
## Download from OSF/Archive of OSF Storage/Data.
## Place into wd and unzip.
### Data-files should thus be place in paste(getwd(), "/Data/",sep="").

# Load data
path <- paste(getwd(), "/Data/",sep="")
files <- list.files(path)
Exp1236 <- readMat(paste(path,files[2],sep=""))
Exp4 <- readMat(paste(path,files[3],sep=""))
Exp5 <- readMat(paste(path,files[4],sep=""))