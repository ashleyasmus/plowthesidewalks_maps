# Define server logic required to draw a histogram
server <- function(input, output, session) {
  #  render scrollytell --------
  output$scr <- renderScrollytell({
    scrollytell()
  })

  # Individual maps ------
  ## ... captions -----
  output$ambmap_caption <- renderUI({
    
    caption <- "In this map, Chicago is divided into half-square-mile
      hexagons. Each hexagon is colored by its percentile
      ranking, from 0 to 100, for the share of population 
      with an ambulatory disability. Neighborhoods on the South and West Sides rank highest for this measure: the hexagons covering Englewood, 
      for example, rank in the 96th to 99th percentile.
      Most of the central north side ranks below the 10th percentile."
      
    map_width <- session$clientData[["output_ambmap_width"]]
    if (map_width < 300) {
      HTML(
      paste0("<p align = 'right' style = 'font-size:0.8rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>
           Ambulatory disabilities
           <span class = 'visually-hidden'>
           ...",
           caption,
           "</span>
           </p>"))
    } else {
      HTML(
        paste0("<p align = 'center' style = 'font-size:1rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>",
      caption,
      "</p>"))
    }
  })
  
  output$vismap_caption <- renderUI({
    
    caption <- "In this map, Chicago is divided into half-square-mile
      hexagons. Each hexagon is colored by its percentile
      ranking, from 0 to 100, for the share of population with a vision disability.
      The map is similar to that of the one for people with ambulatory
      disabilities, with the inclusion of more of the Austin neighborhood 
      on the west side ranking highly for this measure."
    
    map_width <- session$clientData[["output_vismap_width"]]
    if (map_width < 300) {
      HTML(
        paste0("<p align = 'right' style = 'font-size:0.8rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>
           Vision disabilities
           <span class = 'visually-hidden'>
           ...",
               caption,
               "</span>
           </p>"))
    } else {
      HTML(
        paste0("<p align = 'center' style = 'font-size:1rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>",
               caption,
               "</p>"))
    }
  })
  
  
  output$oldmap_caption <- renderUI({
    
    caption <- "In this map, Chicago is divided into half-square-mile
      hexagons. Each hexagon is colored by its percentile
      ranking, from 0 to 100, for the share of population that is over 65 years old.
      In addition to areas that rank highly for people with disabilities (the south and west sides), 
      disabilities, with the South and West sides both ranking highly. 
      However, there are some notable differences: the northwest side 
      (Norridge, Norwood Park, Dunning) 
      and a handful of areas on the lake shore (Edgewater, Near North, Hyde Park)
      all have relatively older populations."
    
    map_width <- session$clientData[["output_oldmap_width"]]
    if (map_width < 300) {
      HTML(
        paste0("<p align = 'right' style = 'font-size:0.8rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>
           65 and older
           <span class = 'visually-hidden'>
           ...",
               caption,
               "</span>
           </p>"))
    } else {
      HTML(
        paste0("<p align = 'center' style = 'font-size:1rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>",
               caption,
               "</p>"))
    }
  })
  
  output$kidmap_caption <- renderUI({
    
    caption <- "In this map, Chicago is divided into half-square-mile
      hexagons. Each hexagon is colored by its percentile
      ranking, from 0 to 100, for the share of population that is under 5 years old.
      Areas that rank highly for the proportion of the population under 5 are scattered across the city , with
      much less spatial clustering than for our other prioritized demographic groups. 
      The areas that score the lowest are around the Loop and Near North, as well as
      on the south side near Calumet Heights and South Deering."
    
    map_width <- session$clientData[["output_kidmap_width"]]
    if (map_width < 300) {
      HTML(
        paste0("<p align = 'right' style = 'font-size:0.8rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>
           Kids under 5
           <span class = 'visually-hidden'>
           ...",
               caption,
               "</span>
           </p>"))
    } else {
      HTML(
        paste0("<p align = 'center' style = 'font-size:1rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>",
               caption,
               "</p>"))
    }
  })
  
  
  output$denmap_caption <- renderUI({
    
    caption <- "In this map, Chicago is divided into half-square-mile
      hexagons. Each hexagon is colored by its percentile
      ranking, from 0 to 100, for its population density.
      Areas on the north side, from Albany Park east to Edgewater
      and south to the Loop, rank highest for this measure."
    
    map_width <- session$clientData[["output_denmap_width"]]
    if (map_width < 300) {
      HTML(
        paste0("<p align = 'right' style = 'font-size:0.8rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>
           Population density
           <span class = 'visually-hidden'>
           ...",
               caption,
               "</span>
           </p>"))
    } else {
      HTML(
        paste0("<p align = 'center' style = 'font-size:1rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>",
               caption,
               "</p>"))
    }
  })
  
  output$incmap_caption <- renderUI({
    
    caption <- "In this map, Chicago is divided into half-square-mile
      hexagons. Each hexagon is colored by its percentile
      ranking, from 0 to 100, for the share of households that make less than $50,000 per year.
      The most affluent neighborhoods in Chicago are on the North Side,
      from North Center to the Loop, ending around the Near North Side."
    
    map_width <- session$clientData[["output_incmap_width"]]
    if (map_width < 300) {
      HTML(
        paste0("<p align = 'right' style = 'font-size:0.8rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>
           Low-income households
           <span class = 'visually-hidden'>
           ...",
               caption,
               "</span>
           </p>"))
    } else {
      HTML(
        paste0("<p align = 'center' style = 'font-size:1rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>",
               caption,
               "</p>"))
    }
  })
  
  output$zcamap_caption <- renderUI({
    
    caption <- "In this map, Chicago is divided into half-square-mile
      hexagons. Each hexagon is colored by its percentile
      ranking, from 0 to 100, for the share of households that don't own a vehicle.
      Areas that rank highly for this measure are concentrated along the
      lake shore from Rogers Park to South Shore,
      in south side neighborhoods including Englewood,
      and from east to west in a narrow band along the Eisenhower Expressway (I-90)."
    
    map_width <- session$clientData[["output_zcamap_width"]]
    if (map_width < 300) {
      HTML(
        paste0("<p align = 'right' style = 'font-size:0.8rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>
           Zero-car households
           <span class = 'visually-hidden'>
           ...",
               caption,
               "</span>
           </p>"))
    } else {
      HTML(
        paste0("<p align = 'center' style = 'font-size:1rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>",
               caption,
               "</p>"))
    }
  })
  
  
  output$snomap_caption <- renderUI({
    
    caption <- "In this map, Chicago is divided into half-square-mile
      hexagons. Each hexagon is colored by its percentile
      ranking, from 0 to 100, for its total number of 311 reports of
      snowy/icy sidewalks. The map is nearly identical to the map of population density,
      and corresponds with relative affluence."
    
    map_width <- session$clientData[["output_snomap_width"]]
    if (map_width < 300) {
      HTML(
        paste0("<p align = 'right' style = 'font-size:0.8rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>
           Snow/ice complaints
           <span class = 'visually-hidden'>
           ...",
               caption,
               "</span>
           </p>"))
    } else {
      HTML(
        paste0("<p align = 'center' style = 'font-size:1rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>",
               caption,
               "</p>"))
    }
  })
  
  output$ctamap_caption <- renderUI({
    
    caption <- "In this map, Chicago is divided into half-square-mile
      hexagons. Each hexagon is colored by its percentile
      ranking, from 0 to 100, for its total number of transit boardings and alightings (what we are calling 'transit activity'). 
      The map shows a patchy distribution of high-ranking half-square-mile areas,
      mostly corresponding with L stations and areas downtown."
    
    map_width <- session$clientData[["output_ctamap_width"]]
    if (map_width < 300) {
      HTML(
        paste0("<p align = 'right' style = 'font-size:0.8rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>
           Transit activity
           <span class = 'visually-hidden'>
           ...",
               caption,
               "</span>
           </p>"))
    } else {
      HTML(
        paste0("<p align = 'center' style = 'font-size:1rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>",
               caption,
               "</p>"))
    }
  })
  
  output$vacmap_caption <- renderUI({
    
    caption <- "In this map, Chicago is divided into half-square-mile
      hexagons. Each hexagon is colored by its percentile
      ranking, from 0 to 100, for its total number of 311 reports of
      vacant buildings. The map is an inverse of the population density map, 
      and corresponds to areas with lower household incomes and greater shares of
      people with disabilities. Areas on the Southside rank highest for this measure."
    
    map_width <- session$clientData[["output_vacmap_width"]]
    if (map_width < 300) {
      HTML(
        paste0("<p align = 'right' style = 'font-size:0.8rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>
           Vacant buildings
           <span class = 'visually-hidden'>
           ...",
               caption,
               "</span>
           </p>"))
    } else {
      HTML(
        paste0("<p align = 'center' style = 'font-size:1rem; font-family: 'Montserrat', sans-serif; color:#000000; margin-top:0; margin-bottom:0;'>",
               caption,
               "</p>"))
    }
  })
  
  ##... titles ----
  dynamic_title <- function(var = "amb", 
                            icon = 'wheelchair-move', 
                            title  = "People with ambulatory disabilities"){
    
    map_id <- paste0("output_", var, "map_width")
    map_width <- session$clientData[[map_id]]
    if (map_width < 300) {
      fontawesome::fa(
        icon,
        fill = '#000000',
        height = '1.5rem'
      )
    } else {
      HTML(glue::glue(
        paste0("<p style = 
              'font-size:1.5rem;
              color: #000000;
              margin-bottom:0px;margin-top:0px'>{fontawesome::fa('",
              icon,
              "', fill = '#000000',
              height = '2rem'
            )}<br>",
            title,
            "</p>"),
      ))
    }
  }
    
  
  output$ambmap_title <- renderUI({
    dynamic_title(var = "amb",
                  icon = "wheelchair-move",
                  title = "People with ambulatory disabilities")
  })
  
  output$vismap_title <- renderUI({
    dynamic_title(var = "vis",
                  icon = "person-walking-with-cane",
                  title = "People with vision disabilities")
  })
  
  output$oldmap_title <- renderUI({
    dynamic_title(var = "old",
                  icon = "user-plus",
                  title = "People 65 and older")
  })
  
  output$kidmap_title <- renderUI({
    dynamic_title(var = "kid",
                  icon = "baby-carriage",
                  title = "Kids under 5")
  })
  
  output$zcamap_title <- renderUI({
    dynamic_title(var = "zca",
                  icon = "car-tunnel",
                  title = "Households without cars")
  })
  
  output$incmap_title <- renderUI({
    dynamic_title(var = "inc",
                  icon = "circle-dollar-to-slot",
                  title = "Low-income households")
  })
  
  output$ctamap_title <- renderUI({
    dynamic_title(var = "cta",
                  icon = "bus",
                  title = "Transit activity")
  })
  
  output$denmap_title <- renderUI({
    dynamic_title(var = "den",
                  icon = "city",
                  title = "Population density")
  })
  
  output$snomap_title <- renderUI({
    dynamic_title(var = "sno",
                  icon = "snowplow",
                  title = "Snow/ice reports")
  })
  
  output$vacmap_title <- renderUI({
    dynamic_title(var = "vac",
                  icon = "building-circle-exclamation",
                  title = "Vacant buildings")
  })
  
  # ... maps ----
  output$ambmap <- 
    renderLeaflet({
    info <- getCurrentOutputInfo()
    if (info$width() < 300) {
      mini_map(percentile_measure = "amb_pctile")
    } else {
      fullscreen_map(absolute_measure = "amb_n_ppl",
                     round_absolute = -2,
                     relative_measure = "amb_pct_ppl", 
                     round_relative = 0,
                     percentile_measure = "amb_pctile",
                     measure_units = "people",
                     measure_quality = "have an ambulatory disability",
                     relative_units = "% of people")
    }
  })
    

    
  
  output$vismap <- renderLeaflet({
    info <- getCurrentOutputInfo()
      if (info$width() < 300) {
        mini_map(percentile_measure = "vis_pctile")
      } else {
        fullscreen_map(absolute_measure = "vis_n_ppl",
                       round_absolute = -2,
                       relative_measure = "vis_pct_ppl", 
                       round_relative = 0,
                       percentile_measure = "old_pctile",
                       measure_units = "people",
                       measure_quality = "have an vision disability",
                       relative_units = "% of people")
      }
  })

    
  output$oldmap <- renderLeaflet({
    info <- getCurrentOutputInfo()
    if (info$width() < 300) {
      mini_map(percentile_measure = "old_pctile")
    } else {
      fullscreen_map(absolute_measure = "old_n_ppl",
                     round_absolute = -3,
                     relative_measure = "old_pct_ppl", 
                     round_relative = 0,
                     percentile_measure = "old_pctile",
                     measure_units = "people",
                     measure_quality = "are 65 or older",
                     relative_units = "% of people")
    }
  })

  
  output$kidmap <- renderLeaflet({
    info <- getCurrentOutputInfo()
    if (info$width() < 300) {
      mini_map(percentile_measure = "kid_pctile")
    } else {
      fullscreen_map(absolute_measure = "kid_n_ppl",
                     round_absolute = -3,
                     relative_measure = "kid_pct_ppl", 
                     round_relative = 0,
                     percentile_measure = "kid_pctile",
                     measure_units = "people",
                     measure_quality = "are under 5",
                     relative_units = "% of people")
    }
  })
  
  

  output$zcamap <- renderLeaflet({
    info <- getCurrentOutputInfo()
    if (info$width() < 300) {
      mini_map(percentile_measure = "zca_pctile")
    } else {
      fullscreen_map(absolute_measure = "zca_n_hhs",
                     round_absolute = -3,
                     relative_measure = "zca_pct_hhs", 
                     round_relative = 0,
                     percentile_measure = "zca_pctile",
                     measure_units = "households",
                     measure_quality = "lack a private vehicle",
                     relative_units = "% of households")
    }
  })
  

  output$incmap <- renderLeaflet({
    info <- getCurrentOutputInfo()
    if (info$width() < 300) {
      mini_map(percentile_measure = "inc_pctile")
    } else {
      fullscreen_map(absolute_measure = "inc_n_hhs",
                     round_absolute = -3,
                     relative_measure = "inc_pct_hhs", 
                     round_relative = 0,
                     percentile_measure = "inc_pctile",
                     measure_units = "households",
                     measure_quality = "make less than $50K per year",
                     relative_units = "% of households")
    }
  })

  output$ctamap <- renderLeaflet({
    info <- getCurrentOutputInfo()
    if (info$width() < 300) {
      mini_map(percentile_measure = "n_cta_pctile")
    } else {
      fullscreen_map(absolute_measure = "n_cta",
                     round_absolute = -3,
                     relative_measure = "n_cta_permi2", 
                     round_relative = -3,
                     relative_transform = 1,
                     percentile_measure = "n_cta_pctile",
                     measure_units = "transit boardings\nand alightings",
                     measure_quality = "occur on a typical weekday",
                     relative_units = "boardings and alightings per square mile")
    }
  })

  output$denmap <- renderLeaflet({
    info <- getCurrentOutputInfo()
    if (info$width() < 300) {
      mini_map(percentile_measure = "n_ppl_pctile")
    } else {
      fullscreen_map(absolute_measure = "n_ppl",
                     round_absolute = -3,
                     relative_measure = "n_ppl_permi2", 
                     round_relative = -3,
                     relative_transform = 1,
                     percentile_measure = "n_ppl_pctile",
                     measure_units = "people",
                     measure_quality = "are residents",
                     relative_units = "people per square mile")
    }
  })


  output$snomap <- renderLeaflet({
    info <- getCurrentOutputInfo()
    if (info$width() < 300) {
      mini_map(percentile_measure = "n_sno_pctile")
    } else {
      fullscreen_map(absolute_measure = "n_sno",
                     round_absolute = 0,
                     relative_measure = "n_sno_permi2", 
                     round_relative = 0,
                     relative_transform = 1,
                     percentile_measure = "n_sno_pctile",
                     measure_units = "snowy/icy sidewalk reports",
                     measure_quality = "have been filed with 311 since 2018",
                     relative_units = "reports per square mile")
    }
  })

  output$vacmap <- renderLeaflet({
    info <- getCurrentOutputInfo()
    if (info$width() < 300) {
      mini_map(percentile_measure = "n_vac_pctile")
    } else {
      fullscreen_map(absolute_measure = "n_vac",
                     round_absolute = 0,
                     relative_measure = "n_vac_permi2", 
                     round_relative = 0,
                     relative_transform = 1,
                     percentile_measure = "n_vac_pctile",
                     measure_units = "vacant building reports",
                     measure_quality = "have been filed with 311 since 2018",
                     relative_units = "vacant buildings per square mile")
    }
  })

  # update weights ------
  weights <- reactiveVal(first_weights)

  observe({
    total <- sum(
      input$s_vis,
      input$s_amb,
      input$s_old,
      input$s_kid,
      input$s_den,
      input$s_zca,
      input$s_inc,
      input$s_cta,
      input$s_sno,
      input$s_vac
    )

    slider_weights <- list(
      "vis_w" = (input$s_vis / total),
      "amb_w" = (input$s_amb / total),
      "old_w" = (input$s_old / total),
      "kid_w" = (input$s_kid / total),
      "den_w" = (input$s_den / total),
      "zca_w" = (input$s_zca / total),
      "inc_w" = (input$s_inc / total),
      "cta_w" = (input$s_cta / total),
      "sno_w" = (input$s_sno / total),
      "vac_w" = (input$s_vac / total)
    )

    weights(slider_weights)
  })

  # second set of weights for drawing map ------
  weights2 <- reactiveVal(first_weights)

  observe({
    total <- sum(
      input$s_vis2,
      input$s_amb2,
      input$s_old2,
      input$s_kid2,
      input$s_den2,
      input$s_zca2,
      input$s_inc2,
      input$s_cta2,
      input$s_sno2,
      input$s_vac2
    )

    slider_weights <- list(
      "vis_w" = (input$s_vis2 / total),
      "amb_w" = (input$s_amb2 / total),
      "old_w" = (input$s_old2 / total),
      "kid_w" = (input$s_kid2 / total),
      "den_w" = (input$s_den2 / total),
      "zca_w" = (input$s_zca2 / total),
      "inc_w" = (input$s_inc2 / total),
      "cta_w" = (input$s_cta2 / total),
      "sno_w" = (input$s_sno2 / total),
      "vac_w" = (input$s_vac2 / total)
    )

    weights2(slider_weights)
  })

  # update weights on scroll ----
  observeEvent(input$scr,
    ignoreNULL = T,
    ignoreInit = T,
    {
      if (input$scr == "equal") {
        weights(first_weights)
      }

      if (input$scr == "disabilities") {
        new_weights <- list(
          "den_w" = 0,
          "vis_w" = 0.25,
          "amb_w" = 0.25,
          "old_w" = 0.125,
          "kid_w" = 0.125,
          "zca_w" = 0.125,
          "inc_w" = 0.125,
          "cta_w" = 0.125,
          "sno_w" = 0.07,
          "vac_w" = 0.07
        )

        weights(new_weights)
      }

      if (input$scr == "transit") {
        new_weights <- list(
          "den_w" = 0.25,
          "vis_w" = 0,
          "amb_w" = 0,
          "old_w" = 0.125,
          "kid_w" = 0.125,
          "zca_w" = 0.125,
          "inc_w" = 0.125,
          "cta_w" = 0.125,
          "sno_w" = 0.07,
          "vac_w" = 0.07
        )

        weights(new_weights)
      }

      if (input$scr == "purple") {
        updateSliderInput(
          inputId = "s_vis",
          value = 0
        )
        updateSliderInput(
          inputId = "s_amb",
          value = 0
        )
        updateSliderInput(
          inputId = "s_old",
          value = 0
        )
        updateSliderInput(
          inputId = "s_kid",
          value = 0
        )
        updateSliderInput(
          inputId = "s_zca",
          value = 0
        )
        updateSliderInput(
          inputId = "s_inc",
          value = 0
        )
        updateSliderInput(
          inputId = "s_cta",
          value = 0
        )
        updateSliderInput(
          inputId = "s_den",
          value = 0
        )
        updateSliderInput(
          inputId = "s_vac",
          value = 0
        )
        updateSliderInput(
          inputId = "s_sno",
          value = 0
        )
      }
    }
  )


  observeEvent(input$disability_button, {
    updateSliderInput(
      inputId = "s_vis2",
      value = 100
    )
    updateSliderInput(
      inputId = "s_amb2",
      value = 100
    )
    updateSliderInput(
      inputId = "s_old2",
      value = 50
    )
    updateSliderInput(
      inputId = "s_kid2",
      value = 50
    )
    updateSliderInput(
      inputId = "s_zca2",
      value = 50
    )
    updateSliderInput(
      inputId = "s_inc2",
      value = 50
    )
    updateSliderInput(
      inputId = "s_cta2",
      value = 50
    )
    updateSliderInput(
      inputId = "s_den2",
      value = 0
    )
    updateSliderInput(
      inputId = "s_vac2",
      value = 25
    )
    updateSliderInput(
      inputId = "s_sno2",
      value = 25
    )
  })


  observeEvent(input$density_button, {
    updateSliderInput(
      inputId = "s_vis2",
      value = 0
    )
    updateSliderInput(
      inputId = "s_amb2",
      value = 0
    )
    updateSliderInput(
      inputId = "s_old2",
      value = 50
    )
    updateSliderInput(
      inputId = "s_kid2",
      value = 50
    )
    updateSliderInput(
      inputId = "s_zca2",
      value = 50
    )
    updateSliderInput(
      inputId = "s_inc2",
      value = 50
    )
    updateSliderInput(
      inputId = "s_cta2",
      value = 50
    )

    updateSliderInput(
      inputId = "s_den2",
      value = 100
    )

    updateSliderInput(
      inputId = "s_vac2",
      value = 25
    )
    updateSliderInput(
      inputId = "s_sno2",
      value = 25
    )
  })

  # update scores -----
  scores <- reactiveVal(first_scores)

  observe({
    updated_scores <- update_scores(
      weights = weights(),
      df = master
    )
    # Feed reactive value
    scores(updated_scores)
  })

  # second set of scores ----------
  scores2 <- reactiveVal(first_scores)

  observe({
    updated_scores <- update_scores(
      weights = weights2(),
      df = master
    )
    # Feed reactive value
    scores2(updated_scores)
  })

  # filter master -----
  master_filtered <- reactiveVal()
  observe({
    master_f_new <-
      master %>%
      left_join(scores2()) %>%
      filter(score_p_rank >= input$f_score[1] &
        score_p_rank <= input$f_score[2]) %>%
      filter(amb_pctile >= input$f_amb[1] / 100 &
        amb_pctile <= input$f_amb[2] / 100) %>%
      filter(vis_pctile >= input$f_vis[1] / 100 &
        vis_pctile <= input$f_vis[2] / 100) %>%
      filter(old_pctile >= input$f_old[1] / 100 &
        old_pctile <= input$f_old[2] / 100) %>%
      filter(kid_pctile >= input$f_kid[1] / 100 &
        kid_pctile <= input$f_kid[2] / 100) %>%
      filter(zca_pctile >= input$f_zca[1] / 100 &
        zca_pctile <= input$f_zca[2] / 100) %>%
      filter(inc_pctile >= input$f_inc[1] / 100 &
        inc_pctile <= input$f_inc[2] / 100) %>%
      filter(n_cta_pctile >= input$f_cta[1] / 100 &
        n_cta_pctile <= input$f_cta[2] / 100) %>%
      filter(n_vac_pctile >= input$f_vac[1] / 100 &
        n_vac_pctile <= input$f_vac[2] / 100) %>%
      filter(n_ppl_pctile >= input$f_den[1] / 100 &
        n_ppl_pctile <= input$f_den[2] / 100) %>%
      filter(n_sno_pctile >= input$f_sno[1] / 100 &
        n_sno_pctile <= input$f_sno[2] / 100)

    master_filtered(master_f_new)
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
    map_data <- master %>%
      left_join(scores()) %>%
      mutate(
        score_bin =
          case_when(
            score_p_rank < 10 ~ "0-10 (Low)",
            score_p_rank < 20 ~ "10-20",
            score_p_rank < 30 ~ "20-30",
            score_p_rank < 40 ~ "30-40",
            score_p_rank < 50 ~ "40-50",
            score_p_rank < 60 ~ "50-60",
            score_p_rank < 70 ~ "60-70",
            score_p_rank < 80 ~ "70-80",
            score_p_rank < 90 ~ "80-90",
            score_p_rank <= 100 ~ "90-100 (High)"
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

    color_data <- map_data$score_bin
    my_title <- "Rank"
    my_pal <-
      colorFactor("plasma",
        color_data,
        reverse = FALSE
      )


    tooltips <- sprintf(
      "<p style='font-family: Poppins, sans-serif;
      font-size:1rem;
      color: #270075'>
      Score:
      <br>
      <strong><span style='font-size:2rem'>
      %s</strong>
      </span>",
      map_data$score_p_rank
    ) %>%
      lapply(htmltools::HTML)


    leafletProxy("mapBuild", data = map_data) %>%
      clearShapes() %>%
      clearControls() %>%
      addPolygons(
        data = map_data,
        layerId = ~hexid,
        label = ~tooltips,
        stroke = FALSE,
        fillOpacity = 0.7,
        fillColor = my_pal(color_data)
      ) %>%
      addLegend(
        position = "topright",
        pal = my_pal,
        group = "score_tiles",
        values = unique(color_data),
        title = "Weighted score<br>(rank percentile)"
      )
  })


  # draw map--------------
  output$mapDraw <- renderLeaflet({
    map_data <- master %>%
      left_join(first_scores) %>%
      mutate(
        score_bin =
          case_when(
            score_p_rank < 10 ~ "0-10 (Low)",
            score_p_rank < 20 ~ "10-20",
            score_p_rank < 30 ~ "20-30",
            score_p_rank < 40 ~ "30-40",
            score_p_rank < 50 ~ "40-50",
            score_p_rank < 60 ~ "50-60",
            score_p_rank < 70 ~ "60-70",
            score_p_rank < 80 ~ "70-80",
            score_p_rank < 90 ~ "80-90",
            score_p_rank <= 100 ~ "90-100 (High)"
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


    tooltips <- sprintf(
      "<p style='font-family: Poppins, sans-serif;
      font-size:1rem;
      color: #270075'>
      Score:
      <br>
      <strong><span style='font-size:2rem'>
      %s</strong>
      </span>",
      map_data$score_p_rank
    ) %>%
      lapply(htmltools::HTML)

    map_data$tooltips <- tooltips

    color_data <- map_data$score_bin
    my_title <- "Rank"
    my_pal <-
      colorFactor("plasma",
        color_data,
        reverse = FALSE
      )


    leaflet(options = leafletOptions(
      minZoom = 10, maxZoom = 13,
      zoomControl = F,
      attributionControl = FALSE
    )) %>%
      addMapPane("lstops", zIndex = 440) %>%
      addMapPane("ward", zIndex = 430) %>%
      addMapPane("sno", zIndex = 420) %>%
      addMapPane("vac", zIndex = 410) %>%
      addMapPane("hex", zIndex = 400) %>%
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
        singleFeature = TRUE,
        editOptions = editToolbarOptions(
          edit = TRUE,
          remove = FALSE,
          selectedPathOptions = NULL,
          allowIntersection = TRUE
        )
      ) %>%
      addPolygons(
        data = map_data,
        label = ~tooltips,
        stroke = FALSE,
        fillOpacity = 0.7,
        fillColor = my_pal(color_data),
        group = "score_tiles",
        options = pathOptions(pane = "hex")
      ) %>%
      addLegend(
        position = "topright",
        pal = my_pal,
        group = "score_tiles",
        values = unique(color_data),
        title = "Weighted score<br>(rank percentile)"
      )
  })

  ward_tooltips <- reactiveVal(init_ward_labs)

  # Ward IDs
  observeEvent(
    eventExpr = input$mapDraw_zoom,
    {
      print(input$mapDraw_zoom) # Display zoom level in the console
      zoom_i <- input$mapDraw_zoom

      if (zoom_i == 10) {
        new_labs <- make_ward_labs(font_size = 0.8)
      }

      if (zoom_i == 11) {
        new_labs <- make_ward_labs(font_size = 1)
      }

      if (zoom_i == 12) {
        new_labs <- make_ward_labs(font_size = 1.2)
      }

      if (zoom_i == 13) {
        new_labs <- make_ward_labs(font_size = 1.5)
      }

      ward_tooltips(new_labs)
    }
  )

  # update draw map with new scores ----
  observe({
    map_data <- master_filtered() %>%
      left_join(scores2()) %>%
      mutate(
        score_bin =
          case_when(
            score_p_rank < 10 ~ "0-10 (Low)",
            score_p_rank < 20 ~ "10-20",
            score_p_rank < 30 ~ "20-30",
            score_p_rank < 40 ~ "30-40",
            score_p_rank < 50 ~ "40-50",
            score_p_rank < 60 ~ "50-60",
            score_p_rank < 70 ~ "60-70",
            score_p_rank < 80 ~ "70-80",
            score_p_rank < 90 ~ "80-90",
            score_p_rank <= 100 ~ "90-100 (High)"
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


    color_data <- map_data$score_bin
    my_title <- "Rank"
    my_pal <-
      colorFactor("plasma",
        color_data,
        reverse = FALSE
      )


    tooltips <- sprintf(
      "<p style='font-family: Poppins, sans-serif;
      font-size:1rem;
      color: #270075'>
      Score:
      <br>
      <strong><span style='font-size:2rem'>
      %s</strong>
      </span>",
      map_data$score_p_rank
    ) %>%
      lapply(htmltools::HTML)

    leafletProxy("mapDraw", data = map_data) %>%
      clearGroup("score_tiles") %>%
      clearControls() %>%
      addPolygons(
        data = map_data,
        label = ~tooltips,
        stroke = FALSE,
        fillOpacity = 0.7,
        fillColor = my_pal(color_data),
        group = "score_tiles",
        options = pathOptions(pane = "hex")
      ) %>%
      addLegend(
        position = "topright",
        pal = my_pal,
        group = "score_tiles",
        values = unique(color_data),
        title = "Weighted score<br>(rank percentile)"
      )
  })

  # add layers to map -----
  observe({
    if (input$ward_layer == TRUE) {
      leafletProxy("mapDraw") %>%
        addPolygons(
          data = wards,
          stroke = TRUE,
          color = "white",
          weight = 1.5,
          fill = FALSE,
          group = "wards",
          options = pathOptions(pane = "ward"),
          highlightOptions = highlightOptions(
            weight = 2.5,
            color = "white",
            bringToFront = F
          )
        ) %>%
        clearGroup("wardlabels") %>%
        addLabelOnlyMarkers(
          data = ward_centroids,
          group = "wardlabels",
          label = ~ ward_tooltips(),
          options = pathOptions(pane = "ward"),
          labelOptions =
            labelOptions(
              noHide = TRUE,
              bringToFront = TRUE,
              direction = "top",
              textOnly = TRUE
            )
        )
    }

    if (input$ward_layer == FALSE) {
      leafletProxy("mapDraw") %>%
        clearGroup("wards") %>%
        clearGroup("wardlabels")
    }


    if (input$sno_layer == TRUE) {
      leafletProxy("mapDraw") %>%
        addGlPoints(
          data = bad_chicago$sno,
          group = "sno",
          radius = 3,
          fillColor = "white",
          fillOpacity = 1,
          pane = "sno"
        )
    }

    if (input$sno_layer == FALSE) {
      leafletProxy("mapDraw") %>%
        clearGroup("sno")
    }

    if (input$vac_layer == TRUE) {
      leafletProxy("mapDraw") %>%
        addGlPoints(
          data = bad_chicago$vac,
          group = "vac",
          radius = 3,
          fillColor = "#270075",
          pane = "vac",
          fillOpacity = 1
        )
    }

    if (input$vac_layer == FALSE) {
      leafletProxy("mapDraw") %>%
        clearGroup("vac")
    }


    if (input$l_stops_layer == TRUE) {
      leafletProxy("mapDraw") %>%
        addCircleMarkers(
          data = l_stops,
          group = "lstops",
          radius = 3,
          fillColor = "#9b51e0",
          color = "#270075",
          opacity = 1,
          options = pathOptions(pane = "lstops"),
          fillOpacity = 1
        )
    }

    if (input$l_stops_layer == FALSE) {
      leafletProxy("mapDraw") %>%
        clearGroup("lstops")
    }
  })

  # react to weight choosing ----
  observeEvent(input$disability_button, {
    runjs("document.getElementById('disability_button').style.backgroundColor = '#9b51e0';")
    runjs("document.getElementById('density_button').style.backgroundColor = '#979797';")
  })

  observeEvent(input$density_button, {
    runjs("document.getElementById('disability_button').style.backgroundColor = '#979797';")
    runjs("document.getElementById('density_button').style.backgroundColor = '#9b51e0';")
  })




  # react to polygon draw button -------
  observeEvent(input$polygon_button, {
    js$polygon_click()

    # shinyjs::enable(input$submit_button)
    # shinyjs::enable(input$edit_button)
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

    text <- case_when(
      user_area_new > 3.1 ~
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
                     Area is too large</span>"
        ),
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
                     Area is too small</span>"
        ),
      TRUE ~
        glue::glue(
          "<span style = 'font-size: 1.2rem;
                         color: #270075;
                     font-family: Poppins, sans-serif;
                     font-weight: bold'>
                     Zone area: {round(user_area_new, 1)}
                     square miles</span>"
        )
    )

    area_text <- tags$div(
      tag.zone.area, HTML(text)
    )

    leafletProxy("mapDraw") %>%
      clearControls() %>%
      addControl(area_text, position = "topleft", className = "map-title")
  })

  poly_summary <- reactiveVal()
  # scorecard -----
  observeEvent(user_area(), ignoreNULL = T, {

      intersection <- st_intersection(user_zone(), master)

      summary <- summarize_poly(intersection)
      poly_summary(summary)


      output$scorecard <-
        render_gt(create_scorecard(summary))
  })

  # submit ----
  observeEvent(input$submit_button, {
    wkt_poly <-
      poly_summary() %>%
      select(-total_area, -X_leaflet_id, -do.union) %>%
      cbind(data.frame(first_weights)) %>%
      mutate(timestamp = Sys.time()) %>%
      mutate(wkt_col = st_as_text(geometry)) %>%
      st_drop_geometry()

    googlesheets4::sheet_append(
      "https://docs.google.com/spreadsheets/d/1h6FH1-Kgr27dfsGcRhVbn7ChwS9V8WgdOQmWN4dUl8k/edit?usp=sharing",
      sheet = "submissions",
      data = wkt_poly
    )
  })
}
