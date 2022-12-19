navbarPage(
  "#PlowTheSidewalks Explorer",
  id = "nav",
  
  tabPanel(
    "Interactive map",
    div(
      class = "outer",
      
      tags$head(
        # include our custom CSS
        includeCSS("styles.css"),
        tags$head(
          tags$style(
            HTML(
              '.irs-from, .irs-to, .irs-min, .irs-max {visibility: hidden !important;}'
            )
          ),
          tags$style(type = "text/css", ".irs { max-height: 30px; }")
        )
      ),
      
      # If not using custom CSS, set height of leafletOutput to a number instead of percent
      leafletOutput("mapBuild", width = "100%", height =
                      "100%"),
      
      absolutePanel(
        id = "welcome",
        class = "panel panel-default",
        fixed = TRUE,
        draggable = FALSE,
        top = 200,
        left = "50%",
        right = "50%",
        bottom = "auto",
        width = 500,
        height = "auto",
        
        h2("Where should Chicago try municipal sidewalk plowing first?"),
        p("Use this tool to translate your priorities into a map of areas that could benefit most from snow- and ice-free sidewalks.")
      ),
      
      absolutePanel(
        id = "controls",
        class = "panel panel-default",
        fixed = TRUE,
        draggable = FALSE,
        top = 100,
        left = 50,
        right = "auto",
        bottom = "auto",
        width = 400,
        height = "auto",
        
        h3("Choose your criteria"),
        p(
          "Use the sliders to assign importance to each of these criteria:"
        ), 
        # Create sliders ------
        h4("Demographics"), 
        sliderInput(
          "s_vis",
          label = "People with vision disabilities",
          min = 0,
          max = 100,
          value = 20,
          step = 0.1,
          width = "300px",
          ticks = FALSE,
          post = "%"
        ),
        
        sliderInput(
          "s_amb",
          label = "People with ambulatory disabilities",
          min = 0,
          max = 100,
          value = 20,
          step = 0.1,
          width = "300px",
          ticks = FALSE,
          post = "%"
        ),
        
        sliderInput(
          "s_old",
          label = "Adults 65 and over",
          min = 0,
          max = 100,
          value = 20,
          step = 0.1,
          width = "300px",
          ticks = FALSE,
          post = "%"
        ),
        
        sliderInput(
          "s_kid",
          label = "Children under 5",
          min = 0,
          max = 100,
          value = 20,
          step = 0.1,
          width = "300px",
          ticks = FALSE,
          post = "%"
        ),
        br(),
        h4("Land use and transportation"), 
        sliderInput(
          "s_den",
          label = "Population density",
          min = 0,
          max = 100,
          value = 20,
          step = 0.1,
          width = "300px",
          ticks = FALSE,
          post = "%"
        ),
        
        sliderInput(
          "s_zca",
          label = "Zero-car households",
          min = 0,
          max = 100,
          value = 20,
          step = 0.1,
          width = "300px",
          ticks = FALSE,
          post = "%"
        ),
        
        sliderInput(
          "s_cta",
          label = "Transit activity",
          min = 0,
          max = 100,
          value = 20,
          step = 0.1,
          width = "300px",
          ticks = FALSE,
          post = "%"
        ),
        
        sliderInput(
          "s_bad",
          label = "Vacant buildings and unclear sidewalks",
          min = 0,
          max = 100,
          value = 20,
          step = 0.1,
          width = "300px",
          ticks = FALSE,
          post = "%"
        ),
        
        h3("Ready to map?"), 
        actionButton(inputId = "go_score", label = "Show results")
        
      )
    ),
  ),
  tabPanel("Data explorer")
)
