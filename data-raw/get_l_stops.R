# Toolbox ----
library(dplyr)
library(tidyr)
library(sf)

# Load data ----
# data from https://data.cityofchicago.org/dataset/CTA-L-Rail-Stations-Shapefile/vmyy-m9qj

l_raw <-
  st_read("data-raw/CTARailLines")

l_stops <-
  l_raw %>%
  janitor::clean_names() %>%
  select(station_id, longname, lines) %>%
  st_transform(crs = 4326)

st_agr(l_stops) <- "constant"

# Write data -----
saveRDS(l_stops, "data/l_stops.RDS")
saveRDS(l_stops, "plow_the_sidewalks_criteria_app/data/l_stops.RDS")
