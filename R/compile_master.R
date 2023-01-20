# Toolbox ----
library(dplyr)
library(tidyr)
library(sf)
library(purrr)
library(units)


# Load data ----
## ... Tracts ----
tracts <- readRDS("data/acs_tracts_chicago.RDS") %>%
  # get rid of 0-hh tracts (Ohare airport)
  filter(n_hhs > 0) %>%
  st_transform(crs = 4326) %>%
  # get square mileage by tract:
  mutate(tract_area_mi2 = units::set_units(tract_area, "mi^2"))

st_agr(tracts) <- "constant"

## ... Chicago ----
chicago <- readRDS("data/plow_geo.RDS") %>%
  purrr::pluck("chi_city") %>%
  st_transform(crs = 4326) %>%
  # get rid of O'hare airport:
  st_crop(xmin = -87.865, xmax = -86, ymin = 0, ymax = 90)

st_agr(chicago) <- "constant"

## ... Hex grid -----
hexgrid <-
  # make grid:
  sf::st_make_grid(
    # use tracts as our boundaries:
    tracts %>%
      # must project to use cellsize argument
      st_transform(crs = 26916),
    # these units are very strange, still do not fully understand
    # https://github.com/r-spatial/sf/issues/1505,
    # but this works:
    cellsize = 1223, # 865 = 0.25 sq mi; 1223 = 0.5 sq mi
    crs = 26916,
    what = "polygons",
    square = FALSE # make hexagonal
  ) %>%
  # make sf object:
  st_sf() %>%
  # make hexid:
  mutate(hexid = row_number()) %>%
  # back to lat-long proj:
  st_transform(crs = 4326) %>%
  # crop to the boundary of chicago:
  st_intersection(chicago) %>%
  # simplify shapes -- not necessary with hexagonal grid
  # st_simplify(dTolerance = 100) %>% # 100 m

  # make valid:
  st_make_valid() %>%
  # calculate area:
  mutate(hex_area_mi2 = units::set_units(st_area(geometry), "mi^2")) %>%
  # get rid of overly-small hex units -- should be at least 1/4 mile
  filter(as.numeric(hex_area_mi2) >= 0.25)

st_agr(hexgrid) <- "constant"

## ... Census data -------
acs_ls <- readRDS("data/acs_summary_chicago.RDS")

# Select variables
acs_var_abbr <-
  c("amb", "vis", "kid", "old", "zca", "inc")

acs_var_long <-
  c(
    "Ambulatory difficulty",
    "Vision difficulty",
    "Under 5",
    "65 and older",
    "Zero-car households",
    "Low-income households"
  )

# rename columns
acs_ls <-
  purrr::map2(
    .x = acs_var_abbr,
    .y = acs_var_long,
    .f = function(abbr, long) {
      full_join(
        acs_ls[[long]][["pct"]] %>%
          select(GEOID, value) %>%
          rename(ppl = value) %>%
          rename_with(.cols = c(ppl), ~ paste0(abbr, "_pct_", .x)),
        acs_ls[[long]][["ppl"]] %>%
          select(GEOID, value) %>%
          rename(ppl = value) %>%
          rename_with(.cols = c(ppl), ~ paste0(abbr, "_n_", .x)),
        by = "GEOID"
      )
    }
  )

names(acs_ls) <- acs_var_abbr

# condense to one data frame
acs <- acs_ls %>%
  purrr:::reduce(inner_join, by = "GEOID") %>%
  # get rid of NAs (three tracts)
  filter(!is.na(vis_pct_ppl)) %>%
  # rename household-based columns with 'hh' suffix instead of 'pop'
  rename(
    zca_pct_hhs = zca_pct_ppl,
    zca_n_hhs = zca_n_ppl,
    inc_n_hhs = inc_n_ppl,
    inc_pct_hhs = inc_pct_ppl
  ) %>%
  # make spatial
  left_join(tracts) %>%
  st_as_sf() %>%
  st_transform(crs = 4326) %>%
  st_make_valid()

st_agr(acs) <- "constant"


## ... 311 data -----
requests311 <- readRDS("data/311_requests_chicago.RDS")

## ... CTA boardings -----
cta_chicago <- readRDS("data/cta_stop_activity_chicago.RDS")

## ... Sidewalks -----


# Tally by hex -----
## ... Census data ----
acs_hex <-
  st_intersection(acs, hexgrid) %>%
  st_make_valid() %>%
  mutate(prop_area = as.numeric(hex_area_mi2) / as.numeric(tract_area_mi2)) %>%
  # Adjust all population/household counts:
  mutate(across(
    matches("n_ppl|n_hh"),
    ~ round(. * prop_area)
  )) %>%
  # Total for this rectangle:
  group_by(hexid, hex_area_mi2) %>%
  summarize(
    across(
      matches("n_ppl|n_hh"),
      ~ sum(., na.rm = T)
    )
  ) %>%
  ungroup() %>%
  # Refresh proportional data:
  # ... per-area variables:
  mutate(
    n_ppl_permi2 = n_ppl / hex_area_mi2
  ) %>%
  # ... population variables:
  mutate(across(
    c(
      contains("n_ppl"),
      # don't change the master column, total population
      -"n_ppl",
      -"n_ppl_permi2"
    ),
    ~ . / n_ppl,
    .names = "{sub('n_ppl', 'pct_ppl', col)}"
  )) %>%
  # ... household-based variables:
  mutate(across(
    c(
      contains("n_hhs"),
      # don't change the total household column
      -"n_hhs"
    ),
    ~ . / n_hhs,
    .names = "{sub('n_hh', 'pct_hh', col)}"
  )) %>%
  # .... get rid of mi2 units:
  mutate(across(
    contains("mi2"),
    ~ as.numeric(.)
  ))

gc()

## ... 311 data ----
sno_hex <-
  st_intersection(requests311$sno, hexgrid) %>%
  st_drop_geometry() %>%
  group_by(hexid) %>%
  tally(n = "n_sno") %>%
  ungroup()

gc()

vac_hex <-
  st_intersection(requests311$vac, hexgrid) %>%
  st_drop_geometry() %>%
  group_by(hexid) %>%
  tally(n = "n_vac") %>%
  ungroup()

gc()

bad_hex <- sno_hex %>%
  left_join(vac_hex) %>%
  mutate(n_bad = n_sno + n_vac)

## ... CTA boardings -----
cta_hex <-
  st_intersection(cta_chicago, hexgrid) %>%
  st_drop_geometry() %>%
  group_by(hexid) %>%
  summarize(n_cta = sum(activity)) %>%
  ungroup()

gc()

## ... Sidewalks ----

# Combine ------
master <- list(
  acs_hex,
  bad_hex,
  cta_hex
) %>%
  purrr::reduce(left_join, by = "hexid") %>%
  # .... get per-area variables:
  mutate(
    n_cta_permi2 = n_cta / hex_area_mi2,
    n_sno_permi2 = n_sno / hex_area_mi2,
    n_vac_permi2 = n_vac / hex_area_mi2
  ) %>%
  # ..... if numeric, replace NA with 0:
  mutate(across(where(is.numeric), ~ tidyr::replace_na(., 0))) %>%
  # .... scale numeric variables:
  # mutate(across(
  #   c(matches(
  #     "pct_ppl|pct_hh|permi2"
  #   )),
  #   # get a scaled value for each variable
  #   ~ scales::rescale(., to = c(0, 1)),
  #   .names = "{sub('pct_ppl|pct_hhs|permi2', 'scale', col)}"
  # )) %>%
  # .... percentile numeric variables:
  mutate(across(
    c(matches(
      "pct_ppl|pct_hh|permi2"
    )),
    ~ percent_rank(.),
    .names = "{sub('pct_ppl|pct_hhs|permi2', 'pctile', col)}"
  )) %>%
  # geometry as last column
  dplyr::relocate(geometry, .after = last_col())


# Write data -----
saveRDS(master, file = "data/scoring_master.RDS")
saveRDS(master, file = "app/data/scoring_master.RDS")
