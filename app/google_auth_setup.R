# Set up googlesheets authentication to work on Shiny
# following instructions from: https://www.jdtrat.com/blog/connect-shiny-google/

options(
  # whenever there is one account token found, use the cached token
  gargle_oauth_email = TRUE,
  # specify auth tokens should be stored in a hidden directory ".secrets"
  gargle_oauth_cache = "app/.secrets"
)

googledrive::drive_auth()
googlesheets4::gs4_auth() 

# check that token is stored: 
list.files("app/.secrets/")
