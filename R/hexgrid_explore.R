library(sf)
library(dplyr)

master <- readRDS("~/MetC_Locals/Personal/plowthesidewalks_maps/data/scoring_master.RDS") %>%
  st_transform(crs = 26916)

bad_chicago <- readRDS("data/311_requests_chicago.RDS")

bad_chicago$sno <- bad_chicago$sno %>%
  st_transform(crs = 26916)

bad_chicago$vac <- bad_chicago$vac %>%
  st_transform(crs = 26916)

cta_chicago <- readRDS("data/cta_stop_activity_chicago.RDS")%>%
  st_transform(crs = 26916)

wards <- readRDS("data/wards.RDS")%>%
  st_transform(crs = 26916)

hexgrid <- 
  sf::st_make_grid(
    master,
    cellsize = 865, # 0.25 sq mi
    # offset = st_bbox(x)[c("xmin", "ymin")],
    # n = c(10, 10),
    crs = 26916,
    what = "polygons",
    square = FALSE
    # flat_topped = FALSE
  ) %>%
  st_sf() %>%
  mutate(hexid = row_number())

units::set_units(st_area(hexgrid$geometry), "miles^2")


pop_summary <-
  st_intersection(scoring_master, hexgrid) %>%
  mutate(intersect_area = st_area(geometry)) %>%
  mutate(intersect_area_mi2 = units::set_units(intersect_area, "mi^2")) %>%
  mutate(prop_area = as.numeric(intersect_area_mi2) / area_mi2) %>%
  # Adjust all population/household counts:
  mutate(across(
    c(
      matches("n_pop|n_hh"),
      "total_population",
      "num_hh"
    ),
    ~ round(. * prop_area)
  )) %>%
  # Total for this rectangle:
  group_by(hexid) %>%
  summarize(
    across(
      c(
        matches("n_pop|n_hh"),
        "total_population",
        "num_hh"
      ),
      ~ sum(.)
    )) %>%
  ungroup() %>%
  mutate(area = st_area(geometry)) %>%
  mutate(area_mi2 = units::set_units(area, "mi^2")) %>%
  # Refresh proportional data:
  # ... per-area variables:
  mutate(
    den = total_population / area_mi2
  ) %>%
  # ... population variables:
  mutate(across(contains("n_pop"),
                ~ . / total_population,
                .names = "{sub('n_pop', 'pct_pop', col)}"
  )) %>%
  # ... household-based variables:
  mutate(across(contains("n_hh"),
                ~ . / num_hh,
                .names = "{sub('n_hh', 'pct_hh', col)}"
  ))

sno_count <- 
  st_intersection(bad_chicago$sno, hexgrid %>% 
                    select(hexid)) %>%
  st_drop_geometry() %>%
  group_by(hexid) %>%
  tally(n = "n_sno") %>%
  ungroup() 


vac_count <- 
  st_intersection(bad_chicago$vac, hexgrid %>% select(hexid)) %>%
  st_drop_geometry() %>%
  group_by(hexid) %>%
  tally(n = "n_vac") %>%
  ungroup() 

cta_total <- 
  st_intersection(cta_chicago, hexgrid %>% select(hexid)) %>%
  st_drop_geometry() %>%
  group_by(hexid) %>%
  summarize(cta_activity =sum(activity)) %>%
  ungroup() 


summary <- list(pop_summary,
                sno_count,
                vac_count,
                cta_total) %>% 
  purrr::reduce(left_join, by = "hexid") %>%
  mutate(cta_permi2 = cta_activity/area_mi2,
         n_sno_permi2 = n_sno/area_mi2,
         n_vac_permi2 = n_vac/area_mi2) %>%
  mutate(area = as.numeric(area), 
         area_mi2 = as.numeric(area_mi2),
         den = as.numeric(den),
         cta_permi2  = as.numeric(cta_permi2), 
         n_sno_permi2 = as.numeric(n_sno_permi2),
         n_vac_permi2 = as.numeric(n_vac_permi2)) %>%
  mutate(across(where(is.numeric), ~tidyr::replace_na(.,0)))
  

get_qtile <- 
  function(x){
    round(
      (100 * ecdf(x)(x)))
  }
  

hexscores <-
  list(
    hexid = summary$hexid,
      amb_score = get_qtile(summary$amb_pct_pop),
      vis_score = get_qtile(summary$vis_pct_pop),
      old_score = get_qtile(summary$old_pct_pop),
      kid_score = get_qtile(summary$kid_pct_pop),
      zca_score = get_qtile(summary$zca_pct_hh),
      cta_score = get_qtile(summary$cta_activity),
      den_score = get_qtile(summary$total_population),
      vac_score = get_qtile(summary$n_vac),
      sno_score = get_qtile(summary$n_sno)) %>%
  data.frame()

hex_result <- 
  hexgrid %>%
  left_join(hexscores)

transit_hexs <- 
  base_hexs %>%
  filter(cta_score > 75 & zca_score > 75)

plot(transit_hexs)


# Weighted Scores
transit_scores <- 
  hex_result %>%
  select(hexid, den_score, vac_score, sno_score, cta_score, zca_score, kid_score) %>%
  tidyr::pivot_longer(cols = den_score:kid_score,
                      names_to = 'cat', values_to = 'score') %>%
  mutate(cat = gsub('_score', replacement = '', x  = cat)) %>%
  filter(!is.na(score)) %>%
  mutate(weight = 
           case_when(cat %in% c('den', 'vac', 'sno') ~ 0.5,
                     cat %in% c('cta', 'zca', 'kid') ~ 0.5)) %>%
  group_by(hexid) %>%
  summarize(wt_score =weighted.mean(score, weight)) %>%
  mutate(rank = get_qtile(wt_score))


plot(transit_scores[,4])

disability_scores <- 
  hex_result %>%
  select(hexid, den_score, vac_score, sno_score, amb_score, vis_score, old_score) %>%
  tidyr::pivot_longer(cols = den_score:old_score,
                      names_to = 'cat', values_to = 'score') %>%
  mutate(cat = gsub('_score', replacement = '', x  = cat)) %>%
  filter(!is.na(score)) %>%
  mutate(weight = 
           case_when(cat %in% c('den', 'vac', 'sno') ~ 0.5,
                     cat %in% c('amb', 'vis', 'old') ~ 0.5)) %>%
  group_by(hexid) %>%
  summarize(wt_score =weighted.mean(score, weight, na.rm = T)) %>%
  ungroup() %>%
  mutate(rank = get_qtile(wt_score))

plot(disability_scores[,4])

par(mfrow=c(1,2))
par(mfrow = c(1, 2))
plot(transit_scores[,4], main = "Transit zone rankings", key.pos = NULL, reset = F)
plot(disability_scores[,4],  main = "Disability zone rankings", key.pos = NULL, reset = F)
