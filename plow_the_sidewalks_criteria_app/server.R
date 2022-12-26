# Define server logic required to draw a histogram
server <- function(input, output, session) {
  #  render scrollytell --------
  output$scr <- renderScrollytell({
    scrollytell()
  })

  output$scr2 <- renderScrollytell({
    scrollytell()
  })

  # update weights ------
  weights <- reactiveVal(first_weights)

  observe({
    total <- sum(
      input$s_dis,
      input$s_old,
      input$s_kid,
      input$s_den,
      input$s_zca,
      input$s_cta,
      input$s_bad
    )

    input_weights <- list(
      "dis_w" = (input$s_dis / total),
      "old_w" = (input$s_old / total),
      "kid_w" = (input$s_kid / total),
      "den_w" = (input$s_den / total),
      "zca_w" = (input$s_zca / total),
      "cta_w" = (input$s_cta / total),
      "bad_w" = (input$s_bad / total)
    )

    weights(input_weights)
  })

  # change weights for scrolling ----
  observeEvent(input$scr, ignoreNULL = T, ignoreInit = T, {
    if (input$scr == "equal") {
      weights(first_weights)
    }

    if (input$scr == "disabilities") {
      new_weights <- list(
        "dis_w" = 0.4,
        "old_w" = 0.4,
        "kid_w" = 0,
        "den_w" = 0.1,
        "zca_w" = 0,
        "cta_w" = 0,
        "bad_w" = 0.1
      )

      weights(new_weights)
    }

    if (input$scr == "transit") {
      new_weights <- list(
        "dis_w" = 0,
        "old_w" = 0,
        "kid_w" = 0.25,
        "den_w" = 0.15,
        "zca_w" = 0.25,
        "cta_w" = 0.25,
        "bad_w" = 0.15
      )

      weights(new_weights)
    }
  })

  # update tract scores -----
  scores <- reactiveVal()

  observe({
    updated_scores <-
      master %>%
      mutate(across(
        c(matches(
          "pct_pop|pct_hh"
        )),
        # get a scaled value for each variable
        ~ scale(
          .,
          center = min(.), scale = diff(range(.))
        )[, 1],
        .names = "{sub('pct_pop|pct_hh', 'scale', col)}"
      )) %>%
      # scale variables with non-standard names:
      mutate(
        den_scale =
          scale(den, center = min(den), scale = diff(range(den)))[, 1],
        bad_scale = scale(
          n_bad_permi2,
          center = min(n_bad_permi2),
          scale = diff(range(n_bad_permi2))
        )[, 1],
        cta_scale = scale(
          cta_permi2,
          center = min(cta_permi2),
          scale = diff(range(cta_permi2))
        )[, 1]
      ) %>%
      select(GEOID, contains("scale")) %>%
      # calculate a weighted score
      mutate(
        score =
        # Demographics
          (amb_scale * weights()$dis_w * 0.5) +
            (vis_scale * weights()$dis_w * 0.5) +
            (old_scale * weights()$old_w) +
            (kid_scale * weights()$kid_w) +
            (zca_scale * weights()$zca_w) +
            # Land use and transportation
            (den_scale * weights()$den_w) +
            (cta_scale * weights()$cta_w) +
            (bad_scale * weights()$bad_w)
      ) %>%
      mutate(score_pctile = ntile(desc(score), 100))

    # Feed reactive value
    scores(updated_scores)
  })

  # base map -----
  output$mapBuild <- renderLeaflet({
    leaflet(options = leafletOptions(
      minZoom = 10, maxZoom = 10,
      zoomControl = F,
      attributionControl = FALSE
    )) %>%
      addProviderTiles("CartoDB.Positron") %>%
      fitBounds(
        lat1 = chi_bbox[["ymin"]],
        lat2 = chi_bbox[["ymax"]],
        lng1 = chi_bbox[["xmin"]],
        lng2 = chi_bbox[["xmax"]]
      ) %>%
      setView(
        lat =
          41.840675,
        lng =
          -87.679365,
        zoom = 10
      )
  })


  # update map with new scores -----
  observe({
    map_data <- scores() %>%
      mutate(helptext = ifelse(
        score_pctile > 50,
        paste0(
          "bottom ",
          100 - round(score_pctile)
        ),
        paste0(
          "top ",
          round(score_pctile)
        )
      ))

    color_data <- map_data$score_pctile
    my_title <- "Rank"
    my_pal <-
      colorBin("plasma",
        color_data,
        10,
        pretty = T,
        reverse = T
      )


    tooltips <- sprintf(
      "<p style='font-family: Poppins, sans-serif;
      font-size:1rem;
      color: #270075'>
      This tract ranks in the
      <br>
      <strong><span style='font-size:1.5rem'>
      %s%% of tracts</strong>
      <br>
      </span>,
      for the priorities you selected.",
      map_data$helptext
    ) %>%
      lapply(htmltools::HTML)

    leafletProxy("mapBuild", data = map_data) %>%
      clearShapes() %>%
      addPolygons(
        data = map_data,
        layerId = ~GEOID,
        label = ~tooltips,
        stroke = FALSE,
        fillOpacity = 0.4,
        fillColor = my_pal(color_data)
      )
  })


  # map for drawing --------------
  output$mapDraw <- renderLeaflet({
    leaflet(options = leafletOptions(
      minZoom = 10, maxZoom = 10,
      zoomControl = F,
      attributionControl = FALSE
    )) %>%
      addProviderTiles("CartoDB.Positron") %>%
      fitBounds(
        lat1 = chi_bbox[["ymin"]],
        lat2 = chi_bbox[["ymax"]],
        lng1 = chi_bbox[["xmin"]],
        lng2 = chi_bbox[["xmax"]]
      ) %>%
      setView(
        lat =
          41.840675,
        lng =
          -87.679365,
        zoom = 10
      ) %>%
      # draw rectangle tool ----
      leaflet.extras::addDrawToolbar(
        position = "topright",
        polylineOptions = FALSE,
        circleOptions = FALSE,
        # polygonOptions = FALSE,
        rectangleOptions = FALSE,
        markerOptions = FALSE,
        circleMarkerOptions = FALSE,
        singleFeature = TRUE
      )
  })

  # react to polygon draw button -------
  observeEvent(input$polygon_button, {
    js$polygon_click()
  })

  # summarize drawn pilot zone ----
  observeEvent(input$mapDraw_draw_new_feature, {
    # convert drawn rectangle to sf object
    user_rect <-
      # get feature:
      input$mapDraw_draw_new_feature %>%
      # translate to JSON:
      jsonify::to_json(., unbox = T) %>%
      # translate to SF:
      geojsonsf::geojson_sf()

    user_area <- st_area(user_rect) %>%
      set_units("miles^2") %>%
      as.numeric()

    # Is user_rect between 2 and 3 square miles?
    print(user_area)


    # intersect, calculate area stats
    intersection <-
      st_intersection(user_rect, master)

    output$scorecard <-
      render_gt(create_scorecard(intersection))
  })
}
