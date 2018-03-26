# Data sources
## Shapefile
http://www.pacourts.us/assets/files/setting-6015/file-6808.zip?cb=6a8eb2

## Block equivalency file
http://www.pacourts.us/assets/files/setting-6015/file-6807.zip?cb=7e07b3

## Documents
http://www.pacourts.us/assets/files/setting-6015/file-6806.pdf?cb=9f2053


# File correction
## Shapefile
1. Symlink `HOUSEDEMOCRATICCAUCUS_CONGRESSIONALDISTRICTBOUNDARY_SHAPEFILE.DBF` to the name `HouseDemocraticCaucus_CongressionalDistrictBoundary_Shapefile.dbf` to match names of other shapefile components.

## Block equivalency file
1. Add a line with column headers `BLOCKID,DISTRICT` to the file `HouseDemocraticPlan_BlockEquivalency.csv` and save it as `HouseDemocraticPlan_BlockEquivalency_fixed.csv`, so that R will acquire all rows of the block equivalency dataset.
