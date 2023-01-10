create_scorecard <-
  function(intersection) {
    # intersection <-
    #   readRDS("plow_the_sidewalks_criteria_app/scrap/intersection_514.RDS")

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
        score_minimum == 0 ~ NA_character_,
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
          "xmark" = "#abb8c3"
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
        label = toupper("Requirements that apply to density-focused pilot zones"),
        rows = requirement_applies_to == "Density-focused zones"
      ) %>%
      tab_row_group(
        label = toupper("Requirements that apply to disability-focused pilot zones"),
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
