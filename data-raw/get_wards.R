# Toolbox ----
library(dplyr)
library(tidyr)
library(sf)

# Load data ----
# data from https://data.cityofchicago.org/Facilities-Geographic-Boundaries/Boundaries-Wards-2023-/p293-wvbd
ward_raw <-
  st_read("data-raw/Boundaries - Wards (2023-)")

wards <-
  ward_raw %>%
  select(ward_id, geometry) %>%
  st_transform(crs = 4326)

st_agr(wards) <- "constant"


# Write data -----
saveRDS(wards, "data/wards.RDS")
saveRDS(wards, "plow_the_sidewalks_criteria_app/data/wards.RDS")
