create_scorecard <- 
  function(intersection){
    # intersection <-
    #   readRDS("plow_the_sidewalks_criteria_app/intersection.RDS")
    
    summary <-
      intersection %>%
      mutate(intersect_area = st_area(geometry)) %>%
      mutate(intersect_area_mi2 = units::set_units(intersect_area, "mi^2")) %>%
      mutate(prop_area = as.numeric(intersect_area_mi2) / area_mi2) %>%
      # Adjust all population/household counts:
      mutate(across(
        c(
          matches("n_pop|n_hh"),
          "total_population",
          "n_sno",
          "n_vac",
          "n_bad",
          "cta_activity",
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
          "n_sno",
          "n_vac",
          "n_bad",
          "cta_activity",
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
        den = total_population / area_mi2,
        cta_permi2 = cta_activity / area_mi2,
        n_sno_permi2 = n_sno / area_mi2,
        n_vac_permi2 = n_sno / area_mi2,
        n_bad_permi2 = n_bad / area_mi2
      ) %>%
      # ... population variables:
      mutate(across(contains("n_pop"),
                    ~ . / total_population,
                    .names = "{sub('n_pop', 'pct_pop', col)}")) %>%
      # ... household-based variables:
      mutate(across(contains("n_hh"),
                    ~ . / num_hh,
                    .names = "{sub('n_hh', 'pct_hh', col)}"))
    
  
    
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
        
        num = c(
          paste0(round(100 * summary$amb_pct_pop), "%"),
          paste0(round(100 * summary$vis_pct_pop), "%"),
          paste0(round(100 * summary$old_pct_pop), "%"),
          paste0(round(100 * summary$kid_pct_pop), "%"),
          paste0(round(100 * summary$zca_pct_hh), "%"),
          paste0(round(as.numeric(summary$den)/1000), "K"),
          paste0(round(as.numeric(summary$cta_permi2)/1000), "K"),
          prettyNum(round(as.numeric(summary$n_sno_permi2)), big.mark = ","),
          prettyNum(round(as.numeric(summary$n_vac_permi2)), big.mark = ",")
        ), 
        
        desc =
          c("of residents have an ambulatory disability",
            "of residents have a vision disability",
            "of residents are age 65 and over",
            "of residents are under age 5",
            "of households have no car",
            "people per square mile",
            "transit boardings per square mile, per day",
            "311 requests for snow removal per square mile",
            "reports of vacant buildings per square mile"
          ),
        
        rank = c(
          round(
            100 * ecdf(master$amb_pct_pop)(summary$amb_pct_pop)
          ),
          
          round(
            100 * ecdf(master$vis_pct_pop)(summary$vis_pct_pop)
          ),
          
          round(
            100 * ecdf(master$amb_pct_pop)(summary$old_pct_pop)
          ),
          
          round(
            100 * ecdf(master$amb_pct_pop)(summary$kid_pct_pop)
          ),
          
          round(
            100 * ecdf(master$zca_pct_hh)(summary$zca_pct_hh)
          ),
          
          round(
            100 * ecdf(master$den)(summary$den)
          ),
          
          round(
            100 * ecdf(master$cta_permi2)(summary$cta_permi2)
          ),
          
          round(
            100 * ecdf(master$n_sno_permi2)(summary$n_sno_permi2)
          ),
          
          round(
            100 * ecdf(master$n_vac_permi2)(summary$n_vac_permi2)
          )
        )
      ) %>%
      mutate(rank = ifelse(rank == 0, 1, rank))
    
    
    scorecard <- 
      summary_tab %>%
      gt::gt() %>%
      gtExtras::gt_fa_column(icon,
                             height = "50px",
                             palette = rep("#270075", nrow(summary_tab))) %>%
      gt::tab_style(locations = cells_body(columns = "num"),
                    style = list(cell_text(
                      color = "#000000",
                      font = "Poppins",
                      size = "2.5rem",
                      align = "right",
                      v_align = "middle",
                      weight = "bold"
                    ))) %>%
      
      gt::tab_style(locations = cells_body(columns = "desc"),
                    style = list(cell_text(
                      color = "#000000",
                      font = "Montserrat",
                      size = "1rem",
                      align = "left",
                      v_align = "middle"
                    ))) %>%
      
      gt::tab_style(locations = cells_body(columns = "rank"),
                    style = list(cell_text(
                      color = "#000000",
                      font = "Poppins",
                      size = "2.5rem",
                      align = "center",
                      v_align = "middle",
                      weight = "bold"
                    ))) %>%
      
      gt::tab_style(locations = cells_column_labels(),
                    style = list(cell_text(
                      color = "#000000",
                      font = "Poppins",
                      size = "2rem",
                      align = "center",
                      v_align = "middle",
                      weight = "bold"
                    ))) %>%
      
      data_color(
        columns = rank,
        apply_to = "fill",
        colors = scales::col_numeric(
          palette = "plasma",
          reverse = T,
          domain = c(0, 100)
        )
      ) %>%
      
      
      gt::cols_label(
        icon = "Result",
        num = "",
        desc = "",
        rank  = gtExtras::with_tooltip(label = "Rank", tooltip = 
                                         stringr::str_wrap(width = 40,
                                                           "Percentile rank (0-100%) of your suggested pilot zone when compared to all Chicago census tracts. The smaller the number, the better your pilot zone performs for the listed measure."))
      ) %>%
      
      gt::tab_options(
        table.background.color = "transparent",
        table.font.size = 14,
        table_body.hlines.color = "transparent",
        table_body.border.top.color = "transparent",
        table_body.border.bottom.color = "transparent",
        container.padding.y = px(0)
      )
    
    scorecard
    
  }

