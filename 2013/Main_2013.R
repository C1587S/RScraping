# Main script
#.rs.restartR() # restart R session
#Sys.sleep(4)
rm(list = ls()) # clear all the environment
Sys.sleep(2)
#if(Sys.info()["user"]=="MROMEROLO") setwd("D:/Dropbox/Research/Webscrape_Puntajes") 
if(Sys.info()["user"]=="c1587s") setwd("/Users/c1587s/Dropbox/Webscrape_Puntajes/2013")
source("prelims_2013.R")
# Scraping starts
tryCatch({source("Scrape_2013.R")}, silent=FALSE,error=send_error_email())
send_noerror_email() # send email if no error occurs
