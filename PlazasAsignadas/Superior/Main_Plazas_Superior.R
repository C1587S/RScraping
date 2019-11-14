# Main script
#.rs.restartR() # restart R session
rm(list = ls()) # clear all the environment
Sys.sleep(2)
if(Sys.info()["user"]=="mauricio"){
  setwd("/mnt/HDD/git/RScraping/PlazasAsignadas/Superior") 
} 
if(Sys.info()["user"]=="c1587s") {
  setwd("/Users/c1587s/Documents/Github/RScraping/PlazasAsignadas/Superior")
}

source("prelims_Plazas_Superior.R")
source("ScrapingR_PlazasAsignadas_Superior.R")
# Scraping starts
Scrape_PlazasAsignadas()

#tryCatch({source("ScrapingR_PlazasAsignadas_Superior.R")}, silent=FALSE,error=send_error_email())
#send_noerror_email() # send email if no error occurs
