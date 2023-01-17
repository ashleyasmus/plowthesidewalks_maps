ui <- bslib::page_fluid(
  title = "#PlowTheSidewalks Pilot",
  theme = bs_theme(version = 5, bootswatch = "pulse"),
  useShinyjs(),
  # css tags -----
  tags$head(
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css?family=Montserrat"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css?family=Poppins"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "irs_style.css"),
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
          title = 'Go to link',
          fill = '#270075',
          height = '1.5rem')}
          </a><br>
          App last updated 2023-01-09
          </h6>"
        )
      ),
      tags$div(
        img(
          src = "access_living_logo.png",
          href = "https://www.betterstreetschicago.org/plow-the-sidewalks",
          height = "60px",
          alt = "Access Living",
          class = "float-right"
        ),
        img(
          src = "better_streets_logo.png",
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
              <span style=
        'text-decoration: underline;
        text-decoration-thickness: 0.4rem;
        text-decoration-color: #9b51e0;'>first</span>?</h3>"
        ),
        HTML(
          "<h4
          style = 'font-size: 1rem;
      font-weight: 500;
      margin-top:0rem;
      margin-bottom:0rem;
      letter-spacing: 0.05rem;
      color: #270075;'>
      An initiative of Better Streets Chicago and Access Living
      </span></h4>"
        )
      ),
      div(
        class = "row mt-3",
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
        class = "row mt-3",
        HTML("<h3>Setting our priorities</h3>"),
        p(
          "To maximize the pilot program’s impact,
          we are asking the city to locate the pilot zones
          in a way that prioritizes:"
        )
      ),
      
      div(
        class = "well",
        priorities_tab
      ),

      


      ## Static maps -----
      div(
        class = "row mt-3",
        HTML("<h3>
              Our priorities, mapped
              </h3>"),
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
        height_mobile = "225px",
        card(
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
          card_body_fill(img(src = "legend.png",
                             alt = "Color legend for the maps in this section.
                                    Title: Percentile rank. 
                                    90-100 (high) values are in dark purple.
                                    0-10 (low) values are in light yellow. 
                                    Values in the middle span from light orange to deep magenta."),
            class = "p-0 mx-auto mt-3"
          )
        ),
        card(
          full_screen = T,
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
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
            class = "p-0"
          )
        ),
        card(
          full_screen = T,
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
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
            class = "p-0"
          )
        ),
        card(
          full_screen = T,
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
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
            class = "p-0"
          )
        ),
        card(
          full_screen = T,
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
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
            class = "p-0"
          )
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
        width = 1 / 6,
        height = "350px",
        height_mobile = "225px",
        card(
          full_screen = T,
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-color: transparent;
                --bs-card-bg: transparent;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
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
            class = "p-0"
          )
        ),
        card(
          full_screen = T,
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-color: transparent;
                --bs-card-bg: transparent;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
          card_header(
            align = "center",
            fontawesome::fa(
              "circle-dollar-to-slot",
              title = "Households without low incomes",
              fill = "#270075",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("incmap"),
            class = "p-0"
          )
        ),
        card(
          full_screen = T,
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
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
            class = "p-0"
          )
        ),
        card(
          full_screen = T,
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
          height = "300px",
          card_header(
            align = "center",
            fontawesome::fa(
              "snowplow",
              fill = "#270075",
              title = "311 reports of icy/snowy sidewalks",
              height = "1.5rem"
            )
          ),
          card_body_fill(plotOutput("snomap"),
            class = "p-0"
          )
        ),
        card(
          full_screen = T,
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
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
            class = "p-0"
          )
        ),
        card(
          full_screen = T,
          style = "--bs-card-spacer-y: 0rem;
                --bs-card-spacer-x: 0rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-width: 0;
                --bs-card-border-color: transparent;
                --bs-card-border-radius: 0rem;
                --bs-card-inner-border-radius: 0rem;
                --bs-card-cap-padding-y: 0rem;
                --bs-card-cap-padding-x: 1rem;
                --bs-card-cap-bg: transparent;
                --bs-card-bg: #fff;
                --bs-card-img-overlay-padding: 1rem;
                --bs-card-group-margin: 0rem;",
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
            class = "p-0"
          )
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
            <span style=
        'text-decoration: underline;
        text-decoration-color: #9b51e0;
        text-decoration-thickness: 0.4rem;'>
            all
            </span>of these priorities at once</h3>"
        ),
        HTML(
          "<p>That is why we are suggesting the city take a
              measured approach to the problem
              of pilot zone placement, and create
              <b>
              two types</b>
              of pilot zones, each based around a key
              constituency that will benefit most from sidewalk plowing:</p>"
        )
      ),

      ## Zone Type table -----
      div(
        class = "well p-3",
        layout_column_wrap(
          width = 1 / 2,
          card(
            style = "--bs-card-spacer-y: 0.5rem;
                     --bs-card-spacer-x: 0rem;
                     --bs-card-title-spacer-y: 0rem;
                     --bs-card-border-width: 0px;
                     --bs-card-bg: transparent;
                     --bs-card-img-overlay-padding: 0rem;",
            HTML(
              "<p style = 'text-align: center; font-size:1.2rem'>Two zones will focus on
                  <b>people with disabilities</b></p>"
            ),
            div(
              class = "mx-auto",
              align = "center",
              fontawesome::fa(
                "wheelchair-move",
                fill = "#270075",
                title = "People with ambulatory disabilities",
                height = "4rem"
              ),
              fontawesome::fa(
                "person-walking-with-cane",
                fill = "#270075",
                title = "People with vision disabilities",
                height = "4rem"
              )
            )
          ),
          card(
            style = "--bs-card-spacer-y: 0.5rem;
                     --bs-card-spacer-x: 0rem;
                     --bs-card-title-spacer-y: 0rem;
                     --bs-card-border-width: 0px;
                     --bs-card-bg: transparent;
                     --bs-card-img-overlay-padding: 0rem;",
            HTML(
              "<p style = 'text-align: center; font-size:1.2rem'>Two zones will focus on
                      <b>dense neighborhoods</b></p>"
            ),
            div(
              class = "mx-auto p-0",
              align = "center",
              fontawesome::fa(
                "city",
                title = "Population density: people per square mile",
                fill = "#270075",
                height = "4rem"
              )
            )
          )
        ),
        card(
          style = "--bs-card-spacer-y: 0.5rem;
                     --bs-card-spacer-x: 0rem;
                     --bs-card-title-spacer-y: 0rem;
                     --bs-card-border-width: 0px;
                     --bs-card-bg: transparent;
                     --bs-card-img-overlay-padding: 0rem;",
          HTML(
            "<p style = 'text-align: center; font-size:1.2rem'>
            All four zones will be selected in a way that also considers
            <b>elders, children, zero-car households, and low-income households
                </b></p>"
          ),
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
              title = "Children 5 and younger",
              fill = "#270075",
              height = "3rem"
            ),
            fontawesome::fa(
              "bus",
              fill = "#270075",
              title = "Transit activity: boardings and alightings per square mile",
              height = "3rem"
            ),
            fontawesome::fa(
              "car-tunnel",
              fill = "#270075",
              title = "Households without cars",
              height = "3rem"
            ),
            fontawesome::fa(
              "circle-dollar-to-slot",
              title = "Households without low incomes",
              fill = "#270075",
              height = "3rem"
            )
          )
        ),
        card(
          style = "--bs-card-spacer-y: 0.5rem;
                     --bs-card-spacer-x: 0rem;
                     --bs-card-title-spacer-y: 0rem;
                     --bs-card-border-width: 0px;
                     --bs-card-bg: transparent;
                     --bs-card-img-overlay-padding: 0rem;",
          HTML(
            "<p style = 'text-align: center; font-size:1.2rem'>
            311 reports of vacant lots and snowy sidewalks will also
            be considered, but to a lesser extent."
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
              "snowplow",
              title = "311 reports of icy/snowy sidewalks",
              fill = "#270075",
              height = "2rem"
            )
          )
        )
      ),



      


      ### Begin scroll ------
      scrolly_container(
        "scr",
        ### place map -----
        scrolly_graph(
          width = "50%",
          height = "90vh",
          card(
            style = "padding: 0;
                    height = '90vh';
                    margin-bottom:2rem;
                    margin-top:10px;
                    background-color: transparent;
                    border: 2px solid #270075;",
            leafletOutput("mapBuild",
              height = "90vh"
            )
          )
        ),
        ### scroll sections -----
        scrolly_sections(
          width = "45%",

          # ...1: Equal priorities ------
          scrolly_section(
            id = "equal",
            HTML(
              "<h3>
              Here's what our weighted priorities look like on the map.
              </h3>"
            ),
            HTML(
              "<p>
            The map on the right scores neighborhoods from
            <b style = '
              color: white;
              background-color: #0D0887;
              margin-top:0rem;
              margin-bottom:0rem;
              letter-spacing: 0.05rem;
              padding-left: 0.5rem;
              padding-right: 0.5rem;'>
             high
            </b>
             to
            <b style = '
              color: black;
              background-color: #F0F921;
              margin-top:0rem;
              margin-bottom:0rem;
              letter-spacing: 0.05rem;
              padding-left: 0.5rem;
              padding-right: 0.5rem;'>
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
                "circle-dollar-to-slot",
                title = "Households without low incomes",
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
                title = "311 reports of icy/snowy sidewalks",
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
          with less weight given to elders, children, transit activity,
          zero-car households and low-income households. Vacant building reports and
          snow removal reports are also in this mix, but are assigned
          a lower importance value than other demographic factors.
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
                title = "Children 5 and younger",
                fill = "#270075",
                height = "3rem"
              ),
              fontawesome::fa(
                "bus",
                fill = "#270075",
                title = "Transit activity: boardings and alightings per square mile",
                height = "3rem"
              ),
              fontawesome::fa(
                "car-tunnel",
                fill = "#270075",
                title = "Households without cars",
                height = "3rem"
              ),
              fontawesome::fa(
                "circle-dollar-to-slot",
                title = "Households without low incomes",
                fill = "#270075",
                height = "3rem"
              )
            ),
            br(),
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
                "snowplow",
                title = "311 reports of icy/snowy sidewalks",
                fill = "#270075",
                height = "2rem"
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
          given to density and known problem areas. Once again,
          indicators of known problem areas are included, but weighted to a lesser
          extent than our demographic variables.
            </p>"
            ),
            div(
              class = "mx-auto",
              align = "center",
              fontawesome::fa(
                "city",
                title = "Population density: people per square mile",
                fill = "#270075",
                height = "4rem"
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
                title = "Children 5 and younger",
                fill = "#270075",
                height = "3rem"
              ),
              fontawesome::fa(
                "bus",
                fill = "#270075",
                title = "Transit activity: boardings and alightings per square mile",
                height = "3rem"
              ),
              fontawesome::fa(
                "car-tunnel",
                fill = "#270075",
                title = "Households without cars",
                height = "3rem"
              ),
              fontawesome::fa(
                "circle-dollar-to-slot",
                title = "Households without low incomes",
                fill = "#270075",
                height = "3rem"
              )
            ),
            br(),
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
                "snowplow",
                title = "311 reports of icy/snowy sidewalks",
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
              s_inc,
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

        # ...all zones: ----
        div(
          class = "row",
          div(
            class = "col-sm-6 offset-sm-3",
            offset = 3,
            card(
              style = "padding: 1rem;
                  margin-top: 0.5rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-color: #270075;
                --bs-card-bg: #F9F9F9;",
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
              )
            )
          )
        ),
        HTML(
          "<p>
          These additional cutoffs are set at the <b>75th percentile</b> for each measure, compared across
          all Chicago census tracts.
          In other words, if our pilot zones were ranked against all Chicago census tracts,
          it would rank in the <b>top 25 percent.</b></p>"
        ),

        # ...special zones -----
       layout_column_wrap(
         width = 1/2,
          # ........disabilities rules -----
          card(
            style = "padding: 1rem;
                  margin-top: 0.5rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-color: #270075;
                --bs-card-bg: #F9F9F9;",
              HTML(
                "<p style = 'text-align:center;
            font-size:1.4rem'><b>In the two pilot zones that
            prioritize people with disabilities should contain: </b></p>"
              ),
              HTML(
                glue::glue(
                  "<p style = 'font-size:1.2rem'>
                       {fontawesome::fa('wheelchair-move',
                            fill = '#270075',
                            title = 'People with ambulatory disabilities',
                            height = '1.6rem')}
                      At least 9%
                       of people <b>(approximately 15,000 people)</b> with an ambulatory (walking)
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
                        At least 3%
                       of people <b>(approximately 5,000 people)</b> with a vision
                       disability</p>"
                )
              )
            ),
          # ........transit/kids rules -----
          card(
            style = "padding: 1rem;
                  margin-top: 0.5rem;
                --bs-card-title-spacer-y: .5rem;
                --bs-card-border-color: #270075;
                --bs-card-bg: #F9F9F9;",
              HTML(
                "<p style = 'text-align:center; font-size:1.4rem'><b>
                 In the two pilot zones focusing on dense neighborhoods:</b></p>"
              ),
              HTML(
                glue::glue(
                  "<p style = 'font-size:1.2rem;'>
                         {fontawesome::fa('city',
                            title = 'Population density',
                            fill = '#270075',
                            height = '1.6rem')}
                        Population density should exceed 11,000 people
                    per square mile, for a total of
                    <b>29,000 to 35,000 residents</b> in a 2.5-to-3 square mile zone.</p>"
                )
              )
            )
      ))),
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
              # ...sliders ----
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
                layout_column_wrap(
                  width = 1 / 2,
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
                    )
                  ),
                  card(
                    card_body_fill(
                      style = "margin-left: 0px; margin-right: 0px; padding: 5px",
                      tags$button(
                        type = "button",
                        id = "density_button",
                        HTML(
                          fontawesome::fa(
                            "city",
                            title = "Population density",
                            height = "2rem",
                            fill = "#FFF"
                          ),
                          "Density mix"
                        ),
                        style = "color:#FFF;
                     width:100%;
                         font-family: Poppins, sans-serif;
                         font-weight: bold;
                         background-color: #9b51e0",
                        class = "btn action-button shiny-bound-input"
                      )
                    )
                  )
                ),
                HTML("<p><b>Or create a custom set of weights:</b></p>"),
                div(
                  class = "label-left",
                  s_amb2,
                  s_vis2,
                  s_old2,
                  s_kid2,
                  s_zca2,
                  s_inc2,
                  s_cta2,
                  s_den2,
                  s_sno2,
                  s_vac2
                )
              ),


              # ....layers -----
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
                  inputId = "ward_layer",
                  label = "Ward boundaries",
                  value = FALSE
                ),
                checkboxInput(
                  inputId = "sno_layer",
                  label = "311 Sidewalk Snow Removal Requests",
                  value = FALSE
                ),
                checkboxInput(
                  inputId = "vac_layer",
                  label = "311 Vacant Building Reports",
                  value = FALSE
                ),
                checkboxInput(
                  inputId = "l_stops_layer",
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

                # ...filters ----
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
                    background: linear-gradient(to left,
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
                  f_inc,
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

                # ....score ----

                HTML(
                  "<p><b>
                                       Draw a zone to see how well your suggested pilot zone
                                       serves our priorities.
                                       </b></p>"
                ),
                gt_output("scorecard")
              )
            )
          )
        ),

        # ....map ----
        card(
          full_screen = T,
          class = "p-0",
          card_header(
            layout_column_wrap(
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
                    HTML(
                      fontawesome::fa(
                        "pencil",
                        height = "2rem",
                        fill = "#FFF"
                      ),
                      "Draw"
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
                    id = "edit_button",
                    HTML(
                      fontawesome::fa("pen-to-square",
                        height = "2rem",
                        fill = "#FFF"
                      ),
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
                        fill = "#FFF"
                      ),
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
            )
          ),
          # end buttons
          card_body_fill(leafglOutput("mapDraw"))
        )
      )
    ),
    
    nav(
      title = "Data sources & methods",
      id = "data_tab",
      ## Rank percentiles introduced -----
      div(
        class = "row mt-5",
        HTML("<h3>
              Data sources and methods
              </h3>"),
        HTML(
          "<p><b>Data sources.</b>
          We relied on a mix of publicly-available data for this project.
          The <a href = 'https://www.census.gov/data/developers/data-sets/acs-5year.html'>
          Census' American Community Survey (ACS)</a>,
          mapped at the tract level and averaged over the
          five years from 2016 to 2021, was our main source of
          demographic information, including
          car ownership,
          disability status,
          population,
          and population by age.
          To measure transit activity, we
          summed the number of average weekday boardings
          and alightings
          for each transit stop, as reported in
          <a href = 'https://data.cityofchicago.org/Transportation/CTA-Ridership-Avg-Weekday-Bus-Stop-Boardings-in-Oc/mq3i-nnqe'>
          CTA's October 2012 Average Weekday Bus Stop dataset</a> [data update pending].
          Finally, we used
          <a href = 'https://data.cityofchicago.org/Service-Requests/311-Service-Requests/v6vf-nfxy'>
          the City's 311 reports database to find indicators of known problem areas,
          </a> filtering to sidewalk snow and ice reports and vacant building reports, December 2018 to present.
          </p>"
        ),
        HTML(
          "<p>
          <b>Data standardization.</b>
          To enable easier comparison across variables
          with very different scales, we have
          we have <b>standardized</b> all our measures to
          <b>rank-percentiles</b> that range from 0 to 100. A neighborhood
          that ranks in the
          99th percentile for the share of people older than 65,
          for example, corresponds to a half-mile square area that
          ranks higher than 99% of the other half-mile square areas in Chicago
          for that measure.</p>"
        ),
        HTML(
          "<p>
          <b>Map boundaries.</b>
            To help identify pilot zone areas
              that cross political, census, or other
              boundaries, we have mapped these populations
              and variables (e.g., transit boardings, 311 reports)
              across the city in a uniform grid where each cell is
              <b>
              a half-square-mile (0.5 mi<sup>2</sup>).
              </b> There are about 32 city blocks
              in a half-square mile. A pilot zone (2.5 to 3 square miles)
              would encompass approximately five to six half-square-mile areas.
            </p>"
        ),
        HTML(glue::glue(
          "<p>
            All of our sources and methods - including this website- are open-source, written in the R
          programming language.
            You can comment and collaborate on our GitHub repository here
          <a href ='https://github.com/ashleyasmus/plowthesidewalks_maps',
          target = '_blank'>
          {fontawesome::fa('arrow-up-right-from-square',
          fill = '#270075',
          title = 'Go to link',
          height = '1.2rem')}
          </a></p>"
        ))
      ),
      
      ## Weighting -----
      div(
        class = "row",
        HTML(
          "<h3>About weighted scores</h3>"
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
      
    )



    # # Tab 3: Draft ---
    # nav(
    #   title = "Read the draft ordinance",
    #   id = "draft_tab",
    #   p("some text")
    # )
  )
)
