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
  
# import ACS census data -----
# Use 2020 ACS 1-Year Public Use Microdata Sample with Experimental Weights
# https://www.census.gov/programs-surveys/acs/data/experimental-data/2020-1-year-pums.html
# Choose variables:
all_acs_vars <-
  tidycensus::load_variables(year = "2019",
                             dataset = "acs5",
                             cache = F)
## choose variables ----
var_ls <- list() 

### race ----
var_ls$race <- all_acs_vars %>%
  filter(grepl("B02001", name)) %>%
  separate(label,
         into = c(NA, NA, "race", "race_detail"), 
         sep = "!!|:!!",
         extra = "drop",
         fill = "right",
         remove = TRUE) %>%
  filter(!is.na(race) & is.na(race_detail)) %>%
  select(-concept, -race_detail) %>%
  mutate(race = gsub(pattern = ":", replacement = "", race)) %>%
  rename(variable = name)

### age ----
var_ls$age <-
  all_acs_vars %>%
  filter(concept == "SEX BY AGE") %>%
  separate(label,
           into = c(NA, NA, "gender", "age"), 
           sep = "!!|:!!",
           extra = "drop",
           fill = "right",
           remove = TRUE) %>%
  filter(!is.na(gender) & !is.na(age)) %>%
  select(-concept) %>%
  # de-select age:
  select(-age) %>% 
  rename(variable = name)

### income ----
var_ls$income <-
  all_acs_vars %>%
  filter(concept == "HOUSEHOLD INCOME IN THE PAST 12 MONTHS (IN 2019 INFLATION-ADJUSTED DOLLARS)") %>%
  separate(label,
           into = c(NA, NA, "income"), 
           sep = "!!|:!!",
           extra = "drop",
           fill = "right",
           remove = TRUE) %>%
  filter(!is.na(income)) %>%
  select(-concept) %>%
  rename(variable = name)

### commute mode ----
var_ls$commute <-
  all_acs_vars %>%
  filter(concept == "MEANS OF TRANSPORTATION TO WORK") %>%
  separate(label,
           into = c(NA, NA, "commute", "commute_detailed"), 
           sep = "!!|:!!",
           extra = "drop",
           fill = "right",
           remove = TRUE) %>%
  filter(!is.na(commute)) %>%
  filter(is.na(commute_detailed)) %>%
  select(-concept, -commute_detailed) %>%
  rename(variable = name)

### disability ----
var_ls$disability <-
  all_acs_vars %>%
  filter(grepl("B18", name) &
           # not cross-tabbed by race:
           !grepl("[A-Z]_", name) &
           # estimates, not "allocation": 
           grepl("SEX BY AGE", concept)) %>%
  separate(label,
           into = c(NA, NA, "gender", "age", "disability_type"), 
           sep = "!!|:!!",
           extra = "drop",
           fill = "right",
           remove = TRUE) %>%
  filter(!is.na(disability_type)) %>%
  mutate(disability_status = case_when(grepl("with a", 
                                  disability_type, 
                                  ignore.case = T) ~ "yes",
                            grepl("no ", 
                                  disability_type, 
                                  ignore.case = T) ~ "no")) %>%
  mutate(disability_type = gsub("With a |With an |No | difficulty", "", disability_type)) %>%
  mutate(disability_type = ifelse(disability_type == "disability", "any", disability_type)) %>%
  rename(variable = name) %>%
  select(variable, gender, age, disability_type, disability_status, geography)


# store ACS tables ---
all_acs <- purrr::map(.x = names(var_ls),
                      function(a_vartype) {
                        result <- 
                        suppressMessages(tidycensus::get_acs(
                          geography = var_ls[[a_vartype]]$geography[[1]],
                          variables = var_ls[[a_vartype]]$variable,
                          # weighted total population estimate
                          state = "IL",
                          county = "Cook",
                          year = 2019,
                          # get the geometry of the block groups as well:
                          geometry = T
                        ) %>%
                          st_transform(crs = 26916) %>%
                          select(-NAME) %>%
                          left_join(var_ls[[a_vartype]],  by = c("variable"))) %>%
                          mutate(bg_area = st_area(geometry))
                        st_agr(result) <- "constant"
                        
                        result
                      })


names(all_acs) <- names(var_ls)

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

# grouping variables for summaries
grp_vars <- list(
  "disability" = c("disability_type", "disability_status"),
  "age" = "age",
  "race" = "race",
  "income" = "income",
  "commute" = "commute"
)

plow_demo <- list()

for (plow_geo_type in names(plow_geo)) {
  plow_demo[[plow_geo_type]] <-
    
    purrr::map(.x = names(all_acs),
               
               function(acs_variable) {
                 acs_var_names <- grp_vars[[acs_variable]]
                 
                 acs_geo_type <-
                   var_ls[[acs_variable]]$geography[[1]]
                 
                 base_geo_i <-
                   base_geo[[acs_geo_type]][[plow_geo_type]]
                 
                 plow_demo_i <-
                   base_geo_i %>%
                   st_drop_geometry %>%
                   left_join(all_acs[[acs_variable]] %>%
                               st_drop_geometry() %>%
                               select(-bg_area),
                             by = c("GEOID")) %>%
                   mutate(adj_est = round(estimate * area_frac)) %>%
                   group_by_at(c("Name",
                                 "Description",
                                 acs_var_names)) %>%
                   summarize(adj_est = sum(adj_est)) %>%
                   ungroup()
                 
                 plow_demo_i
                 
               })
  
  names(plow_demo[[plow_geo_type]]) <- names(all_acs)
}

# save data
saveRDS(object = plow_geo, file = "data/plow_geo.RDS")
saveRDS(plow_demo, "data/plow_demo.RDS")
