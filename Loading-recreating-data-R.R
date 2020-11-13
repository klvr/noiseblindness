# Loading and recreating matlab-data in R.
# Creating sub-set of data without incongruent trials, translate back to matlab.

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

# Exp1236
Exp1236 <- Exp1236$data
partID <- as.numeric(unique(Exp1236[[1]]))
df <- row.names(c("subject","exp","wasrespcor","biasedtrial","whichcue","whichchosen","responsetimes","contrast","targetarraystd","confidencerts","confidencerep","wasrespoptout","realstdcats", paste("pvs",1:8,sep="")))
data <- row.names(c("subject","exp","wasrespcor","biasedtrial","whichcue","whichchosen","responsetimes","contrast","targetarraystd","confidencerts","confidencerep","wasrespoptout","realstdcats", paste("pvs",1:8,sep="")))
for(i in partID){
  df <- cbind(Exp1236[[1]][Exp1236[[1]]==i], Exp1236[[3]][Exp1236[[1]]==i], Exp1236[[4]][Exp1236[[1]]==i], Exp1236[[5]][Exp1236[[1]]==i], Exp1236[[6]][Exp1236[[1]]==i], Exp1236[[7]][Exp1236[[1]]==i], Exp1236[[9]][Exp1236[[1]]==i], Exp1236[[10]][Exp1236[[1]]==i], Exp1236[[11]][Exp1236[[1]]==i], Exp1236[[12]][Exp1236[[1]]==i], Exp1236[[13]][Exp1236[[1]]==i], Exp1236[[14]][Exp1236[[1]]==i])
  df2 <- Exp1236[[8]][Exp1236[[1]]==i]
  df2 <- matrix(df2,ncol=8)
  df3 <- cbind(df,df2)
  data <- rbind(data,df3)
}
names <- c("subject","wasrespcor","biasedtrial","whichcue","whichchosen","responsetimes","contrast","targetarraystd","confidencerts","confidencerep","wasrespoptout","realstdcats", paste("pvs",1:8,sep=""))
colnames(data) <- names
Exp1236 <- as.data.frame(data)

# Analyses
## Compare mean vs. mode pvs
### Mean
Exp1236$pvsmean <- rowMeans(Exp1236[13:20])
#### Simplified
Exp1236$pvsmean <- as.numeric(Exp1236$pvsmean>0)
Exp1236$pvsmean <- replace(Exp1236$pvsmean, Exp1236$pvsmean==0, -1)
### Mode
pvsmode <- Exp1236[13:20]
pvsmode <- pvsmode>0
pvsmode <- cbind(pvsmode,(rowSums(pvsmode)-4))
pvsmode <- cbind(pvsmode, pvsmode[,9]>0, (pvsmode[,9]<0)*-1)
pvsmode <- cbind(pvsmode, rowSums(pvsmode[,10:11]))
Exp1236$pvsmode <- pvsmode[,12]
### Equal mean and mode
equal <- sum(Exp1236$pvsmean==Exp1236$pvsmode, na.rm=TRUE)/(sum(Exp1236$pvsmean==Exp1236$pvsmode, na.rm=TRUE)+sum(Exp1236$pvsmean!=Exp1236$pvsmode, na.rm=TRUE))
print(equal)
### Discrepancy between mean and mode
discrep <- sum(Exp1236$pvsmean!=Exp1236$pvsmode, na.rm=TRUE)/(sum(Exp1236$pvsmean==Exp1236$pvsmode, na.rm=TRUE)+sum(Exp1236$pvsmean!=Exp1236$pvsmode, na.rm=TRUE))
print(discrep)

# Subset of data with only non-discpreancy trials
Exp1236$equal <- Exp1236$pvsmean==Exp1236$pvsmode
Exp1236Sub <- Exp1236[Exp1236$equal,]


