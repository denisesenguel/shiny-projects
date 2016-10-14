# send GET requests to twitter streaming API and bring data into plottable format

# what do we get from twitter:
# location, language, text, user id

load("twitter-map/myOAuth.RData")
load("data/debate-test-tweets.RData")

streamObj <- list()
i <- 1
while(i <= 10) {
  streamObj[[i]] <- filterStream(file.name = "",
                            track     = c("#presidentialdebate"),
                            # get the whole world (workaround for getting tweets with location data)
                            locations = c(-180, -85, 180, 85),
                            # language  = ,
                            timeout   = 60, # in secs
                            oauth     = myOAuth)
  i <- i + 1
}

tweetList <- lapply(streamObj, parseTweets)

tweets <- rbind(tweets, do.call(rbind, tweetList))

# raw tweets
save(tweets, file = "data/debate-test-tweets.RData")

# define function for getting date into the right format
formatDate <- function(date) {
  
  year <- str_sub(date, start = -4)
  monthVal <- data.frame(month = c("Jan", "Feb", "Mar", "Apr",
                                 "May", "Jun", "Jul", "Aug", 
                                 "Sep", "Oct", "Nov", "Dez"),
                       numval = c("01", "02", "03", "04", "05", "06", 
                                  "07", "08", "09", "10", "11", "12"))
  monthVal <- dplyr::filter(monthVal, unlist(lapply(month, function(x) grepl(x, date))))
  month <- as.character(monthVal$month)
  month_value <- as.character(monthVal$numval)
  
  day <- str_sub(strsplit(date, paste0(" ", month, " "))[[1]][2], end = 2)
  
  # different time zones?
  date2 <- format(as.POSIXlt(paste(year, month_value, day, sep = "-")), format = "%Y-%m-%d")
  
  return(date2)
}

# kick out unnused columns
tweetsClean <- tweets %>%
  dplyr::select(c(retweet_count, id_str, created_at, in_reply_to_status_id_str, 
                listed_count, place_lat, place_lon)) %>% 
  mutate(created_at = unlist(lapply(created_at, formatDate)))

save(tweetsClean, file = "data/debate-tweets-clean.RData")
