theme_access_insta <-
  function(base_size = 11,
           base_family = "",
           base_line_size = base_size / 22,
           base_rect_size = base_size / 22,
           font_sizes = list(
             title = 48,
             subtitle = 30,
             axis_title = 22,
             axis_text = 22,
             legend_title = 22,
             legend_text = 22,
             caption = 18,
             strip = 30
           )) {
    requireNamespace("sysfonts", quietly = TRUE)
    requireNamespace("showtext", quietly = TRUE)
    showtext::showtext_auto()
    

    font_families <-
      list(
        "title" = "Montserrat",
        "subtitle" = "Montserrat",
        "axis_title" = "Montserrat",
        "axis_text" = "Montserrat",
        "legend_title" = "Montserrat",
        "legend_text" = "Montserrat",
        "caption" = "Montserrat",
        "strip" = "Montserrat"
      )

    
    
    half_line <- base_size / 2
    t <-
      theme(
        line = ggplot2::element_line(
          colour = colors$black,
          size = base_line_size,
          linetype = 1,
          lineend = "butt"
        ),
        rect = ggplot2::element_rect(
          fill = colors$white,
          colour = colors$black,
          size = base_rect_size,
          linetype = 1
        ),
        text = ggplot2::element_text(
          family = base_family,
          face = "plain",
          colour = colors$black,
          size = base_size,
          lineheight = 0.25,
          hjust = 0.5,
          vjust = 0.5,
          angle = 0
        ),
        # margin = ggplot2::margin(),
        axis.line = ggplot2::element_blank(),
        axis.line.x = NULL,
        axis.line.y = NULL,
        axis.text = ggplot2::element_text(
          family = font_families$axis,
          size = font_sizes$axis_text,
          color = "gray30"
        ),
        axis.text.x = ggplot2::element_text(
          size = font_sizes$axis_text,
          family = font_families$axis_text,
          margin = ggplot2::margin(t = 0.8 *
            half_line /
            2),
          vjust = 0.5
        ),
        axis.text.x.top = ggplot2::element_text(
          size = font_sizes$axis_text,
          family = font_families$axis_text,
          margin = ggplot2::margin(b = 0.8 *
            half_line /
            2),
          vjust = 0
        ),
        axis.text.y = ggplot2::element_text(
          size = font_sizes$axis_text,
          family = font_families$axis_text,
          margin = ggplot2::margin(r = 0.8 *
            half_line /
            2),
          hjust = 1
        ),
        axis.text.y.right = ggplot2::element_text(
          size = font_sizes$axis_text,
          family = font_families$axis_text,
          margin = ggplot2::margin(l = 0.8 *
            half_line /
            2),
          hjust = 0
        ),
        axis.ticks = element_blank(),
        axis.ticks.length = ggplot2::unit(half_line / 2, "pt"),
        axis.ticks.length.x = NULL,
        axis.ticks.length.x.top = NULL,
        axis.ticks.length.x.bottom = NULL,
        axis.ticks.length.y = NULL,
        axis.ticks.length.y.left = NULL,
        axis.ticks.length.y.right = NULL,
        axis.title.x = element_blank(),
        axis.title.y = ggplot2::element_text(
          angle = 0,
          family = font_families$axis_title,
          size = font_sizes$axis_title,
          margin = ggplot2::margin(r = half_line / 2),
          vjust = 0.5
        ),
        axis.title.y.right = ggplot2::element_text(
          family = font_families$axis_title,
          size = font_sizes$axis_title,
          margin = ggplot2::margin(l = half_line /
            2),
          vjust = 0.5,
          angle = 0
        ),
        legend.background = ggplot2::element_blank(),
        legend.spacing = ggplot2::unit(half_line, "pt"),
        legend.spacing.x = ggplot2::unit(half_line / 1.5, "pt"),
        legend.spacing.y = ggplot2::unit(half_line, "pt"),
        legend.margin = ggplot2::margin(
          half_line,
          half_line,
          half_line,
          half_line
        ),
        legend.key = ggplot2::element_blank(),
        legend.key.size = ggplot2::unit(0.6, "lines"),
        legend.key.height = NULL,
        legend.key.width = NULL,
        legend.text = ggplot2::element_text(
          size = font_sizes$legend_text,
          family = font_families$legend_text
        ),
        legend.text.align = NULL,
        legend.title = element_blank(),
        legend.title.align = NULL,
        legend.position = "top",
        legend.justification = c(0, 0),
        legend.box = NULL,
        legend.box.margin = ggplot2::margin(0, 0, 0, 0, "cm"),
        legend.box.background = ggplot2::element_blank(),
        legend.box.spacing = ggplot2::unit(2 *
          half_line, "pt"),
        panel.background = ggplot2::element_blank(),
        panel.border = ggplot2::element_blank(),
        panel.grid = ggplot2::element_line(colour = "grey92"),
        panel.grid.minor = ggplot2::element_blank(),
        panel.grid.major.y = ggplot2::element_line(size = ggplot2::rel(0.5)),
        panel.grid.major.x = ggplot2::element_blank(),
        panel.spacing = ggplot2::unit(half_line, "pt"),
        panel.spacing.x = NULL,
        panel.spacing.y = NULL,
        panel.ontop = FALSE,
        strip.background = ggplot2::element_blank(),
        strip.text = ggplot2::element_text(
          family = font_families$strip,
          colour = "grey10",
          size = font_sizes$strip,
          margin = ggplot2::margin(
            0.8 * half_line, 0.8 * half_line,
            0.8 * half_line, 0.8 * half_line
          )
        ),
        strip.text.x = NULL,
        strip.text.y = ggplot2::element_text(angle = -90),
        strip.text.y.left = ggplot2::element_text(angle = 90),
        strip.placement = "inside",
        strip.placement.x = NULL,
        strip.placement.y = NULL,
        strip.switch.pad.grid = ggplot2::unit(
          half_line / 2,
          "pt"
        ),
        strip.switch.pad.wrap = ggplot2::unit(
          half_line / 2,
          "pt"
        ),
        # plot.background = ggplot2::element_rect(colour = colors$white),
        plot.title = ggplot2::element_text(
          size = font_sizes$title,
          hjust = 0,
          vjust = 1,
          family = font_families$title,
          margin = ggplot2::margin(b = half_line)
        ),
        plot.title.position = "plot",
        plot.subtitle = ggplot2::element_text(
          size = font_sizes$subtitle,
          family = font_families$subtitle,
          hjust = 0,
          vjust = 1,
          margin = ggplot2::margin(b = half_line)
        ),
        plot.caption = ggplot2::element_text(
          hjust = 0,
          vjust = 1,
          size = font_sizes$caption,
          # lineheight = 0.25,
          color = "grey30",
          face = "italic",
          family = font_families$caption,
          margin = ggplot2::margin(t = 10)
        ),
        plot.caption.position = "plot",
        plot.tag = ggplot2::element_text(
          size = ggplot2::rel(1.2),
          hjust = 0.5,
          vjust = 0.5
        ),
        plot.tag.position = "topleft",
        plot.margin = ggplot2::margin(10, 10, 10, 10, unit = "pt"),
        plot.background = ggplot2::element_rect(
          fill = "white",
          colour = NA,
          linetype = 0
        ),
        complete = TRUE,
        validate = TRUE
      )
    return(t)
  }


theme_access_large <-
  function(base_size = 11,
           base_family = "",
           base_line_size = base_size / 22,
           base_rect_size = base_size / 22,
           use_showtext = FALSE,
           use_manual_font_sizes = FALSE,
           font_sizes = list(
             title = 64,
             subtitle = 48,
             axis_title = 30,
             axis_text = 30,
             legend_title = 30,
             legend_text = 30,
             caption = 24,
             strip = 24
           )) {
    requireNamespace("sysfonts", quietly = TRUE)
    requireNamespace("showtext", quietly = TRUE)
    showtext::showtext_auto()
    
    
    font_families <-
      list(
        "title" = "Montserrat",
        "subtitle" = "Montserrat",
        "axis_title" = "Montserrat",
        "axis_text" = "Montserrat",
        "legend_title" = "Montserrat",
        "legend_text" = "Montserrat",
        "caption" = "Montserrat",
        "strip" = "Montserrat"
      )
    
    
    

    half_line <- base_size / 2
    t <-
      theme(
        line = ggplot2::element_line(
          colour = colors$black,
          size = base_line_size,
          linetype = 1,
          lineend = "butt"
        ),
        rect = ggplot2::element_rect(
          fill = colors$white,
          colour = colors$black,
          size = base_rect_size,
          linetype = 1
        ),
        text = ggplot2::element_text(
          family = base_family,
          face = "plain",
          colour = colors$black,
          size = base_size,
          lineheight = 0.25,
          hjust = 0.5,
          vjust = 0.5,
          angle = 0
        ),
        # margin = ggplot2::margin(),
        axis.line = ggplot2::element_blank(),
        axis.line.x = NULL,
        axis.line.y = NULL,
        axis.text = ggplot2::element_text(
          family = font_families$axis,
          size = font_sizes$axis_text,
          color = "gray30"
        ),
        axis.text.x = ggplot2::element_text(
          size = font_sizes$axis_text,
          family = font_families$axis_text,
          margin = ggplot2::margin(t = 0.8 *
            half_line /
            2),
          vjust = 0.5
        ),
        axis.text.x.top = ggplot2::element_text(
          size = font_sizes$axis_text,
          family = font_families$axis_text,
          margin = ggplot2::margin(b = 0.8 *
            half_line /
            2),
          vjust = 0
        ),
        axis.text.y = ggplot2::element_text(
          size = font_sizes$axis_text,
          family = font_families$axis_text,
          margin = ggplot2::margin(r = 0.8 *
            half_line /
            2),
          hjust = 1
        ),
        axis.text.y.right = ggplot2::element_text(
          size = font_sizes$axis_text,
          family = font_families$axis_text,
          margin = ggplot2::margin(l = 0.8 *
            half_line /
            2),
          hjust = 0
        ),
        axis.ticks = element_blank(),
        axis.ticks.length = ggplot2::unit(half_line / 2, "pt"),
        axis.ticks.length.x = NULL,
        axis.ticks.length.x.top = NULL,
        axis.ticks.length.x.bottom = NULL,
        axis.ticks.length.y = NULL,
        axis.ticks.length.y.left = NULL,
        axis.ticks.length.y.right = NULL,
        axis.title.x = element_blank(),
        axis.title.y = ggplot2::element_text(
          angle = 0,
          family = font_families$axis_title,
          size = font_sizes$axis_title,
          margin = ggplot2::margin(r = half_line / 2),
          vjust = 0.5
        ),
        axis.title.y.right = ggplot2::element_text(
          family = font_families$axis_title,
          size = font_sizes$axis_title,
          margin = ggplot2::margin(l = half_line /
            2),
          vjust = 0.5,
          angle = 0
        ),
        legend.background = ggplot2::element_blank(),
        legend.spacing = ggplot2::unit(half_line, "pt"),
        legend.spacing.x = ggplot2::unit(half_line / 1.5, "pt"),
        legend.spacing.y = ggplot2::unit(half_line, "pt"),
        legend.margin = ggplot2::margin(
          half_line,
          half_line,
          half_line,
          half_line
        ),
        legend.key = ggplot2::element_blank(),
        legend.key.size = ggplot2::unit(0.6, "lines"),
        legend.key.height = NULL,
        legend.key.width = NULL,
        legend.text = ggplot2::element_text(
          size = font_sizes$legend_text,
          family = font_families$legend_text
        ),
        legend.text.align = NULL,
        legend.title = element_blank(),
        legend.title.align = NULL,
        legend.position = "top",
        legend.justification = c(0, 0),
        legend.box = NULL,
        legend.box.margin = ggplot2::margin(0, 0, 0, 0, "cm"),
        legend.box.background = ggplot2::element_blank(),
        legend.box.spacing = ggplot2::unit(2 *
          half_line, "pt"),
        panel.background = ggplot2::element_blank(),
        panel.border = ggplot2::element_blank(),
        panel.grid = ggplot2::element_line(colour = "grey92"),
        panel.grid.minor = ggplot2::element_blank(),
        panel.grid.major.y = ggplot2::element_line(size = ggplot2::rel(0.5)),
        panel.grid.major.x = ggplot2::element_blank(),
        panel.spacing = ggplot2::unit(half_line, "pt"),
        panel.spacing.x = NULL,
        panel.spacing.y = NULL,
        panel.ontop = FALSE,
        strip.background = ggplot2::element_blank(),
        strip.text = ggplot2::element_text(
          family = font_families$strip,
          colour = "grey10",
          size = font_sizes$strip,
          margin = ggplot2::margin(
            0.8 * half_line, 0.8 * half_line,
            0.8 * half_line, 0.8 * half_line
          )
        ),
        strip.text.x = NULL,
        strip.text.y = ggplot2::element_text(angle = -90),
        strip.text.y.left = ggplot2::element_text(angle = 90),
        strip.placement = "inside",
        strip.placement.x = NULL,
        strip.placement.y = NULL,
        strip.switch.pad.grid = ggplot2::unit(
          half_line / 2,
          "pt"
        ),
        strip.switch.pad.wrap = ggplot2::unit(
          half_line / 2,
          "pt"
        ),
        # plot.background = ggplot2::element_rect(colour = colors$white),
        plot.title = ggplot2::element_text(
          size = font_sizes$title,
          hjust = 0,
          vjust = 1,
          family = font_families$title,
          margin = ggplot2::margin(b = half_line)
        ),
        plot.title.position = "plot",
        plot.subtitle = ggplot2::element_text(
          size = font_sizes$subtitle,
          family = font_families$subtitle,
          hjust = 0,
          vjust = 1,
          margin = ggplot2::margin(b = half_line)
        ),
        plot.caption = ggplot2::element_text(
          hjust = 0,
          vjust = 1,
          size = font_sizes$caption,
          # lineheight = 0.25,
          color = "grey30",
          face = "italic",
          family = font_families$caption,
          margin = ggplot2::margin(t = 10)
        ),
        plot.caption.position = "plot",
        plot.tag = ggplot2::element_text(
          size = ggplot2::rel(1.2),
          hjust = 0.5,
          vjust = 0.5
        ),
        plot.tag.position = "topleft",
        plot.margin = ggplot2::margin(10, 10, 10, 10, unit = "pt"),
        plot.background = ggplot2::element_rect(
          fill = "white",
          colour = NA,
          linetype = 0
        ),
        complete = TRUE,
        validate = TRUE
      )
    return(t)
  }
