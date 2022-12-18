# Toolbox ----
library(dplyr)
library(tidyr)
library(sf)
library(purrr) 

# load tract shapefile
acs_tracts <- readRDS("data/acs_tracts_chicago.RDS") %>%
  st_transform(crs = 4326)

# (1) ACS Census data -------
## Load data ----
acs <- readRDS("data/acs_summary_chicago.RDS")


## Select variables ----
acs_var_abbr <-
  c("amb", "vis", "kid", "old", "bip", "zca", "oca", "inc")

acs_var_long <-
  c(
    "Ambulatory difficulty",
    "Vision difficulty",
    "Under 5",
    "65 and older",
    "BIPOC people",
    "Zero-car households",
    "One-car households",
    "Low-income households"
  )

master_acs_ls <- 
purrr::map2(
  .x = acs_var_abbr,
  .y = acs_var_long,
  .f = function(abbr, var) {
    
    full_join(
      acs[[var]][["pct"]] %>%
        select(GEOID, value, pctile) %>%
        rename(pop = value) %>%
        rename_with(.cols = c(pop, pctile), ~ paste0(abbr, "_pct_", .x)),
      
      acs[[var]][["pop"]] %>%
        select(GEOID, value, pctile) %>%
        rename(pop = value) %>%
        rename_with(.cols = c(pop, pctile), ~ paste0(abbr, "_n_", .x)),
      
      by = "GEOID"
    )
  }
)

names(master_acs_ls) <- acs_var_abbr

## density - people per square mile -----
master_acs_ls[["den"]] <- acs_tracts %>%
  mutate(area_mi2 = as.numeric(tract_area * 3.86102e-7)) %>%
  mutate(den = total_population/area_mi2) %>%
  mutate(den_pctile = ntile(den, 100)) %>%
  select(GEOID, total_population, num_hh, area_mi2, den, den_pctile)

## compile ----
master_acs <- master_acs_ls %>% purrr:::reduce(inner_join, by = "GEOID") %>%
  # get rid of NAs (three tracts) 
  filter(!is.na(vis_pct_pop))


## make spatial -----
master_acs <- master_acs %>%
  st_as_sf() %>%
  st_transform(crs = 4326)

## rename, household-based columns to hh vars ----
master_acs <- master_acs %>%
  rename(inc_pct_hh = inc_pct_pop,
         zca_pct_hh = zca_pct_pop,
         oca_pct_hh = oca_pct_pop,
         inc_n_hh = inc_n_pop,
         zca_n_hh = zca_n_pop,
         oca_n_hh = oca_n_pop)



# (2) 311 Requests -----
requests311 <- readRDS("data/311_requests.RDS")
# Snow removal requests per square mile, by tract
sno_tracts <- st_join(requests311$sno, acs_tracts, join = st_within) %>%
  group_by(GEOID, tract_area) %>%
  tally(n = "n_sno") %>%
  ungroup() %>%
  mutate(n_sno_permi2 = n_sno/units::set_units(tract_area, "miles^2")) %>%
  st_drop_geometry()

# Vacant building requests per square mile, by tract
vac_tracts <- st_join(requests311$vac, acs_tracts, join = st_within) %>%
  group_by(GEOID, tract_area) %>%
  tally(n = "n_vac") %>%
  ungroup() %>%
  mutate(n_vac_permi2 = n_vac/units::set_units(tract_area, "miles^2")) %>%
  st_drop_geometry()

bad_tracts <- sno_tracts %>%
  left_join(vac_tracts) %>%
  mutate(n_bad = n_sno + n_vac) %>%
  mutate(n_bad_permi2 = n_bad/units::set_units(tract_area, "miles^2")) %>%
  select(-tract_area)

# (3) CTA Stop Activity (total, within tract) -----
ctadat_sf <- readRDS("data/cta_stop_activity.RDS")
cta_tracts <- st_join(ctadat_sf, acs_tracts, join = st_within) %>%
  group_by(GEOID) %>%
  summarize(cta_activity = sum(activity)) %>%
  ungroup() %>%
  st_drop_geometry() 

# (4) Sidewalks -----


# Compile (1) through (4) ------
master <- master_acs %>%
  left_join(cta_tracts, by = "GEOID") %>%
  left_join(bad_tracts, by = "GEOID") %>%
  # replace missing values for these with zeros
  mutate(across(c(n_sno, n_sno_permi2, n_vac, n_vac_permi2, n_bad, n_bad_permi2, cta_activity), ~as.numeric(.))) %>%
  mutate(across(c(n_sno, n_sno_permi2, n_vac, n_vac_permi2, n_bad, n_bad_permi2, cta_activity), ~replace_na(., 0)))
  # left_join(swalk_tracts, by = "GEOID")


# Write data -----
saveRDS(master, file = "data/scoring_master.RDS")
saveRDS(master, file = "plow_the_sidewalks_criteria_app/data/scoring_master.RDS")
