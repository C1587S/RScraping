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
rawData_2009 <- fread('/Users/c1587s/Dropbox/Webscrape_Puntajes/RawData/Basica2009.csv', header=FALSE, skip=1)
columnasN <- nrow(rawData_2009)
#--------------------------------------
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
#dataBase_names <- c(pregs_gral_names, Esp_correcta, Esp_marcada, Mat_correcta, Mat_marcada)
dataBase_names <- c(pregs_gral_names, Esp_marcada, Mat_marcada)
DataBase = data.frame(matrix(ncol=length(Esp_marcada)+length(Mat_marcada)+length(pregs_gral_names),nrow=1))
colnames(DataBase) <- dataBase_names
DataBase <- data.frame(lapply(DataBase, as.character), stringsAsFactors=FALSE)

dataBase_names <- c(Esp_correcta, Mat_correcta)
DataBaseCorrecta = data.frame(matrix(ncol=length(Esp_correcta)+length(Mat_correcta),nrow=1))
colnames(DataBaseCorrecta) <- dataBase_names
DataBaseCorrecta <- data.frame(lapply(DataBaseCorrecta, as.character), stringsAsFactors=FALSE)
#--------------------------------------
# List of Español question
## T1: Compresion lectora
Esp_first_col_T1  <- c(); Esp_second_col_T1 <- c(); Esp_third_col_T1  <- c(); Esp_fourth_col_T1 <- c(); 
## T2: Reflexion sobre la lengua
Esp_first_col_T2 <- c()

for (i in seq(1,10, by=1)){
  Esp_first_col_T1[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                  as.character(i), "]/a")
  Esp_second_col_T1[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                   as.character(i), "]/a")
  Esp_third_col_T1[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                  as.character(i), "]/a")
  Esp_fourth_col_T1[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[4]/td[",
                                   as.character(i), "]/a")
  Esp_first_col_T2[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                                  as.character(i), "]/a")
  
}
# Pasting elements
Esp_T1 <- c(Esp_first_col_T1, Esp_second_col_T1, Esp_third_col_T1, Esp_fourth_col_T1)#
Esp_T2 <- c(Esp_first_col_T2)
pregs_esp <- c(Esp_T1,Esp_T2)

#--------------------------------------
# List of Matemáticas question
## T1: Numeros naturales
Mat_first_col_T1  <- c(); Mat_second_col_T1 <- c(); Mat_third_col_T1  <- c()
## T2: Numeros fraccionarios y decimales
Mat_first_col_T2 <- c()
## T3: Geometria
Mat_first_col_T3 <- c()
## T4: Longitud y area
Mat_first_col_T4 <- c()
## T5: Paso y tiempo (unidades)
Mat_first_col_T5 <- c()
## T6: Manejo de información
Mat_first_col_T6 <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T1[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                  as.character(i), "]/a")
  Mat_second_col_T1[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                   as.character(i), "]/a")
}
for (i in seq(1,8, by=1)){
  Mat_third_col_T1[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                  as.character(i), "]/a")
}
for (i in seq(1,6, by=1)){
  
  Mat_first_col_T3[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                                  as.character(i), "]/a")
  Mat_first_col_T4[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                                  as.character(i), "]/a")
  Mat_first_col_T5[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                                  as.character(i), "]/a")
}
for (i in seq(1,3, by=1)){
  Mat_first_col_T2[[i]] <- paste0("/html/body/span/table[2]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                                  as.character(i), "]/a")
}
Mat_first_col_T6[[1]] <- paste0("/html/body/span/table[2]/tbody/tr[7]/td[2]/table/tbody/tr/td/a")
# Pasting elements
Mat_T1 <- c(Mat_first_col_T1, Mat_second_col_T1, Mat_third_col_T1)
Mat_T2 <- c(Mat_first_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
pregs_mat <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6)


# Send and e-mail if an error occurs
send_error_email <- function(){
  sender <- "servidorscrapingr@gmail.com"
  recipients <- c("Sebastian Cadavid Sanchez <s.cadavid1587@gmail.com>")
  send.mail(from = sender,
            to = recipients,
            subject = "El proceso de scraping ENLACE - 2009 se detuvo.",
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
            subject = "El proceso de scraping ENLACE - 2009 se detuvo.",
            body = "El proceso se detuvo porque finalizó sin errores.",
            smtp = list(host.name = "smtp.gmail.com", port = 465,
                        user.name = "servidorscrapingr@gmail.com",
                        passwd = "ServidorScrape1", ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
}

write.csv(DataBase, file="CreatedData/2009/DataBase_ENLACE2009_Total.csv", row.names = FALSE)
write.csv(DataBaseCorrecta, file="CreatedData/2009/DataBase_ENLACE2009_Correcta.csv", row.names = FALSE)
print("Prelims - Done")