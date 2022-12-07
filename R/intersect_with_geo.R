# toolbox ----
library(sf)
library(dplyr)
library(tidyr)
library(tidycensus)

# import campaign shapefiles ----
plowxml <-
  "data-raw/Chicago Sidewalk Snow Plowing Draft Pilot Zone Map.kml"
plowxml_layers <- sf::st_layers(plowxml)

plow_geo = list()
for (i in 1:length(plowxml_layers$name)) {
  layer <-
    read_sf(dsn = plowxml,
            layer = plowxml_layers$name[i]) %>%
    st_zm(drop = TRUE, what = "ZM") %>%
    st_transform(crs = 26916)
  
  st_agr(layer) <- "constant"
  
  plow_geo[[plowxml_layers$name[i]]] <- layer
}

rm(layer, i, plowxml_layers, plowxml)

names(plow_geo) <- c("chi_city", "pilot_zones", "wards")

plow_geo$wards <-
  plow_geo$wards %>%
  separate(Description, into = c(NA, "Name"), sep = "ward: ", remove = F) %>%
  mutate(Name = trimws(Name))
  


# intersect ACS with study boundaries ----
## get all tracts ----
trs <-
  all_acs$disability %>%
  select(GEOID, bg_area, geometry) %>%
  unique()

st_agr(trs) <- "constant"

## get all block groups ----
bgs <-
  all_acs$race %>%
  select(GEOID, bg_area, geometry) %>%
  unique()

st_agr(bgs) <- "constant"

## intersection with plow geography ----
base_geo <- list()

base_geo[["block group"]] <- purrr::map(.x = names(plow_geo),
                  function(geo) {
                    st_intersection(bgs, plow_geo[[geo]]) %>%
                      mutate(int_area = st_area(geometry)) %>%
                      mutate(area_frac = as.numeric(int_area / bg_area))
                  })

base_geo[["tract"]] <- purrr::map(.x = names(plow_geo),
                                   function(geo) {
                                     st_intersection(trs, plow_geo[[geo]]) %>%
                                       mutate(int_area = st_area(geometry)) %>%
                                       mutate(area_frac = as.numeric(int_area / bg_area))
                                   })

names(base_geo[["tract"]]) <- names(plow_geo)
names(base_geo[["block group"]]) <- names(plow_geo)


rm(trs, bgs)


# get estimates for each variable plow geo ----


# save data
saveRDS(object = plow_geo, file = "plow_the_sidewalks_criteria_app/plow_geo.RDS", compress = "xz")
saveRDS(plow_demo, "plow_the_sidewalks_criteria_app/plow_demo.RDS", compress = "xz")

saveRDS(object = plow_geo, file = "data/plow_geo.RDS", compress = "xz")
saveRDS(plow_demo, "data/plow_demo.RDS", compress = "xz")
