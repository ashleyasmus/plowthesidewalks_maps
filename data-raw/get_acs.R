# toolbox ----
library(dplyr)
library(tidyr)
library(tidycensus)


# import ACS census data (2015-2020 ACS 5-year estimates) -----
# Choose variables:
acs_vars_all <-
  tidycensus::load_variables(year = "2020",
                             dataset = "acs5",
                             cache = F)

## choose variables ----
acs_vars_ls <- list() 

### race ----
acs_vars_ls$race <- acs_vars_all %>%
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
acs_vars_ls$age <-
  acs_vars_all %>%
  filter(concept == "SEX BY AGE") %>%
  separate(label,
           into = c(NA, NA, "gender", "age"), 
           sep = "!!|:!!",
           extra = "drop",
           fill = "right",
           remove = TRUE) %>%
  filter(!is.na(gender) & !is.na(age)) %>%
  select(-concept) %>%
  # de-select gender:
  select(-gender) %>% 
  rename(variable = name)

### income ----
acs_vars_ls$income <-
  acs_vars_all %>%
  filter(concept == "HOUSEHOLD INCOME IN THE PAST 12 MONTHS (IN 2020 INFLATION-ADJUSTED DOLLARS)") %>%
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
acs_vars_ls$commute <-
  acs_vars_all %>%
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
acs_vars_ls$disability <-
  acs_vars_all %>%
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


### vehicle access -----
acs_vars_ls$vehicles <-
  acs_vars_all %>%
  filter(concept == "TENURE BY VEHICLES AVAILABLE") %>%
  separate(label,
           into = c(NA, NA, "tenure", "num_vehicles"), 
           sep = "!!|:!!",
           extra = "drop",
           fill = "right",
           remove = TRUE) %>%
  filter(!is.na(num_vehicles)) %>%
  mutate(num_vehicles = case_when(num_vehicles == "No vehicle available" ~ "0",
                                  num_vehicles == "1 vehicle available" ~ "1",
                                  num_vehicles == "2 vehicles available" ~ "2",
                                  num_vehicles == "3 vehicles available" ~ "3",
                                  num_vehicles == "4 vehicles available" ~ "4",
                                  num_vehicles == "5 or more vehicles available" ~ "5+"))%>%
  mutate(vehicle_available = case_when(num_vehicles == "0" ~ "0", 
                                       num_vehicles == "1" ~ "1",
                                       TRUE ~ "2 or more")) %>%
  rename(variable = name) %>%
  select(-concept)

#get data ----
acs_raw <- purrr::map(.x = names(acs_vars_ls),
                      function(a_vartype) {
                        result <- 
                          suppressMessages(tidycensus::get_acs(
                            geography = "tract",
                            variables = acs_vars_ls[[a_vartype]]$variable,
                            # weighted total population estimate
                            state = "IL",
                            county = "Cook",
                            year = 2020,
                            # get the geometry of the tracts separately: 
                            geometry = F
                          ) %>%
                            select(-NAME) %>%
                            left_join(acs_vars_ls[[a_vartype]],  by = c("variable")))
                          
                        result
                      })


names(acs_raw) <- names(acs_vars_ls)


# grouping variables for summaries -----
acs_vars_groups <- list(
  "disability" = c("disability_type", "disability_status"),
  "age" = "age",
  "race" = "race",
  "income" = "income",
  "commute" = "commute",
  "vehicles" = "vehicle_available"
)

acs_grouped <-
  purrr::map(.x = names(acs_raw),
             
             function(acs_variable) {
               
               acs_var_names <- acs_vars_groups[[acs_variable]]
               
               acs_grouped_i <- acs_raw[[acs_variable]] %>%
                 group_by_at(c("GEOID", acs_var_names)) %>%
                 summarize(est = sum(estimate)) %>%
                 ungroup()
               
               acs_grouped_i
               
             })

names(acs_grouped) <- names(acs_raw)

# Custom aggregation/variable selection -----
acs_summary_ls <- list()

## race ----
acs_summary_ls[["race"]] <-
  acs_grouped$race %>%
  group_by(GEOID) %>%
  mutate(total_est = sum(est)) %>%
  ungroup() %>%
  filter(!race == "White alone") %>%
  mutate(var_short = "BIPOC people",
         var_long = "People who identify as Black, Indigenous and other people of color") %>%
  select(-race)

## age ----
acs_summary_ls[["age"]] <-
  acs_grouped$age %>%
  group_by(GEOID) %>%
  mutate(total_est = sum(est)) %>%
  ungroup() %>%
  mutate(
    age = recode_factor(
      age,
      "Under 5 years" = "Under 5",
      "65 and 66 years" = "65 and older",
      "67 to 69 years" = "65 and older",
      "70 to 74 years" = "65 and older",
      "75 to 79 years" = "65 and older",
      "80 to 84 years" = "65 and older",
      "85 years and over" = "65 and older"
    )
  ) %>% 
  filter(age %in% c("Under 5", "65 and older")) %>%
  mutate(var_short = age,
         var_long = case_when(age == "Under 5" ~ "Children younger than 5 years old",
                              age == "65 and older" ~ "Adults 65 years old and older")) %>%
  select(-age)

## income ----
acs_summary_ls[["income"]] <-
  acs_grouped$income %>%
  group_by(GEOID) %>%
  mutate(total_est = sum(est)) %>%
  filter(
    income %in% c(
      "$10,000 to $14,999",
      "$15,000 to $19,999",
      "$20,000 to $24,999",
      "$25,000 to $29,999",
      "$30,000 to $34,999",
      "$35,000 to $39,999",
      "$40,000 to $44,999",
      "$45,000 to $49,999"
    )
  ) %>%
  select(-income) %>%
  mutate(var_short = "Low-income households",
         var_long = "People who live in households with total incomes under $50,000 per year")

## commute ----
acs_summary_ls[["commute"]] <-
  acs_grouped$commute %>%
  group_by(GEOID) %>%
  mutate(total_est = sum(est)) %>%
  filter(
   commute %in% c("Walked", "Bicycle", "Public transportation (excluding taxicab):")
  ) %>%
  select(-commute) %>%
  mutate(var_short = "Non-car commutes",
         var_long = "People who walk, bike or take public transit to work")


## disability -----
acs_summary_ls[["disability"]] <-
  acs_grouped$disability %>%
  group_by(GEOID) %>%
  mutate(total_est = sum(est)) %>%
  ungroup() %>%
  filter(disability_type %in% c("ambulatory", "vision") &
           disability_status == "yes") %>%
  mutate(var_short = case_when(disability_type == "ambulatory" ~ "Ambulatory difficulty",
                               disability_type == "vision" ~ "Vision difficulty"),
         var_long = case_when(disability_type == "ambulatory" ~ "People who have serious difficulty walking or climbing stairs",
                              disability_type == "vision" ~ "People who are blind or have serious difficulty seeing even when wearing glasses")) %>%
  select(-disability_status, -disability_type)

## vehicles ----
acs_summary_ls[["vehicles"]] <-
  acs_grouped$vehicles %>%
  group_by(GEOID) %>%
  mutate(total_est = sum(est)) %>%
  ungroup() %>%
  filter(vehicle_available %in% c("0", "1")) %>%
  mutate(var_short = case_when(vehicle_available == "0" ~ "Zero-car households",
                               vehicle_available == "1" ~ "One-car households"),
         var_long = case_when(vehicle_available == "0" ~ "Households with no vehicle",
                              vehicle_available == "1" ~ "Households with one vehicle")) %>%
  select(-vehicle_available)


acs_summary_c <-
acs_summary_ls %>%
  bind_rows() %>%
  group_by(GEOID, var_short, var_long) %>%
  summarize(pop = sum(est),
            pct = round(100 * sum(est)/total_est, 2)) %>%
  ungroup() %>%
  unique() %>%
  pivot_longer(cols = c(pop, pct), names_to = "measure", values_to = "value") %>%
  filter(!is.na(value)) %>%
  group_by(var_short, var_long, measure) %>%
  mutate(pctile = ntile(desc(value), 100),
         scaled = scale(value, center = F, scale = T)[,1]) %>%
  ungroup() %>%
  mutate(
   units = case_when(measure == "pop" ~ "people", 
                     measure == "pct" ~ "% of people"), 
   var_type = "Demographics",
   tooltip = paste0("<b>", var_long, "</b>", 
                    "<br><b>", round(value), " ", units, "</b>",
                    "<br>In the top ", pctile, "% of Chicago tracts for ", var_short,
                    "<br>Tract ", GEOID, 
                    "<br>Source: 2016-2020 American Community Survey"))


acs_summary_split1 <- split(acs_summary_c, acs_summary_c$var_short, drop = TRUE)
acs_summary_split2 <- lapply(acs_summary_split1, function(df) split(df, df[["measure"]], drop = T))


saveRDS(acs_summary_split2, file = "data/acs_summary.RDS", compress = "xz")