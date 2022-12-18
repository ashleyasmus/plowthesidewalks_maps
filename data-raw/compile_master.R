# Toolbox ----
library(dplyr)
library(tidyr)
library(sf)
library(purrr) 

# Load data ----
acs <- readRDS("data/acs_summary_chicago.RDS")
acs_tracts <- readRDS("data/acs_tracts_chicago.RDS")


# Select variables ----
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

master_acs <- 
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

names(master_acs) <- acs_var_abbr

## density - people per square mile -----
master_acs[["den"]] <- acs_tracts %>%
  mutate(area_mi2 = as.numeric(tract_area * 3.86102e-7)) %>%
  mutate(den = total_population/area_mi2) %>%
  mutate(den_pctile = ntile(den, 100)) %>%
  select(GEOID, total_population, num_hh, area_mi2, den, den_pctile)

# compile ----
master <- master_acs %>% purrr:::reduce(inner_join, by = "GEOID") %>%
  # get rid of NAs (three tracts) 
  filter(!is.na(vis_pct_pop))


# make spatial -----
master <- master %>%
  st_as_sf() %>%
  st_transform(crs = 4326)

# rename, household-based columns to hh vars ----
master <- master %>%
  rename(inc_pct_hh = inc_pct_pop,
         zca_pct_hh = zca_pct_pop,
         oca_pct_hh = oca_pct_pop,
         inc_n_hh = inc_n_pop,
         zca_n_hh = zca_n_pop,
         oca_n_hh = oca_n_pop)


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
