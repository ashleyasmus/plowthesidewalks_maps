ui <- fixedPage(
  useShinyjs(),
  fresh::use_googlefont("Montserrat"),
  fresh::use_googlefont("Poppins"),


  # css tags -----
  tags$head(
    # tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    # tags$link(rel = "stylesheet", type = "text/css", href = "colors.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "fresh_style.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "irs_style.css"),
    ## ... extra styling for sliders
    tags$style(
      HTML(
        ".label-left .form-group {
          display: flex;              /* Use flexbox for positioning children */
          flex-direction: row;        /* Place children on a row (default) */
          width: 90%;                /* Set width for container */
          max-width: 400px;
        }
        .label-left label {
          margin-right: 1rem;         /* Add spacing between label and slider */
          align-self: center;         /* Vertical align in center of row */
          text-align: left;
          flex-basis: 30px;          /* Target width for label */
        }
        .label-left .irs {
          flex-basis: 300px;          /* Target width for slider */
        }
        "
      )
    ),

    ## ...navigation bar ----
    tags$style(
      HTML(
        ".nav-pills {display: flex;
          flex-direction: row;
          justify-content: space-around;
          min-height: 5.3rem;
          padding: 0;
          padding-top: 0px;
          margin: 0;
          margin-left: 0px;
          padding-top: 1rem;
          padding: 0;
          font-family: 'Poppins',sans-serif;
          font-weight: bold;
          font-size: 1.8rem;
          line-height: 1.5;
          color: #000;
          fill: #999999;
          margin: 0;
          margin-right: 0px;
          margin-left: 0px;
          margin-left: 1.5rem;
          margin-right: .5rem;
         }

         .nav-pills{
          margin-top:20px;
          width:100%;
          }

          .nav-pills > li {
          float: left;
          }"
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
    )
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
        "<h1
          style='font-family: Poppins, sans-serif;
      font-size:4rem;
      font-weight: bold;
      line-height: 0.8;
      color: #270075'>
      #PlowTheSidewalks
      <br>
      <span style='font-family: Poppins, sans-serif;
      font-size:2.5rem;
      line-height: 0.8;
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
      font-size:1.8rem;
      font-weight: 100;
      line-height: 0.5;
      color: #000000;'>
      An inititative of Better Streets Chicago and Access Living
      </span></h1>"
      )
    ),
    windowTitle = "Where should we #PlowTheSidewalks first?"
  ),


  # About --------
  tabsetPanel(
    type = "pills",
    tabPanel(
      title = "About",
      id = "about_tab",
      fluidRow(
        br(),
        wellPanel(
          HTML(
            "<h3><section style='font-family: Poppins, sans-serif;
      font-size:3rem; font-weight: bold; color: #270075'>
    Where should Chicago try municipal sidewalk plowing
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
      ## Priorities -----
      fluidRow(
        HTML(
          "<h3><section style='font-family: Poppins, sans-serif;
      font-size:2rem; font-weight: bold; color: #270075'>
    Setting our priorities</h3>"
        ),
        p(
          "To maximize the pilot program’s impact,
          we are asking the city to locate the pilot zones
          in a way that prioritizes:"
        ),
        wellPanel(priorites_tab)
      ),
      fluidRow(
        HTML(
          "<h3><section style='font-family: Poppins, sans-serif;
      font-size:2rem; font-weight: bold; color: #270075'>
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
      wellPanel(
        fluidRow(
          column(
            6,
            HTML(
              "<p style = 'text-align: center'>One set of zones will focus on
      <span style='color: #270075; font-weight:bold'>
      people with disabilities and elders</span></p>"
            ),
            fluidRow(
              align = "center",
              fontawesome::fa(
                "wheelchair-move",
                fill = "#270075",
                height = "30px"
              ),
              fontawesome::fa("user-plus",
                fill = "#270075",
                height = "30px"
              )
            )
          ),
          column(
            6,
            HTML(
              "<p style = 'text-align: center'>A second set of zones will focus on
      <span style='color: #270075; font-weight:bold'>
      transit activity, zero-car households and children</span></p>"
            ),
            fluidRow(
              align = "center",
              fontawesome::fa("bus",
                fill = "#270075",
                height = "30px"
              ),
              fontawesome::fa("car",
                fill = "#270075",
                height = "30px"
              ),
              fontawesome::fa("baby-carriage",
                fill = "#270075",
                height = "30px"
              ),
            )
          )
        ),
        br(),
        fluidRow(column(
          12,
          HTML(
            "<p style = 'text-align: center'>Both sets of zones will still give some weight to
      <span style='color: #270075; font-weight:bold'>
      population density and known problem areas.</span></p>"
          ),
          fluidRow(
            align = "center",
            fontawesome::fa("city",
              fill = "#270075",
              height = "30px"
            ),
            fontawesome::fa(
              "building-circle-exclamation",
              fill = "#270075",
              height = "30px"
            )
          )
        ))
      ),

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
          "<p>
      <span style = 'font-family: Poppins, sans-serif; font-weight: bold; color: #270075;'>
      Weighting</span>
      is a way of calculating a score from many different types of numbers.
      You might remember taking a class where the
      final exam was worth half of your grade -- your teacher was using weighting."
        ),
        HTML(
          "<p>In addition to weighting, we are using
         <span style = 'font-family: Poppins, sans-serif; font-weight: bold; color: #270075;'>
         standardization
         </span>to
      put measures that exist on very different scales on even footing
      with one another. This ensures that priorities that measure in large numbers (like the number of
      transit boardings, our measure of transit activity) do not overwhelm
      priorites that are measured with smaller numbers,
      like the percentage of people who have a disability."
        )
      ),

      # Here's what that looks like ----
      br(),
      br(),
      fluidRow(
        HTML(
          "<h3><section style='font-family: Poppins, sans-serif;
      font-size:2rem; font-weight: bold; color: #270075'>
    Here's what that looks like on a map.
    </h3>"
        )
      ),

      ### Begin scroll ------
      scrolly_container(
        "scr",
        ### place map -----
        scrolly_graph(
          width = "50%",
          height = "100%",
          wellPanel(leafletOutput("mapBuild"))
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
            <span style = 'font-family: Poppins, sans-serif;
      font-weight: bold; color: #fcb900;'>
            high
      </span>
      to
       <span style = 'font-family: Poppins, sans-serif;
      font-weight: bold; color: #270075;'>
            low
      </span>
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
                height = "30px"
              ),
              fontawesome::fa("user-plus",
                fill = "#270075",
                height = "30px"
              ),
              fontawesome::fa("baby-carriage",
                fill = "#270075",
                height = "30px"
              ),
              fontawesome::fa("bus",
                fill = "#270075",
                height = "30px"
              ),
              fontawesome::fa("car",
                fill = "#270075",
                height = "30px"
              ),
              fontawesome::fa("city",
                fill = "#270075",
                height = "30px"
              ),
              fontawesome::fa(
                "building-circle-exclamation",
                fill = "#270075",
                height = "30px"
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
                height = "40px"
              ),
              fontawesome::fa("user-plus",
                fill = "#270075",
                height = "40px"
              )
            ),
            br(),
            fluidRow(
              align = "center",
              fontawesome::fa("city",
                fill = "#270075",
                height = "20px"
              ),
              fontawesome::fa(
                "building-circle-exclamation",
                fill = "#270075",
                height = "20px"
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
                height = "40px"
              ),
              fontawesome::fa("car",
                fill = "#270075",
                height = "40px"
              ),
              fontawesome::fa("bus",
                fill = "#270075",
                height = "40px"
              )
            ),
            br(),
            fluidRow(
              align = "center",
              fontawesome::fa("city",
                fill = "#270075",
                height = "20px"
              ),
              fontawesome::fa(
                "building-circle-exclamation",
                fill = "#270075",
                height = "20px"
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
            div(
              class = "label-left",
              s_dis,
              s_old,
              s_kid,
              s_den,
              s_zca,
              s_cta,
              s_bad
            )
          )
        )
      ),
      fluidRow(
        HTML(
          "<h3 style = 'font-size:2rem; font-family: Poppins, sans-serif;
      font-weight: bold; color: #270075;'>
          Now that we can see some broad areas of the city that
          meet our criteria,
          the next step is to draw some potential pilot zones.
            </h3>"
        ),
        HTML(
          "<p style = 'font-family: Poppins, sans-serif;
      font-weight: bold; color: #270075;'>
          Our draft ordinance has some extra rules about the
          how these zones are drawn.</p>"
        ),
        p("In the two pilot zones that prioritize people with disabilities:"),
        wellPanel(
          HTML(
            "<li>at least 100% of people should have an ambulatory (walking) disability,</li>
           <li>at least 100% of people should have a vision disability, and </li>
           <li>and at least 100% of people should be over 65</li>
           </li>"
          )
        ),
        br(),
        p(
          "A similar set of rules applies to zones that focus on children, transit, and households without cars:"
        ),
        wellPanel(
          HTML(
            "<li>at least 50% of people should be under 5,</li>
           <li>at least 50% of households should have no car</li>
           <li>transit activity (boardings plus alightings)
        should average at least 3,000 per day
           </li>"
          )
        ),
        HTML(
          "<p style = 'font-family: Poppins, sans-serif;
      font-weight: bold; color: #270075;'>
          These cutoffs would place our zones in the top
      25% of Chicago census tracts for each of the measures listed.</h3>"
        ),

        # Here's what that looks like 2 ----
        br(),
        br(),
        HTML(
          "<h3><section style='font-family: Poppins, sans-serif;
      font-size:2rem; font-weight: bold; color: #270075'>
    Scroll on to see some examples of pilot zones that meet
    these criteria,
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
            scrolly_section(
              id = "2_1",
              p("Some text")
            ),
            scrolly_section(
              id = "2_2",
              p("Some text")
            ),
            scrolly_section(
              id = "2_3",
              p("Some text")
            )
          )
        ))
      )
    ),
    # Tab 2: Tool ----
    tabPanel(
      title = "Mapping tool",
      id = "map_tab",
      fluidRow(
        id = "mapntools",
        column(5,
          id = "tools",
          tabsetPanel(
            type = "hidden",
            tabPanel(
              "Explore",
              shinyjs::extendShinyjs(text = jspolygon, functions = c("polygon_click")),
              tags$button(
                type = "button",
                id = "polygon_button",
                HTML(
                  fontawesome::fa("arrow-pointer",
                    height = "2rem",
                    fill = "#FFF"
                  ),
                  "Draw a pilot zone"
                ),
                style = "color:#FFF;
                     width:100%;
                         font-family: Poppins, sans-serif;
                         font-weight: bold;
                         background-color: #9b51e0",
                class = "btn action-button shiny-bound-input"
              ),
              HTML(
                "<h3 style = 'font-size:1.5rem;
                 font-family: Poppins, sans-serif;
                 font-weight: bold; color: #270075;'>
                 Use the sliders to color the map according to
                 your top priorities.
                 </h3>"
              ),
              div(
                class = "label-left",
                s_dis2,
                s_old2,
                s_kid2,
                s_den2,
                s_zca2,
                s_cta2,
                s_bad2
              )
            ),
            tabPanel(
              "Results",
              gt_output("scorecard")
            )
          )
        ),
        column(7,
          id = "map",
          tags$div(
            tags$style(type = "text/css", "#mapDraw {height: calc(80vh - 80px) !important;}"),
            leafletOutput("mapDraw", height = "100%", width = "100%")
          )
        )
      )
    ),

    # Tab 3: Draft ---
    tabPanel(
      title = "Draft Ordinance",
      id = "draft_tab",
      p("some text")
    ),



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
  # end tabset panel
) # end page
