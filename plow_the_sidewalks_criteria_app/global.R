# toolbox ----
# shiny
library(shiny)
library(shinyjs)
library(bslib)
library(shinyWidgets)
library(shinycssloaders)

# scrolly
library(scrollytell)

# icons
library(fontawesome)
library(tippy)

# tables
library(gt)
library(gtExtras)

# data
library(sf)
library(dplyr)
library(tidyr)
library(units)
library(purrr)

# mapping
library(leaflet)
library(RColorBrewer)
library(leaflet.extras)
library(geojsonsf)
library(jsonify)

# data ----
master <- readRDS("data/scoring_master.RDS")%>%
  st_transform(crs = 4326)

bad_chicago <- readRDS("data/311_requests_chicago.RDS")

bad_chicago$sno <- bad_chicago$sno %>%
  st_transform(crs = 4326)

bad_chicago$vac <- bad_chicago$vac %>%
  st_transform(crs = 4326)

cta_chicago <- readRDS("data/cta_stop_activity_chicago.RDS")%>%
  st_transform(crs = 4326)

wards <- readRDS("data/wards.RDS")%>%
  st_transform(crs = 4326)

# colors ---
source("_colors.R")

# scorecard function ----
source("fun_create_scorecard.R")

# bounding box (map) ----
chi_bbox <- st_bbox(master)

# variables ----
vars <- list("dis", "old", "kid", "den", "zca", "cta", "bad")


# initialize weights as equal to start -----
first_weights <- list(
  # Demographics:
  "dis_w" =  100 * 1 / length(vars),
  "old_w" =  100 * 1 / length(vars),
  "kid_w" =  100 * 1 / length(vars),

  # Transportation and land use:
  "zca_w" =  100 * 1 / length(vars),
  "den_w" =  100 * 1 / length(vars),
  "cta_w" =  100 * 1 / length(vars),
  "bad_w" =  100 * 1 / length(vars)
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
        height = "2rem"
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


s_dis2 <- create_slider("s_dis2", "wheelchair-move")
s_old2 <- create_slider("s_old2", "user-plus")
s_kid2 <- create_slider("s_kid2", "baby-carriage")
s_den2 <- create_slider("s_den2", "city")
s_zca2 <- create_slider("s_zca2", "car")
s_cta2 <- create_slider("s_cta2", "bus")
s_bad2 <- create_slider("s_bad2", "building-circle-exclamation")


# Function to update slider weights ----
update_slider_weights <-
  function(input, slider_i) {
    remaining <- 100 - input[[slider_i]]
    slider_o <- sliders[!sliders %in% slider_i]
    total <- sum(
      input[[slider_o[1]]],
      input[[slider_o[2]]],
      input[[slider_o[3]]],
      input[[slider_o[4]]],
      input[[slider_o[5]]],
      input[[slider_o[6]]]
    )
    purrr:::map(
      .x = slider_o,
      .f = function(sliderid) {
        updateSliderInput(
          inputId = sliderid,
          value = remaining * input[[sliderid]] /
            total
        )
      }
    )
  }


# Function to update scores -----
update_scores <- 
  function(weights){
    master %>%
      select(GEOID, contains("scale")) %>%
      # calculate a weighted score
      mutate(
        score =
          # Demographics
          (amb_scale * weights$dis_w * 0.5) +
          (vis_scale * weights$dis_w * 0.5) +
          (old_scale * weights$old_w) +
          (kid_scale * weights$kid_w) +
          (zca_scale * weights$zca_w) +
          # Land use and transportation
          (den_scale * weights$den_w) +
          (cta_scale * weights$cta_w) +
          (sno_scale * weights$bad_w * 0.5) + 
          (vac_scale * weights$bad_w * 0.5)
      ) %>%
      mutate(score_pctile = ntile(desc(score), 100))
  }


# Table of priorities -----
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
        "<p style = 'font-size: 1.2rem;'><b>People with disabilities</b>, especially ambulatory (walking)
         and vision disabilities, who may use assistive devices like wheelchairs and canes</p>",
        "<p style = 'font-size: 1.2rem;'><b>Elders</b>, who are more vulnerable to serious fall-related injuries,
         and may be unable to shovel their own sidewalks, regardless of
         whether they identify as having a disability.</p>",
        "<p style = 'font-size: 1.2rem;'><b>Young children</b> and their caretakers, who may use strollers</p>",
        "<p style = 'font-size: 1.2rem;'><b>Households without cars</b>, who are more likely to rely on walking to meet their needs</p>",
        "<p style = 'font-size: 1.2rem;'><b>Population-dense areas</b>, to maximize the benefit of each mile of clear sidewalk</p>",
        "<p style = 'font-size: 1.2rem;'><b>Areas with high transit activity</b>, because the vast majority of riders get to
       and from their stop by walking</p>",
        "<p style = 'font-size: 1.2rem;'><b>Known problem areas</b>, specifically those with many 311 reports of unclear sidewalks and
        vacant buildings</p>"
      )
  )


priorites_tab <-
  priorities_df %>%
  gt::gt() %>%
  gt::fmt_markdown(columns = desc) %>%
  gtExtras::gt_fa_column(icon,
    height = '3rem',
    palette = rep(pal$access_purple, nrow(priorities_df))
  ) %>%
  gt::tab_options(
    column_labels.hidden = TRUE,
    table.background.color = "transparent",
    table.font.size = '1.2rem',
    table_body.hlines.color = "transparent",
    table_body.border.top.color = "transparent",
    table_body.border.bottom.color = "transparent",
    container.padding.y = px(0)
  )

# Polygon draw button -----
jspolygon <- "shinyjs.polygon_click = function(){
    var e = document.createEvent('Event');
    e.initEvent('click', true, true);
    var cb = document.getElementsByClassName('leaflet-draw-draw-polygon');
    return !cb[0].dispatchEvent(e);
}"

# Edit button -----
jsedit <- "shinyjs.edit_click = function(){
    var e = document.createEvent('Event');
    e.initEvent('click', true, true);
    var cb = document.getElementsByClassName('leaflet-draw-edit-edit');
    return !cb[0].dispatchEvent(e);
}"


# Text box for Leaflet area --------
tag.zone.area <- tags$style(HTML("
  .leaflet-control.map-title { 
    transform: translate(-50%,20%);
    position: relative;
    left: 50%;
    text-align: center;
    padding-left: 10px; 
    padding-right: 10px; 
    background: rgba(255,255,255,0.75);
    font-weight: bold;
    font-family: 'Poppins', sans-serif;
    font-size: 1.2rem;
  }
"))
