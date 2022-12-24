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

# data ----
master <- readRDS("data/scoring_master.RDS")

# colors ---
source("_colors.R")

# bounding box (map) ----
chi_bbox <- st_bbox(master)

# variables ----
vars <- list("dis", "old", "kid", "den", "zca", "cta", "bad")


# initialize weights as equal to start -----
first_weights <- list(
  # Demographics:
  "dis_w" = 1 / length(vars),
  "old_w" = 1 / length(vars),
  "kid_w" = 1 / length(vars),

  # Transportation and land use:
  "zca_w" = 1 / length(vars),
  "den_w" = 1 / length(vars),
  "cta_w" = 1 / length(vars),
  "bad_w" = 1 / length(vars)
)

# Create sliders -----------
sliders <- unlist(lapply(vars, function(x) {
  paste0("s_", x)
}))


create_slider <-
  function(slider_id, icon_name) {
    sliderInput(
      slider_id,
      label = fontawesome::fa(icon_name,
        fill = "#270075",
        height = "25px"
      ),
      min = 0,
      max = 100,
      value = 100 * 1 / length(vars),
      step = 1,
      width = "100%",
      ticks = FALSE,
      post = "%"
    )
  }

s_dis <- create_slider("s_dis", "wheelchair-move")
s_old <- create_slider("s_old", "user-plus")
s_kid <- create_slider("s_kid", "baby-carriage")
s_den <- create_slider("s_den", "city")
s_zca <- create_slider("s_zca", "car")
s_cta <- create_slider("s_cta", "bus")
s_bad <- create_slider("s_bad", "building-circle-exclamation")

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
                 input[[slider_o[6]]])
    purrr:::map(
      .x = slider_o,
      .f = function(sliderid) {
        updateSliderInput(inputId = sliderid,
                          value = remaining * input[[sliderid]] /
                            total)
      }
    )
  }

## Table of priorities -----
priorities_df <-
  data.frame(
    icon =
      c(
        "wheelchair-move",
        "user-plus",
        "baby-carriage",
        "car",
        "city",
        "bus",
        "building-circle-exclamation"
      ),
    desc =
      c(
        "<b>People with disabilities</b>, especially ambulatory (walking)
         and vision disabilities, who may use assistive devices like wheelchairs and canes",
        "<b>Elders</b>, who are more vulnerable to serious fall-related injuries,
         and may be unable to shovel their own sidewalks, regardless of
         whether they identify as having a disability.",
        "<b>Young children</b> and their caretakers, who may use strollers",
        "<b>Households without cars</b>, who are more likely to rely on walking to meet their needs",
        "<b>Population-dense areas</b>, to maximize the benefit of each mile of clear sidewalk",
        "<b>Areas with high transit activity</b>, because the vast majority of riders get to
       and from their stop by walking",
        "<b>Known problem areas</b>, specifically those with many 311 reports of unclear sidewalks and
        vacant buildings"
      )
  )


priorites_tab <-
  priorities_df %>%
  gt::gt() %>%
  gt::fmt_markdown(columns = desc) %>%
  gtExtras::gt_fa_column(icon,
    height = "50px",
    palette = rep(pal$access_purple, nrow(priorities_df))
  ) %>%
  gt::tab_options(
    column_labels.hidden = TRUE,
    table.background.color = "transparent",
    table.font.size = 14,
    table_body.hlines.color = "transparent",
    table_body.border.top.color = "transparent",
    table_body.border.bottom.color = "transparent",
    container.padding.y = px(0)
  )
