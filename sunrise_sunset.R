

get_sunrise_sunset <- function() {
  
  creds <- read_yaml("creds.yaml")
  latitude        <- creds$lights$latitude
  longitude       <- creds$lights$longitude
  
  ### Get sunrise and sunset times
  GET(paste0("https://api.sunrise-sunset.org/json?lat=",latitude,"&lng=",longitude,"&formatted=0")) %>%
    content() %>%
    pluck("results") %>%
    map(as.POSIXct, origin = "1970-01-01")
}
