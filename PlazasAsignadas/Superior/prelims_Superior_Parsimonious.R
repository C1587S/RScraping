MuteMessages <- suppressPackageStartupMessages
MuteMessages(library(tidyverse))
MuteMessages(library(RSelenium))
MuteMessages(library(XML))
MuteMessages(library(sendmailR))
MuteMessages(library(mailR))
MuteMessages(library(rJava))

DataFrame_colNames <- c("cicloEscolar", "entidad", "nivelEducativo", "concurso", "tipoConcurso", "subsistema",
                        "tipoEvaluacion", "idoneos", "idoneosAsignados", "concurso", "entidad", 
                        "subsistema", "folio", "prelacion", "tipoPlaza", "curp",
                        "tipoEvaluacion", "tipoVacante", "sostenimiento", "numeroroHoras",
                        "fechaInicioVacante", "fechaFinVacante", "CCTlabora", "clavePlaza")
DataBase <- data.frame(matrix(ncol =  length(DataFrame_colNames), nrow = 1))
colnames(DataBase) <- DataFrame_colNames
DataBase <- data.frame(lapply(DataBase, as.character), stringsAsFactors=FALSE)
#--------------------------------------
# Create list of options for all sections
# ciclo escolar / ENTER
ops_cicloEscolar <- c()
for (j in seq(1,6, by=1)){ops_cicloEscolar[[j]] <- paste0('//*[(@id=\"react-select-2--option-', as.character(j-1), '\")]')}
# Entidad / ENTER
ops_entidad <- c()
for (j in seq(1,32, by=1)) {ops_entidad[[j]] <- paste0('//*[(@id=\"react-select-3--option-', as.character(j-1),'\")]')}
# Nivel educativo / ENTER
ops_NivelEduc <- '//*[(@id="react-select-4--option-1")]'


#--------------------------------------
# email funcitons
# Send and e-mail if an error occurs
# email funcitons
# Send and e-mail if an error occurs
send_error_email <- function(){
  sender <- "servidorscrapingr@gmail.com"
  recipients <- c("Sebastian Cadavid Sanchez <s.cadavid1587@gmail.com>") 
  send.mail(from = sender,
            to = recipients,
            subject = "El proceso de scraping ENLACE - 2008 se detuvo.",
            body = "El proceso de scraping Plazas Asignadas se detuvo porque ocurrió un error.",
            smtp = list(host.name = "smtp.gmail.com", port = 465,
                        user.name = "servidorscrapingr@gmail.com",
                        passwd = "ServidorScrape1", ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
  
}

# Send an e-mail when the process finished without errors
send_noerror_email <- function(){
  sender <- "servidorscrapingr@gmail.com"
  recipients <- c("Sebastian Cadavid Sanchez <s.cadavid1587@gmail.com>") # " Mauricio Romero Londoño <mauricioromerolondono@gmail.com>"
  send.mail(from = sender,
            to = recipients,
            subject = "El proceso de scraping Plazas Asignadas se detuvo.",
            body = "El proceso se detuvo porque finalizó sin errores.",
            smtp = list(host.name = "smtp.gmail.com", port = 465,
                        user.name = "servidorscrapingr@gmail.com",
                        passwd = "ServidorScrape1", ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
}

write.csv(DataBase, file="DataBase_PlazasAsignadas_Superior.csv", row.names = F)
print("Prelims - Done")
