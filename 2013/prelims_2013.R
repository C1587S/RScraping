MuteMessages <- suppressPackageStartupMessages
MuteMessages(library(rvest))
MuteMessages(library(tidyverse))
MuteMessages(library(RSelenium))
MuteMessages(library(XML))
MuteMessages(library(data.table))
MuteMessages(library(sendmailR))
MuteMessages(library(mailR))
MuteMessages(library(rJava))
MuteMessages(library(bigstep))
#--------------------------------------
# Import FOLIOs data
rawData_2013 <- fread('/Users/c1587s/Dropbox/Webscrape_Puntajes/RawData/Basica2013.csv', header = FALSE, skip=1)
columnasN <- nrow(rawData_2013)
# Create and empty dataframe
pregs_gral_names <-  c("Folio", "Grado", "Grupo", "Turno", "TipoDeEscuela", "NombreDeLaEscuela", "CCT", "Entidad", "GradoDeMarginacion", "PuntajeTotalEsp", "PuntajeTotalMat")
# List of names for Español questions
Mat_correcta <- c(); Mat_marcada <- c(); Esp_correcta <- c(); Esp_marcada <- c()
for (i in seq(1, 130, by=1)) {
  Mat_correcta[[i]] <- paste("MatCorrecta", as.character(i), sep="_")
  Mat_marcada[[i]] <- paste("MatMarcada", as.character(i), sep="_")
  Esp_correcta[[i]] <- paste("EspCorrecta", as.character(i), sep="_")
  Esp_marcada[[i]] <- paste("EspMarcada", as.character(i), sep="_")
}
dataBase_names <- c(pregs_gral_names, Esp_correcta, Esp_marcada, Mat_correcta, Mat_marcada)
DataBase = data.frame(matrix(ncol=531,nrow=3))
colnames(DataBase) <- dataBase_names
DataBase <- data.frame(lapply(DataBase, as.character), stringsAsFactors=FALSE)
#--------------------------------------
# List of Español questions
## T1: Aspectos sintácticos y semánticos
Esp_first_col_T1  <- c()
## T2: Búsqueda y manejo de la información
Esp_first_col_T2 <- c()
## T3: Comprensión e interpretación
Esp_first_col_T3 <- c(); Esp_second_col_T3 <- c(); Esp_third_col_T3 <- c()
## T4: Conocimiento del sistema de escritura y ortografía
Esp_first_col_T4 <- c()
# T5: Propiedades y características de los textos
Esp_first_col_T5 <- c(); Esp_second_col_T5 <- c()

for (i in seq(1,10, by=1)){
  Esp_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[1]/td[",
                          as.character(i), "]/a", sep="")
  Esp_second_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[2]/td[",
                          as.character(i), "]/a", sep="")
  Esp_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr[1]/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,8, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Esp_second_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr[2]/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Esp_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Esp_third_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[3]/td[",
                          as.character(i), "]/a", sep="")
}
# paste all the elements
Esp_T1 <- c(Esp_first_col_T1)
Esp_T2 <- c(Esp_first_col_T2)
Esp_T3 <- c(Esp_first_col_T3,Esp_second_col_T3, Esp_third_col_T3)
Esp_T4 <- c(Esp_first_col_T4)
Esp_T5 <- c(Esp_first_col_T5, Esp_second_col_T5)
pregs_esp <- c(Esp_T1,Esp_T2,Esp_T3,Esp_T4,Esp_T5)

#--------------------------------------
# List of Matemáticas questions
## T1: Medida
Mat_first_col_T1  <- c()
## T2: Números y sistemas de numeración
Mat_first_col_T2 <- c(); Mat_second_col_T2 <- c()
## T3: Problemas aditivos
Mat_first_col_T3 <- c()
## T4: Problemas multiplicativos
Mat_first_col_T4 <- c(); Mat_second_col_T4 <- c(); Mat_third_col_T4 <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr[1]/td[",
                          as.character(i), "]/a", sep="")
  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr[1]/td[",
                          as.character(i), "]/a", sep="")
  Mat_second_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr[2]/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Mat_second_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr[2]/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr/td[",
                          as.character(i), "]/a", sep="")
}
Mat_third_col_T4[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr[3]/td/a"
# paste all the elements
Mat_T1 <- c(Mat_first_col_T1)
Mat_T2 <- c(Mat_first_col_T2, Mat_second_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4, Mat_second_col_T4, Mat_third_col_T4)
preguntas_mat <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4)

#--------------------------------------
# email funcitons
# Send and e-mail if an error occurs
send_error_email <- function(){
  sender <- "servidorscrapingr@gmail.com"
  recipients <- c("Sebastian Cadavid Sanchez <s.cadavid1587@gmail.com>")
  send.mail(from = sender,
            to = recipients,
            subject = "El proceso de scraping ENLACE - 2013 se detuvo.",
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
          subject = "El proceso de scraping ENLACE - 2013 se detuvo.",
          body = "El proceso se detuvo porque finalizó sin errores.",
          smtp = list(host.name = "smtp.gmail.com", port = 465,
                      user.name = "servidorscrapingr@gmail.com",
                      passwd = "ServidorScrape1", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)
}

print("Prelims - Done")
