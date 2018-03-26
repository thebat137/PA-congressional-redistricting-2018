# Data sources
## Shapefile
http://www.pacourts.us/assets/files/setting-6061/file-6845.zip?cb=b6385e

## Block equivalency file
http://www.pacourts.us/assets/files/setting-6061/file-6843.zip?cb=45943e

## Documents
http://www.pacourts.us/assets/files/setting-6061/file-6852.pdf?cb=df65be

http://www.pacourts.us/assets/files/setting-6061/file-6850.pdf?cb=f87849

http://www.pacourts.us/assets/files/setting-6061/file-6851.pdf?cb=759d3a

http://www.pacourts.us/assets/files/setting-6061/file-6849.pdf?cb=3f0848

http://www.pacourts.us/assets/files/setting-6061/file-6846.zip?cb=3e1645

http://media-downloads.pacourts.us/RemedialPlanDistrictbyDistrictImages.zip?cb=4812243

http://media-downloads.pacourts.us/2011PlanDistrictbyDistrictImages.zip?cb=4812243

http://www.pacourts.us/assets/files/setting-6061/file-6844.zip?cb=c50222

http://www.pacourts.us/assets/files/setting-6015/file-6879.pdf?cb=ebe678


# File correction
## Shapefile
1. Symlink `REMEDIAL PLAN SHAPEFILE.DBF` to the name `Remedial Plan Shapefile.dbf` to match names of other shapefile components.

## Block equivalency file
1. Add a line with column headers `BlockID,District` to the file `Court Remedial Plan 2 19.csv` and save it as `Court Remedial Plan 2 19_fixed.csv`, so that R will acquire all rows of the block equivalency dataset.
