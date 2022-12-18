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
vars <- list("vis", "amb", "den", "old", "kid", "zca", "oca", "inc")
sliders <- unlist(lapply(vars, function(x) paste0("s_", x)))

# initialize weights as equal to start -----
first_weights <- list(
  "vis_w" = 1/length(vars),
  "amb_w" = 1/length(vars),
  "den_w" = 1/length(vars),
  "old_w" = 1/length(vars),
  "kid_w" = 1/length(vars),
  "zca_w" = 1/length(vars),
  "oca_w" = 1/length(vars),
  "inc_w" = 1/length(vars)
)

