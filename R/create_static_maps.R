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
master <- readRDS("data/scoring_master.RDS") %>%
  st_transform(crs = 4326)

# Create static maps ----
create_staticmap <- function(variable) {
  ggplot() +
    geom_sf(
      data = master, aes(fill = get(variable)),
      color = NA, alpha = 0.8
    ) +
    scale_y_continuous() +
    scale_fill_viridis(
      option = "plasma",
      direction = -1
    ) +
    theme_void() +
    theme(
      legend.position = "none",
      plot.title = element_blank()
    )
}

pctile_vars <- names(master %>% select(contains("pctile")))

pctile_maps <-
  purrr::map(
    .x = pctile_vars,
    ~ create_staticmap(.)
  )

names(pctile_maps) <- pctile_vars
pctile_maps[1]

# legend
legend_data <-
  data.frame(
    pctile =
      c(
        "90-100 (High)",
        "80-90",
        "70-80",
        "60-70",
        "50-60",
        "40-50",
        "30-40",
        "20-30",
        "10-20",
        "0-10 (Low)"
      )
  ) %>%
  mutate(pctile = as.factor(pctile)) %>%
  mutate(pctile = factor(pctile, levels = rev(levels(pctile))))

leg_plot <-
  ggplot(
    legend_data,
    aes(x = 1, y = 1, fill = pctile)
  ) +
  geom_polygon(alpha = 0.8) +
  scale_fill_viridis(
    discrete = T, option = "plasma", direction = 1,
    name = "Percentile rank"
  ) +
  theme_void() +
  theme(
    legend.title = element_text(
      family = "Poppins",
      lineheight = 0.3,
      face = "bold",
      size = 48
    ),
    legend.text = element_text(
      family = "Poppins",
      size = 36
    ),
    legend.spacing.y = unit(1, "lines"),
    legend.position = c(0.5, 0.5),
    legend.key.size = unit(4, "lines")
  )

# leg_plot

ggsave("plow_the_sidewalks_criteria_app/www/legend.png",
  leg_plot,
  height = 3000,
  width = 4000,
  units = "px"
)

# pctile_maps[["legend"]] <- leg_plot


# #  Histogram: Percentiles
# waffle_dat <- master %>%
#   select(hexid,
#          n_vac_permi2,
#          n_vac_pctile) %>%
#   sf::st_drop_geometry() %>%
#   mutate(vac_bin = cut(n_vac_permi2, breaks = c(-1, seq(from = 0, to = 300, by = 10)))) %>%
#   mutate(vac_bin = ifelse(is.na(vac_bin), "300+", as.character(vac_bin))) %>%
#   mutate(vac_bin = recode_factor(vac_bin,
#                                  "(-1,0]" = "None",
#                                  "(0,10]" = "1-10",
#                                  "(10,20]" = "10-20",
#                                  "(20,30]" = "20-30",
#                                  "(30,40]" = "30-40",
#                                  "(40,50]" = "40-50",
#                                  "(50,60]" = "50-60",
#                                  "(60,70]" = "60-70",
#                                  "(70,80]" = "70-80",
#                                  "(80,90]" = "80-90",
#                                  "(90,100]" = "90-100",
#                                  "(100,110]" = "100-110",
#                                  "(110,120]" = "110-120",
#                                  "(120,130]" = "120-130",
#                                  "(130,140]" = "130-140",
#                                  "(140,150]" = "140-150",
#                                  "(150,160]" = "150-160",
#                                  "(160,170]" = "160-170",
#                                  "(170,180]" = "170-180",
#                                  "(180,190]" = "180-190",
#                                  "(190,200]" = "190-200",
#                                  "(200,210]" = "200-210",
#                                  "(210,220]" = "210-220",
#                                  "(220,230]" = "220-230",
#                                  "(230,240]" = "230-240",
#                                  "(240,250]" = "240-250",
#                                  "(250,260]" = "250-260",
#                                  "(260,270]" = "260-270",
#                                  "(270,280]" = "270-280",
#                                  "(280,290]" = "280-290",
#                                  "(290,300]" = "290-300",
#                                  "300+" = "300+")) %>%
#  mutate(vac_pctile_bin = cut(n_vac_pctile * 100,
#                             breaks = seq(from = 0, to = 100, by = 10),
#                             include.lowest = T)) %>%
#   mutate(vac_pctile_bin = recode_factor(vac_pctile_bin,
#                                         "[0,10]" = "0-10 (Low)",
#                                         "(10,20]" = "10-20",
#                                         "(20,30]" = "20-30",
#                                         "(30,40]" = "30-40",
#                                         "(40,50]" = "40-50",
#                                         "(50,60]" = "50-60",
#                                         "(60,70]" = "60-70",
#                                         "(70,80]" = "70-80",
#                                         "(80,90]" = "80-90",
#                                         "(90,100]" = "90-100 (High)")) %>%
#   # mutate(vac_pctile_bin = factor(vac_pctile_bin, levels = rev(levels(vac_pctile_bin)))) %>%
#   group_by(vac_bin) %>%
#   sample_frac(0.3) %>%
#   arrange(vac_pctile_bin) %>%
#   mutate(n = 2 * row_number())
#
#
# hist <-
# ggplot(waffle_dat, aes(x = vac_bin, y = 1, fill = vac_pctile_bin,
#                        text = paste0(round(n_vac_permi2), " vacant buildings per square mile"))) +
#   geom_bar(position = "stack", stat = "identity", color = "white") +
#   scale_x_discrete(breaks = function(x){x[c(TRUE, FALSE, FALSE)]})+
#   labs(x = "Number of vacant buildings per square mile") +
#   scale_fill_viridis_d(option = "plasma", name = "Rank Percentile", direction = -1) +
#   theme_void() +
#   coord_cartesian(ylim = c(1, 20), xlim = c(0, 30)) +
#   guides(fill = guide_legend(nrow = 2)) +
#   theme(
#     legend.position = c(0.5, 0.9),
#     legend.direction = "horizontal",
#         panel.grid=element_blank(), panel.border=element_blank(),
#         legend.key.height = unit(0.5, "lines"),
#         legend.text = element_text(family = "Poppins",
#                                    size = 14),
#         legend.title = element_text(family = "Poppins",
#                                     size = 14),
#         axis.title.x = element_text(family = "Poppins", size = 14,
#                                     vjust = -3),
#         axis.text.x = element_text(family = "Poppins",
#                                    size = 12,
#                                    vjust = 3,
#                                    hjust = 0.5),
#         axis.ticks.length.x = unit(1, "lines"),
#     legend.margin = margin(unit(c(10, 10, 10, 10), "lines")),
#     legend.box.background = element_rect(color = 'gray80', fill = NULL),
#     plot.margin = unit(c(0, 0, 2, 0), "lines"))
#
# hist
#
# pctile_maps[["histogram"]] <- hist
saveRDS(pctile_maps, "plow_the_sidewalks_criteria_app/data/pctile_maps.RDS")
