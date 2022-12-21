# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    col <- input$scr
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = col, border = 'white')
  })
  
  output$scr <- renderScrollytell({scrollytell()})
  output$section <- renderText(paste0("Section: ", input$scr))
  
  observe({cat("section:", input$scr, "\n")})
}