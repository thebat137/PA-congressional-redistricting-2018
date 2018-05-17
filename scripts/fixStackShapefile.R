# This script corrects the erroneous district number labels in the shapefile proposed by Lt. Governor Stack.  The correct numbers can be found in the map on page 9 of the PDF report submitted with the map, stored in this repository as "map data/Stack/docs/Proposed Districting Plans Lt Gov Stack - 006813.pdf".  These numbers match the numbers used in the Lt. Governor's submitted block equivalency file.

require(rgdal);
require(stringr);

dataLocations <- read.csv(file = "dataLocations.csv", stringsAsFactors = FALSE, colClasses = c(rep("character", 5), "integer", "character", "integer", "integer"));

i <- 12;
shapefile <- rgdal::readOGR(dsn = file.path(dirname(getwd()), "map data", dataLocations[i, "dsn"], "corrections"), layer = str_replace(dataLocations[i, "layer"], "fixed_", ""), stringsAsFactors = FALSE);

shapefile$Districts <- c(15, 13, 10, 17, 11, 16, 6, 7, 2, 1, 8, 4, 5, 9, 18, 14, 12, 3);

writeOGR(
    obj = shapefile,
    dsn = file.path(dirname(getwd()), "map data", dataLocations[i, "dsn"], "corrections"),
    layer = dataLocations[i, "layer"],
    driver = "ESRI Shapefile",
    check_exists = TRUE,
    overwrite_layer = TRUE);
