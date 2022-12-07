# toolbox ----
library(sf)
library(dplyr)
library(tidyr)
library(tidycensus)

# get the tract geography: 
acs_tracts <- 
  tidycensus::get_acs(
    geography = "tract",
    variables = "B01001_001",
    # weighted total population estimate
    state = "IL",
    county = "Cook",
    year = 2020,
    # get the geometry of the tracts as well:
    geometry = T
  ) %>%
  # project to local crs: 
  st_transform(crs = 26916) %>%
  select(GEOID, NAME, estimate) %>%
  rename(total_population = estimate) %>%
  mutate(tract_area = st_area(geometry))

st_agr(acs_tracts) <- "constant"

saveRDS(acs_tracts, file = "data/acs_tracts.RDS", compress = "xz")