results <- GET(construct_url("schedules")) %>%
  content()

GET(construct_url("lights/5")) %>%
  content() %>%
  pluck("state")

PUT(paste0("http://",bridge_ip,"/api/",bridge_username,"/lights/5/state"), 
    body = list(on  = TRUE,
                hue = 65535, 
                sat = 0,
                ct  = 100,
                bri = 100),
    encode = "json") %>%
  content()


PUT(paste0("http://",bridge_ip,"/api/",bridge_username,"/lights/5/state"), 
    body = list(on  = FALSE),
    encode = "json") %>%
  content()



for(id in 1:2) {
  message(DELETE(paste0("http://",bridge_ip,"/api/",bridge_username,"/schedules/",id)) %>% content())
}
