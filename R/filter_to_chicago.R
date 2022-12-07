# toolbox ----
library(sf)
library(dplyr)
library(tidyr)
library(tidycensus)

# import campaign shapefiles ----
plow_geo <- readRDS("data/plow_geo.RDS")

# import ACS tracts ----
acs_tracts <-readRDS("data/acs_tracts.RDS")
st_agr(acs_tracts) <- "constant"

# import ACS data ----
acs_summary <-readRDS("data/acs_summary.RDS")


# intersect tracts with city boundary ----
acs_tracts_chi <- st_intersection(acs_tracts, plow_geo$chi_city)

# filter ACS summary -----
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

saveRDS(acs_summary_chi, "data/acs_summary_chicago.RDS")
saveRDS(acs_tracts_chi, "data/acs_tracts_chicago.RDS")