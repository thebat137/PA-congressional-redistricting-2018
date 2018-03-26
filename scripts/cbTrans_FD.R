#This script creates a translation table ("cbTrans_FD.csv") that matches each census block used by Fair Democracy to its corresponding official 2010 US Census block.

require(rgdal);
blah <- readOGR(dsn = file.path(dirname(getwd()), "map data", "Fair Democracy", "corrections"), layer = "Block_Shapefile_021618", stringsAsFactors = FALSE);
write.csv(x = blah@data[, c("BLOCK", "BLOCK2010")], file = file.path(dirname(getwd()), "census block data", "cbTrans_FD.csv"), row.names = FALSE);
