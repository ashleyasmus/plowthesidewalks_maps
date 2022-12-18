# Toolbox ----
library(dplyr)
library(tidyr)
library(sf)

# Load data ----
# data from https://data.cityofchicago.org/Transportation/CTA-Ridership-Avg-Weekday-Bus-Stop-Boardings-in-Oc/mq3i-nnqe
# data is for weekdays, October 2012
ctadat_raw <-
  read.csv("data-raw/CTA_-_Ridership_-_Avg._Weekday_Bus_Stop_Boardings_in_October_2012.csv") %>%
  janitor::clean_names()

ctadat <- 
  ctadat_raw %>%
  # add boardings & alightings ----
  mutate(activity = boardings + alightings) %>%
  # group by stop_id, instead of by route -----
  group_by(stop_id, location) %>%
  summarize(activity = sum(activity))

# Make spatial -----
ctadat_sf <-
  ctadat %>%
  mutate(location = gsub(pattern = "[(]|[)]", replace = "", location)) %>%
  mutate(lat = stringr::word(location, 1, sep = ", "),
         lon = stringr::word(location, 2, sep = ", ")) %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326)

plot(ctadat_sf)

# Write data -----
saveRDS(ctadat_sf, "data/cta_stop_activity.RDS")
