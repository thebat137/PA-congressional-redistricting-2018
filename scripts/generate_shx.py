# This script is a trivial modification of one originally written by Joona Lehtomaki (jlehtoma) and published online at https://gist.github.com/jlehtoma/c7388e0baee60680862e.
# Right now the only use I'm making of this script is to add an .shx file to the data provided by the ACRU, as their shapefile lacked both a .dbf and an .shx.  (The .dbf was created by hand using a spreadsheet program and just has an arbitrary index for each district.)


# Based on solution given here: http://geospatialpython.com/2011/11/generating-shapefile-shx-files.html
# Depends on pyshp

# Build a new shx index file
import fnmatch
import os
import shapefile

# List all the shapefiles
def find(pattern, path):
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                result.append(os.path.join(root, name))
    return result

shp_files = find('*.shp', os.path.join(os.pardir, 'map data', 'ACRU', 'corrections'))

for shp_file in shp_files:

  # Explicitly name the shp and dbf file objects
  # so pyshp ignores the missing/corrupt shx

  shp = open(shp_file, "rb")
  dbf = open(shp_file.replace("shp", "dbf"), "rb")
  r = shapefile.Reader(shp=shp, shx=None, dbf=dbf)
  w = shapefile.Writer(r.shapeType)

  # Copy everything from reader object to writer object

  w._shapes = r.shapes()
  w.records = r.records()
  w.fields = list(r.fields)

  # saving will generate the shx
  fixed_shp_file = os.path.join(os.path.dirname(shp_file),
                                "fixed_" + os.path.basename(shp_file))
w.save(fixed_shp_file)
