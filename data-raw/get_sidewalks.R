# Toolbox ----
library(dplyr)
library(tidyr)
library(sf)

# Read in zip file -----
# downloaded from https://www.cmap.illinois.gov/data/data-hub
# placed in data-raw, extracted to get subfolder access
# git-ignored
tmpdir <- tempdir()
unzip("data-raw/SidewalkInventory_CMAP_2018/SidewalkInventoryGDB_CMAP_2018.zip", exdir = tmpdir )
sidewalkfile <- paste0(tmpdir, "/SidewalkInventory_CMAP_2018.gdb")

# the gdb has several layers 
# st_layers(sidewalkfile)
# will use layer (from readme)
# •	IRIS_SidewalkLinks_CMAP7Co (feature class) – All IRIS roadway links coded as having a sidewalk on one side, both sides, or neither side of the segment.•	IRIS_SidewalkLinks_CMAP7Co (feature class) – All IRIS roadway links coded as having a sidewalk on one side, both sides, or neither side of the segment.
swalk <- st_read(sidewalkfile, layer = "IRIS_SidewalkLinks_CMAP7Co") %>%
  st_transform(crs = 4326) %>%
  st_make_valid() %>%
  st_simplify()

st_agr(swalk) <- "constant"

# Aggregate to tract level -----
# load tract shapefile
acs_tracts <- readRDS("data/acs_tracts_chicago.RDS") %>%
  st_transform(crs = 4326)
st_agr(acs_tracts) <- "constant"

sidewalks_in_tracts <- 
  st_intersection(swalk, acs_tracts)
  

st_length(sidewalks_in_tracts$geometry)
