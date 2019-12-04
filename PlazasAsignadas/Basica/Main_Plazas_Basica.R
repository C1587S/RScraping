# Main script
#.rs.restartR() # restart R session

rm(list = ls()) # clear all the environment
Sys.sleep(2)
if(Sys.info()["user"]=="mauricio"){
  setwd("/mnt/HDD/git/RScraping/PlazasAsignadas/Basica") 
} 
if(Sys.info()["user"]=="c1587s") {
  setwd("/Users/c1587s/Documents/Github/R_Scraping/PlazasAsignadas/Basica")
}
source("prelims_Plazas_Basica.R")
source("ScrapingR_PlazasAsignadas_Basica.R")
# Scraping starts
Scrape_PlazasAsignadas() 

# en caso de que resolvamos iniciar desde la plaza en que el scraper presente una falla
# retry(Scrape_PlazasAsignadas()) 
# Propuesta: hacerlo por entidad (son 32, no sería tan problemático, pero debería correrse 
# desde el inicio por si una falla)

# Email si un error ocurre
# tryCatch({Scrape_PlazasAsignadas()}, silent=F,error=send_error_email())
# send_noerror_email() # 

