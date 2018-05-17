# Data sources
## Shapefile and block equivalency file
http://www.pacourts.us/assets/files/setting-6015/file-6814.zip?cb=9e0cb9

## Documents
http://www.pacourts.us/assets/files/setting-6015/file-6813.pdf?cb=c60273


# File correction
## Shapefile
The ESRI shapefile provided by Lt. Gov. Stack had district numbers that did not match the district numbers used in the block equivalency file also provided with his submission.   The correct numbers can be found in the map on page 9 of the PDF report submitted with the map, stored in this repository as "map data/Stack/docs/Proposed Districting Plans Lt Gov Stack - 006813.pdf".
 1. Run the script `fixStackShapefile.R` from the `scripts` directory to produce a new shapefile with corrected district numbers.
