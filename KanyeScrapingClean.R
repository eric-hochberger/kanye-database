# Kanye Scraping Final 

library(rvest)
library(tidyverse)
library(janitor)
library(rlist)
library(rjson)
library(tidyjson)
library(jsonlite)
library(dbConnect)
library(assertthat)
library(tools)




# Generate list of html-friendly album titles -----------------------------

album_titles_text <- c("The-college-dropout", 
                       "Late-registration", 
                       "Graduation", "808s-heartbreak", "My-beautiful-dark-twisted-fantasy", 
                       "Yeezus", "The-life-of-pablo", "Ye")



# Connect to SQLite Database and load in data -----------------------------

mydb <- dbConnect(RSQLite::SQLite(), "my-db2.sqlite")

for (l in album_titles_text) {
  
  album_url <- paste('https://genius.com/albums/Kanye-west/', l, sep = "")
  album_webpage <- read_html(album_url)
  album_songs_data <- html_nodes(album_webpage, '.chart_row-content-title')
  album_songs_text <- html_text(album_songs_data) %>% 
    trimws()
  album_songs_text <- gsub("\n", " ", album_songs_text)
  album_songs_text <- gsub("Lyrics", " ", album_songs_text) %>% 
    trimws()
  album_songs_text <- as.data.frame(album_songs_text)
  album_songs_text <- make_clean_names(album_songs_text$album_songs_text)
  album_songs_text <- gsub("_", "-", album_songs_text)
  
  for(i in album_songs_text){
    url <- paste("https://genius.com/Kanye-west-", i, sep = "") %>% 
      str_remove("-lyrics") %>% 
      str_remove("-ft-.*") %>%
      str_remove("-number") %>% 
      paste("-lyrics", sep = "")
    #Modifying non-functioning URLs
    if (url == "https://genius.com/Kanye-west-slow-jamz-by-twista-kanye-west-jamie-foxx-lyrics") {
      
      url <- "https://genius.com/Twista-kanye-west-and-jamie-foxx-slow-jamz-lyrics"
    } 
    if (url == "https://genius.com/Kanye-west-robo-cop-lyrics") {
      
      url <- "https://genius.com/Kanye-west-robocop-lyrics"
    } 
    if (url == "https://genius.com/Kanye-west-x808s-heartbreak-tracklist-album-cover-lyrics") {
      
      url <- "https://genius.com/Kanye-west-808s-and-heartbreak-tracklist-album-cover-annotated"
    }
    if (url == "https://genius.com/Kanye-west-x30-hours-lyrics") {
      
      url <- "https://genius.com/Kanye-west-30-hours-lyrics"
    } 
    if (url == "https://genius.com/Kanye-west-the-life-of-pablo-studio-notepad-annotated") {
      
      url <- "https://genius.com/Kanye-west-the-life-of-pablo-credits-annotated"
    } 
      webpage <- read_html(url)
      producer_data <-  html_nodes(webpage, "meta[itemprop='page_data']") #Access page metadata
      producer_json <- html_attr(producer_data, "content") #Render metadata as JSON
      producer_non_json <- fromJSON(producer_json) #Render metadata as accessible R object
    
        n <- length(producer_non_json$song$producer_artists$name)
        k <- length(producer_non_json$song$song_relationships$songs[[1]]$primary_artist$name) # Isolate number of samples the song contains
        q <- length(producer_non_json$song$featured_artists$name) # Isolate number of Featured Artists
    
    

# Insert song's "sample" information into database ---------------------------------

    if (k > 0) {
      for (m in 1:k) {
        query <- dbSendStatement(mydb, paste("INSERT INTO Samples (Sample_Name, Sample_Artist) VALUES ('",
                                             producer_non_json$song$song_relationships$songs[[1]]$title[m], "', '",
                                             producer_non_json$song$song_relationships$songs[[1]]$primary_artist$name[m], "');", sep = ""))
        query
        dbClearResult(query)

      }
    }
    

# Insert song’s "featured artist” information into database ---------------
    if (q >0) {
      for (s in 1:q)
        query <- dbSendStatement(mydb, paste("INSERT INTO Features (Feature_Artist_Name) VALUES ('",
                                             producer_non_json$song$featured_artists$name[s], "');", sep = ""))
      query
      dbClearResult(query)
    }
        

# Insert song’s “producer” information into database ----------------------

    for (j in 1:n) {
      query <- dbSendStatement(mydb, paste("INSERT INTO Producers(Producer_Name) VALUES ('",
                                           producer_non_json$song$producer_artists$name[[j]], "');", sep = ""))
      query
      dbClearResult(query)
    }
   # Song Loop
    query <- dbSendStatement(mydb, paste("INSERT INTO Song (Song_Name, Album_Name, Year_Released) VALUES ('",
                                         producer_non_json$song$title, "', '",
                                         producer_non_json$song$album$name, "', '",
                                         producer_non_json$song$release_date_components$year, "');", sep = ""))
    query
    dbClearResult(query)

# Insert information into temporary linking tables "Song_Producers, Song_Samples, and Song_Features----------------------

    # Song_Producers Loop
    for (j in 1:n) {
      query <- dbSendStatement(mydb, paste("INSERT INTO Song_Producers_temp (Producer_Name, Song_Name) VALUES ('",
                                           producer_non_json$song$producer_artists$name[[j]], "', '",
                                           producer_non_json$song$title, "');", sep = ""))
      query
      dbClearResult(query)
    }
    
    # Song_Samples Loop
    if (k > 0) {
        for (m in 1:k) {
          query <- dbSendStatement(mydb, paste("INSERT INTO Song_Samples_temp (Song_Name, Sample_Name, Sample_Artist) VALUES ('",
                                               producer_non_json$song$title, "', '",
                                               producer_non_json$song$song_relationships$songs[[1]]$title[m], "', '",
                                               producer_non_json$song$song_relationships$songs[[1]]$primary_artist$name[m], "');", sep = ""))
          query
          dbClearResult(query)

        } # End of for-loop
    } #End of if-statement
    # Song_Features Loop
    if (q >0) {
      for (s in 1:q)
        query <- dbSendStatement(mydb, paste("INSERT INTO Song_Features_temp (Song_Name, Feature_Artist_Name) VALUES ('",
                                             producer_non_json$song$title, "', '",
                                             producer_non_json$song$featured_artists$name[s], "');", sep = ""))
      query
      dbClearResult(query)
    } #End of for-loop
  } #End of if-statement
} #End of album_titles_text for-loop
dbDisconnect(mydb)

