# Toolbox ----
library(dplyr)
library(tidyr)
library(sf)
library(purrr) 

# Load data ----
acs <- readRDS("data/acs_summary_chicago.RDS")
acs_tracts <- readRDS("data/acs_tracts_chicago.RDS")


# Select variables ----
master_ls <- list()

## number of people with ambulatory, vision difficulties ----
master_ls[["amb"]] <- 
  acs[["Ambulatory difficulty"]][["pop"]] %>%
  select(GEOID, value, pctile) %>%
  rename(pctpop = value) %>%
  rename_with(.cols = c(pctpop, pctile), ~ paste0("amb_", .x))

master_ls[["vis"]] <-
  acs[["Vision difficulty"]][["pop"]] %>%
  select(GEOID, value, pctile) %>%
  rename(pctpop = value) %>%
  rename_with(.cols = c(pctpop, pctile), ~ paste0("vis_", .x))

## density - people per square mile -----
master_ls[["den"]] <- acs_tracts %>%
  mutate(area_mi2 = as.numeric(tract_area * 3.86102e-7)) %>%
  mutate(den = total_population/area_mi2) %>%
  mutate(den_pctile = ntile(den, 100)) %>%
  select(GEOID, total_population, area_mi2, den, den_pctile)


## % of children under 5 & elders over 65 -----
master_ls[["old"]] <- 
  acs[["65 and older"]][["pct"]] %>%
  select(GEOID, value, pctile) %>%
  rename(pctpop = value) %>%
  rename_with(.cols = c(pctpop, pctile), ~ paste0("old_", .x))

master_ls[["kid"]] <- 
  acs[["Under 5"]][["pct"]] %>%
  select(GEOID, value, pctile) %>%
  rename(pctpop = value) %>%
  rename_with(.cols = c(pctpop, pctile), ~ paste0("kid_", .x))

## % of BIPOC people -----
master_ls[["bip"]] <- 
  acs[["BIPOC people"]][["pct"]] %>%
  select(GEOID, value, pctile) %>%
  rename(pctpop = value) %>%
  rename_with(.cols = c(pctpop, pctile), ~ paste0("bip_", .x))

## % of zero-car households ------
master_ls[["zca"]] <- 
  acs[["Zero-car households"]][["pct"]] %>%
  select(GEOID, value, pctile) %>%
  rename(pcthhs = value) %>%
  rename_with(.cols = c(pcthhs, pctile), ~ paste0("zca_", .x))

## % of one-car households -----
master_ls[["oca"]] <- 
  acs[["One-car households"]][["pct"]] %>%
  select(GEOID, value, pctile) %>%
  rename(pcthhs = value) %>%
  rename_with(.cols = c(pcthhs, pctile), ~ paste0("oca_", .x))

## % of low-income households -----
master_ls[["inc"]] <- 
  acs[["Low-income households"]][["pct"]] %>%
  select(GEOID, value, pctile) %>%
  rename(pcthhs = value) %>%
  rename_with(.cols = c(pcthhs, pctile), ~ paste0("inc_", .x))

# compile ----
master <- master_ls %>% purrr:::reduce(inner_join, by = "GEOID")


# make spatial -----
master <- master %>%
  st_as_sf() %>%
  st_transform(crs = 4326)


saveRDS(master, file = "data/scoring_master.RDS")
saveRDS(master, file = "plow_the_sidewalks_criteria_app/data/scoring_master.RDS")


# Test scoring method -----
# weights <- list(
#   "old_w" = 0.25,
#   "kid_w" = 0.25,
#   "zca_w" = 0.2,
#   "oca_w" = 0.2,
#   "inc_w" = 0.1
# )
# 
# sum(unlist(weights))
# 
# scores <-
# master %>%
#   # basic filter:
#   filter(amb_pctile >=75 | vis_pctile >= 75) %>%
#   mutate(test = scale(kid_pctpop, center = min(kid_pctpop), scale = diff(range(kid_pctpop)))) %>%
#   mutate(across(c(contains("pctpop"), contains("pcthhs")),
#                 # get a scaled value for each variable:
#                 ~scale(., center = min(.), scale = diff(range(.)))[,1])) %>%
#   # calculate a weighted score:
#   mutate(score =
#            (old_pctpop * weights$old_w) +
#            (kid_pctpop * weights$kid_w) +
#            (zca_pcthhs * weights$zca_w) +
#            (oca_pcthhs * weights$oca_w) +
#            (inc_pcthhs * weights$inc_w)) %>%
#   mutate(score_pctile = ntile(score, 100)) %>%
#   arrange(desc(score))
# 
# hist(scores$score_pctile)
# View(scores)
# 
