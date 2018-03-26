# This script:
#
# 1. Loads each set of block equivalency and shapefiles provided by the various parties
# 2. Converts the various block equivalency file formats to a single standardized format using official 2010 US Census blocks
# 3. For each district in each proposed map, aggregates the corresponding demographic and electoral data present in the Pennsylvania legislature's official 2011 redistricting data and collects this into a single standardized ESRI shapefile format for each proposed map.
# 4. Computes a few aggregate statistics for each proposed map.
#
# Processing information about each proposed map is contained in the dataLocations.csv file stored in this directory.  Raw data and some documentation for each proposed map are stored in the "map data" directory.  Census-block level demographic and electoral data, and a few translation tables related to the census blocks, are stored in the "census block data" directory.
#
# Standardized block equivalency and shapefiles are output to the "standardized data" directory.  Aggregate map statistics are output to the "map statistics" directory.


# initialization
require(rgdal);
require(stringr);
require(maptools);
require(sp);
require(geosphere);

dataLocations <- read.csv(file = "dataLocations.csv", stringsAsFactors = FALSE, colClasses = c(rep("character", 5), "integer", "character", "integer", "integer"));
planCount <- nrow(dataLocations);

cbDataShortID <- read.csv(
    file = file.path(dirname(getwd()), "census block data", "cbDataShortID.csv"),
    stringsAsFactors = FALSE,
    colClasses = c(rep("character", 13), rep("integer", 48), rep("numeric", 99)));
cbTransFD <- read.csv(file.path(dirname(getwd()), "census block data", "cbTransFD.csv"), stringsAsFactors = FALSE, colClasses = "character");
tractEquiv <- read.csv(
    file = file.path(dirname(getwd()), "census block data", "tractEquiv.csv"),
    stringsAsFactors = FALSE,
    colClasses = "character");

stats <- array(data = NA, dim = c(planCount, 17), dimnames = list(dataLocations$name, c("pop_max", "pop_min", "pop_dev", "pp_min", "pp_mean", "pp_max", "sch_min", "sch_mean", "sch_max", "isc_min", "isc_mean", "isc_max", "maj-min", "r_dist", "d_dist", "c_dist", "med-mean")));

# cycle through all the plans
for(i in 1 : planCount)
 {
  #load and clean up the district shapefile
  print(dataLocations[i, "name"]);
  print("  Loading district shapefile...");
  if(dataLocations[i, "dsn"] == "")
   {
    shapefile <- NULL;
   }
  else
   {
    shapefile <- rgdal::readOGR(dsn = file.path(dirname(getwd()), "map data", dataLocations[i, "dsn"], "shapefiles"), layer = dataLocations[i, "layer"], stringsAsFactors = FALSE);
    shapefile <- shapefile[, dataLocations[i, "sfDistrictCol"]];
    names(shapefile)[1] <- "OldDist";
    shapefile$OldDist <- as.numeric(shapefile$OldDist);
    oldDists <- sort(as.numeric(unique(shapefile$OldDist)));
    dists = data.frame(OldDist = oldDists, District = stringr::str_pad(c(1:length(oldDists)), 2, pad = "0"), stringsAsFactors = FALSE);
    shapefile <- merge(shapefile, dists, by = "OldDist");
    shapefile <- shapefile[, "District"];

    if(dataLocations[i, "sfType"] == "tract")
     {
      sfData <- data.frame(District = unique(shapefile@data$District), stringsAsFactors = FALSE);
      sfPolys <- maptools::unionSpatialPolygons(SpP = shapefile, IDs = shapefile$District);  # combine the polygons for each set of merged units
      shapefile <- sp::SpatialPolygonsDataFrame(Sr = sfPolys, data = sfData, match.ID = "District");
     }
   }

  #load and clean up the block equivalency file
  print("  Loading block equivalency file...");
  if(dataLocations[i, "bef"] == "")
   {
    bef <- NULL;
   }
  else
   {
    bef <- read.csv(file = file.path(dirname(getwd()), "map data", dataLocations[i, "dsn"], "block equivalency files", dataLocations[i, "bef"]), stringsAsFactors = FALSE, colClasses = list("character", "character"));
    bef <- bef[, as.numeric(c(dataLocations[i, "befBlockIDCol"], dataLocations[i, "befDistrictCol"]))];
    names(bef) <- c("BlockID", "OldDist");
    bef$OldDist <- as.numeric(bef$OldDist);
    oldDists <- sort(as.numeric(unique(bef$OldDist)));
    dists = data.frame(OldDist = oldDists, District = stringr::str_pad(c(1:length(oldDists)), 2, pad = "0"), stringsAsFactors = FALSE);
    bef <- merge(bef, dists, by = "OldDist");
    bef <- bef[, c("BlockID", "District")];

    if(dataLocations[i, "befType"] == "block")
     {
      bef$BlockID <- substr(bef$BlockID, 1, 15);
      bef <- bef[!duplicated(bef$BlockID), ];
     }
    else if(dataLocations[i, "befType"] == "block_FD")
     {
      bef <- merge(cbTransFD, bef, by.x = "BLOCK", by.y = "BlockID");
      bef <- bef[, c("BLOCK2010", "District")];
      names(bef)[1] <- "BlockID";
      bef <- bef[!duplicated(bef$BlockID), ];
      bef <- bef[substr(bef$BlockID, 1, 2) == "42", ];
     }
    else if(dataLocations[i, "befType"] == "tract")
     {
      bef <- merge(bef, tractEquiv, by.x = "BlockID", by.y = "tractid");
      bef <- bef[, c("geoid10", "District")];
      names(bef)[1] <- "BlockID";
     }

    # save the cleaned-up block equivalency file
    write.csv(x = bef, file = file.path(dirname(getwd()), "standardized data", "block equivalency files", paste(dataLocations[i, "name"], ".csv", sep = "")), row.names = FALSE);
   }

  # merge the block data with demographic and electoral stats, add this to the shapefile, and compute some aggregate statistics
  print("  Adding demographics and election data to districts...");
  if(!is.null(bef))
   {
    # add demographic and electoral stats to the districts
    sfData <- merge(cbDataShortID, bef, by.x = "geoid10", by.y = "BlockID");

    sfData <- aggregate(sfData[, names(cbDataShortID[, c(14:160)])], by = list(sfData$District), FUN = sum);
    names(sfData)[1] <- "District";
    shapefile <- merge(shapefile, sfData, by = "District");

    # district population stats
    pop_mean = sum(shapefile$tapersons) / nrow(shapefile);
    shapefile$pop_dev <- (shapefile$tapersons - pop_mean) / pop_mean;
    stats[i, "pop_min"] <- min(shapefile$tapersons);
    stats[i, "pop_max"] <- max(shapefile$tapersons);
    stats[i, "pop_dev"] <- (stats[i, "pop_max"] - stats[i, "pop_min"]) / pop_mean;

    # Polsby-Popper score
    shapefile$ppscore <- areaPolygon(shapefile) * 4 * pi / perimeter(shapefile)^2;
    stats[i, "pp_min"] <- min(shapefile$ppscore);
    stats[i, "pp_mean"] <- mean(shapefile$ppscore);
    stats[i, "pp_max"] <- max(shapefile$ppscore);
    print("Polsby-Popper score (min, mean, max)");
    print(stats[i, c("pp_min", "pp_mean", "pp_max")]);

    # Inverse Schwartzberg score
    shapefile$iscscore <- 2 * sqrt(pi) * sqrt(areaPolygon(shapefile)) / perimeter(shapefile)
    stats[i, "isc_min"] <- min(shapefile$iscscore);
    stats[i, "isc_mean"] <- mean(shapefile$iscscore);
    stats[i, "isc_max"] <- max(shapefile$iscscore);
    print("Inverse Schwartzberg score (min, mean, max)");
    print(stats[i, c("isc_min", "isc_mean", "isc_max")]);

    # Schwartzberg score
    shapefile$schscore <- 1 / shapefile$iscscore;
    stats[i, "sch_min"] <- min(shapefile$schscore);
    stats[i, "sch_mean"] <- mean(shapefile$schscore);
    stats[i, "sch_max"] <- max(shapefile$schscore);
    print("Schwartzberg score (min, mean, max)");
    print(stats[i, c("sch_min", "sch_mean", "sch_max")]);

    # racial demographics
    shapefile$vapctblk <- shapefile$vablackaln / shapefile$vapersons;
    shapefile$vapcthp <- shapefile$vahispanic / shapefile$vapersons;
    shapefile$vapctwnh <- shapefile$vanwhtaln / shapefile$vapersons;
    stats[i, "maj-min"] <- sum(shapefile$vapctwnh < .5);
    print("Majority non-(White non-Hispanic) districts");
    print(stats[i, "maj-min"]);

    # average Republican share of the two-party vote for even-year statewide elections, 2008-2010 (for comparison with the expert report of Jowei Chen in League of Women Voters of Pennsylvania et al. v. Commonwealth of Pennsylvania et al. (No. 159 MM 2017))
    shapefile$rvt0810 <- ((shapefile$ussen_r10 / (shapefile$ussen_r10 + shapefile$ussen_d10)) + (shapefile$gov_r10 / (shapefile$gov_r10 + shapefile$gov_d10)) + (shapefile$pres_r08 / (shapefile$pres_r08 + shapefile$pres_d08)) + (shapefile$atgen_r08 / (shapefile$atgen_r08 + shapefile$atgen_d08)) + (shapefile$audgn_r08 / (shapefile$audgn_r08 + shapefile$audgn_d08)) + (shapefile$stres_r08 / (shapefile$stres_r08 + shapefile$stres_d08))) / 6;

    # number of Republican/Democratic/competitive districts based on the vote share computed above
    stats[i, "r_dist"] <- sum(shapefile$rvt0810 > 0.5);
    stats[i, "d_dist"] <- sum(shapefile$rvt0810 < 0.5);
    stats[i, "c_dist"] <- sum((shapefile$rvt0810 < 0.515) & (shapefile$rvt0810 > 0.485));
    print("R/?/D");
    print(paste(stats[i, c("r_dist", "d_dist", "c_dist")], collapse = "/"));

    # mean-median gap based on the vote share computed above
    stats[i, "med-mean"] <- median(shapefile$rvt0810) - mean(shapefile$rvt0810);
    print("Median - Mean 2008-2010 Republican lean");
    print(stats[i, "med-mean"]);

    # save shapefile
    writeOGR(
        obj = shapefile,
        dsn = file.path(dirname(getwd()), "standardized data", "shapefiles"),
        layer = dataLocations[i, "name"],
        driver = "ESRI Shapefile",
        check_exists = TRUE,
        overwrite_layer = TRUE);
   }
 }

# print stats summary
write.csv(x = stats, file = file.path(dirname(getwd()), "map statistics", "stats.csv"), row.names = TRUE);
