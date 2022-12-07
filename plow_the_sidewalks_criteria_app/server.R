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
  
  
  ##  % one car hhs ----
  observeEvent(input$s_oca, {
    slider_i <- "s_oca"
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
  
  ## % low-income hhs -----
  observeEvent(input$s_inc, {
    slider_i <- "s_inc"
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
      "den_w" = input$s_den,
      "old_w" = input$s_old,
      "kid_w" = input$s_kid,
      "zca_w" = input$s_zca,
      "oca_w" = input$s_oca,
      "inc_w" = input$s_inc
    )
    
    weights(input_weights)
  })
  
  
  
  # Generate Scores -----
  scores <- reactiveVal()
  
  observe({
    
    # Filter by density/disability ----
    # if(input$filter1 == "Density"){
    #   selected_tracts <- master %>%
    #     filter(den_pctile <= 25)
    # } else if (input$filter1 == "Disability"){
    #   selected_tracts <- master %>%
    #     filter(amb_pctile <= 25 | vis_pctile <= 25)
    # }
    
    updated_scores <-
      master %>%
      mutate(across(c(contains("pctpop"), contains("pcthhs")),
                    ## get a scaled value for each variable ----
                    ~scale(., center = min(.), scale = diff(range(.)))[,1],
                    .names = "{sub('pctpop|pcthhs', 'scale', col)}")) %>%
      mutate(den_scale = scale(den, center = min(den), scale = diff(range(den)))[,1]) %>%
      ## calculate a weighted score -----
      mutate(score =
               (amb_scale * weights()$amb_w) +
               (vis_scale * weights()$vis_w) +
               (den_scale * weights()$den_w) +
               (old_scale * weights()$old_w) +
               (kid_scale * weights()$kid_w) +
               (zca_scale * weights()$zca_w) +
               (oca_scale * weights()$oca_w) +
               (inc_scale * weights()$inc_w)) %>%
      mutate(score_pctile = ntile(desc(score), 100))

    
    # Feed reactive value
    scores(updated_scores)
  })
  

  
  # Base map -----
  output$mapBuild <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      fitBounds(lat1 = chi_bbox[["ymin"]], lat2 = chi_bbox[["ymax"]], 
                lng1 = chi_bbox[["xmin"]]+0.15, lng2 = chi_bbox[["xmax"]]+0.15)
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
      "This tract ranks in the <strong>%s%%</strong><br/>of tracts based on the priorities you selected. Click to see more.",
      map_data$helptext
    ) %>% lapply(htmltools::HTML)
    
   leafletProxy("mapBuild", data = map_data) %>%
      clearShapes() %>%
      addPolygons(data = map_data, 
                  layerId=~GEOID,
                  label = ~tooltips,
                 stroke=FALSE, fillOpacity=0.4, fillColor=my_pal(color_data)) %>%
      addLegend("bottomright", pal=my_pal, values=color_data, title= my_title,
                layerId="colorLegend")
  })
  
  # # Show a popup at the given location
  # showZipcodePopup <- function(GEOID, lat, lng) {
  #   selectedZip <- allzips[allzips$GEOID == GEOID,]
  #   content <- as.character(tagList(
  #     tags$h4("Score:", as.integer(selectedZip$centile)),
  #     tags$strong(HTML(sprintf("%s, %s %s",
  #                              selectedZip$city.x, selectedZip$state.x, selectedZip$GEOID
  #     ))), tags$br(),
  #     sprintf("Median household income: %s", dollar(selectedZip$income * 1000)), tags$br(),
  #     sprintf("Percent of adults with BA: %s%%", as.integer(selectedZip$college)), tags$br(),
  #     sprintf("Adult population: %s", selectedZip$adultpop)
  #   ))
  #   leafletProxy("map") %>% addPopups(lng, lat, content, layerId = GEOID)
  # }
  # 
  # When map is clicked, show a popup with city info
  # observe({
  #   leafletProxy("map") %>% clearPopups()
  #   event <- input$map_shape_click
  #   if (is.null(event))
  #     return()
  #   
  #   isolate({
  #     showZipcodePopup(event$id, event$lat, event$lng)
  #   })
  # })
  # 
  
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
  #     showZipcodePopup(zip, lat, lng)
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
