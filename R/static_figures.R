# toolbox ----
library(sf)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(showtext)
showtext::showtext_auto()
source("R/_plotly_layout.R")
source("R/_access_color_pal.R")
source("R/_ggplot_theme.R")


sysfonts::font_add_google("Montserrat")

# data ----
plow_demo <- readRDS("data/plow_demo.RDS")

city <- list()
plow <- list()

city$vehicles <-
  plow_demo[["chi_city"]][["vehicles"]] %>%
  group_by(Name) %>%
  mutate(total = sum(adj_est)) %>%
  ungroup() %>%
  mutate(prop = adj_est / total) %>%
  filter(vehicle_available == "no") %>%
  select(Name, vehicle_available, prop)

plow$vehicles <-
  plow_demo[["pilot_zones"]][["vehicles"]] %>%
  group_by(Name) %>%
  mutate(total = sum(adj_est)) %>%
  ungroup() %>%
  mutate(prop = adj_est / total) %>%
  filter(vehicle_available == "no") %>%
  select(Name, vehicle_available, prop) %>%
  mutate(zone = stringr::str_extract(Name, "(\\d)+")) %>%
  mutate(zone = as.factor(as.numeric(zone))) 


city$disability <-
  plow_demo[["chi_city"]][["disability"]] %>%
  filter(disability_type %in% c("ambulatory", "vision")) %>%
  group_by(disability_type) %>%
  mutate(total = sum(adj_est)) %>%
  ungroup() %>%
  mutate(prop = adj_est / total) %>%
  filter(disability_status == "yes") %>%
  select(disability_type, prop)


plow$disability <-
  plow_demo[["pilot_zones"]][["disability"]] %>%
  filter(disability_type %in% c("ambulatory", "vision")) %>%
  group_by(Name, disability_type) %>%
  mutate(total = sum(adj_est)) %>%
  ungroup() %>%
  mutate(prop = adj_est / total) %>%
  filter(disability_status == "yes") %>%
  select(Name, disability_type, prop) %>%
  mutate(zone = stringr::str_extract(Name, "(\\d)+")) %>%
  mutate(zone = as.factor(as.numeric(zone))) 

ggs <- list() 

ggs$disability <-
ggplot(plow$disability, aes(x = zone, y = prop, fill = disability_type)) +
  geom_col() +
  scale_x_discrete() +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_fill_manual(values = c(colors$vivid_green_cyan, colors$vivid_cyan_blue)) +
  geom_hline(data = city$disability, aes(yintercept = prop),
             lwd = 0.5) +
  geom_text(
    data = city$disability,
    aes(x = 0, y = prop,
    label = paste0("City-wide: ", round(prop * 100), "%")),
    vjust = -1,
    hjust = 0,
    size = 8
  ) + 
  facet_grid(~stringr::str_to_title(disability_type)) + 
  labs(x = "Pilot Zone", y = "", 
       title = "Percent of people with ambulatory or vision difficulty,\nby #PlowTheSidewalks pilot zone",
       subtitle = "Source: 2015-2019 American Community Survey, tract-level estimates.") + 
  theme_access_insta() + 
  theme(legend.position = "none")
  

ggs$vehicles <-
  ggplot(plow$vehicles, aes(x = zone, y = prop)) +
  geom_col(position = "stack", fill = colors$luminous_vivid_amber) +
  scale_x_discrete() +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_hline(data = city$vehicles,
             aes(yintercept = prop),
             lwd = 0.5) +
  geom_text(
    data = city$vehicles,
    aes(x = 0, y = prop,
        label = paste0("City-wide: ", round(prop * 100), "%")),
    vjust = -1,
    hjust = 0,
    size = 8
  ) + 
  labs(
    x = "Pilot Zone",
    y = "",
    title = "Percent of people with no vehicle,\nby #PlowTheSidewalks pilot zone",
    subtitle = "Source: 2015-2019 American Community Survey, tract-level estimates."
  ) +
  theme_access_insta() +
  theme(legend.position = "none")


ggsave("fig/pct_ambulatory_vision_by_pilot_zone.png", 
       ggs[["disability"]],
       height = 1000, width = 2000, units = "px", dpi = 300)

ggsave("fig/pct_no_vehicle_by_pilot_zone.png", 
       ggs[["vehicles"]],
       height = 1000, width = 1500, units = "px", dpi = 300)

  
  