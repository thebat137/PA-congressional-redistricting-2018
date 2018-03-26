# This script creates a table in the "census block data" directory that matches each census block to its corresponding census tract.  The purpose of this matching is to enable processing of the map data provided by the Republican intervenors, which was only broken down to the census tract level rather than the census block level.

cbData_shortID <- read.csv(
    file = file.path(dirname(getwd()), "census block data", "cbData_shortID.csv"),
    stringsAsFactors = FALSE,
    colClasses = c(rep("character", 13), rep("integer", 48), rep("numeric", 99)));

cbData_shortID$tractid <- substr(cbData_shortID$geoid10, 1, 11);
tractEquiv <- cbData_shortID[, c("geoid10", "tractid")];

write.csv(x = tractEquiv, file = file.path(dirname(getwd()), "census block data", "tractEquiv.csv"), row.names = FALSE);
