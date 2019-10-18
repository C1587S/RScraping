# Main script
#.rs.restartR() # restart R session
#Sys.sleep(4)
rm(list = ls()) # clear all the environment
Sys.sleep(2)
setwd("/Users/c1587s/Dropbox/Webscrape_Puntajes/Codigos/Scripts/2009")
source("prelims_2009.R")
# Scraping starts
tryCatch({source("Scrape_2009.R")}, silent=FALSE,error=send_error_email())
send_noerror_email() # send email if no error occurs