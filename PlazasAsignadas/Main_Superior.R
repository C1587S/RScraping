# Main script
#.rs.restartR() # restart R session
#Sys.sleep(4)
rm(list = ls()) # clear all the environment
Sys.sleep(2)
setwd("/Users/c1587s/Documents/GitHub/RScraping/PlazasAsignadas")
source("prelims_Superior.R")
# Scraping starts
tryCatch({source("ScrapingR_PlazasAsignadas_Superior.R")}, silent=FALSE,error=send_error_email())
send_noerror_email() # send email if no error occurs


