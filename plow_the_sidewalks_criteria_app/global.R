# toolbox ----
# shiny
library(shiny)
library(shinyjs)
library(bslib)

# vertical tabset panel: 
library(shinyWidgets)

# scrolly
library(scrollytell)

# icons
library(fontawesome)
library(tippy)

# tables
library(gt)
library(gtExtras)

# plotting
library(ggplot2)
library(sysfonts)
library(showtext)
sysfonts::font_add_google(name = "Poppins")
showtext_auto()

# data
library(sf)
library(dplyr)
library(tidyr)
library(units)
library(purrr)

# mapping
library(leaflet)
library(leafgl)
library(RColorBrewer)

# drawn shapes:
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

ward_centroids <- readRDS("data/ward_centroids.RDS")%>%
  st_transform(crs = 4326)

l_stops <- readRDS("data/l_stops.RDS")%>%
  st_transform(crs = 4326)

# static maps ----
pctile_maps <- readRDS("data/pctile_maps.RDS")

# colors ---
source("_colors.R")

# scorecard function ----
source("fun_create_scorecard.R")



# bounding box (map) ----
chi_bbox <- st_bbox(master)

# variables ----
vars <- list("vis",
             "amb",
             "old",
             
             "kid",
             "zca",
             "inc",
             "cta",
             
             "den", 
             "sno", 
             "vac")


# initialize weights as equal to start -----
first_weights <- list(
  # Demographics:
  "vis_w" =  1 / length(vars),
  "amb_w" =  1 / length(vars),
  "old_w" =  1 / length(vars),
  
  "kid_w" =  1 / length(vars),
  "zca_w" =  1 / length(vars),
  "inc_w" =  1 / length(vars),
  "cta_w" =  1 / length(vars),
  
  "den_w" =  1 / length(vars),
  "sno_w" =  1 / length(vars),
  "vac_w" =  1 / length(vars)
)

# Create sliders -----------
sliders <- unlist(lapply(vars, function(x) {
  paste0("s_", x)
}))


create_slider <-
  function(slider_id, icon_name, icon_title = NULL) {
    sliderInput(
      slider_id,
      label = fontawesome::fa(icon_name,
        fill = "#270075",
        height = "2rem",
        title = icon_title
      ),
      min = 0,
      max = 100,
      value = 100,
      step = 1,
      width = "100%",
      ticks = FALSE,
      post = "%"
    )
  }

s_vis <- create_slider("s_vis",
                       "person-walking-with-cane",
                       "Percent of people with vision disabilities")
s_amb <- create_slider("s_amb",
                       "wheelchair-move",
                       "Percent of people with ambulatory disabilities")
s_old <- create_slider("s_old", "user-plus",
                       "Percent of people over 65")

s_kid <- create_slider("s_kid", "baby-carriage",
                       "Percent of people under 5")
s_zca <- create_slider("s_zca", "car-tunnel",
                       "Percent of households without cars")

s_inc <- create_slider("s_inc", "circle-dollar-to-slot",
                       "Percent of households with incomes less than $50K")

s_cta <- create_slider("s_cta",
                       "bus",
                       "Transit activity: boardings and alightings per square mile")

s_den <- create_slider("s_den", "city",
                       "Population density: people per square mile")
s_sno <- create_slider("s_sno",
                       "snowplow",
                       "Number of snowy/icy sidewalk complaints per square mile")
s_vac <- create_slider("s_vac",
                       "building-circle-exclamation",
                       "Number of vacant buildings per square mile")


s_vis2 <- create_slider("s_vis2",
                       "person-walking-with-cane",
                       "Percent of people with vision disabilities")
s_amb2 <- create_slider("s_amb2",
                       "wheelchair-move",
                       "Percent of people with ambulatory disabilities")
s_old2 <- create_slider("s_old2", "user-plus",
                       "Percent of people over 65")

s_kid2 <- create_slider("s_kid2", "baby-carriage",
                       "Percent of people under 5")
s_zca2 <- create_slider("s_zca2", "car-tunnel",
                       "Percent of households without cars")
s_inc2 <- create_slider("s_inc2", "circle-dollar-to-slot",
                        "Percent of households without income less than $50K")
s_cta2 <- create_slider("s_cta2",
                       "bus",
                       "Transit activity: boardings and alightings per square mile")

s_den2 <- create_slider("s_den2", "city",
                       "Population density: people per square mile")
s_sno2 <- create_slider("s_sno2",
                       "snowplow",
                       "Number of snowy/icy sidewalk complaints per square mile")
s_vac2 <- create_slider("s_vac2",
                       "building-circle-exclamation",
                       "Number of vacant buildings per square mile")


# Create filters -----------
sliders <- unlist(lapply(vars, function(x) {
  paste0("s_", x)
}))


create_filter <-
  function(filter_id, icon_name, icon_title = NULL) {
    sliderInput(
      filter_id,
      label = fontawesome::fa(icon_name,
                              fill = "#270075",
                              height = "2rem"
      ),
      min = 0,
      max = 100,
      value = c(0, 100),
      step = 5,
      width = "100%",
      ticks = F,
      post = "%",
      dragRange = F
    )
  }

f_score <- create_filter("f_score", 
                         "plus-minus",
                         "Overall weighted score")
f_vis <- create_filter("f_vis", 
                       "person-walking-with-cane", 
                       "Percent of people with vision disabilities")
f_amb <- create_filter("f_amb", 
                       "wheelchair-move",
                       "Percent of people with ambulatory disabilities"
                       )
f_old <- create_filter("f_old", "user-plus",
                       "Percent of people over 65")

f_kid <- create_filter("f_kid", "baby-carriage",
                       "Percent of people under 5")
f_zca <- create_filter("f_zca", "car-tunnel",
                       "Percent of households without cars")
f_inc <- create_filter("f_inc", "circle-dollar-to-slot",
                       "Percent of households with low incomes")
f_cta <- create_filter("f_cta", "bus", 
                       "Transit activity: boardings and alightings per square mile")

f_den <- create_filter("f_den", "city",
                       "Population density: people per square mile")
f_sno <- create_filter("f_sno", "snowplow",
                       "Number of snowy/icy sidewalk complaints per square mile")
f_vac <- create_filter("f_vac", "building-circle-exclamation",
                       "Number of vacant buildings per square mile")



# Function to update scores -----
update_scores <- 
  function(weights, df = master){
    
    
    scores <- 
    df %>%
      st_drop_geometry() %>%
      select(hexid, contains("pctile")) %>%
      pivot_longer(
        cols = contains("pctile"),
        names_to = "variable",
        values_to = "pctile",
        names_transform = ~ gsub("_pctile", "", .)
      ) %>%
      mutate(
        weight =
          case_when(
            variable == "vis" ~ weights$vis_w,
            variable == "amb" ~ weights$amb_w,
            variable == "kid" ~ weights$kid_w,
            variable == "old" ~ weights$old_w,
            variable == "zca" ~ weights$zca_w,
            variable == "inc" ~ weights$inc_w,
            variable == "n_cta" ~ weights$cta_w,
            variable == "n_sno" ~ weights$sno_w,
            variable == "n_vac" ~ weights$vac_w,
            variable == "n_ppl" ~ weights$den_w
          )
      ) %>%
      group_by(hexid) %>%
      summarize(wtd_score = 
                  round(100 *
                  weighted.mean(x = pctile, w = weight))) %>%
      ungroup() %>%
      mutate(score_p_rank = round(100 * percent_rank(wtd_score))) %>%
      arrange(desc(score_p_rank), hexid)
    
    scores
  }

first_scores <- update_scores(first_weights, master)

# Table of priorities -----
priorities_df <-
  data.frame(
    icon =
      c(
        "wheelchair-move",
        "user-plus",
        "baby-carriage",
        "car-tunnel",
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

# Function to make ward ID labels
make_ward_labs <- function(font_size = 1, ward_ids = ward_centroids$ward_id){
  sprintf(
    paste0(
    "<i style='font-family: Montserrat, sans-serif;
      font-weight: bold;
      font-size:",
    font_size,
    "rem;
    color: white'>
      %s</i>"
  ), 
  ward_ids) %>%
    lapply(htmltools::HTML)
}

init_ward_labs <- make_ward_labs()


