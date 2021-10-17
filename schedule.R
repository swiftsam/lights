library(httr)
library(magrittr)
library(purrr)
library(yaml)

creds <- read_yaml("creds.yaml")

bridge_ip       <- creds$lights$bridge_ip
bridge_username <- creds$lights$bridge_username

source("hue_api.R")


schedule_scene <- function(scene_name, 
                           group_name, 
                           scheduled_time_local, 
                           trans_time = 10) {
  
  group_id <- get_group_id(group_name)
  scene_id <- get_scene_id(scene_name, group_id)
  
  tmp <- POST(paste0("http://",bridge_ip,"/api/",bridge_username,"/schedules"),
              body = list(
                name = scene_name,
                command = list(
                  address = paste0("/api/",bridge_username,"/groups/1/action"),
                  method = "PUT",
                  body = list(scene = scene_id,
                              transitiontime = trans_time)
                ),
                localtime = scheduled_time_local
              ),
              encode = "json"
  ) %>%
    content()
  
  message(scene_name, " ... ", scene_id, " ... ", scheduled_time_local, " ... ", trans_time, " -- ", names(tmp[[1]])[1])
  
}

schedule_scene("dawn",    "middle", paste0(Sys.Date(),"T06:40:00"), trans_time = 10*60*15)
schedule_scene("morning", "middle", paste0(Sys.Date(),"T07:05:00"), trans_time = 10*60*15)
schedule_scene("midday",  "middle", paste0(Sys.Date(),"T08:00:00"), trans_time = 10*60*15)
schedule_scene("evening", "middle", paste0(Sys.Date(),"T18:30:00"), trans_time = 10*60*15)
schedule_scene("night",   "middle", paste0(Sys.Date(),"T20:30:00"), trans_time = 10*60*15)

