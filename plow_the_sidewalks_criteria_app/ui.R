ui <- fluidPage(
  useShinyjs(),
  # css tags -----
  tags$head(
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css?family=Montserrat"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css?family=Poppins"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "irs_style.css"),
    ## ... extra styling for sliders
    tags$style(
      HTML(
        ".label-left .form-group {
          display: flex;              /* Use flexbox for positioning children */
          flex-direction: row;        /* Place children on a row (default) */
          width: 90%;                /* Set width for container */
          align-self: center;
          height: 2rem;
          max-width: 400px;
        }
        .label-left label {
          margin-right: 1rem;         /* Add spacing between label and slider */
          align-self: center;         /* Vertical align in center of row */
          text-align: left;
          flex-basis: 2rem;          /* Target width for label */
          height: 2rem;
        }
        .label-left .irs{
          flex-basis: 300px;          /* Target width for slider */
          align-self: center;
          height: 2rem;
        }
        .label-left .irs-line {
            top: 1rem;
            bottom: 1rem;
        }
        .label-left .irs-bar {
            top: 1rem;
            bottom: 1rem;
        }

        .label-left .irs-handle {
            top: 0.3rem;
            bottom: 0rem;
          }
        "
      )
    ),
    
    ## ...draw polygon button ----
    tags$style(
      HTML(
        "
      a.leaflet-draw-draw-polygon {
      display: inline;
      visibility: hidden !important;
      }
     div.leaflet-draw-toolbar{
       box-shadow: 0 0px 0px rgba(0,0,0,0) !important;
      -moz-box-shadow:0 0px 0px rgba(0,0,0,0) !important;
      -webkit-box-shadow: 0 0px 0px rgba(0,0,0,0) !important;
      border-color: rgba(0,0,0,0) !important;
      }"
      )
    ),
    
    ## ...edit polygon button ----
    tags$style(
      HTML(
        "
      a.leaflet-draw-edit-edit {
      display: inline;
      visibility: hidden !important;
      }"
      )
    ),
  ),
  
  # Page title  -------
  titlePanel(
    title = div(
      img(
        src = "main-logo.png",
        height = "100px",
        alt = "Access Living logo",
        class = "pull-right"
      ),
      img(
        src = "second-logo.png",
        height = "100px",
        alt = "Better streets logo",
        class = "pull-right"
      ),
      HTML(
        "<h2
      style = 'line-height: 2rem;
      margin-top:3rem;
      margin-bottom:1rem;'>
      #PlowTheSidewalks
      <br>
      <span style='font-family: Poppins, sans-serif;
      font-size:1.8rem;
      line-height: 0.5rem;
      font-weight: bold; color: #000000;'>
      Let’s make
      <span style='color: #9b51e0;'>
      sidewalk snow removal
      </span>
      <span style='color: #000000;'>
      a municipal service.
      </span>
      <br>
      <span
      style='font-family: Montserrat, sans-serif;
      font-size:1.2rem;
      font-weight: 100;
      line-height: 0.2rem;
      color: #000000;'>
      An inititative of Better Streets Chicago and Access Living
      </span></h1>"
      )
    ),
    windowTitle = "Where should we #PlowTheSidewalks first?"),
  
  # About --------
  tabsetPanel(
    type = "tabs",
    tabPanel(
      title = "About the pilot",
      id = "about_tab",
      
      ## Introduction -----
      fluidRow(
        br(),
        br(),
        br(),
        wellPanel(
          HTML(
            "<h3>Where should Chicago try municipal sidewalk plowing
              <span style='color: #9b51e0;'>first?</span></h3>"
          )
        ),
        p(
          "Better Streets Chicago and Access Living are drafting an ordinance asking Chicago
          to set aside $750,000 in the upcoming budget
          for a municipal sidewalk clearing pilot program.
          This pilot will serve as a small test of what a city-wide program
          could look like."
        ),
        p(
          "The draft ordinance calls for the city to run the pilot in four,
            2.5 square-mile zones across the city, with an eye towards mobility justice."
        ),
        p(
          'This interactive page asks, "Where should we try sidewalk plowing first?",
            and translates our priorities into a map of places
            where a test of sidewalk snow plowing would have greatest impact
            for the people that need it most.'
        )
      ),
      ## Priorities table -----
      fluidRow(
        HTML("<h3>Setting our priorities</h3>"),
        p(
          "To maximize the pilot program’s impact,
          we are asking the city to locate the pilot zones
          in a way that prioritizes:"
        ),
        wellPanel(priorites_tab)
      ),
      
      ## Two types of zones -----
      fluidRow(
        HTML(
          "<h3>
            No one neighborhood will best serve
            <span style='color: #9b51e0'>
            all
            </span>of these priorities at once</h3>"
        ),
        HTML(
          "<p>That is why we are suggesting the city take a
              measured approach to the problem
              of pilot zone placement, and create
              <span style='color: #9b51e0; font-weight:bold'>
              two types</span>
              of pilot zones:</p>"
        )
      ),
      
      ## Zone Type table -----
      wellPanel(fluidRow(
        column(
          6,
          HTML(
            "<p style = 'text-align: center; font-size:1.2rem'>One set of zones will focus on
                  <b>
                  people with disabilities and elders</b></p>"
          ),
          fluidRow(
            align = "center",
            fontawesome::fa(
              "wheelchair-move",
              fill = "#270075",
              height = "2rem"
            ),
            
            fontawesome::fa(
              "person-walking-with-cane",
              fill = "#270075",
              height = "2rem"
            ),
            
            fontawesome::fa("user-plus",
                            fill = "#270075",
                            height = "2rem")
          )
        ),
        column(
          6,
          HTML(
            "<p style = 'text-align: center; font-size:1.2rem'>A second set of zones will focus on
                      <b>
                      transit users and children</b></p>"
          ),
          fluidRow(
            align = "center",
            fontawesome::fa("bus",
                            fill = "#270075",
                            height = "2rem"),
            fontawesome::fa("car",
                            fill = "#270075",
                            height = "2rem"),
            fontawesome::fa("baby-carriage",
                            fill = "#270075",
                            height = "2rem")
          )
        )
      ),
      fluidRow(column(
        12,
        HTML(
          "<p style = 'text-align: center; font-size:1.2rem'>Both sets of zones will still give some weight to
               <b>
                population density and known problem areas.</b></p>"
        ),
        fluidRow(
          align = "center",
          fontawesome::fa("city",
                          fill = "#270075",
                          height = "2rem"),
          fontawesome::fa(
            "building-circle-exclamation",
            fill = "#270075",
            height = "2rem"
          ),
          fontawesome::fa("snowplow",
                          fill = "#270075",
                          height = "2rem")
        )
      ))),
      
      ## Weighting -----
      fluidRow(
        HTML(
          "<h3><section style='font-family: Poppins, sans-serif;
                font-size:2rem; font-weight: bold; color: #270075'>
                We propose using a
                <span style='color: #9b51e0'>
                weighting approach
                </span>to identify neighborhoods that might be a good fit
                for each type of pilot zone.</h3>"
        ),
        HTML(
          "<p><b>
              Weighting</b>
              is a way of calculating a score from many different types of numbers.
              You might remember taking a class where the
              final exam was worth half of your grade -- your teacher was using weighting.</p>"
        ),
        HTML(
          "<p>In addition to weighting, we are using
             <b>
             standardization
             </b>to
            put measures that exist on very different scales on even footing
              with one another. This ensures that priorities that measure in large numbers (like the number of
              transit boardings, our measure of transit activity) do not overwhelm
              priorites that are measured with smaller numbers,
              like the percentage of people who have a disability.</p>"
        )
      ),
      
      # Here's what that looks like ----
      fluidRow(HTML(
        "<h3>
    Here's what that looks like on a map.
    </h3>"
      )),
    
    ### Begin scroll ------
    scrolly_container(
      "scr",
      ### place map -----
      scrolly_graph(
        width = "50%",
        height = "100%",
        wellPanel(
          style = "padding: 0;
                    margin-bottom:0;
                    background-color: transparent;
                    border: 2px solid #270075;",
          leafletOutput("mapBuild")
        )
      ),
      ### scroll sections -----
      scrolly_sections(
        width = "45%",
        # ...1: Equal priorities ------
        scrolly_section(
          id = "equal",
          HTML(
            "<p>
            The map on the right scores neighborhoods from
            <b color:#000000; background: #fcb900;'>
             high
            </b>
             to
             <b color: #fff;
            background:#270075'>
            low
            </b>
            based on how well they measure up for
            all of our priorities. On this map, all of our priorities
            are weighted equally.
            </p>"
          ),
          fluidRow(
            align = "center",
            fontawesome::fa(
              "wheelchair-move",
              fill = "#270075",
              height = "2rem"
            ),
            fontawesome::fa("user-plus",
                            fill = "#270075",
                            height = "2rem"),
            fontawesome::fa("baby-carriage",
                            fill = "#270075",
                            height = "2rem"),
            fontawesome::fa("bus",
                            fill = "#270075",
                            height = "2rem"),
            fontawesome::fa("car",
                            fill = "#270075",
                            height = "2rem"),
            fontawesome::fa("city",
                            fill = "#270075",
                            height = "2rem"),
            fontawesome::fa(
              "building-circle-exclamation",
              fill = "#270075",
              height = "2rem"
            )
          )
        ),
        
        # ...2: disabilities ------
        scrolly_section(
          id = "disabilities",
          HTML(
            "<p>
            Now the map shows areas that score highly for
           the percentage of people with disabilities and elders,
          with less importance given to
          known problem areas and density.
            </p>"
          ),
          fluidRow(
            align = "center",
            fontawesome::fa(
              "wheelchair-move",
              fill = "#270075",
              height = "3rem"
            ),
            fontawesome::fa("user-plus",
                            fill = "#270075",
                            height = "3rem")
          ),
          br(),
          fluidRow(
            align = "center",
            fontawesome::fa("city",
                            fill = "#270075",
                            height = "1.5rem"),
            fontawesome::fa(
              "building-circle-exclamation",
              fill = "#270075",
              height = "1.5rem"
            )
          )
        ),
        
        # ...3: transit ------
        scrolly_section(
          id = "transit",
          HTML(
            "<p>
            Finally, this map shows the areas with a
          high percentage of children, zero-car households,
          and transit activity, with less importance
          given to density and known problem areas.
            </p>"
          ),
          fluidRow(
            align = "center",
            fontawesome::fa("baby-carriage",
                            fill = "#270075",
                            height = "3rem"),
            fontawesome::fa("car",
                            fill = "#270075",
                            height = "3rem"),
            fontawesome::fa("bus",
                            fill = "#270075",
                            height = "3rem")
          ),
          br(),
          fluidRow(
            align = "center",
            fontawesome::fa("city",
                            fill = "#270075",
                            height = "1.5rem"),
            fontawesome::fa(
              "building-circle-exclamation",
              fill = "#270075",
              height = "1.5rem"
            )
          ),
          br(),
          br()
        ),
        
        # ...4: try it ---------
        scrolly_section(
          id = "purple",
          HTML(
            "<p>
            You can create your own mix of these priorites
          using the sliders below. Increase the importance of
          any priority by moving the slider to the right.
            </p>"
          ),
          div(class = "label-left",
              s_dis,
              s_old,
              s_kid,
              s_den,
              s_zca,
              s_cta,
              s_bad),
          br(),
          br(),
          br()
        )
      )
    ),
    
    # Zone rules  -----
    fluidRow(
      HTML("<h3>From exploring neighborhoods to drawing zones</h3>"),
      HTML(
        "<p>Now that we can see some broad areas of the city that
          meet our criteria, the next step is to draw some potential pilot zones.
          Our draft ordinance has some extra rules about the
          how these zones are drawn.</p>"
      ),
      
      #...all zones: ----
      fluidRow(column(
        6,
        offset = 3,
        wellPanel(
          style = "padding: 1rem;
                  margin-top: 0.5rem;",
          
          HTML(
            "<p style = 'text-align:center; font-size:1.4rem;'><b>All pilot zones</b></p>"
          ),
          
          HTML(
            glue::glue(
              "<p style = 'font-size:1.2rem;'>
                     {fontawesome::fa('chart-area',
                            fill = '#270075',
                            height = '1.6rem')}
                      Must be <b>2 to 3 square miles</b> in area</p>"
            )
          ),
          
          HTML(
            "<p style = 'font-size:1.2rem;'>
          and must <b>meet or exceed</b>
             Chicago's <b>median</b> (average) population density,
             complaints of unshoveled sidewalks, and vacant buildings.
          In numbers, that translates to <b>at least:</b></p>"
          ),
          
          HTML(
            glue::glue(
              "<p style = 'font-size:1.2rem;'>{fontawesome::fa('city',
                            fill = '#270075',
                            height = '1.6rem')}
                      <b>38,000 residents</b></p>"
            )
          ),
          
          HTML(
            glue::glue(
              "<p style = 'font-size:1.2rem;'>{fontawesome::fa('snowplow',
                            fill = '#270075',
                            height = '1.6rem')}
                      <b>150 sidewalk snow removal complaints</b>
                     in the last 3 years</p>"
            )
          ),
          
          HTML(
            glue::glue(
              "<p style = 'font-size:1.2rem;'>{fontawesome::fa('building-circle-exclamation',
                            fill = '#270075',
                            height = '1.6rem')}
                      <b>120 vacant building</b> reports in the last 3 years</p>"
            )
          )
        )
      )),
      
      HTML(
        "<p>
          These additional cutoffs are set at the <b>75th percentile</b> for each measure, compared across
          all Chicago census tracts.
          In other words, if our pilot zones were ranked against all Chicago census tracts,
          it would rank in the <b>top 25 percent.</b></p>"
      ),
      
      #...special zones -----
      fluidRow(style = "margin-left:0px; padding: 0px;",
               #........disabilities rules -----
               column(6,
                      wellPanel(
                        # style = "max-width: 400px;",
                        HTML(
                          "<p style = 'text-align:center;
            font-size:1.4rem'><b>In the two pilot zones that
            prioritize people with disabilities:</b></p>"
                        ),
            
            HTML(
              glue::glue(
                "<p style = 'font-size:1.2rem'>
                       {fontawesome::fa('wheelchair-move',
                            fill = '#270075',
                            height = '1.6rem')}
                      At least <b>1.4%</b>
                       of people should have an ambulatory (walking)
                       disability</p>"
              )
            ),
            
            HTML(
              glue::glue(
                "<p style = 'font-size:1.2rem'>
                       {fontawesome::fa('person-walking-with-cane',
                            fill = '#270075',
                            height = '1.6rem')}
                        At least <b>0.5%</b>
                       of people should have an vision
                       disability</p>"
              )
            ),
            
            HTML(
              glue::glue(
                "<p style = 'font-size:1.2rem'>
                       {fontawesome::fa('user-plus',
                            fill = '#270075',
                            height = '1.6rem')}
                        At least <b>17%</b>
                       of people should be over 65</p>"
              )
            )
                      )),
            #........transit/kids rules -----
            column(6,
                   wellPanel(
                     # style = "max-width: 400px;",
                     HTML(
                       "<p style = 'text-align:center; font-size:1.4rem'><b>
                 In the two pilot zones focusing on children and transit
                 users:</b></p>"
                     ),
                 HTML(
                   glue::glue(
                     "<p style = 'font-size:1.2rem'>
                         {fontawesome::fa('baby-carriage',
                            fill = '#270075',
                            height = '1.6rem')}
                        At least <b>8%</b>
                       of people should be under 5</p>"
                   )
                 ),
                 
                 HTML(
                   glue::glue(
                     "<p style = 'font-size:1.2rem'>
                         {fontawesome::fa('bus',
                            fill = '#270075',
                            height = '1.6rem')}
                        Transit activity should average at least <b>7,500</b>
                       boardings and alightings per day</p>"
                   )
                 ),
                 
                 HTML(
                   glue::glue(
                     "<p style = 'font-size:1.2rem;'>
                         {fontawesome::fa('car',
                            fill = '#270075',
                            height = '1.6rem')}
                        At least <b>36%</b>
                        of households should have zero cars</p>"
                   )
                 )
                   )))
    ),
    
    
    # Here's what that looks like 2 ----
    br(),
    br(),
    HTML(
      "<h3>
          Scroll on to see some examples of pilot zones that meet
          these criteria
          </h3>"
    ),
    
    ### Begin scroll ------
    fluidRow(scrolly_container(
      "scr2",
      ### place map -----
      scrolly_graph(width = "50%"),
      ### scroll sections -----
      scrolly_sections(
        width = "50%",
        scrolly_section(id = "2_1",
                        p("Some text")),
        scrolly_section(id = "2_2",
                        p("Some text")),
        scrolly_section(id = "2_3",
                        p("Some text"))
      )
    ))
    ),
    # Tab 2: Tool ----

    tabPanel(
      title = "Suggest a pilot zone",
      id = "map_tab",
      type = "pills",
      fluidRow(
        id = "mapntools",
        
        # tools ------
        column(5,
               id = "tools",
               shinyWidgets::verticalTabsetPanel(
                 color = "#9b51e0",
                 id = "toolnav",
                 #...sliders ----
                 verticalTabPanel (
                   id = "sliders",
                   title = HTML(glue::glue("{fontawesome::fa('screwdriver-wrench')}<br>
                                            {fontawesome::fa('layer-group')}<br>
                                            {fontawesome::fa('map-location-dot')}")),
                   HTML(
                     "<p><b>
                               Use the sliders to color the map according to
                               your top priorities.
                               </b></p>"
                   ),
                   div(class = "label-left",
                       s_dis2,
                       s_old2,
                       s_kid2,
                       s_den2,
                       s_zca2,
                       s_cta2,
                       s_bad2),
                   
                  
                   
                   checkboxGroupInput(
                     inputId = 'layers',
                     label =  HTML("<p><b>Add to the map:
                               </b></p>"),
                     choices = c(
                       "Ward boundaries",
                       "L stations",
                       "Sidewalk snow removal requests",
                       "Vacant building reports"
                     )
                   )
                 ),
                 ##...scorecard----
                 verticalTabPanel (
                   id = "scorecard",
                   title = HTML(glue::glue("<br>{fontawesome::fa('list-check')}<br>")),
                   HTML(
                     "<p><b>
                                       Draw a zone to see how well your suggested pilot zone
                                       serves our priorities.
                                       </b></p>"
                   ),
                   gt_output("scorecard")
                 )
               )),
        ##...map -----
        column(7,
               id = "map",
               tags$div(
                 #...draw/edit buttons -----
                 fluidRow(
                   column(
                     4,
                     style = "margin-left: 0px; margin-right: 0px; padding: 5px",
                     shinyjs::extendShinyjs(text = jspolygon, functions = c("polygon_click")),
                     tags$button(
                       type = "button",
                       id = "polygon_button",
                       HTML(
                         fontawesome::fa("arrow-pointer",
                                         height = "2rem",
                                         fill = "#FFF"),
                         "Draw"
                       ),
                       style = "color:#FFF;
                     width:100%;
                         font-family: Poppins, sans-serif;
                         font-weight: bold;
                         background-color: #9b51e0",
                     class = "btn action-button shiny-bound-input"
                     )
                   ),
                   
                   column(
                     4,
                     style = "margin-left: 0px; margin-right: 0px; padding: 5px",
                     tags$button(
                       type = "button",
                       id = "edit_button",
                       HTML(
                         fontawesome::fa("pen-to-square",
                                         height = "2rem",
                                         fill = "#FFF"),
                         "Edit"
                       ),
                       style = "color:#FFF;
                     width:100%;
                         font-family: Poppins, sans-serif;
                         font-weight: bold;
                         background-color: #9b51e0",
                     class = "btn action-button shiny-bound-input"
                     )
                   ),
                   
                   column(
                     4,
                     style = "margin-left: 0px; margin-right: 0px; padding: 5px",
                     tags$button(
                       type = "button",
                       id = "submit_button",
                       HTML(
                         fontawesome::fa("paper-plane",
                                         height = "2rem",
                                         fill = "#FFF"),
                         "Submit"
                       ),
                       style = "color:#FFF;
                     width:100%;
                         font-family: Poppins, sans-serif;
                         font-weight: bold;
                         background-color: #9b51e0",
                     class = "btn action-button shiny-bound-input"
                     )
                   )
                 ),
                 tags$style(type = "text/css", "#mapDraw {height: calc(80vh - 80px) !important;}"),
                 leafletOutput("mapDraw", height = "100%", width = "100%")
               ))
      )
    ),
    
    # Tab 3: Draft ---
    tabPanel(title = "Read the draft ordinance",
             id = "draft_tab",
             p("some text")),
    
    
    
    # Footer ------
    footer = tags$div(
      "This project is open-source. See our GitHub repository here",
      tags$a(
        href = "https://github.com/ashleyasmus/plowthesidewalks_maps",
        shiny::icon("external-link-alt", lib = "font-awesome"),
        target = "_blank"
      ),
      tags$br(),
      "App last updated ",
      "2022-12-21",
      style = "font-size: 1.5rem;
             display: block;
             text-align: right;
             padding: 1%;",
      align = "right",
      class = "pull-down-right"
    )
  )
)
