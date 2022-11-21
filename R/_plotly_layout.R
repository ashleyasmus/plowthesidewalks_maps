plotly_margin <- list(
  l = 50,
  r = 50,
  b = 50,
  t = 80,
  pad = 0.5
)

hov_lab_list <- list(
  font = list(
    size = 18,
    family = "Arial Narrow",
    color = councilR::colors$suppWhite
  ),
  # bgcolor = "white",
  stroke = list(
    councilR::colors$suppGray,
    councilR::colors$suppGray,
    councilR::colors$suppGray,
    councilR::colors$suppGray
  ),
  padding = list(l = 5, r = 5, b = 5, t = 5)
)

plotly_layout <-
  function(a_plotly,
           x_title,
           y_title,
           main_title,
           subtitle,
           legend_title) {
    a_plotly %>%
      plotly::layout(
        margin = plotly_margin,
        barmode = "group",
        yaxis = list(
          title = list(
            text = y_title,
            font = list(
              family = "Arial Narrow",
              size = 20
            )
          ),
          tickfont = list(
            family = "Arial Narrow",
            size = 16
          )
        ),
        xaxis = list(
          tickfont = list(
            family = "Arial Narrow",
            size = 16
          ),
          title = list(
            text = x_title,
            font = list(
              family = "Arial Narrow",
              size = 20
            )
          )
        ),
        xaxis2 = list(
          tickfont = list(
            family = "Arial Narrow",
            size = 18
          ),
          title = list(
            text = x_title,
            font = list(
              family = "Arial Narrow",
              size = 24
            )
          )
        ),
        title = list(
          text = main_title,
          font = list(
            family = "Arial Narrow",
            size = 24
          ),
          x = 0,
          y = 1.1,
          xref = "paper",
          yref = "paper"
        ),
        annotations = list(
          list(
            text = subtitle,
            font = list(
              family = "Arial Narrow",
              size = 14
            ),
            x = 0,
            y = 1.15,
            xref = "paper",
            yref = "paper",
            showarrow = F
          )
        ),
        legend = list(
          title = list(
            text = legend_title,
            font = list(
              family = "Arial Narrow",
              size = 20
            )
          ),
          font = list(
            family = "Arial Narrow",
            size = 14
          )
        ),
        hovermode = "closest",
        hoverdistance = "10",
        hoverlabel = hov_lab_list
      )
  }
