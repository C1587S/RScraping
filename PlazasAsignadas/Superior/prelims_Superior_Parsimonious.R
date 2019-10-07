MuteMessages <- suppressPackageStartupMessages
MuteMessages(library(tidyverse))
MuteMessages(library(RSelenium))
MuteMessages(library(XML))
MuteMessages(library(sendmailR))
MuteMessages(library(mailR))
MuteMessages(library(rJava))

# -----------------------------
## Create an empty dataframe with the name of variables
DataFrame <- data.frame(cicloEscolar = character(0),
                        entidad= character(0),
                        nivelEducativo = character(0),
                        concurso = character(0),
                        tipoConcurso = character(0),
                        subsistema= character(0),
                        tipoEvaluacion= character(0),
                        idoneos = character(0),
                        idoneosAsignados= character(0),
                        concurso_info = character(0),
                        entidad_info= character(0),
                        subsistema_info= character(0),
                        folio_info= character(0),
                        prelacion_info= character(0),
                        tipoPlaza_info= character(0),
                        curp_info= character(0),
                        tipoEvaluacion_info= character(0),
                        tipoVacante_info= character(0),
                        sostenimiento_info= character(0),
                        numeroroHoras_info= character(0),
                        fechaInicioVacante_info= character(0),
                        fechaFinVacante_info= character(0),
                        CCTlabora_info= character(0),
                        clavePlaza_info= character(0))

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
  recipients <- c(" Mauricio Romero Londoño <mauricioromerolondono@gmail.com>", "Sebastian Cadavid Sanchez <s.cadavid1587@gmail.com>") 
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
  recipients <- c(" Mauricio Romero Londoño <mauricioromerolondono@gmail.com>", "Sebastian Cadavid Sanchez <s.cadavid1587@gmail.com>") 
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

print("Prelims - Done")
