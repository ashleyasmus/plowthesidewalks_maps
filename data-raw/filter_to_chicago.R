# toolbox ----
library(sf)
library(dplyr)
library(tidyr)
library(tidycensus)

# import chicago shapefile ----
plow_geo <- readRDS("data/plow_geo.RDS")
# plow_geo$chi_city is the chicago boundary.

# import ACS tracts ----
acs_tracts <-readRDS("data/acs_tracts.RDS")
st_agr(acs_tracts) <- "constant"

# filter ACS tracts ----
acs_tracts_chi <- st_intersection(acs_tracts, plow_geo$chi_city)

# import ACS summary data ----
acs_summary <-readRDS("data/acs_summary.RDS")

# filter ACS summary data-----
names(acs_summary)

acs_summary_chi<- list()

for(n in names(acs_summary)) {
  acs_summary_chi[[n]] <-
    purrr::map(
      .x = c("pct", "pop"),
      .f = function(p) {
        
        acs_summary[[n]][[p]] %>%
          filter(GEOID %in% acs_tracts_chi$GEOID)
        
      }
    )
  
  names(acs_summary_chi[[n]]) <- c("pct", "pop")
}


# import 311 requests ----
requests311 <-readRDS("data/311_requests.RDS")

# filter 311 requests ----
requests311_chi<- list()

chi_city_latlon <- st_transform(plow_geo$chi_city, 4326)

for(n in names(requests311)) {
  st_agr(requests311[[n]]) <- "constant"
  
  requests311_chi[[n]] <-
    requests311[[n]] %>%
    st_intersection(., chi_city_latlon)
}

# trims just a few off.

# write data ------
saveRDS(acs_summary_chi, "data/acs_summary_chicago.RDS")
saveRDS(acs_tracts_chi, "data/acs_tracts_chicago.RDS")
saveRDS(requests311_chi, "data/311_requests_chicago.RDS")

