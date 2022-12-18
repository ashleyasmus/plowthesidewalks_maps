library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

function(input, output, session) {
  
  
   
  # Update sliders -----
  # this code forces all sliders to add to 100.
  ## amb ----
  observeEvent(input$s_amb, {
    slider_i <- "s_amb"
    remaining <- 100 - input[[slider_i]]
    slider_o <- sliders[!sliders %in% slider_i]
    total <- sum(input[[slider_o[1]]],
                 input[[slider_o[2]]],
                 input[[slider_o[3]]],
                 input[[slider_o[4]]],
                 input[[slider_o[5]]],
                 input[[slider_o[6]]],
                 input[[slider_o[7]]])
    purrr:::map(.x = slider_o,
                .f = function(sliderid){
                  updateSliderInput(inputId = sliderid, 
                                    value = remaining * input[[sliderid]]/total)
                })
    
  })
  
  ## vis ----
  observeEvent(input$s_vis, {
    slider_i <- "s_vis"
    remaining <- 100 - input[[slider_i]]
    slider_o <- sliders[!sliders %in% slider_i]
    total <- sum(input[[slider_o[1]]],
                 input[[slider_o[2]]],
                 input[[slider_o[3]]],
                 input[[slider_o[4]]],
                 input[[slider_o[5]]],
                 input[[slider_o[6]]],
                 input[[slider_o[7]]])
    purrr:::map(.x = slider_o,
                .f = function(sliderid){
                  updateSliderInput(inputId = sliderid, 
                                    value = remaining * input[[sliderid]]/total)
                })
    
  })
  
    
  ## % old ----
  observeEvent(input$s_old, {
    slider_i <- "s_old"
    remaining <- 100 - input[[slider_i]]
    slider_o <- sliders[!sliders %in% slider_i]
    total <- sum(input[[slider_o[1]]],
                 input[[slider_o[2]]],
                 input[[slider_o[3]]],
                 input[[slider_o[4]]],
                 input[[slider_o[5]]],
                 input[[slider_o[6]]],
                 input[[slider_o[7]]])
    purrr:::map(.x = slider_o,
                .f = function(sliderid){
                  updateSliderInput(inputId = sliderid, 
                                    value = remaining * input[[sliderid]]/total)
                })
    
  })
  
  ## % kids ----
  observeEvent(input$s_kid, {
    slider_i <- "s_kid"
    remaining <- 100 - input[[slider_i]]
    slider_o <- sliders[!sliders %in% slider_i]
    total <- sum(input[[slider_o[1]]],
                 input[[slider_o[2]]],
                 input[[slider_o[3]]],
                 input[[slider_o[4]]],
                 input[[slider_o[5]]],
                 input[[slider_o[6]]],
                 input[[slider_o[7]]])
    purrr:::map(.x = slider_o,
                .f = function(sliderid){
                  updateSliderInput(inputId = sliderid, 
                                    value = remaining * input[[sliderid]]/total)
                })
    
  })
  
  ## den ----
  observeEvent(input$s_den, {
    slider_i <- "s_den"
    remaining <- 100 - input[[slider_i]]
    slider_o <- sliders[!sliders %in% slider_i]
    total <- sum(input[[slider_o[1]]],
                 input[[slider_o[2]]],
                 input[[slider_o[3]]],
                 input[[slider_o[4]]],
                 input[[slider_o[5]]],
                 input[[slider_o[6]]],
                 input[[slider_o[7]]])
    purrr:::map(.x = slider_o,
                .f = function(sliderid){
                  updateSliderInput(inputId = sliderid, 
                                    value = remaining * input[[sliderid]]/total)
                })
    
  })
  
  
  ## % zero car hhs ----
  observeEvent(input$s_zca, {
    slider_i <- "s_zca"
    remaining <- 100 - input[[slider_i]]
    slider_o <- sliders[!sliders %in% slider_i]
    total <- sum(input[[slider_o[1]]],
                 input[[slider_o[2]]],
                 input[[slider_o[3]]],
                 input[[slider_o[4]]],
                 input[[slider_o[5]]],
                 input[[slider_o[6]]],
                 input[[slider_o[7]]])
    purrr:::map(.x = slider_o,
                .f = function(sliderid){
                  updateSliderInput(inputId = sliderid, 
                                    value = remaining * input[[sliderid]]/total)
                })
    
  })
  
  
  ## transit activity ----
  observeEvent(input$s_cta, {
    slider_i <- "s_cta"
    remaining <- 100 - input[[slider_i]]
    slider_o <- sliders[!sliders %in% slider_i]
    total <- sum(input[[slider_o[1]]],
                 input[[slider_o[2]]],
                 input[[slider_o[3]]],
                 input[[slider_o[4]]],
                 input[[slider_o[5]]],
                 input[[slider_o[6]]],
                 input[[slider_o[7]]])
    purrr:::map(.x = slider_o,
                .f = function(sliderid){
                  updateSliderInput(inputId = sliderid, 
                                    value = remaining * input[[sliderid]]/total)
                })
    
  })
  
  ## problems: snow removal requests, vacant buildings -----
  observeEvent(input$s_bad, {
    slider_i <- "s_bad"
    remaining <- 100 - input[[slider_i]]
    slider_o <- sliders[!sliders %in% slider_i]
    total <- sum(input[[slider_o[1]]],
                 input[[slider_o[2]]],
                 input[[slider_o[3]]],
                 input[[slider_o[4]]],
                 input[[slider_o[5]]],
                 input[[slider_o[6]]],
                 input[[slider_o[7]]])
    purrr:::map(.x = slider_o,
                .f = function(sliderid){
                  updateSliderInput(inputId = sliderid, 
                                    value = remaining * input[[sliderid]]/total)
                })
    
  })
  

  
  # Update Weights ------
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
  
  
  
  # Generate Scores -----
  scores <- reactiveVal()
  
  observe({
    
    # OFF - Filter by density/disability ----
    # if(input$filter1 == "Density"){
    #   selected_tracts <- master %>%
    #     filter(den_pctile <= 25)
    # } else if (input$filter1 == "Disability"){
    #   selected_tracts <- master %>%
    #     filter(amb_pctile <= 25 | vis_pctile <= 25)
    # }
    
    updated_scores <-
      master %>%
      mutate(across(c(matches("pct_pop|pct_hh")),
                    ## get a scaled value for each variable ----
                    ~scale(., center = min(.), scale = diff(range(.)))[,1],
                    .names = "{sub('pct_pop|pct_hh', 'scale', col)}")) %>%
      # scale non-demographic variables: 
      mutate(den_scale = scale(den, center = min(den), scale = diff(range(den)))[,1],
             bad_scale = scale(n_bad_permi2, center = min(n_bad_permi2), scale = diff(range(n_bad_permi2)))[,1],
             cta_scale = scale(cta_activity, center = min(cta_activity), scale = diff(range(cta_activity)))[,1]) %>%
      select(GEOID, contains("scale")) %>%
      ## calculate a weighted score -----
      mutate(score =
               # Demographics
               (amb_scale * weights()$amb_w) +
               (vis_scale * weights()$vis_w) +
               (old_scale * weights()$old_w) +
               (kid_scale * weights()$kid_w) +
               (zca_scale * weights()$zca_w) +
               # Land use and transportation 
               (den_scale * weights()$den_w) +
               (cta_scale * weights()$cta_w) +
               (bad_scale * weights()$bad_w)) %>%
      mutate(score_pctile = ntile(desc(score), 100))

    
    # Feed reactive value
    scores(updated_scores)
  })
  

  
  # Base map -----
  output$mapBuild <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      fitBounds(lat1 = chi_bbox[["ymin"]], lat2 = chi_bbox[["ymax"]], 
                lng1 = chi_bbox[["xmin"]]+0.17, lng2 = chi_bbox[["xmax"]]+0.17) %>%
      leaflet.extras::addDrawToolbar(position = "topright", 
                                     polylineOptions = FALSE,
                                     circleOptions = FALSE,
                                     polygonOptions = FALSE,
                                     # rectangleOptions = FALSE, 
                                     markerOptions = FALSE,
                                     circleMarkerOptions =  FALSE,
                                     singleFeature = TRUE)
  })
  
  # Update map --------
  observe({
    map_data <- scores() %>%
      mutate(helptext = ifelse(score_pctile >50, 
                               paste0("bottom ",
                                      100-round(score_pctile)),
                               paste0("top ",
                                      round(score_pctile))))
  
    color_data <- map_data$score_pctile
    my_title <- "Rank"
    my_pal <- colorBin("plasma", color_data, 10, pretty = T, reverse = T)
    
    
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
      addPolygons(data = map_data, 
                  layerId=~GEOID,
                  label = ~tooltips,
                 stroke=FALSE, fillOpacity=0.4, fillColor=my_pal(color_data)) %>%
      addLegend("bottomright", pal=my_pal, values=color_data, title= my_title,
                layerId="colorLegend")
  })
  
  # Drawn Pilot Zone ------
  observeEvent(input$mapBuild_draw_new_feature,{
    
    user_rect <- 
      # get feature: 
      input$mapBuild_draw_new_feature %>%
      # translate to JSON: 
      jsonify::to_json(., unbox = T) %>%
      # translate to SF: 
      geojsonsf::geojson_sf()
    
    ## Intersect, calculate area stats -----
    area_summary <-
      st_intersection(user_rect, master) %>%
      mutate(intersect_area = st_area(geometry)) %>%
      mutate(intersect_area_mi2 = units::set_units(intersect_area, "mi^2")) %>%
      mutate(prop_area = as.numeric(intersect_area_mi2) / area_mi2) %>%
      # Adjust all population/household counts: 
      mutate(across(c(matches("n_pop|n_hh"),
                      "total_population",
                      "num_hh"),
                    ~ round(. * prop_area))) %>%
      # Total for this rectangle: 
      group_by(X_leaflet_id) %>%
      summarize(across(c(matches("n_pop|n_hh"),
                         "total_population",
                         "num_hh"),
                       ~sum(.)),
                geometry = st_union(geometry)) %>%
      mutate(area = st_area(geometry)) %>%
      mutate(area_mi2 = units::set_units(area, "mi^2")) %>%
      mutate(density = total_population/area_mi2) %>%
      # Refresh proportional data: 
      # ... population variables: 
      mutate(across(contains("n_pop"), 
                      ~./total_population,
                      .names = "{sub('n_pop', 'pct_pop', col)}")) %>%
      # ... household-based variables: 
      mutate(across(contains("n_hh"), 
                    ~./num_hh,
                    .names = "{sub('n_hh', 'pct_hh', col)}"))
  })
  
  # Tract popup ------
  show_tract_info <- function(GEOID, lat, lng) {
    selected_tract <- master %>%
      filter(GEOID == GEOID)
      # left_join(scores())
    
    content <- as.character(tagList(
      # tags$h4("Score:", as.integer(selected_tract$score_pctile)),
      tags$strong(HTML(sprintf("%s",
                               selected_tract$GEOID
      ))), tags$br(),
      sprintf("Population with an ambulatory diability: %s%%", selected_tract$amb_pct_pop), tags$br(),
      sprintf("Population with a vision disability: %s%%", as.integer(selected_tract$vis_pct_pop)), tags$br(),
      sprintf("Population density: %s people per square mile", selected_tract$den)
    ))
    leafletProxy("mapBuild") %>% addPopups(lng, lat, content, layerId = GEOID)
  }

  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("mapBuild") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()

    isolate({
      show_tract_info(event$id, event$lat, event$lng)
    })
  })

  
  ## Data Explorer ###########################################
  
  # observe({
  #   cities <- if (is.null(input$states)) character(0) else {
  #     filter(acs_summary, State %in% input$states) %>%
  #       `$`('City') %>%
  #       unique() %>%
  #       sort()
  #   }
  #   stillSelected <- isolate(input$cities[input$cities %in% cities])
  #   updateSelectizeInput(session, "cities", choices = cities,
  #                        selected = stillSelected, server = TRUE)
  # })
  # 
  # observe({
  #   zipcodes <- if (is.null(input$states)) character(0) else {
  #     acs_summary %>%
  #       filter(State %in% input$states,
  #              is.null(input$cities) | City %in% input$cities) %>%
  #       `$`('Zipcode') %>%
  #       unique() %>%
  #       sort()
  #   }
  #   stillSelected <- isolate(input$zipcodes[input$zipcodes %in% zipcodes])
  #   updateSelectizeInput(session, "zipcodes", choices = zipcodes,
  #                        selected = stillSelected, server = TRUE)
  # })
  # 
  # observe({
  #   if (is.null(input$goto))
  #     return()
  #   isolate({
  #     map <- leafletProxy("map")
  #     map %>% clearPopups()
  #     dist <- 0.5
  #     zip <- input$goto$zip
  #     lat <- input$goto$lat
  #     lng <- input$goto$lng
  #     show_tract_info(zip, lat, lng)
  #     map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
  #   })
  # })
  # 
  # output$ziptable <- DT::renderDataTable({
  #   df <- acs_summary %>%
  #     filter(
  #       Score >= input$minScore,
  #       Score <= input$maxScore,
  #       is.null(input$states) | State %in% input$states,
  #       is.null(input$cities) | City %in% input$cities,
  #       is.null(input$zipcodes) | Zipcode %in% input$zipcodes
  #     ) %>%
  #     mutate(Action = paste('<a class="go-map" href="" data-lat="', Lat, '" data-long="', Long, '" data-zip="', Zipcode, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
  #   action <- DT::dataTableAjax(session, df, outputId = "ziptable")
  #   
  #   DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
  # })
}
