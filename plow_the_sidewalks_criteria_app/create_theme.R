fresh::use_googlefont("Montserrat")

my_fresh_theme <-
  fresh::create_theme(
    output_file = "plow_the_sidewalks_criteria_app/www/fresh_style.css",
    theme = "default",
    bs_vars_global(
      body_bg = "#FFFFFF",
      text_color = "black",
      link_color = "#10626f",
      link_hover_color = "#00d084",
      line_height_base = 1.5,
      grid_columns = NULL,
      grid_gutter_width = NULL,
      border_radius_base = NULL
    ),
    bs_vars_wells(bg = "#F9F9F9", border = "transparent"),
    bs_vars_font(
      family_sans_serif = "'Montserrat', sans-serif",
      size_base = 16,
      size_large = 42,
      size_small = 16,
      size_h1 = 42,
      size_h2 = 36,
      size_h3 = 20,
      size_h4 = 16,
      size_h5 = 16,
      size_h6 = 16
    ),
    bs_vars_color(
      brand_primary = "#270075",
      brand_success = "#9b51e0",
      brand_info = "#F9F9F9",
      brand_warning = "#cf2e2e",
      brand_danger = "#F9F9F9"
    ),
    bs_vars_navbar(
      default_bg = "#FFFFFF",
      default_color = "#FFFFFF",
      default_link_color = "#10626f",
      default_link_active_color = "#00d084"
    )
  )

my_fresh_theme
