server <- function(input, output, session) {
  # Add waypoints -----
  w0 <- Waypoint$new("m0",
                     offset = my_offset,
                     animate = TRUE,
                     animation = my_animation)$start()
  w1 <- Waypoint$new("m1",
                     offset = my_offset,
                     animate = TRUE,
                     animation = my_animation)$start()
  w2 <- Waypoint$new("m2",
                     offset = my_offset,
                     animate = TRUE,
                     animation = my_animation)$start()
  w3 <- Waypoint$new("m3",
                     offset = my_offset,
                     animate = TRUE,
                     animation = my_animation)$start()
  w4 <- Waypoint$new("m4",
                     offset = my_offset,
                     animate = TRUE,
                     animation = my_animation)$start()
  w5 <- Waypoint$new("m5",
                     offset = my_offset,
                     animate = TRUE,
                     animation = my_animation)$start()
  w6 <- Waypoint$new("m6",
                     offset = my_offset,
                     animate = TRUE,
                     animation = my_animation)$start()
  
  # Render UIs ------
  ## 0 -----
  output$ui0 <- renderUI({
    div(
      h1("Let's #PlowTheSidewalks"),
      p(
        "Let’s make sidewalk snow and ice removal a city-wide and city-run service."
      ),
      p("An initiative of Better Streets Chicago and Access Living"),
      br(),
      
      h2("Where should Chicago try municipal sidewalk plowing first?"),
      p(style = "text-align:center;",
        tags$i(class = "fas fa-chevron-down fa-3x")),
      br()
    )
  })
  
  ## 1 -----
  output$ui1 <- renderUI({
    req(w1$get_triggered())
    if (w1$get_triggered() == TRUE)
      tagList(
        p("Some text"),
        p(
          "Scroll on the left side to continue reading.
          Scroll on the right side to view the map more closely."
        )
      )
  })
  
  ## 2 ---------
  output$ui2 <- renderUI({
    req(w2$get_triggered())
    if (w2$get_triggered() == TRUE)
      tagList(p("Some text"))
  })
  
  ## 3 -----------
  output$ui3 <- renderUI({
    req(w3$get_triggered())
    if (w3$get_triggered() == TRUE)
      tagList(p("Some text"))
  })
  
  ## 4 -------
  output$ui4 <- renderUI({
    req(w4$get_triggered())
    if (w4$get_triggered() == TRUE)
      tagList(p("Some text"))
  })
  
  ## 5 ----------
  output$ui5 <- renderUI({
    req(w5$get_triggered())
    if (w5$get_triggered() == TRUE)
      tagList(p("Some text"))
  })
  
  ## 6 ----------
  output$ui6 <- renderUI({
    req(w6$get_triggered())
    if (w6$get_triggered() == TRUE)
      tagList(p("Some text"))
  })
  
  # React to waypoints -----
  ## 1 down  --------
  observeEvent(w1$get_direction(), {
    if (w1$get_direction() == "down")
      # update map
      leafletProxy("mapBuild")
  })
  
  ## 2 up --------
  # observeEvent(w2$get_direction(), {
  #   if (w2$get_direction() == "up")
  #     # do this
  # })
  
  ## 2 down -----
  # observeEvent(w2$get_direction(), {
  #   if (w2$get_direction() == "down")
  #     # do this
  # })
  
  ## 3 up ------
  # observeEvent(w3$get_direction(), {
  #   if (w3$get_direction() == "up")
  #   # do this
  # })
  
  ## 3 down ---------
  # observeEvent(w3$get_direction(), {
  #   if (w3$get_direction() == "down")
  # })
  
  ## 4 up -----
  # observeEvent(w4$get_direction(), {
  #   if (w4$get_direction() == "up")
  # })
  
  ## 4 down -------
  # observeEvent(w4$get_direction(), {
  #   if (w4$get_direction() == "down")
  # })
  
  ## 5 up -----
  # observeEvent(w5$get_direction(), {
  #   if (w5$get_direction() == "up")
  # })
  
  ## 5 down --------
  # observeEvent(w5$get_direction(), {
  # })
  
  # sticky plot ---------
  shtick <- Shtick$new("#stick")$shtick()
  
  
  # update sliders -----
  # this code forces all sliders to add to 100.
  observeEvent(input$s_amb, {
    update_slider_weights("s_amb")
  })
  
  observeEvent(input$s_vis, {
    update_slider_weights("s_vis")
  })
  
  observeEvent(input$s_old, {
    update_slider_weights("s_old")
  })
  
  observeEvent(input$s_kid, {
    update_slider_weights("s_kid")
  })
  
  observeEvent(input$s_den, {
    update_slider_weights("s_den")
  })
  
  observeEvent(input$s_zca, {
    update_slider_weights("s_zca")
  })
  
  observeEvent(input$s_cta, {
    update_slider_weights("s_cta")
  })
  
  observeEvent(input$s_bad, {
    update_slider_weights("s_bad")
  })
  
  
  
  # update weights ------
  weights <- reactiveVal(first_weights)
  
  observeEvent(input$go_score, {
    input_weights <- list(
      "amb_w" = input$s_amb,
      "vis_w" = input$s_vis,
      "old_w" = input$s_old,
      "kid_w" = input$s_kid,
      "den_w" = input$s_den,
      "zca_w" = input$s_zca,
      "cta_w" = input$s_cta,
      "bad_w" = input$s_bad
    )
    
    weights(input_weights)
  })
  
  
  
  # update tract scores -----
  scores <- reactiveVal()
  
  observe({
    updated_scores <-
      master %>%
      mutate(across(c(matches(
        "pct_pop|pct_hh"
      )),
      # get a scaled value for each variable
      ~ scale(
        ., center = min(.), scale = diff(range(.))
      )[, 1],
      .names = "{sub('pct_pop|pct_hh', 'scale', col)}")) %>%
      # scale variables with non-standard names:
      mutate(
        den_scale = scale(den, center = min(den), scale = diff(range(den)))[, 1],
        bad_scale = scale(
          n_bad_permi2,
          center = min(n_bad_permi2),
          scale = diff(range(n_bad_permi2))
        )[, 1],
        cta_scale = scale(
          cta_activity,
          center = min(cta_activity),
          scale = diff(range(cta_activity))
        )[, 1]
      ) %>%
      select(GEOID, contains("scale")) %>%
      # calculate a weighted score
      mutate(
        score =
          # Demographics
          (amb_scale * weights()$amb_w) +
          (vis_scale * weights()$vis_w) +
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
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      fitBounds(
        lat1 = chi_bbox[["ymin"]],
        lat2 = chi_bbox[["ymax"]],
        lng1 = chi_bbox[["xmin"]] + 0.17,
        lng2 = chi_bbox[["xmax"]] + 0.17
      ) %>%
      leaflet.extras::addDrawToolbar(
        position = "topright",
        polylineOptions = FALSE,
        circleOptions = FALSE,
        polygonOptions = FALSE,
        # rectangleOptions = FALSE,
        markerOptions = FALSE,
        circleMarkerOptions =  FALSE,
        singleFeature = TRUE
      )
  })
  
  # update map with new scores -----
  observe({
    map_data <- scores() %>%
      mutate(helptext = ifelse(
        score_pctile > 50,
        paste0("bottom ",
               100 - round(score_pctile)),
        paste0("top ",
               round(score_pctile))
      ))
    
    color_data <- map_data$score_pctile
    my_title <- "Rank"
    my_pal <-
      colorBin("plasma",
               color_data,
               10,
               pretty = T,
               reverse = T)
    
    
    tooltips <- sprintf(
      "<h6><section style='font-size:14pt'>
      This tract ranks in the
      <br>
      <strong><section style='font-size:18pt'>
      %s%% of tracts</strong>
      <br>
      <section style='font-size:14pt'>
      for the priorities you selected.",
      map_data$helptext
    ) %>%
      lapply(htmltools::HTML)
    
    leafletProxy("mapBuild", data = map_data) %>%
      clearShapes() %>%
      addPolygons(
        data = map_data,
        layerId =  ~ GEOID,
        label = ~ tooltips,
        stroke = FALSE,
        fillOpacity = 0.4,
        fillColor = my_pal(color_data)
      ) %>%
      addLegend(
        "bottomright",
        pal = my_pal,
        values = color_data,
        title = my_title,
        layerId = "colorLegend"
      )
  })
  
  # summarize drawn pilot zone ----
  observeEvent(input$mapBuild_draw_new_feature, {
    # convert drawn rectangle to sf object
    user_rect <-
      # get feature:
      input$mapBuild_draw_new_feature %>%
      # translate to JSON:
      jsonify::to_json(., unbox = T) %>%
      # translate to SF:
      geojsonsf::geojson_sf()
    
    # intersect, calculate area stats
    area_summary <-
      st_intersection(user_rect, master) %>%
      mutate(intersect_area = st_area(geometry)) %>%
      mutate(intersect_area_mi2 = units::set_units(intersect_area, "mi^2")) %>%
      mutate(prop_area = as.numeric(intersect_area_mi2) / area_mi2) %>%
      # Adjust all population/household counts:
      mutate(across(
        c(matches("n_pop|n_hh"),
          "total_population",
          "num_hh"),
        ~ round(. * prop_area)
      )) %>%
      # Total for this rectangle:
      group_by(X_leaflet_id) %>%
      summarize(across(c(
        matches("n_pop|n_hh"),
        "total_population",
        "num_hh"
      ),
      ~ sum(.)),
      geometry = st_union(geometry)) %>%
      mutate(area = st_area(geometry)) %>%
      mutate(area_mi2 = units::set_units(area, "mi^2")) %>%
      mutate(density = total_population / area_mi2) %>%
      # Refresh proportional data:
      # ... population variables:
      mutate(
        across(contains("n_pop"),
               ~ . / total_population,
               .names = "{sub('n_pop', 'pct_pop', col)}")
      ) %>%
      # ... household-based variables:
      mutate(across(contains("n_hh"),
                    ~ . / num_hh,
                    .names = "{sub('n_hh', 'pct_hh', col)}"))
  })
}