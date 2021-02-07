### Hue API function
# https://developers.meethue.com/develop/hue-api/

construct_url <- function(endpoint) {
  
  base_url <- paste("http:/",bridge_ip,"api",bridge_username, sep ="/")
  paste(base_url, endpoint, sep = "/")
  
}

get_group_id <- function(group_name) {
  
  GET(construct_url("groups")) %>%
    content() %>%
    keep(~.x$name == group_name) %>%
    imap(~.y) %>%
    unlist() %>% unname()
}


get_scene_id <- function(scene_name, group_id) {
  
  GET(construct_url("scenes")) %>%
    content() %>%
    keep(~.x$name == scene_name && .x$group == group_id) %>%
    imap(~.y) %>%
    unlist() %>% unname()
}



set_scene <- function(scene_name,
                      group_name,
                      trans_time = 10) {
  
  group_id <- get_group_id(group_name)
  scene_id <- get_scene_id(scene_name, group_id)
  
  PUT(paste0("http://",bridge_ip,"/api/",bridge_username,"/groups/1/action"), 
      body = list(scene = scene_id,
                  transitiontime = trans_time),
      encode = "json") %>%
    content()
  
}