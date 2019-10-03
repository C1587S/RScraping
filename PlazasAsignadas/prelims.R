MuteMessages <- suppressPackageStartupMessages
MuteMessages(library(tidyverse))
MuteMessages(library(RSelenium))
MuteMessages(library(XML))
MuteMessages(library(sendmailR))
MuteMessages(library(mailR))
MuteMessages(library(rJava))


# Open browser / navigate the page
#  > docker run -d -p 4445:4444 selenium/standalone-firefox
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "firefox")
remDr$open(silent = TRUE) #opens a browser
url_raw <- 'http://balanceador.cnspd.mx/AsignacionDePlazas/consulta/'
remDr$navigate(url_raw) # Navigate the page with the browser
remDr$screenshot(display = TRUE)

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
# email funcitons
# Send and e-mail if an error occurs
send_error_email <- function(){
  sender <- "servidorscrapingr@gmail.com"
  recipients <- c("Sebastian Cadavid Sanchez <s.cadavid1587@gmail.com>")
  send.mail(from = sender,
            to = recipients,
            subject = "El proceso de scraping ENLACE - 2008 se detuvo.",
            body = "El proceso se detuvo porque ocurrió un error.",
            smtp = list(host.name = "smtp.gmail.com", port = 465,
                        user.name = "servidorscrapingr@gmail.com",
                        passwd = "ServidorScrape1", ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
  
}

# Send an e-mail when the process finished without errors
send_noerror_email <- function(){
  sender <- "servidorscrapingr@gmail.com"
  recipients <- c("Sebastian Cadavid Sanchez <s.cadavid1587@gmail.com>") #" Mauricio Romero Londoño <mauricioromerolondono@gmail.com>",
  send.mail(from = sender,
            to = recipients,
            subject = "El proceso de scraping ENLACE - 2008 se detuvo.",
            body = "El proceso se detuvo porque finalizó sin errores.",
            smtp = list(host.name = "smtp.gmail.com", port = 465,
                        user.name = "servidorscrapingr@gmail.com",
                        passwd = "ServidorScrape1", ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
}

print("Prelims - Done")