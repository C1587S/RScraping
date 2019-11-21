# Main script
#.rs.restartR() # restart R session
#Sys.sleep(4)
rm(list = ls()) # clear all the environment
Sys.sleep(2)
if(Sys.info()["user"]=="MROMEROLO") {
  setwd("D:/Dropbox/Research/Webscrape_Puntajes")
  dir_do="D:/git/RScraping/2013/"
}
if(Sys.info()["user"]=="mauricio"){
  setwd("/mnt/HDD/Dropbox/Research/Webscrape_Puntajes")
  dir_do="/mnt/HDD/git/RScraping/2013/"
}
if(Sys.info()["user"]=="c1587s") {
  setwd("/Users/c1587s/Dropbox/Webscrape_Puntajes")
    dir_do = "/Users/c1587s/Documents/GitHub/RScraping/ENLACE/2013/"
}


source(paste0(dir_do,"prelims_2013.R"))
source(paste0(dir_do,"Scrape_2013.R"))
# Scraping starts
retry(Scrape_2013())

#tryCatch({source(paste0(dir_do,"Scrape_2013.R"))}, silent=FALSE,error=send_error_email())
#send_noerror_email() # send email if no error occurs
