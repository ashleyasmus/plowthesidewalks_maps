ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "style.css"),
    tags$link(
      rel = "stylesheet",
      href = "https://use.fontawesome.com/releases/v5.8.1/css/all.css",
      integrity = "sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf",
      crossorigin = "anonymous"
    )
  ),
  
  shticky::use_shticky(),
  waypointer::use_waypointer(),
  
  # Keep the  map stuck on the right -----
  div(
    id = "bg",
    div(id = "stick",
        style = "position:fixed;width:100%;",
        fluidRow(column(5),
                 column(
                   7, leafletOutput("mapBuild", width = "100%", height = "100vh")
                 ))),
    
    
    # Marker 0: Welcome ----
    longdiv(style = "width:100%;",
            div(id = "m0",
                fluidRow(
                  column(1),
                  column(4, uiOutput("ui0"))
                ))),
    
    # Marker 1: Priorities -----
    longdiv(style = "width:100%;",
            div(id = "m1",
                fluidRow(
                  column(1),
                  column(4, uiOutput("ui1"))
                ))),
    
    # Marker 2: Equal Weights -------
    longdiv(style = "width:100%;",
            div(id = "m2",
                fluidRow(
                  column(1),
                  column(4, uiOutput("ui2"))
                ))),
    
    
    
    # Marker 3: Sliders -------
    longdiv(style = "width:100%;",
            div(id = "m3",
                fluidRow(
                  column(1),
                  column(4, uiOutput("ui3"))
                ))),
    
    # Marker 4 ----------
    longdiv(style = "width:100%;",
            div(id = "m4",
                fluidRow(
                  column(1),
                  column(4, uiOutput("ui4"))
                ))),
    
    # Marker 5 --------
    longdiv(style = "width:100%;",
            div(id = "m5",
                fluidRow(
                  column(1),
                  column(4, uiOutput("ui5"))
                ))),
    
    # Marker 6 -------
    longdiv(style = "width:100%;",
            div(id = "m6",
                fluidRow(
                  column(1),
                  column(4, uiOutput("ui6"))
                )))
  )
)