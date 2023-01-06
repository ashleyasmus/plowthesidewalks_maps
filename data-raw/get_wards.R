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

# Centroids ------
plot.new()
ward_centroids <- 
  suppressWarnings(
    wards %>%
      st_transform(crs = 26916) %>%
      as_Spatial() %>%
      rgeos::polygonsLabel(pols = ., method = "buffer") %>%
      as.data.frame() %>%
      st_as_sf(coords = c(lon = "V1", lat = "V2"), crs = 26916) %>%
      st_transform(crs = 4326) %>%
      cbind(ward_id = wards$ward_id) 
  )


# Write data -----
saveRDS(ward_centroids, "data/ward_centroids.RDS")
saveRDS(ward_centroids, "plow_the_sidewalks_criteria_app/data/ward_centroids.RDS")

