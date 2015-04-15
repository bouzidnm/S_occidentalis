###############################################################
# Sceloporus occidentalis data downloaded from GBIF 30 Mar 2015
# Sima Bouzid

## Read in data
occ_data <- read.csv("occurrence.txt", sep="\t", header=TRUE, na.strings = c("", " "))

## Plot all records by institution
museums <- occ_data$institutionCode
specimens <- table(museums)
specimen_hist <- barplot(specimens, axes=T, axisnames=T, ylab="# specimens", main=expression(paste(italic("Sceloporus occidentalis "), "by Institution")), las=2)
mtext("Institution", side=1, line=5)

### Subdivide by Institution & export as .csv
## occ_data$occurrenceRemarks!=""
occ_CAS <- occ_data[occ_data$institutionCode=="CAS",]

## Things with SVL already measured; output .csv file
occ_CAS_SVL <- grep("\\<SVL\\>", occ_CAS$occurrenceRemarks)
occ_CAS_SVL_measured <- occ_CAS[occ_CAS_SVL,]
write.csv(occ_CAS_SVL_measured, file="CAS_SVL_measured.csv")
occ_CAS <- occ_CAS[-occ_CAS_SVL,]

## Alcohol specimens only
occ_CAS_fluid <-  grep("\\<Alcohol\\>", occ_CAS$preparations)
occ_CAS <- occ_CAS[occ_CAS_fluid,]

# Not lost, missing, or destroyed
occ_CAS_lost <- grep("\\<Lost\\>", occ_CAS$occurrenceRemarks)
occ_CAS <- occ_CAS[-occ_CAS_lost,]
occ_CAS_missing <- grep("\\<Missing\\>", occ_CAS$occurrenceRemarks)
occ_CAS <- occ_CAS[-occ_CAS_missing,]
occ_CAS_destroyed <- grep("\\<Destroyed\\>", occ_CAS$occurrenceRemarks)
occ_CAS_toMeasure <- occ_CAS[-occ_CAS_destroyed,]

# Remove columns with all NAs
occ_CAS_toMeasure <- occ_CAS_toMeasure[, unlist(lapply(occ_CAS_toMeasure, function(x) !all(is.na(x))))]

## Write .csv of specimens to measure
write.csv(occ_CAS_toMeasure, file="CAS_SVL_toMeasure.csv")

## Remove all records without lat/long
CAS_toMeasure <- read.csv("CAS_SVL_toMeasure.csv")
CAS <- subset(CAS_toMeasure, decimalLatitude!="NA" & decimalLongitude!="NA")
write.csv(CAS, file="CAS_toMeasure.csv")
write.csv(scelop_subsets, file="scelop_subsets.csv")





