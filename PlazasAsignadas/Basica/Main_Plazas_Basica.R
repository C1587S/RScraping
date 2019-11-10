# Main script
#.rs.restartR() # restart R session

rm(list = ls()) # clear all the environment
Sys.sleep(2)
if(Sys.info()["user"]=="mauricio"){
  setwd("/mnt/HDD/git/RScraping/PlazasAsignadas/Basica") 
} 
if(Sys.info()["user"]=="c1587s") {
  setwd("/Users/c1587s/Documents/Github/RScraping/PlazasAsignadas/Basica")
}

source("prelims_Plazas_Basica.R")
source("ScrapingR_PlazasAsignadas_Basica.R")
# Scraping starts
#tryCatch({source("ScrapingR_PlazasAsignadas_Superior.R")}, silent=FALSE,error=send_error_email())
#send_noerror_email() # send email if no error occurs
