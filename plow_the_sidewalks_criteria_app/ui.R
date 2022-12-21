ui <- fluidPage(
  fresh::use_googlefont("Montserrat"),
  fresh::use_googlefont("Poppins"),
  fresh::use_theme(my_fresh_theme),
  tags$head(
    # tags$link(rel = "stylesheet", href = "style.css"),
    tags$link(
      rel = "stylesheet",
      href = "https://use.fontawesome.com/releases/v5.8.1/css/all.css",
      integrity = "sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf",
      crossorigin = "anonymous"
    )
  ),
  position = "fixed-top",
  
  # Title panel -------
  titlePanel(title =
               div(
                 img(
                   src = "main-logo.png",
                   height = "100px",
                   alt = "Access Living logo",
                   class = "pull-right"
                 ),
                 HTML(
                   "<h1><section style='font-family: Poppins, sans-serif;
      font-size:4rem; font-weight: bold; color: #270075'>
    #PlowTheSidewalks pilot zone explorer</h3>"
                 )
               ),
    windowTitle = "Where should we #PlowTheSidewalks first?"),
  
  # Main panel --------
  mainPanel(
    ## Intro -------
    wellPanel(
      HTML(
        "<h2><section style='font-family: Poppins, sans-serif;
      font-size:20pt;
      font-weight: bold; color: #270075; line-height = 2;'>
      Let’s make
      <span><section style='color: #9b51e0;'>
      sidewalk snow and ice removal
      </span>
      <span><section style='color: #270075;'>
      a municipal service.
      </span></h2>"
      ),
      p("An inititative of Better Streets Chicago and Access Living"),
    ),
    ## About --------
    fluidRow(
      HTML(
        "<h3><section style='font-family: Poppins, sans-serif;
      font-size:2rem; font-weight: bold; color: #270075'>
    Where should Chicago try municipal sidewalk plowing first?</h3>"
      ),
    p(
      "We are drafting an ordinance asking Chicago
          to set aside $750,000 in the upcoming budget
          for a municipal sidewalk clearing pilot program –
          a small test of what a city-wide program will look like."
    ),
    p(
      "This interactive page explores where that pilot program should occur --
      and how to prioritize communities in the process."
    )),
    ## 1: Priorities -----
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
    Finding places that match all of these priorities is probably
    impossible</h3>"
      ),
    p(
      "To maximize the pilot program’s impact,
          we are asking the city to locate the pilot zones
          in a way that prioritizes:"
    ),
    
    wellPanel(p("Some maps by priority"))
    ),
    
    # 2: Priorities, mapped -----
    fluidRow(scrolly_container(
      "scr",
      scrolly_graph(textOutput("section"),
                    plotOutput("distPlot"))
      ,
      scrolly_sections(
        scrolly_section(
          id = "green",
          sliderInput(
            "bins",
            "Number of bins:",
            min = 1,
            max = 50,
            value = 30
          )
        ),
        scrolly_section(
          id = "red",
          h3("Title"),
          p("dit is een paragraaf, die de grafiek rood maakt")
        ),
        scrolly_section(id = "blue", "Blauw"),
        scrolly_section(id = "pink", "Rose"),
        scrolly_section(id = "purple", "Paars"),
        scrolly_section(id = "orange", "Oranje boven!")
      )
    ))
  ),
  tags$div(
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
    class = "pull-down"
  )
)