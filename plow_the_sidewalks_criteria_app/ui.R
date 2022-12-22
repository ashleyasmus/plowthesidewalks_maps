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
                 img(
                   src = "second-logo.png",
                   height = "100px",
                   alt = "Better streets logo",
                   class = "pull-right"
                 ),
                 HTML(
                   "<h1><section style='font-family: Poppins, sans-serif;
      font-size:4rem; font-weight: bold; color: #270075'>
    #Plow The Sidewalks pilot zone explorer</h3>"
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
    
    wellPanel(fluidRow(
      column(
        6,
        HTML(
          "<p style = 'text-align: center'>One set of zones will focus on
      <span style='color: #270075; font-weight:bold'>
      people with disabilities and elders</span></p>"
        ),
      fluidRow(
        align = 'center',
        fontawesome::fa(
          "wheelchair-move",
          fill = "#270075",
          height = '30px'
        ),
        fontawesome::fa("user-plus",
                        fill = "#270075",
                        height = '30px')
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
        align = 'center',
        fontawesome::fa("bus",
                        fill = "#270075",
                        height = '30px'),
        fontawesome::fa("car",
                        fill = "#270075",
                        height = '30px'),
        fontawesome::fa("baby-carriage",
                        fill = "#270075",
                        height = '30px'),
        
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
        align = 'center',
        fontawesome::fa(
          "city",
          fill = "#270075",
          height = '40px'
        ),
        fontawesome::fa("building-circle-exclamation",
                        fill = "#270075",
                        height = '40px')
      )
    ))),
    
    # Map our priorities -----
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
    class = "pull-down-right"
  )
)