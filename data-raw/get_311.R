# Toolbox ----
library(dplyr)
library(tidyr)
library(sf)


# Load data ----
# data from https://data.cityofchicago.org/Service-Requests/311-Service-Requests/v6vf-nfxy
# dataset is huge - using data.table to read in
dat311_raw <- data.table::fread("data-raw/311_Service_Requests.csv") %>%
  janitor::clean_names()

# Filter data -----
dat311_filter <-
  dat311_raw %>%
  ## relevant request types ----
  # SR_TYPE: Vacant/Abandoned Building Complaint
  # SR_SHORT_CODE: BBK
  # SR_TYPE: Snow – Uncleared Sidewalk Complaint
  # SR_SHORT_CODE: SDO
  filter(sr_short_code %in% c("BBK", "SWSNOREM")) %>%
  ## last 3 years --- (arbitrary)
  mutate(created_datetime = lubridate::parse_date_time(created_date, orders = c("%m/%d/%Y %I/%M/%S %p"))) %>%
  mutate(created_date = as.Date(created_datetime)) %>%
  # filter(created_date >= "2020-01-01") %>%
  ## canceled requests -----
  filter(!status == "Canceled") %>%
  ## not a duplicate ----
  filter(duplicate == FALSE)


# Select columns ----
dat311_select <-
  dat311_filter %>%
  select(sr_type, sr_short_code, created_date, latitude, longitude)

# Make spatial ----
dat311_sf <-
  dat311_select %>%
  filter(!is.na(longitude) & !is.na(latitude)) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

# Split into list by type -----
vac <- dat311_sf %>%
  filter(sr_short_code == "BBK")

sno <- dat311_sf %>%
  filter(sr_short_code == "SWSNOREM")

requests311 <-
  list(
    "vac" = vac,
    "sno" = sno
  )

# Write data -----
saveRDS(requests311, "data/311_requests.RDS")
