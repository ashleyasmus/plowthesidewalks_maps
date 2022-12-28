create_scorecard <-
  function(intersection) {
    
    # intersection <-
    #   readRDS("plow_the_sidewalks_criteria_app/intersection.RDS")
    
    pop_summary <-
      intersection %>%
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
      group_by(X_leaflet_id) %>%
      summarize(across(
        c(
          matches("n_pop|n_hh"),
          "total_population",
          "num_hh"
        ),
        ~ sum(.)
      )) %>%
      mutate(geometry = st_union(geometry)) %>%
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
      st_intersection(bad_chicago$sno, pop_summary %>% select(X_leaflet_id)) %>%
      st_drop_geometry() %>%
      group_by(X_leaflet_id) %>%
      tally(n = "n_sno") %>%
      ungroup() 
    
    
    vac_count <- 
      st_intersection(bad_chicago$vac, pop_summary %>% select(X_leaflet_id)) %>%
      st_drop_geometry() %>%
      group_by(X_leaflet_id) %>%
      tally(n = "n_vac") %>%
      ungroup() 
    
    cta_total <- 
      st_intersection(cta_chicago, pop_summary %>% select(X_leaflet_id)) %>%
      st_drop_geometry() %>%
      group_by(X_leaflet_id) %>%
      summarize(cta_activity =sum(activity)) %>%
      ungroup() 
    
      
    summary <- list(pop_summary,
                    sno_count,
                    vac_count,
                    cta_total) %>% 
      purrr::reduce(left_join, by = "X_leaflet_id") %>%
      mutate(cta_permi2 = cta_activity/area,
             n_sno_permi2 = n_sno/area,
             n_vac_permi2 = n_vac/area)
      

    summary_tab <-
      data.frame(
        icon =
          c(
            "wheelchair-move",
            "person-walking-with-cane",
            "user-plus",
            "baby-carriage",
            "car",
            "city",
            "bus",
            "snowplow",
            "building-circle-exclamation"
          ),
        desc =
          c(
            paste0(round(100 * summary$amb_pct_pop), "% of residents have an ambulatory disability"),
            paste0(round(100 * summary$vis_pct_pop), "% of residents have a vision disability"),
            paste0(round(100 * summary$old_pct_pop), "% of residents are age 65 and over"),
            paste0(round(100 * summary$kid_pct_pop), "% of residents are under age 5"),
            paste0(round(100 * summary$zca_pct_hh), "% of households have no car"),
            paste0(round(as.numeric(summary$total_population) / 1000), "K residents"),
            paste0(round(as.numeric(summary$cta_activity) / 1000), "K transit boardings and alightings per day"),
            paste0(prettyNum(round(as.numeric(summary$n_sno)), big.mark = ","), " sidewalk snow/ice removal requests"),
            paste0(prettyNum(round(as.numeric(summary$n_vac)), big.mark = ","), " vacant building reports")
          ),
        score = c(
          round(
            100 - (100 * ecdf(master$amb_pct_pop)(summary$amb_pct_pop))
          ),
          round(
            100 - (100 * ecdf(master$vis_pct_pop)(summary$vis_pct_pop))
          ),
          round(
            100 - (100 * ecdf(master$amb_pct_pop)(summary$old_pct_pop))
          ),
          round(
            100 - (100 * ecdf(master$amb_pct_pop)(summary$kid_pct_pop))
          ),
          round(
            100 - (100 * ecdf(master$zca_pct_hh)(summary$zca_pct_hh))
          ),
          round(
            100 - ( 100 * ecdf(master$den)(summary$den))
          ),
          round(
            100 - (100 * ecdf(master$cta_permi2)(summary$cta_permi2))
          ),
          round(
            100 - (100 * ecdf(master$n_sno_permi2)(summary$n_sno_permi2))
          ),
          round(
            100 - (100 * ecdf(master$n_vac_permi2)(summary$n_vac_permi2))
          )
        )
      )


    scorecard <-
      summary_tab %>%
      mutate(icon = factor(icon,
                              levels = c("city", 
                                         "snowplow",
                                         "building-circle-exclamation",
                                         
                                         "wheelchair-move",
                                         "person-walking-with-cane",
                                         "user-plus",
                                         
                                         "baby-carriage",
                                         "bus",
                                         "car"))) %>%
      mutate(requirement_applies_to = recode_factor(icon,
                                   "city" = "All zones", 
                                   "snowplow" =  "All zones",
                                   "building-circle-exclamation" = "All zones",
                                   
                                   "wheelchair-move" = "Disability-focused zones",
                                   "person-walking-with-cane" = "Disability-focused zones",
                                   "user-plus" = "Disability-focused zones",
                                   
                                   "baby-carriage" = "Transit-focused zones",
                                   "bus" = "Transit-focused zones",
                                   "car" = "Transit-focused zones")) %>%
        
        mutate(
          score_minimum = recode(
            requirement_applies_to,
            "All zones" = 50,
            "Disability-focused zones" = 75,
            "Transit-focused zones" = 75
          )
        ) %>% 
      mutate(meets_requirement = ifelse(score >= score_minimum, "circle-check", "xmark")) %>% 
      arrange(requirement_applies_to, icon) %>%
      select(requirement_applies_to, icon, desc, score, score_minimum, meets_requirement) %>%
      gt::gt() %>%
      gtExtras::gt_fa_column(meets_requirement,
        height = "1.5rem",
        palette = c("circle-check" = "#9b51e0", 
                    "xmark" = "#abb8c3")
      ) %>%
        gtExtras::gt_fa_column(icon,
                               height = "1.5rem",
                               palette = rep("#270075", nrow(summary))) %>%
        
      gt::tab_style(
        locations = cells_body(),
        style = list(cell_text(
          color = "#270075",
          font = "Poppins",
          weight = "bold",
          size = "1rem",
          align = "left",
          v_align = "middle"
        ))
      )%>%
       
      gt::tab_style(
        locations = cells_body(columns = c("score", "score_minimum")),
        style = list(cell_text(
          font = "Poppins",
          size = "1.5rem",
          align = "center",
          v_align = "middle",
          weight = "bold"
        ))
      ) %>%
        tab_row_group(
          label = toupper("Requirements that apply to transit-focused pilot zones (min. score: 75)"),
          rows = requirement_applies_to == "Transit-focused zones"
        ) %>%
        tab_row_group(
          label = toupper("Requirements that apply to disability-focused pilot zones (min. score: 75)"),
          rows = requirement_applies_to == "Disability-focused zones"
        ) %>%
        tab_row_group(
          label = toupper("Requirements that apply to all pilot zones (min. score: 50)"),
          rows = requirement_applies_to == "All zones",
        ) %>%
        gt::cols_hide(c("requirement_applies_to", "score_minimum")) %>%
        gt::tab_style(
          locations = cells_column_labels(),
          style = list(cell_text(
            color = "white",
            font = "Poppins",
            weight = "bold",
            size = "1.2rem",
            align = "left",
            v_align = "middle"
          ))
        ) %>%
        gt::tab_style(
          locations = cells_row_groups(),
          style = list(cell_text(
            color = "#270075",
            font = "Poppins",
            weight = "bold",
            size = "1rem",
            align = "left",
            v_align = "middle"
          ))
        ) %>%
      gt::cols_label(
          icon = "",
          meets_requirement = "Meets req.",
          score = gt::html(glue::glue("<span 
                                style= 'font-family: Poppins, sans-serif;
                                font-size:1.2rem;
                                color = white,
                                font-weight: bold'>
                                Score
                                </span>
                                {gtExtras::with_tooltip(tooltip = 
                                stringr::str_wrap(width = 30,
                                'The percentile rank of the pilot zone you drew, 
                                compared to all Chicago census tracts. 
                                Higher numbers correspond to a higher rank.'),
                              fontawesome::fa('circle-info',
                              prefer_type = 'solid',
                              height = '1rem'))}")
            ),
          icon = gt::html(glue::glue("<span 
                                style= 'font-family: Poppins, sans-serif;
                                font-size:1.2rem;
                                color = white,
                                font-weight: bold'>
                                Result
                                </span>")),
          desc = ""
      ) %>%
      gt::tab_style(
        locations = cells_column_labels(),
        style = list(cell_text(
          color = "white",
          font = "Poppins",
          size = "1.2rem",
          align = "center",
          v_align = "middle",
          weight = "bold"
        ))
      ) %>%
      gt::tab_options(
        column_labels.background.color =  "#270075",
        row_group.background.color ="#F9F9F9",
        table.background.color = "transparent",
        table.font.size = 10,
        table_body.hlines.color = "transparent",
        table_body.border.top.color = "transparent",
        table_body.border.bottom.color = "transparent",
        container.padding.y = px(0)
        # column_labels.hidden = TRUE
      )

    scorecard
  }
