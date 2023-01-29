mini_map <- function(percentile_measure = "amb_pctile") {
  master_tr <-
    master_gl %>%
    mutate(
      score_bin =
        case_when(
          !!(rlang::sym(percentile_measure))< 0.1 ~ "0-10 (Low)",
          !!(rlang::sym(percentile_measure))< 0.3 ~ "20-30",
          !!(rlang::sym(percentile_measure))< 0.4 ~ "30-40",
          !!(rlang::sym(percentile_measure))< 0.5 ~ "40-50",
          !!(rlang::sym(percentile_measure))< 0.6 ~ "50-60",
          !!(rlang::sym(percentile_measure))< 0.7 ~ "60-70",
          !!(rlang::sym(percentile_measure))< 0.8 ~ "70-80",
          !!(rlang::sym(percentile_measure))< 0.9 ~ "80-90",
          !!(rlang::sym(percentile_measure))<= 1 ~ "90-100 (High)"
        )
    ) %>%
    mutate(score_bin = factor(score_bin,
                              levels = c(
                                "90-100 (High)",
                                "80-90",
                                "70-80",
                                "60-70",
                                "50-60",
                                "40-50",
                                "30-40",
                                "20-30",
                                "10-20",
                                "0-10 (Low)"
                              )
    ))
  
  color_data <- master_tr$score_bin
  
  my_pal <-
    colorFactor("plasma",
                color_data,
                reverse = FALSE
    )
  
  leaflet(options = leafletOptions(
    minZoom = 9.5, maxZoom = 9.5,
    zoomControl = F,
    attributionControl = FALSE,
    bg = "#fff"
  )) %>%
    setView(
      lat =
        41.840675,
      lng =
        -87.679365,
      zoom = 9.5
    ) %>%
    setMaxBounds(
      lat1 = chi_bbox[["ymin"]],
      lat2 = chi_bbox[["ymax"]],
      lng1 = chi_bbox[["xmin"]],
      lng2 = chi_bbox[["xmax"]]
    ) %>%
    addGlPolygons(
      data = master_gl,
      fillOpacity = 0.9,
      color = my_pal(color_data),
      fillColor = my_pal(color_data)
    ) 
}

fullscreen_map <- function(absolute_measure = "amb_n_ppl",
                           round_absolute = -2,
                           relative_measure = "amb_pct_ppl", 
                           relative_transform = 100,
                           round_relative = 0,
                           percentile_measure = "amb_pctile",
                           measure_units = "people",
                           measure_quality = "have an ambulatory disability",
                           relative_units = "%% of people") {
  
  tooltips <- sprintf(
    "<p align='center' 
     style='font-family: Poppins, sans-serif;
     font-size:1rem;
     color: #000000'>
      
      In this area,
      
      <b>
      %s %s 
      </b>
      
      <b>
      (%s%s)
      </b>
      %s,
      
      ranking it in the
      
      <br>
      <b>
      %sth percentile
      </b>
      
      <br>
      of all 450 half-square mile areas areas in Chicago.
      ",
    ifelse(round(master[[absolute_measure]], round_absolute) == 0, 
           paste0("<1", rep("0", abs(round_absolute))),
           prettyNum(round(master[[absolute_measure]], round_absolute),
           big.mark = ",")),
    
    measure_units,
    
    ifelse(round(relative_transform * master[[relative_measure]], round_relative) == 0,
           paste0("<1", rep("0", abs(round_absolute))),
           prettyNum(round(relative_transform * master[[relative_measure]], round_relative),
                     big.mark = ",")),
    
    relative_units,
    measure_quality,
    round(100 * master[[percentile_measure]])
  ) %>%
    lapply(htmltools::HTML)
   
  
  
  master_tr <-
    master %>%
    mutate(
      score_bin =
        case_when(
          !!(rlang::sym(percentile_measure)) < 0.1 ~ "0-10 (Low)",
          !!(rlang::sym(percentile_measure)) < 0.2 ~ "10-20",
          !!(rlang::sym(percentile_measure)) < 0.3 ~ "20-30",
          !!(rlang::sym(percentile_measure)) < 0.4 ~ "30-40",
          !!(rlang::sym(percentile_measure)) < 0.5 ~ "40-50",
          !!(rlang::sym(percentile_measure)) < 0.6 ~ "50-60",
          !!(rlang::sym(percentile_measure)) < 0.7 ~ "60-70",
          !!(rlang::sym(percentile_measure)) < 0.8 ~ "70-80",
          !!(rlang::sym(percentile_measure)) < 0.9 ~ "80-90",
          !!(rlang::sym(percentile_measure)) <= 1 ~ "90-100 (High)"
        )
    ) %>%
    mutate(score_bin = factor(score_bin,
                              levels = c(
                                "90-100 (High)",
                                "80-90",
                                "70-80",
                                "60-70",
                                "50-60",
                                "40-50",
                                "30-40",
                                "20-30",
                                "10-20",
                                "0-10 (Low)"
                              )
    ))
  
  color_data <- master_tr$score_bin
  
  my_pal <-
    colorFactor("plasma",
                color_data,
                reverse = FALSE
    )
  
  leaflet(options = leafletOptions(
    minZoom = 10, maxZoom = 15,
    zoomControl = T,
    attributionControl = FALSE
  )) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(
      lat =
        41.840675,
      lng =
        -87.679365,
      zoom = 11
    ) %>%
    setMaxBounds(
      lat1 = chi_bbox[["ymin"]] - .1,
      lat2 = chi_bbox[["ymax"]] + .1,
      lng1 = chi_bbox[["xmin"]] - .1,
      lng2 = chi_bbox[["xmax"]] + .1
    ) %>%
    addPolygons(
      data = master,
      layerId = ~hexid,
      label = ~tooltips,
      stroke = TRUE,
      weight = 1,
      color = my_pal(color_data),
      fillOpacity = 0.7,
      fillColor = my_pal(color_data)
    ) %>%
    addLegend(
      position = "topright",
      pal = my_pal,
      group = "score_tiles",
      values = unique(color_data),
      title = "Rank percentile"
    )
}

summarize_poly <-
  function(intersection) {
    # intersection <-
      # readRDS("app/intersection_789.RDS")

    pop_summary <-
      intersection %>%
      mutate(intersect_area = st_area(geometry)) %>%
      mutate(intersect_area_mi2 = units::set_units(intersect_area, "mi^2")) %>%
      mutate(prop_area = as.numeric(intersect_area_mi2) / as.numeric(hex_area_mi2)) %>%
      # Adjust all population/household counts:
      mutate(across(
        c(
          matches("n_ppl|n_hhs")
        ),
        ~ round(. * prop_area)
      )) %>%
      # Total for this rectangle:
      group_by(X_leaflet_id) %>%
      summarize(
        do.union = T,
        across(
          c(
            matches("n_ppl|n_hhs")
          ),
          ~ sum(.)
        )
      ) %>%
      ungroup() %>%
      mutate(total_area = st_area(geometry)) %>%
      mutate(total_area_mi2 = units::set_units(total_area, "mi^2")) %>%
      mutate(total_area_mi2 = as.numeric(total_area_mi2)) %>%
      # Refresh proportional data:
      # ... per-area variables:
      mutate(
        n_ppl_permi2 = n_ppl / total_area_mi2
      ) %>%
      # ... population variables:
      mutate(across(contains("n_ppl"),
        ~ . / n_ppl,
        .names = "{sub('n_ppl', 'pct_ppl', col)}"
      )) %>%
      # ... household-based variables:
      mutate(across(contains("n_hh"),
        ~ . / n_hhs,
        .names = "{sub('n_hh', 'pct_hh', col)}"
      )) %>%
      st_transform(crs = 4326)

    sno_count <-
      st_intersection(bad_chicago$sno, pop_summary %>%
        select(X_leaflet_id)) %>%
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
      summarize(n_cta = sum(activity)) %>%
      ungroup()


    summary <- list(
      pop_summary,
      sno_count,
      vac_count,
      cta_total
    ) %>%
      purrr::reduce(left_join, by = "X_leaflet_id") %>%
      mutate(
        n_cta_permi2 = n_cta / total_area_mi2,
        n_sno_permi2 = n_sno / total_area_mi2,
        n_vac_permi2 = n_vac / total_area_mi2
      )
  }

create_scorecard <-
  function(summary) {
    summary_tab <-
      data.frame(
        icon =
          c(
            "city",
            "wheelchair-move",
            "person-walking-with-cane",
            "user-plus",
            "baby-carriage",
            "car-tunnel",
            "circle-dollar-to-slot",
            "bus",
            "snowplow",
            "building-circle-exclamation"
          ),
        desc =
          c(
            paste0(round(as.numeric(summary$n_ppl) / 1000), "K residents"),
            paste0(prettyNum(round(summary$amb_n_ppl, -3), big.mark = ","), " of residents have an ambulatory disability"),
            paste0(prettyNum(round(summary$vis_n_ppl, -2), big.mark = ","), " of residents have a vision disability"),
            paste0(round(100 * summary$old_pct_ppl), "% of residents are age 65 and over"),
            paste0(round(100 * summary$kid_pct_ppl), "% of residents are under age 5"),
            paste0(round(100 * summary$zca_pct_hhs), "% of households have no car"),
            paste0(round(100 * summary$inc_pct_hhs), "% of households have incomes less than $50K"),
            paste0(round(as.numeric(summary$n_cta) / 1000), "K transit boardings and alightings per day"),
            paste0(prettyNum(round(as.numeric(summary$n_sno)), big.mark = ","), " sidewalk snow/ice removal requests"),
            paste0(prettyNum(round(as.numeric(summary$n_vac)), big.mark = ","), " vacant building reports")
          ),
        score = c(
          round(
            (100 * ecdf(master$n_ppl_permi2)(summary$n_ppl_permi2))
          ),
          round(
            (100 * ecdf(master$amb_pct_ppl)(summary$amb_pct_ppl))
          ),
          round(
            (100 * ecdf(master$vis_pct_ppl)(summary$vis_pct_ppl))
          ),
          round(
            (100 * ecdf(master$old_pct_ppl)(summary$old_pct_ppl))
          ),
          round(
            (100 * ecdf(master$kid_pct_ppl)(summary$kid_pct_ppl))
          ),
          round(
            (100 * ecdf(master$zca_pct_hhs)(summary$zca_pct_hhs))
          ),
          round(
            (100 * ecdf(master$inc_pct_hhs)(summary$inc_pct_hhs))
          ),
          round(
            (100 * ecdf(master$n_cta_permi2)(summary$n_cta_permi2))
          ),
          round(
            (100 * ecdf(master$n_sno_permi2)(summary$n_sno_permi2))
          ),
          round(
            (100 * ecdf(master$n_vac_permi2)(summary$n_vac_permi2))
          )
        )
      )


    scorecard <-
      summary_tab %>%
      mutate(icon = factor(icon,
        levels = c(
          "city",
          "wheelchair-move",
          "person-walking-with-cane",
          "user-plus",
          "baby-carriage",
          "car-tunnel",
          "circle-dollar-to-slot",
          "bus",
          "snowplow",
          "building-circle-exclamation"
        )
      )) %>%
      mutate(
        requirement_applies_to = recode_factor(
          icon,
          "city" = "Density-focused zones",
          "wheelchair-move" = "Disability-focused zones",
          "person-walking-with-cane" = "Disability-focused zones",
          "snowplow" = "Tertiary",
          "building-circle-exclamation" = "Tertiary",
          "user-plus" = "Secondary",
          "baby-carriage" = "Secondary",
          "bus" = "Secondary",
          "car-tunnel" = "Secondary",
          "circle-dollar-to-slot" = "Secondary"
        )
      ) %>%
      mutate(
        score_minimum = recode(
          requirement_applies_to,
          "Secondary" = 0,
          "Tertiary" = 0,
          "Disability-focused zones" = 75,
          "Density-focused zones" = 75
        )
      ) %>%
      mutate(meets_requirement = case_when(
        # score_minimum == 0 ~ NA_character_,
        score >= score_minimum ~ "circle-check",
        score < score_minimum ~ "xmark"
      )) %>%
      arrange(requirement_applies_to, icon) %>%
      select(requirement_applies_to, icon, desc, score, score_minimum, meets_requirement) %>%
      gt::gt() %>%
      gtExtras::gt_fa_column(meets_requirement,
        height = "1.5rem",
        palette = c(
          "circle-check" = "#9b51e0",
          "xmark" = "#abb8c3", 
          "white"
        )
      ) %>%
      gtExtras::gt_fa_column(icon,
        height = "1.5rem",
        palette = rep("#270075", nrow(summary_tab))
      ) %>%
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
      ) %>%
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
        label = toupper("Tertiary considerations"),
        rows = requirement_applies_to == "Tertiary",
      ) %>%
      tab_row_group(
        label = toupper("Secondary considerations"),
        rows = requirement_applies_to == "Secondary",
      ) %>%
      tab_row_group(
        label = toupper("Density-focused zone requirements"),
        rows = requirement_applies_to == "Density-focused zones"
      ) %>%
      tab_row_group(
        label = toupper("Disability-focused zone requirements"),
        rows = requirement_applies_to == "Disability-focused zones"
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
                              height = '1rem'))}")),
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
        column_labels.background.color = "#270075",
        row_group.background.color = "#F9F9F9",
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
