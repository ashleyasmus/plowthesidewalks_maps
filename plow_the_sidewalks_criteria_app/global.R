# toolbox ----
library(shiny)
library(sf)
library(dplyr)
library(tidyr)
library(leaflet)
library(RColorBrewer)
library(dplyr)
library(leaflet.extras)
library(geojsonsf)
library(jsonify)
library(units)

# devtools::install_github("ricardo-bion/ggradar", 
#                          dependencies = TRUE)
# library(ggradar)

# data ----
master <- readRDS("data/scoring_master.RDS")

# bounding box (map) ----
chi_bbox <- st_bbox(master)

# variables ----
vars <- list("vis", "amb", "old", "kid", "den", "zca", "cta", "bad")
sliders <- unlist(lapply(vars, function(x) paste0("s_", x)))

# initialize weights as equal to start -----
first_weights <- list(
  # Demographics: 
  "vis_w" = 1/length(vars),
  "amb_w" = 1/length(vars),
  "old_w" = 1/length(vars),
  "kid_w" = 1/length(vars),
  
  # Transportation and land use:
  "zca_w" = 1/length(vars),
  "den_w" = 1/length(vars),
  "cta_w" = 1/length(vars),
  "bad_w" = 1/length(vars)
)

