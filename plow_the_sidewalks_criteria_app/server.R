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
  
  # second set of weights for drawing map ------
  weights2 <- reactiveVal(first_weights)
  
  observe({
    total <- sum(
      input$s_dis2,
      input$s_old2,
      input$s_kid2,
      input$s_den2,
      input$s_zca2,
      input$s_cta2,
      input$s_bad2
    )
    
    input_weights2 <- list(
      "dis_w2" = (input$s_dis2 / total),
      "old_w2" = (input$s_old2 / total),
      "kid_w2" = (input$s_kid2 / total),
      "den_w2" = (input$s_den2 / total),
      "zca_w2" = (input$s_zca2 / total),
      "cta_w2" = (input$s_cta2 / total),
      "bad_w2" = (input$s_bad2 / total)
    )
    
    weights2(input_weights2)
  })

  # update weights on scroll ----
  observeEvent(input$scr, 
               ignoreNULL = T, 
               ignoreInit = T, {
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
    updated_scores <- update_scores(weights = weights())
    # Feed reactive value
    scores(updated_scores)
  })
  
  # second set of scores ----------
  scores2 <- reactiveVal()
  observe({
    updated_scores <- update_scores(weights = weights2())
    # Feed reactive value
    scores2(updated_scores)
  })

  # base map -----
  output$mapBuild <- renderLeaflet({
    leaflet(options = leafletOptions(
      minZoom = 10, maxZoom = 10,
      zoomControl = F,
      attributionControl = FALSE
    )) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(
        lat =
          41.840675,
        lng =
          -87.679365,
        zoom = 10
      ) %>%
      setMaxBounds(
        lat1 = chi_bbox[["ymin"]],
        lat2 = chi_bbox[["ymax"]],
        lng1 = chi_bbox[["xmin"]],
        lng2 = chi_bbox[["xmax"]]
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


  # base map for drawing --------------
  output$mapDraw <- renderLeaflet({
    leaflet(options = leafletOptions(
      minZoom = 10, maxZoom = 13,
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
      setMaxBounds(
        lat1 = chi_bbox[["ymin"]],
        lat2 = chi_bbox[["ymax"]],
        lng1 = chi_bbox[["xmin"]],
        lng2 = chi_bbox[["xmax"]]
      )%>%
      # draw rectangle tool ----
      leaflet.extras::addDrawToolbar(
        position = "topright",
        polylineOptions = FALSE,
        circleOptions = FALSE,
        # polygonOptions = FALSE,
        rectangleOptions = FALSE,
        markerOptions = FALSE,
        circleMarkerOptions = FALSE,
        singleFeature = TRUE,
        
        
        editOptions = editToolbarOptions(
          edit = TRUE, 
          remove = FALSE, 
          selectedPathOptions = NULL,
          allowIntersection = TRUE
        )
      )
  })
  
  # update draw map with new scores ----
  observe({
    map_data <- scores2() %>%
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
    
    leafletProxy("mapDraw", data = map_data) %>%
      clearGroup("score_tiles") %>%
      addPolygons(
        data = map_data,
        layerId = ~GEOID,
        label = ~tooltips,
        stroke = FALSE,
        fillOpacity = 0.4,
        fillColor = my_pal(color_data),
        group = "score_tiles"
      )
  })
  
  # react to polygon draw button -------
  observeEvent(input$polygon_button, {
    js$polygon_click()
  })
  
  # react to edit button -------
  observeEvent(input$edit_button, {
    js$edit_click()
  })
  
  user_zone <- reactiveVal()
  
  # summarize drawn pilot zone ----
  observeEvent(input$mapDraw_draw_all_features, {
    # convert drawn rectangle to sf object
    user_sf <-
      # get feature:
      input$mapDraw_draw_all_features %>%
      # translate to JSON:
      jsonify::to_json(., unbox = T) %>%
      # translate to SF:
      geojsonsf::geojson_sf() %>%
      sf::st_transform(crs = 4326)
    
    user_zone(user_sf)
  })
  
  user_area <- reactiveVal()
  
  # print area -----
  observeEvent(user_zone(), ignoreNULL = T, {
    user_area_new <- st_area(user_zone()) %>%
      set_units("miles^2") %>%
      as.numeric()
    
    user_area(user_area_new)
    
    text <- case_when(user_area_new > 3.1 ~
                     glue::glue(
                     "<span style = 'font-size: 1.2rem; 
                     color: #270075;
                     font-family: Poppins, sans-serif;
                     font-weight: bold'> 
                     Zone area: {round(user_area_new, 1)}
                     square miles<br>
                     
                     {fontawesome::fa('exclamation-triangle', 
                     fill = '#ff6900',
                     height = '1.2rem')}
                     Area is too large</span>"),
                   
                     user_area_new < 1.9 ~
                          glue::glue(
                            "<span style = 'font-size: 1.2rem; 
                            color: #270075;
                     font-family: Poppins, sans-serif;
                     font-weight: bold'> 
                     Zone area: {round(user_area_new, 1)}
                     square miles<br>
                     
                     {fontawesome::fa('exclamation-triangle', 
                     fill = '#ff6900',
                     height = '1.2rem')}
                     Area is too small</span>"),
                     
                     TRUE ~ 
                       glue::glue(
                         "<span style = 'font-size: 1.2rem;
                         color: #270075;
                     font-family: Poppins, sans-serif;
                     font-weight: bold'> 
                     Zone area: {round(user_area_new, 1)}
                     square miles</span>")
                     )
                   
    area_text <- tags$div(
      tag.zone.area, HTML(text)
    )  
    
    leafletProxy("mapDraw")  %>%
      clearControls() %>%
      addControl(area_text, position = "topleft", className="map-title")
    
  })
  
  # scorecard -----
  observeEvent(user_area(), ignoreNULL = T, {
 
    if(user_area() < 3.1 &
       user_area() > 1.9)
    {
      # intersect, calculate area stats
      intersection <-
        st_intersection(user_zone(), master)
      
      output$scorecard <-
        render_gt(create_scorecard(intersection))
    }
   
  })
  
}
  

  
  
  