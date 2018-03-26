# This script begins with the census block level data table provided in the 2011 legislative redistricting data (here stored as cbLayer.csv).  It then strips out all of the non-aggregatable chaff (i.e. everything that's not a unique identifier or a demographic/electoral statistic), and writes it out to two files:
# - cbDataShortID.csv aggregates the census blocks used by the legislature into its corresponding official 2010 US Census blocks.  Most legislative census blocks and US Census blocks are identical, but a few of 2010 US Census blocks were divided in the legislature's data.
# - tractData.csv aggregates these census blocks by census tract, for use with the tract-level district assignment data provided by some parties.

require(stringr);

# load cleaned-up demographic/electoral data for the census blocks used by the legislature
cbData <- read.csv(
    file = file.path(dirname(getwd()), "census block data", "cbLayer.csv"),
    stringsAsFactors = FALSE,
    colClasses = c(rep("character", 39), rep("integer", 48), "numeric", "character", rep("numeric", 106)));
cbData[is.na(cbData)] <- 0;
cbData <- cbData[, c(89, 6, 20:30, 40:87, 94:141, 143:193)];
cbData$countyfp10 <- stringr::str_pad(cbData$countyfp10, 3, pad = "0");
cbData$tractce10 <- stringr::str_pad(cbData$tractce10, 6, pad = "0");
cbData$blockce10 <- stringr::str_pad(cbData$blockce10, 4, pad = "0");
#write.csv(x = cbData, file = file.path(dirname(getwd()), "census block data", "cbData.csv"), row.names = FALSE);

#cbDataShortID <- cbData;
#cbDataShortID$geoid10 <- as.character(gsub("-P[0-9]", "", cbDataShortID$geoid10));
#cbDataShortID <- stats::aggregate(
#    formula = formula(paste("cbind(", paste(names(cbDataShortID)[14:160], collapse = ", "), ") ~ .", sep = "")),
#    data = cbDataShortID,
#    FUN = sum);
#write.csv(x = cbDataShortID, file = file.path(dirname(getwd()), "census block data", "cbDataShortID.csv"), row.names = FALSE);
#
#tractData <- stats::aggregate(
#    formula = formula(paste("cbind(", paste(names(cbDataShortID)[14:160], collapse = ", "), ") ~ .", sep = "")),
#    data = cbDataShortID[, c(10:12, 14:160)],
#    FUN = sum);
#tractData$geoid10 <- paste(tractData$statefp10, tractData$countyfp10, tractData$tractce10, sep = "");
#tractData <- tractData[, c(151, 1:150)];
#write.csv(x = tractData, file = file.path(dirname(getwd()), "census block data", "tractData.csv"), row.names = FALSE);

# aggregate demographic/electoral data into official 2010 US Census blocks
cbData$geoid10 <- as.character(gsub("-P[0-9]", "", cbData$geoid10));
cbData <- stats::aggregate(
    formula = formula(paste("cbind(", paste(names(cbData)[14:160], collapse = ", "), ") ~ .", sep = "")),
    data = cbData,
    FUN = sum);
write.csv(x = cbData, file = file.path(dirname(getwd()), "census block data", "cbDataShortID.csv"), row.names = FALSE);

# aggregate demographic/electoral data into census tracts
cbData <- stats::aggregate(
    formula = formula(paste("cbind(", paste(names(cbData)[14:160], collapse = ", "), ") ~ .", sep = "")),
    data = cbData[, c(10:12, 14:160)],
    FUN = sum);
cbData$geoid10 <- paste(cbData$statefp10, cbData$countyfp10, cbData$tractce10, sep = "");
cbData <- cbData[, c(151, 1:150)];
write.csv(x = cbData, file = file.path(dirname(getwd()), "census block data", "tractData.csv"), row.names = FALSE);
