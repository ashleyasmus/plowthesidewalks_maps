# toolbox ----
library(sf)
library(dplyr)
library(tidyr)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggradar)

# data ----
acs_summary <- readRDS("data/acs_summary.rds")
acs_tracts <- readRDS("data/acs_tracts.rds")


acs %>%
  filter(measure == "pct") %>%
  pivot_wider(names_from = "var_short", values_from = "value", id_cols = "GEOID") %>%
  mutate_each(funs(rescale), -GEOID) %>%
  tail(100) %>%
  ggradar() +
  theme(legend.position = "none")

mtcars %>%
  add_rownames(var = "group") %>%
  mutate_each(funs(rescale), -group) %>%
  tail(4) %>%
  select(1:10) -> mtcars_radar

library(plotly)


fig <- plot_ly(
  type = "scatterpolar",
  fill = "toself"
)

fig <- fig %>%
  add_trace(
    r = c(39, 28, 8, 7, 28, 39),
    theta = c("A", "B", "C", "D", "E", "A"),
    name = "Group A"
  )

fig <- fig %>%
  add_trace(
    r = c(1.5, 10, 39, 31, 15, 1.5),
    theta = c("A", "B", "C", "D", "E", "A"),
    name = "Group B"
  )

fig <- fig %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0, 50)
      )
    )
  )

figcdfuiiiiiiiiiiiiiiiiiiiiiihnjqw

ggradar(mtcars_radar)

acs <- combine(combine(acs_summary))

tract_scores <- list()

tract_scores[["population"]] <- acs_tracts %>% select(GEOID, total_population)
tract_scores[["Vision difficulty"]] <- acs_summary[["Vision difficulty"]][["pct"]]

w1 <- 0.2
w2 <- 0.8


layer2 <- acs_summary[["Non-car commutes"]][["pct"]]


x <- acs_summary[["Vision difficulty"]][["pct"]]$value %>% scale(0, 1)
y <- acs_summary[["Vision difficulty"]][["pct"]]$pctile

plot(x, y)

l1 <-
  layer1 %>%
  select(GEOID, pctile) %>%
  rename(pctile_1 = pctile)

l2 <-
  layer2 %>%
  select(GEOID, pctile) %>%
  rename(pctile_2 = pctile)

l <-
  mutate(score = pctile_1 * 0.2 + pctile_2 * 0.8)
