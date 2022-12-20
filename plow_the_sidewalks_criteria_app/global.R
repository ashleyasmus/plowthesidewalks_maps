# toolbox ----
# shiny
library(shiny)
library(shinyjs)

# scrolly
library(waypointer)
library(shticky)
library(sigmajs)

# icons
library(fontawesome)

# tables
library(gt)
library(gtExtras)

# data
library(sf)
library(dplyr)
library(tidyr)
library(units)

# mapping
library(leaflet)
library(RColorBrewer)
library(leaflet.extras)
library(geojsonsf)
library(jsonify)

# creates 100vh div
longdiv <- function(...){
  div(
    ...,
    class = "container",
    style = "height:200vh;z-index:500;"
  )
}

my_offset <- "50%"
my_animation <- "slideInUp"


# data ----
master <- readRDS("data/scoring_master.RDS")

# colors ---
source("_colors.R")

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

# Function to update slider weights ----
update_slider_weights <-
  function(input, slider_i) {
    remaining <- 100 - input[[slider_i]]
    slider_o <- sliders[!sliders %in% slider_i]
    total <- sum(input[[slider_o[1]]],
                 input[[slider_o[2]]],
                 input[[slider_o[3]]],
                 input[[slider_o[4]]],
                 input[[slider_o[5]]],
                 input[[slider_o[6]]],
                 input[[slider_o[7]]])
    purrr:::map(
      .x = slider_o,
      .f = function(sliderid) {
        updateSliderInput(inputId = sliderid,
                          value = remaining * input[[sliderid]] /
                            total)
      }
    )
  }

## Priorities table
priorities <- 
  list("wheelchair-move" = 
         "<b>People with disabilities</b>, especially ambulatory (walking) 
         and vision disabilities, who may use assistive devices 
         (wheelchairs, walkers, canes) to get around.",
       
       "user-plus" = 
         "<b>Elders</b>, who are more vulnerable to serious fall-related injuries, 
         and may be unable to shovel their own sidewalks, regardless of 
         whether they identify as having a disability.",
         
         "baby-carriage" = 
           "<b>Young children</b> and their caretakers, who may use strollers",
       
       "car" = 
         "<b>Households without cars</b>, who are more likely to rely on walking to meet their needs",
       
       "city" = 
         "<b>Population-dense areas</b>, to maximize the benefit of each mile of clear sidewalk",
       
       "bus" = 
         "<b>Areas with high transit activity</b>, because the vast majority of riders get to 
       and from their stop by walking",
       
       "building-circle-exclamation" = 
         "<b>Known problem areas</b>, specifically those with a high number of sidewalk 
       snow removal requests and vacant buildings reported via 311 and municipal offices"
         )


priorites_tab <- 
priorities %>%
  unlist(recursive = FALSE) %>% 
  tibble::enframe() %>% 
  gt::gt() %>% 
  gt::fmt_markdown(columns = value) %>%
  gtExtras::gt_fa_column(name, height = "50px", 
                         palette = rep(pal$access_purple, length(priorities)))


priorites_row <- 
  priorities %>%
  unlist(recursive = FALSE) %>% 
  tibble::enframe() %>% 
  select(name) %>%
  gt::gt() %>% 
  gtExtras::gt_fa_column(name, height = "50px", 
                         palette = rep(pal$access_purple, length(priorities)))

