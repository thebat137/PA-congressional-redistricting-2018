# Data sources
## Shapefiles, block equivalency files, and statistical spreadsheets
http://www.pacourts.us/assets/files/setting-6015/file-6858.zip?cb=16ef44<br>
(Originally received 2018.02.16 by personal communication with Mr. John Lavelle, attorney for Fair Democracy.)

## Documents
http://www.pacourts.us/assets/files/setting-6015/file-6824.pdf?cb=5d76ec

http://www.pacourts.us/assets/files/setting-6015/file-6856.pdf?cb=ad57ee

## Block equivalency translation key
Fair Democracy used a distinctive set of census blocks to design their districts and produce their block equivalency file.  Fortunately, each of these blocks could be related to a standard 2010 US Census block in one of the following ways:
 - One 2010 US Census block is composed of a single FD block (most cases).
 - One 2010 US Census block is composed of a few FD blocks, all of which are assigned to the same district (a small fraction of cases).
 - One 2010 US Census block from Ohio (state ID 39) has been accidentally included in the data (2 cases).

A translation key relating block equivalency file block IDs to official 2010 US Census block IDs was provided on 2018.02.16 by Mr. John Lavelle, attorney for Fair Democracy, via personal communication and is present in this repository.


# File correction
## Shapefiles
1. Symlink `FD1-SHAPEFILE.DBF` to the name `FD1-Shapefile.dbf` and `FD2-SHAPEFILE.DBF` to the name `FD2-Shapefile.dbf` to match names of other shapefile components.

## Block equivalency files
1. Unzip the translation key data (`Block_Shapefile_021618.zip`).
2. In the `scripts` directory, run the R script `cbTrans_FD.R` (using the command `Rscript cbTrans_FD.R`).
3. The newly created file `cbTrans_FD.csv` in the `census block data` directory gives the translation from Fair Democracy's block IDs (column `BLOCK`) to 2010 Census block IDs (column `BLOCK2010`).  This file is used by the analysis script (`stats.R`) to assemble the district statistics.
