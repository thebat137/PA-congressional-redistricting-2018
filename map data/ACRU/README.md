# Data sources
## Shapefile
https://www.dropbox.com/s/dbnd77n8bniumc7/ACRU.shp?dl=0

## Block equivalency file
https://www.dropbox.com/s/r3lrlva85bp3omd/ACRU%20MAP.DBF?dl=0

## Documents
http://www.pacourts.us/assets/files/setting-6015/file-6825.pdf?cb=3cbfd3

http://www.pacourts.us/assets/files/setting-6015/file-6854.pdf?cb=d7b04b

## Shapefile repair script (`generate_shx.py`)
https://gist.github.com/jlehtoma/c7388e0baee60680862e


# File correction
## Shapefile
The ESRI shapefile provided by the ACRU was missing both its attribute table (`.dbf`) and geometry indexing (`.shx`) components and consisted only of the district polygons file `ACRU.shp`.  To make the shapefile usable by R, it was necessary to create a dummy attribute table and use a shapefile repair script to reconstruct the index file.
 1. Use a spreadsheet program to create a spreadsheet with a single column having an arbitrarily chosen header (in this case, `DISTRICT,N,2,0`) and 18 unique district identifiers (in this case, the numbers 1 through 18).  Save this file in DBF format as `ACRU.dbf`.
 2. Run `python generate_shx.py` from the `scripts` directory.  This will use the `ACRU.dbf` and `ACRU.shp` files to generate the missing `.shx` file, saving the new, complete shapefile as `fixed_ACRU.dbf`, `fixed_ACRU.shp`, and `fixed_ACRU.shx`.

## Block equivalency file
The block equivalency file provided by the ACRU was saved as a dBase (`.dbf`) file rather than in the more standard comma-separated value (`.csv`) text format.
 1. Open `ACRU MAP.DBF` in a spreadsheet program and save it as `block_equivalency.csv`.
