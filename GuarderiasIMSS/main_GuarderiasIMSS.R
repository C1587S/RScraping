rm(list = ls()) # clear all the environment
Sys.sleep(2)
if(Sys.info()["user"]=="mauricio"){
  setwd("/mnt/HDD/git/RScraping/GuarderiasIMSS") 
} 
if(Sys.info()["user"]=="c1587s") {
  setwd("/Users/c1587s/Documents/Github/R_Scraping/GuarderiasIMSS")
}


source("prelims_GuarderiasIMSS.R")
source("Scraping_GuarderiasIMSS.R")

