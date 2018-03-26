# Data sources
## Shapefile
http://www.pacourts.us/assets/files/setting-6015/file-6828.zip?cb=9e6884

## Block equivalency file
http://www.pacourts.us/assets/files/setting-6015/file-6815.zip?cb=1f9d15

## Documents
http://www.pacourts.us/assets/files/setting-6015/file-6809.pdf?cb=dc9b8a


# File correction
The Republican intervenors' shapefile and block equivalency file were both constructed in highly non-standard ways which required significant reformatting.

## Shapefile
The features in the shapefile are not districts, as in other parties' submissions, but rather census tracts, each with an associated district assignment.  The `stats.R` script handles these un-merged shapefiles specially, by taking all features with the same district ID and merging them into one.

## Block equivalency file
The provided block equivalency file (named `BlockAssignments.csv` or `Intervenors submission.csv` in different postings) is non-functional.  During preparation of this file, rather than storing the full 15 digits of each block ID, the IDs were interpreted as 15-digit integers and stored in exponential notation, with only the 6 initial digits preserved in the file, and these possibly having been subjected to rounding.  Consequently, the block equivalencies must be reconstructed from the provided ESRI shapefile.

The features in the shapefile are whole census tracts, each with an associated district assignment.  The block equivalencies can thus be inferred from the census tract GEOIDs given in the shapefile, which match the first 11 digits of the GEOID for each census block.  The procedure was as follows:
1. Create a "tract equivalency" file (`tract_equivalency.csv`) by opening the shapefile's attribute table (`PA_CD_Submission.dbf`) in a spreadsheet program and saving the `GEOID10,C,11` (tract GEOID) and `PAMap_BG_D,N,10,0` (district ID) columns to a CSV file.
2. The `cb_to_tract.R` script creates a translation table (`tractEquiv.csv`) in the `census block data` directory which gives the census tract for each census block.
3. The `stats.R` script loads the tract equivalency file and uses the translation table to convert it to a full 2010 US Census block equivalency file, using the matching described above.
