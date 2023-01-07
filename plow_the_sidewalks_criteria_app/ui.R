ui <- bslib::page_fluid(
  title = "Where should we #PlowTheSidewalks first?",
  theme = bs_theme(version = 5, bootswatch = "pulse"),
  useShinyjs(),
  # css tags -----
  tags$head(
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css?family=Montserrat"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css?family=Poppins"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "irs_style.css"),
    tags$head(
      tags$script(
        '
                                var dimension = [0, 0];
                                $(document).on("shiny:connected", function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                                $(window).resize(function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                            '
      )
    ),
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
    )
  ),
  
  
  # About --------
  navs_bar(
    bg = "#270075",
    nav_item(
      class = "navbar-brand",
      HTML(
        "<h2
      style =
      'font-size: 1.5rem;
      font-weight: 300;
      color: white;
      background-color: #9b51e0;
      margin-top:0rem;
      margin-bottom:0rem;
      letter-spacing: 0.05rem;
      padding-left: 0.5rem;
      padding-right: 0.5rem;'>
       #PLOW THE SIDEWALKS </h2>"
      )
    ),
    # Footer ------
    footer = tags$div(
      style = "font-size: 1.5rem;
             display: block;
             text-align: right;
             padding: 1%;",
      align = "right",
      class = "pull-down-right",
      
      HTML(
        glue::glue(
          "<h6
          margin-top:0rem;
          margin-bottom:0rem;'>
          This project is open-source. See our GitHub repository here
          <a href ='https://github.com/ashleyasmus/plowthesidewalks_maps'
          target = '_blank'>
          {fontawesome::fa('arrow-up-right-from-square',
          fill = '#270075',
          height = '1.5rem')}
          </a><br>
          App last updated 2023-01-04
          </h6>"
        )
      ),
      tags$div(
        img(
          src = "main-logo.png",
          href = "https://www.betterstreetschicago.org/plow-the-sidewalks",
          height = "60px",
          alt = "Access Living",
          class = "float-right"
        ),
        img(
          src = "second-logo.png",
          href = "https://www.accessliving.org/defending-our-rights/accessible-transportation/plow-the-sidewalks-a-campaign-to-make-snow-clearance-a-municipal-responsibility/",
          height = "60px",
          alt = "Better Streets Chicago",
          class = "float-right"
        )
      ),
    ),
    nav(
      title = "About the pilot",
      id = "about_tab",
      
      ## Introduction -----
      div(
        class = "well",
        HTML(
          "<h3 style = 'margin-top: 0rem;
        margin-bottom: 0rem;'>Where should Chicago try municipal sidewalk plowing
              <span style='color: #9b51e0;'>first?</span></h3>"
        ),
        
        HTML(
          "<h4
          style = 'font-size: 1rem;
      font-weight: 500;
      color: #9b51e0;
      margin-top:0rem;
      margin-bottom:0rem;
      letter-spacing: 0.05rem;
      color: #9b51e0;'>
      An inititative of Better Streets Chicago and Access Living
      </span></h4>"
        )
      ),
      
      div(
        class = "row",
        p(
          "Better Streets Chicago and Access Living are drafting an ordinance asking Chicago
          to set aside $750,000 in the upcoming budget
          for a municipal sidewalk clearing pilot program.
          This pilot will serve as a small test of what a city-wide program
          could look like."
        ),
        HTML(
          "<p>The draft ordinance calls for the city to run the pilot in <b>four,
            2.5 square-mile zones</b> across the city, with an eye towards <b>mobility justice</b>.</p>"
        ),
        HTML(
          '<p><b>This page asks, "Where should we try sidewalk plowing first?"</b>
            Using our interactive tool, you can help us translate our priorities
            into a map of places where a test of sidewalk snow plowing would have greatest impact
            for the people that need it most.</p>'
        )
      ),
      ## Priorities table -----
      div(
        class = "row",
        HTML("<h3>Setting our priorities</h3>"),
        p(
          "To maximize the pilot program’s impact,
          we are asking the city to locate the pilot zones
          in a way that prioritizes:"
        )
      ),
      div(class = "well",
          priorites_tab),
      
      ## Static maps -----
      div(
        class = "row",
        HTML("<h3>
              Our priorities, mapped
              </h3>"),
        
        HTML(
          "<p>
            To help identify pilot zone araes
              that cross political, census, or other
              boundaries, we have mapped these populations
              and variables (e.g., transit boardings, 311 complaints)
              across the city in a grid of
              <b>
              half-square-mile areas (0.5 mi2)
              </b>.
            </p>"
        ),
        
        HTML(
          "<p>To enable easier comparison across variables
          with very different scales, we have
          we have <b>standardized</b> all our measures to
          <b>rank-percentiles</b> that range from 0 to 100. An area that ranks in the
          99th percentile for the share of people older than 65,
          for example, corresponds to a half-mile square area that
          ranks higher than 99% of the other half-mile square areas in Chicago
          for that measure.</p>"
        ),
        
        p(
          "South (Englewood) and West Chicago (Austin, Humboldt Park) tend to have the highest
          shares of people with ambulatory and vision disabilities.
          These areas overlap somewhat -- but not completely -- with
          the Chicago neighborhoods whose population skews older,
          which are located farther southside (e.g., Avalon Park)
          and in communities northwest (e.g., Jefferson Park)."
        )
      ),
      
      layout_column_wrap(
        width = 1 / 5,
        height = "350px",
        height_mobile = "300px",
        card(card_body_fill(img(src = "Rplot.png"),
                            class = "p-0 mx-auto mt-3")),
        card(
          card_header(
            align = "center",
            fontawesome::fa(
              "wheelchair-move",
              title = "People with ambulatory disabilities",
              fill = "#270075",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("ambmap"),
                         class = "p-0")
        ),
        card(
          card_header(
            align = "center",
            fontawesome::fa(
              "person-walking-with-cane",
              title = "People with vision disabilities",
              fill = "#270075",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("vismap"),
                         class = "p-0")
        ),
        card(
          card_header(
            align = "center",
            fontawesome::fa(
              "user-plus",
              fill = "#270075",
              title = "People 65 and older",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("oldmap"),
                         class = "p-0")
        ),
        card(
          card_header(
            align = "center",
            fontawesome::fa(
              "baby-carriage",
              fill = "#270075",
              title = "Children 5 and younger",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("kidmap"),
                         class = "p-0")
        )
      ),
      
      div(
        class = "row",
        p(
          "Meanwhile, the areas that
                   rank highest for the share of population under 5
                   are scattered across the City. Areas along the lake shore
                   rank lowest for under-5 populaton share."
        ),
        p(
          "As might be expected, areas that rank
              highest for transit activity
              are similar to those that have the lowest
              rates of household vehicle ownership.
              Clusters to the South and West sides show up, with additional
              areas along Lake Michigan."
        )
      ),
      
      layout_column_wrap(
        width = 1 / 5,
        height = "350px",
        height_mobile = "300px",
        card(
          card_header(
            align = "center",
            fontawesome::fa(
              "car-tunnel",
              title = "Households without cars",
              fill = "#270075",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("zcamap"),
                         class = "p-0")
        ),
        card(
          height = "300px",
          card_header(
            align = "center",
            fontawesome::fa(
              "bus",
              fill = "#270075",
              title = "Transit activity: boardings and alightings per square mile",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("ctamap"),
                         class = "p-0")
        ),
        
        card(
          height = "300px",
          card_header(
            align = "center",
            fontawesome::fa(
              "snowplow",
              fill = "#270075",
              title = "311 complaints of icy/snowy sidewalks",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("snomap"),
                         class = "p-0")
        ),
        
        card(
          height = "300px",
          card_header(
            align = "center",
            fontawesome::fa(
              "city",
              fill = "#270075",
              title = "Population density: people per square mile",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("denmap"),
                         class = "p-0")
        ),
        card(
          height = "300px",
          card_header(
            align = "center",
            fontawesome::fa(
              "building-circle-exclamation",
              title = "311 reports of vacant buildings per square  mile",
              fill = "#270075",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("vacmap"),
                         class = "p-0")
        )
      ),
      
      div(
        class = "row",
        p(
          "Areas with high rates of sidewalk snow removal requests to
            311 overlap neatly with the map of population density. This makes
            sense, given that dense areas tend to have more people who walk
            for transportation."
        )
      ),
      
      div(
        class = "row",
        p(
          "Areas with high rates of vacant building reports are concentrated on the south
            and west sides of the city. Though not a direct map of unshoveled sidewalks,
            we know that vacant buildings are rarely shoveled, a serious pitfall
            to our current system of sidewalk shoveling."
        )
      ),
      
      ## Two types of zones -----
      div(
        class = "row",
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
              of pilot zones, each based around a key
              constituency that will benefit most from sidewalk plowing:</p>"
        )
      ),
      
      ## Zone Type table -----
      div(
        class = "well",
        layout_column_wrap(width = 1 / 2,
                           card(
                             HTML(
                               "<p style = 'text-align: center; font-size:1.2rem'>One set of zones will focus on
                  <b>people with disabilities</b></p>"
                             ),
                  div(
                    class = "mx-auto",
                    align = "center",
                    fontawesome::fa(
                      "wheelchair-move",
                      fill = "#270075",
                      title = "People with ambulatory disabilities",
                      height = "2rem"
                    ),
                    
                    fontawesome::fa(
                      "person-walking-with-cane",
                      fill = "#270075",
                      title = "People with vision disabilities",
                      height = "2rem"
                    )
                  )
                           ),
                  card(
                    HTML(
                      "<p style = 'text-align: center; font-size:1.2rem'>A second set of zones will focus on
                      <b>dense neighborhoods and people who rely on transit</b></p>"
                    ),
                    div(
                      class = "mx-auto",
                      align = "center",
                      fontawesome::fa(
                        "city",
                        title = "Population density: people per square mile",
                        fill = "#270075",
                        height = "2rem"
                      ),
                      fontawesome::fa(
                        "bus",
                        fill = "#270075",
                        title = "Transit activity: boardings and alightings per square mile",
                        height = "2rem"
                      ),
                      fontawesome::fa(
                        "car-tunnel",
                        fill = "#270075",
                        title = "Households without cars",
                        height = "2rem"
                      )
                    )
                  )),
        card(
          HTML(
            "<p style = 'text-align: center; font-size:1.2rem'>
           Both sets of zones will consider
               <b> elders and children.
                </b></p>"
          ),
          div(
            class = "mx-auto",
            align = "center",
            fontawesome::fa(
              "user-plus",
              fill = "#270075",
              title = "People 65 and older",
              height = "2rem"
            ),
            fontawesome::fa(
              "baby-carriage",
              title = "Children 5 and younger",
              fill = "#270075",
              height = "2rem"
            )
          )
        ),
        card(
          HTML(
            "<p style = 'text-align: center; font-size:1.2rem'>
            311 complaints will also be considered, but to a lesser extent.<br>

            Transit-focused zones will consider <b>sidwewalk snow removal complaints</b>,
            While disability-focused zones will consider <b>vacant building reports</b>.</p>"
          ),
          div(
            class = "mx-auto",
            align = "center",
            fontawesome::fa(
              "building-circle-exclamation",
              title = "311 reports of vacant buildings per square  mile",
              fill = "#270075",
              height = "2rem"
            ),
            fontawesome::fa(
              "arrows-left-right",
              fill = "#270075",
              height = "2rem"
            ),
            fontawesome::fa(
              "snowplow",
              title = "311 complaints of icy/snowy sidewalks",
              fill = "#270075",
              height = "2rem"
            )
          )
        )
      ),
      
      
      
      ## Weighting -----
      div(
        class = "row",
        HTML(
          "<h3>We propose using a
                <span style='color: #9b51e0'>
                weighting approach
                </span>to
                identify places that might
                be a good fit for a pilot zone.</h3>"
        ),
        HTML(
          "<p><b>
              Weighting</b>
              calculates a single score from
              many different measures. Numerical
              importance values are assigned to each
              measure, with higher importance values
              given to measures with greater priority.
              You might remember taking a class where the
              final exam was worth half of your grade -- your teacher was using weighting.</p>"
        ),
        
        HTML(
          "<p>The concept is the same in our case: we'll assign higher importance values
             to our key population measures (e.g., the share of population with disabilities),
             and lower importance values to population density and 311 reports. We can
             then rank our half-square-mile areas according to their overall weighted scores for these
             measures."
        )
      ),
      
      
      div(
        class = "row",
        HTML(
          "<h3>
              Here's what our weighted priorities look like on the map.
              </h3>"
        )
      ),
      
      ### Begin scroll ------
      scrolly_container(
        "scr",
        ### place map -----
        scrolly_graph(
          width = "50%",
          height = "100vh",
          div(
            class = "well",
            style = "padding: 0;
                    margin-bottom:2rem;
                    margin-top:10px;
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
            div(
              class = "mx-auto",
              align = "center",
              fontawesome::fa(
                "wheelchair-move",
                fill = "#270075",
                title = "People with ambulatory disabilities",
                height = "2rem"
              ),
              fontawesome::fa(
                "person-walking-with-cane",
                title = "People with vision disabilities",
                fill = "#270075",
                height = "2rem"
              ),
              fontawesome::fa(
                "user-plus",
                fill = "#270075",
                title = "People 65 and older",
                height = "2rem"
              ),
              fontawesome::fa(
                "baby-carriage",
                title = "Children 5 and younger",
                fill = "#270075",
                height = "2rem"
              ),
              fontawesome::fa(
                "bus",
                fill = "#270075",
                title = "Transit activity: boardings and alightings per square mile",
                height = "2rem"
              ),
              fontawesome::fa(
                "car-tunnel",
                title = "Households without cars",
                fill = "#270075",
                height = "2rem"
              ),
              fontawesome::fa(
                "city",
                title = "Population density: people per square mile",
                fill = "#270075",
                height = "2rem"
              ),
              fontawesome::fa(
                "snowplow",
                title = "311 complaints of icy/snowy sidewalks",
                fill = "#270075",
                height = "2rem"
              ),
              fontawesome::fa(
                "building-circle-exclamation",
                title = "311 reports of vacant buildings per square  mile",
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
          problem areas
          and population density. In this case,
          we are using vacant building reports as our indicator
          of problem areas, owing to its overlap with the neighborhoods
          where people with disabilites live.
            </p>"
            ),
          div(
            class = "mx-auto",
            align = "center",
            fontawesome::fa(
              "wheelchair-move",
              title = "People with ambulatory disabilities",
              fill = "#270075",
              height = "6rem"
            ),
            fontawesome::fa(
              "person-walking-with-cane",
              title = "People with vision disabilities",
              fill = "#270075",
              height = "6rem"
            )
          ),
          br(),
          div(
            class = "mx-auto",
            align = "center",
            fontawesome::fa(
              "user-plus",
              fill = "#270075",
              title = "People 65 and older",
              height = "3rem"
            ),
            fontawesome::fa(
              "baby-carriage",
              fill = "#270075",
              title = "Children under 5",
              height = "3rem"
            ),
            fontawesome::fa(
              "building-circle-exclamation",
              title = "311 reports of vacant buildings per square  mile",
              fill = "#270075",
              height = "3rem"
            )
          ),
          br(),
          br()
          ),
          
          # ...3: transit ------
          scrolly_section(
            id = "transit",
            HTML(
              "<p>
            Finally, this map shows the areas with a
          high percentage of children, zero-car households,
          and transit activity, with less importance
          given to density and known problem areas. For this set of zones,
          we are using unclear sidewalk reports as our indicator of problem areas,
          owing to its overlap with transit activity.
            </p>"
            ),
          div(
            class = "mx-auto",
            align = "center",
            fontawesome::fa(
              "baby-carriage",
              title = "Children 5 and younger",
              fill = "#270075",
              height = "4rem"
            ),
            fontawesome::fa(
              "car-tunnel",
              title = "Households without cars",
              fill = "#270075",
              height = "4rem"
            ),
            fontawesome::fa(
              "bus",
              title = "Transit activity: boardings and alightings per square mile",
              fill = "#270075",
              height = "4rem"
            )
          ),
          br(),
          div(
            class = "mx-auto",
            align = "center",
            fontawesome::fa(
              "city",
              title = "Population density: people per square mile",
              fill = "#270075",
              height = "2rem"
            ),
            fontawesome::fa(
              "snowplow",
              title = "311 complaints of icy/snowy sidewalks",
              fill = "#270075",
              height = "2rem"
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
            s_amb,
            s_vis,
            s_old,
            
            s_kid,
            s_cta,
            s_zca,
            
            s_den,
            s_sno,
            s_vac
          ),
          br(),
          br(),
          br()
          )
        )
      ),
      
      # Zone rules  -----
      div(
        class = "row",
        HTML("<h3>From exploring neighborhoods to drawing zones</h3>"),
        HTML(
          "<p>Now that we can see some broad areas of the city that
          meet our criteria, the next step is to draw some potential pilot zones.
          Our draft ordinance has some extra rules about the
          how these zones are drawn.</p>"
        ),
        
        #...all zones: ----
        div(class = "row",
            div(
              class = "col-sm-6 offset-sm-3",
              offset = 3,
              div(
                class = "well",
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
                            title = 'Population density: people per square mile',
                            fill = '#270075',
                            height = '1.6rem')}
                      <b>38,000 residents</b></p>"
            )
          ),
          
          HTML(
            glue::glue(
              "<p style = 'font-size:1.2rem;'>{fontawesome::fa('snowplow',
                            fill = '#270075',
                            title = '311 complaints of icy/snowy sidewalks',
                            height = '1.6rem')}
                      <b>150 sidewalk snow removal complaints</b>
                     in the last 3 years</p>"
            )
          ),
          
          HTML(
            glue::glue(
              "<p style = 'font-size:1.2rem;'>{fontawesome::fa('building-circle-exclamation',
                            fill = '#270075',
                            title = '311 reports of vacant buildings per square  mile',
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
        div(
          class = "row",
          style = "margin-left:0px; padding: 0px;",
          #........disabilities rules -----
          div(class = "col-sm-6",
              div(
                class = "well",
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
                            title = 'People with ambulatory disabilities',
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
                            title = 'People with vision disabilities',
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
                            title = 'People 65 and older',
                            height = '1.6rem')}
                        At least <b>17%</b>
                       of people should be over 65</p>"
              )
            )
              )),
          #........transit/kids rules -----
          div(class = "col-sm-6 ms-auto",
              div(
                class = "well",
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
                             title = 'Children 5 and younger',
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
                            title = 'Transit activity: boardings and alightings per square mile',
                            height = '1.6rem')}
                        Transit activity should average at least <b>40,000</b>
                       boardings and alightings per day</p>"
                  )
                ),
                
                HTML(
                  glue::glue(
                    "<p style = 'font-size:1.2rem;'>
                         {fontawesome::fa('car-tunnel',
                            title = 'Households without cars',
                            fill = '#270075',
                            height = '1.6rem')}
                        At least <b>36%</b>
                        of households should have zero cars</p>"
                  )
                )
              ))
        )
      )
      
      
      # Here's what that looks like 2 ----
    ),
    # Tab 2: Tool ----
    
    nav(
      title = "Suggest a pilot zone",
      id = "map_tab",
      
      layout_column_wrap(
        width = 1 / 2,
        
        # panel with controls ----
        card(
          card_body_fill(
             class = "p-0",
             style = "padding-left: 0px;",
             full_screen = T,
             
             navs_tab_card(
               # well = FALSE,
               # widths = c(2, 10),
               # color = "#9b51e0",
               # contentWidth = 10,
               # id = "toolnav",
               #...sliders ----
               nav(
                 title = HTML(
                   glue::glue(
                     "{fontawesome::fa('scale-unbalanced-flip', height = '2rem')}<br>
                                        <p style = 'font-size:0.75rem'>
                  Weights</p>"
                   )
                 ),
                 id = "sliders",
                 HTML(
                   "<h4 style = 'font-size:1.2rem'>Color the map according to your priorities</h4>"
                 ),
                 # preset weights -----
                 HTML("<p><b>Use our pre-set weights: </b></p>"),
                 layout_column_wrap(width = 1/2,
                   card(
                     card_body_fill(
                     style = "margin-left: 0px; margin-right: 0px; padding: 5px",
                     tags$button(
                       type = "button",
                       id = "disability_button",
                       HTML(
                         fontawesome::fa(
                           "wheelchair-move",
                           height = "2rem",
                           title = "People with ambulatory disabilities",
                           fill = "#FFF"
                         ),
                         "Disability mix"
                       ),
                       style = "color:#FFF;
                     width:100%;
                         font-family: Poppins, sans-serif;
                         font-weight: bold;
                         background-color: #9b51e0",
                     class = "btn action-button shiny-bound-input"
                     )
                   )),
                   
                   card(
                     card_body_fill(style = "margin-left: 0px; margin-right: 0px; padding: 5px",
                     tags$button(
                       type = "button",
                       id = "transit_button",
                       HTML(
                         fontawesome::fa(
                           "bus",
                           title = "Transit activity: boardings and alightings per square mile",
                           height = "2rem",
                           fill = "#FFF"
                         ),
                         "Transit mix"
                       ),
                       style = "color:#FFF;
                     width:100%;
                         font-family: Poppins, sans-serif;
                         font-weight: bold;
                         background-color: #9b51e0",
                     class = "btn action-button shiny-bound-input"
                     )
                   ))
                 ),
                 
                 HTML("<p><b>Or create a custom set of weights:</b></p>"),
                 div(
                   class = "label-left",
                   s_amb2,
                   s_vis2,
                   s_old2,
                   
                   s_kid2,
                   s_zca2,
                   s_cta2,
                   
                   s_den2,
                   s_sno2,
                   s_vac2
                 )
               ),
               
               
               #....layers -----
               nav(
                 title = HTML(
                   glue::glue(
                     "{fontawesome::fa('layer-group', height = '2rem')}
                                        <br>
                                        <p style = 'font-size:0.8rem'>
                                        Layers</p>"
                   )
                 ),
                 
                 HTML(
                   "<h4 style = 'font-size:1.2rem'>View additional layers on the map</h4>"
                 ),
                 checkboxInput(
                   inputId = 'ward_layer',
                   label = "Ward boundaries",
                   value = FALSE
                 ),
                 checkboxInput(
                   inputId = 'sno_layer',
                   label = "311 Sidewalk Snow Removal Requests",
                   value = FALSE
                 ),
                 checkboxInput(
                   inputId = 'vac_layer',
                   label = "311 Vacant Building Reports",
                   value = FALSE
                 ),
                 checkboxInput(
                   inputId = 'l_stops_layer',
                   label = "L stations",
                   value = FALSE
                 )
                 
               ),
               
               nav(
                 title = HTML(
                   glue::glue(
                     "{fontawesome::fa('filter', height = '2rem')}<br>
                                        <p style = 'font-size:0.8rem'>
                                        Filters</p>"
                   )
                 ),
                 
                 #...filters ----
                 br(),
                 div(
                   class = "label-left",
                   id = "filtersliders",
                   tags$style(
                     " #filtersliders .irs-bar {
                    left: 0px;
                    width: 100%;
                  }
                  #filtersliders .irs-line {
                    left: 0px;
                    width: 100%;
                    top: 25px;
                    height: 8px;
                    border-top: 0px;
                    border-bottom: 0px;
                    background: linear-gradient(to right,
                    #0D0887, #47039F, #7301A8, #9C179E, #BD3786,
                    #D8576B, #ED7953, #FA9E3B, #FDC926, #F0F921);
                  }
                  #filtersliders .irs--shiny .irs-bar {
                    visibility: hidden;
                  }
                   #filtersliders .irs-handle {
                    top: 50%;
                   }
                  #filtersliders .irs-handle {
                    top: 50%;
                  }

                   #filtersliders .irs--shiny .irs-handle {
                    width: 20px;
                    height: 20px;
                    border: 1px solid #000;
                    background-color: white;
                    box-shadow: 1px 1px 1px #000, 0px 0px 1px #0d0d0d;
                    border-radius: 20px;
                  }

                  #filtersliders .irs--shiny .irs-from, .irs--shiny .irs-to, .irs--shiny .irs-single {
                      color: #270075;
                      text-shadow: none;
                      padding: 1px 3px;
                      font-family: Poppins, sans-serif;
                      background-color: transparent;
                      border-radius: 3px;
                      font-size: 0.8rem;
                      line-height: 1rem;
                    }
                    "
                   ),
                  HTML(
                    "<h4 style = 'font-size:1.2rem'>Filter by total score weighted by your priorities </h4>"
                  ),
                  
                  f_score,
                  
                  HTML(
                    "<h4 style = 'font-size:1.2rem'>Filter to areas by percentile rank (0-100) for individual measures</h4>"
                  ),
                  
                  f_amb,
                  f_vis,
                  f_old,
                  
                  f_kid,
                  f_zca,
                  f_cta,
                  
                  f_den,
                  f_sno,
                  f_vac
                 )
               ),
               
               nav(
                 title = HTML(
                   glue::glue(
                     "{fontawesome::fa('clipboard', height = '2rem')}<br>
                                        <p style = 'font-size:0.8rem'>
                                        Scores</p>"
                   )
                 ),
                 
                 #....score ----
                 
                 HTML(
                   "<p><b>
                                       Draw a zone to see how well your suggested pilot zone
                                       serves our priorities.
                                       </b></p>"
                 ),
                 gt_output("scorecard")
               )
             ))),
        
        #....map ----
        card(
          full_screen = T,
          class = "p-0",
          card_header(layout_column_wrap(
            width = 1 / 3,
            
            gap = "0.25rem",
            card(
              style = "--bs-card-spacer-y: 0rem;
                     --bs-card-spacer-x: 0rem;
                     --bs-card-title-spacer-y: 0rem;
                     --bs-card-border-width: 0px;
                     --bs-card-bg: transparent;
                     --bs-card-img-overlay-padding: 0rem;",
              card_body_fill(
                shinyjs::extendShinyjs(text = jspolygon, functions = c("polygon_click")),
                shinyjs::extendShinyjs(text = jsedit, functions = c("edit_click")),
                tags$button(
                  type = "button",
                  id = "polygon_button",
                  HTML(fontawesome::fa(
                    "pencil",
                    height = "2rem",
                    fill = "#FFF"
                  ),
                  "Draw"),
                  style = "color:#FFF;
                     width:100%;
                         font-family: Poppins, sans-serif;
                         font-weight: bold;
                  font-size: 0.8rem;
                         background-color: #9b51e0",
                  class = "btn action-button shiny-bound-input"
                )
              )
            ),
            card(
              style = "--bs-card-spacer-y: 0rem;
                     --bs-card-spacer-x: 0rem;
                     --bs-card-title-spacer-y: 0rem;
                     --bs-card-border-width: 0px;
                     --bs-card-bg: transparent;
                     --bs-card-img-overlay-padding: 0rem;",
              
              card_body_fill(
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
                  font-size: 0.8rem;
                         background-color: #9b51e0",
                  class = "btn action-button shiny-bound-input"
                )
              )
            ),
            
            card(
              style = "--bs-card-spacer-y: 0rem;
                     --bs-card-spacer-x: 0rem;
                     --bs-card-title-spacer-y: 0rem;
                     --bs-card-border-width: 0px;
                     --bs-card-bg: transparent;
                     --bs-card-img-overlay-padding: 0rem;",
              
              card_body_fill(
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
                         font-size: 0.8rem;
                         font-family: Poppins, sans-serif;
                         font-weight: bold;
                         background-color: #9b51e0",
                  class = "btn action-button shiny-bound-input"
                )
              )
            )
          )),
          # end buttons
          card_body_fill(leafglOutput("mapDraw"))
        )
        
      )
    ),
    
    
    
    # Tab 3: Draft ---
    nav(title = "Read the draft ordinance",
        id = "draft_tab",
        p("some text"))
    
    
  )
)
