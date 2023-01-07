# toolbox ----
# data
library(sf)
library(dplyr)
library(tidyr)

# mapping
library(leaflet)
library(RColorBrewer)
library(ggplot2)
library(viridis)
library(ggtext)
library(showtext)


sysfonts::font_add_google(name = "Poppins")
showtext_auto()

# data ----
master <- readRDS("data/scoring_master.RDS")%>%
  st_transform(crs = 4326)

# Create static maps ----
create_staticmap <- function(variable){
  ggplot() + 
    geom_sf(data = master, aes(fill = get(variable)),
            color = NA, alpha = 0.8) + 
    scale_y_continuous() + 
    scale_fill_viridis(option = "plasma", 
                       direction = -1) + 
    theme_void() +
    theme(legend.position = "none",
          plot.title = element_blank())
}

pctile_vars <- names(master %>% select(contains("pctile")))

pctile_maps <-
  purrr::map(.x = pctile_vars,
             ~create_staticmap(.))

names(pctile_maps) <- pctile_vars
pctile_maps[1]

# legend 
legend_data <- 
  data.frame(
    pctile = 
    c("90-100 (High)",
      "80-90",
      "70-80",
      "60-70",
      "50-60",
      "40-50",
      "30-40",
      "20-30",
      "10-20",
      "0-10 (Low)"
  )) %>%
  mutate(pctile = as.factor(pctile)) %>%
  mutate(pctile = factor(pctile, levels = rev(levels(pctile))))

leg_plot <- 
  ggplot(legend_data, 
         aes(x = 1, y = 1, fill = pctile)) + 
  geom_polygon(alpha = 0.8) + 
  scale_fill_viridis(discrete = T, option = "plasma", direction = 1, 
                     name = "Percentile rank") + 
  theme_void() + 
  theme(legend.title =  element_text(family = "Poppins", 
                                     lineheight = 0.3,
                                     face = "bold",
                                     size = 48),
        legend.text = element_text(family = "Poppins", 
                                   size = 36),
        legend.spacing.y = unit(1, "lines"),
        legend.position = c(0.5, 0.5),
        legend.key.size = unit(4, "lines"))

leg_plot

ggsave("plow_the_sidewalks_criteria_app/www/legend.png", 
       leg_plot, 
       height = 3000, 
       width = 4000, 
       units = "px")

pctile_maps[["legend"]] <- leg_plot

saveRDS(pctile_maps, "plow_the_sidewalks_criteria_app/data/pctile_maps.RDS")

