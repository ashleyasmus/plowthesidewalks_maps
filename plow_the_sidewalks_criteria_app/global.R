# toolbox ----
# shiny
library(shiny)
library(shinyjs)
library(fresh)
# scrolly
library(scrollytell)

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

# theme ----
fresh::use_googlefont("Montserrat")
my_fresh_theme <- 
  fresh::create_theme(
  theme = "default",
  bs_vars_global(
    body_bg = "#FFFFFF",
    text_color = "black",
    link_color = "#10626f",
    link_hover_color = "#00d084",
    line_height_base = 1.5,
    grid_columns = NULL,
    grid_gutter_width = NULL,
    border_radius_base = NULL
  ),
  bs_vars_wells(bg = "#F9F9F9", border = "transparent"),
  bs_vars_font(
    family_sans_serif = "'Montserrat', sans-serif",
    size_base = 16,
    size_large = 42,
    size_small = 13,
    size_h1 = 42,
    size_h2 = 36,
    size_h3 = 20,
    size_h4 = 16,
    size_h5 = 16,
    size_h6 = 16
  ),
  bs_vars_color(
    brand_primary = "#270075",
    brand_success = "#9b51e0",
    brand_info = "#F9F9F9",
    brand_warning = "#cf2e2e",
    brand_danger = "#F9F9F9"
  ),
  bs_vars_navbar(
    default_bg = "#FFFFFF",
    default_color = "#FFFFFF",
    default_link_color = "#10626f",
    default_link_active_color = "#00d084"
  )
)


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
# update_slider_weights <-
#   function(input, slider_i) {
#     remaining <- 100 - input[[slider_i]]
#     slider_o <- sliders[!sliders %in% slider_i]
#     total <- sum(input[[slider_o[1]]],
#                  input[[slider_o[2]]],
#                  input[[slider_o[3]]],
#                  input[[slider_o[4]]],
#                  input[[slider_o[5]]],
#                  input[[slider_o[6]]],
#                  input[[slider_o[7]]])
#     purrr:::map(
#       .x = slider_o,
#       .f = function(sliderid) {
#         updateSliderInput(inputId = sliderid,
#                           value = remaining * input[[sliderid]] /
#                             total)
#       }
#     )
#   }

## Priorities table
priorities <- 
  list("wheelchair-move" = 
         "<b>People with disabilities</b>, especially ambulatory (walking) 
         and vision disabilities, who may use assistive devices like wheelchairs and canes",
       
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
         "<b>Known problem areas</b>, specifically those with many 311 reports of unclear sidewalks and
        vacant buildings"
         )


priorites_tab <- 
priorities %>%
  unlist(recursive = FALSE) %>% 
  tibble::enframe() %>% 
  gt::gt() %>% 
  gt::fmt_markdown(columns = value) %>%
  gtExtras::gt_fa_column(name, height = "50px", 
                         palette = rep(pal$access_purple, length(priorities))) %>%
  gt::tab_options(column_labels.hidden = TRUE,
                  table.background.color = "transparent",
                  table.font.size = 14,
                  table_body.hlines.color = "transparent",
                  table_body.border.top.color = "transparent",
                  table_body.border.bottom.color = "transparent",
                  container.padding.y = px(0))


priorites_row <- 
  priorities %>%
  unlist(recursive = FALSE) %>% 
  tibble::enframe() %>% 
  select(name) %>%
  gt::gt() %>% 
  gtExtras::gt_fa_column(name, height = "50px", 
                         palette = rep(pal$access_purple, length(priorities)))