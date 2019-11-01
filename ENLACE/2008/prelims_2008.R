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
rawData_2008 <- fread('RawData/Basica2008.csv', header = FALSE, skip=1)
columnasN <- nrow(rawData_2008)
#--------------------------------------
# Create and empty dataframe
pregs_gral_names <-  c("Folio", "Grado", "Grupo", "Turno", "TipoDeEscuela", "NombreDeLaEscuela", "CCT", "Entidad", "GradoDeMarginacion", "PuntajeTotalEsp", "PuntajeTotalMat")
# List of names for Español questions
Mat_correcta <- c(); Mat_marcada <- c(); Esp_correcta <- c(); Esp_marcada <- c()
for (i in seq(1, 160, by=1)) {
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

# There are three identified patterns of questions (there is an efficient way to create the list of questions?)
# Note: the fist question in matematicas is a good point to identify different cases (because for the spanish case all begin at the same question)
# -----------------------------
# Case 1
# Begins with mstematicas question number: 11
#----------------------------------------------------------------------------------------------------------------------------------------------------
# List of Español questions
## T1: Lectura
Esp_first_col_T1  <- c(); Esp_second_col_T1  <- c(); Esp_third_col_T1  <- c(); Esp_fourth_col_T1  <- c()
## T2: Reflexión sobre lectura
Esp_first_col_T2 <- c()


for (i in seq(1,10, by=1)){
  
  Esp_first_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_second_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_third_col_T1[[i]] <- paste("//html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,9, by=1)){
  Esp_fourth_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[4]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_first_col_T2[[i]] <- paste("/html/body/span/table[2]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
# paste all the elements
Esp_T1 <- c(Esp_first_col_T1, Esp_second_col_T1, Esp_third_col_T1, Esp_fourth_col_T1)
Esp_T2 <- c(Esp_first_col_T2)
pregs_esp_case1 <- c(Esp_T1, Esp_T2)

#--------------------------------------
# List of Matemáticas questions
## T1: NÚMEROS NATURALES
Mat_first_col_T1  <- c(); Mat_second_col_T1  <- c(); Mat_third_col_T1  <- c()
## T2: NÚMEROS FRACCIONARIOS Y DECIMALES
Mat_first_col_T2 <- c()
## T3: GEOMETRÍA
Mat_first_col_T3 <- c()
## T4: LONGITUD Y ÁREA (CÁLCULO)
Mat_first_col_T4 <- c()
## T5: PESO Y TIEMPO (UNIDADES)
Mat_first_col_T5 <- c()
## T6: PESO Y TIEMPO (UNIDADES)
Mat_first_col_T6 <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Mat_second_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
}
for (i in seq(1,8, by=1)){
  Mat_third_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/span/table[2]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
  Mat_first_col_T4[[i]] <- paste("/html/body/span/table[2]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Mat_first_col_T5[[i]] <- paste("/html/body/span/table[2]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_first_col_T2[[i]] <- paste("/html/body/span/table[2]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,1, by=1)){
  Mat_first_col_T6[[i]] <- "/html/body/span/table[2]/tbody/tr[7]/td[2]/table/tbody/tr/td/a"
}

# paste all the elements
Mat_T1 <- c(Mat_first_col_T1, Mat_second_col_T1, Mat_third_col_T1)
Mat_T2 <- c(Mat_first_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
pregs_mat_case1 <- c(Mat_T1, Mat_T2, Mat_T3, Mat_T4, Mat_T5, Mat_T6)

# Case 2
# Begins with mstematicas question number: 12
#----------------------------------------------------------------------------------------------------------------------------------------------------
# List of Español questions
## T1: Lectura
Esp_first_col_T1  <- c(); Esp_second_col_T1  <- c(); Esp_third_col_T1  <- c(); Esp_fourth_col_T1  <- c()
## T2: Reflexión sobre lectura
Esp_first_col_T2 <- c()


for (i in seq(1,10, by=1)){
  
  Esp_first_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_second_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_third_col_T1[[i]] <- paste("//html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,9, by=1)){
  Esp_first_col_T2[[i]] <- paste("/html/body/span/table[2]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Esp_fourth_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[4]/td[",
                                  as.character(i), "]/a", sep="")
}
# paste all the elements
Esp_T1 <- c(Esp_first_col_T1, Esp_second_col_T1, Esp_third_col_T1, Esp_fourth_col_T1)
Esp_T2 <- c(Esp_first_col_T2)
pregs_esp_case2 <- c(Esp_T1, Esp_T2)

#--------------------------------------
# List of Matemáticas questions
## T1: NÚMEROS NATURALES
Mat_first_col_T1  <- c(); Mat_second_col_T1  <- c(); Mat_third_col_T1  <- c(); Mat_fourth_col_T1  <- c()
## T2: NÚMEROS FRACCIONARIOS Y DECIMALES
Mat_first_col_T2 <- c(); Mat_second_col_T2 <- c()
## T3: VARIACIÓN PROPORCIONAL Y MANEJO DE LA INFORMACIÓN 
Mat_first_col_T3 <- c()
## T4: GEOMETRÍA 
Mat_first_col_T4 <- c()
## T5: LONGITUD, ÁREA Y VOLUMEN (CÁLCULO) 
Mat_first_col_T5 <- c()
## T6: CAPACIDAD, PESO Y TIEMPO (UNIDADES Y EQUIVALENCIA) 
Mat_first_col_T6 <- c()
## T7: EXPERIMENTOS ALEATORIOS
Mat_first_col_T7 <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Mat_second_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  Mat_third_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                 as.character(i), "]/a", sep="")
  Mat_first_col_T2[[i]] <- paste("/html/body/span/table[2]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,9, by=1)){
  Mat_first_col_T4[[i]] <- paste("/html/body/span/table[2]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,7, by=1)){
  Mat_first_col_T6[[i]] <- paste("/html/body/span/table[2]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Mat_first_col_T5[[i]] <- paste("/html/body/span/table[2]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/span/table[2]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_fourth_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[4]/td[",
                                  as.character(i), "]/a", sep="")
}
for (i in seq(1,1, by=1)){
  Mat_second_col_T2[[i]] <- paste("/html/body/span/table[2]/tbody/tr[3]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  Mat_first_col_T7[[i]] <- "/html/body/span/table[2]/tbody/tr[8]/td[2]/table/tbody/tr/td/a"
}

# paste all the elements
Mat_T1 <- c(Mat_first_col_T1, Mat_second_col_T1, Mat_third_col_T1, Mat_fourth_col_T1)
Mat_T2 <- c(Mat_first_col_T2, Mat_second_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
Mat_T7 <- c(Mat_first_col_T7)
pregs_mat_case2 <- c(Mat_T1, Mat_T2, Mat_T3, Mat_T4, Mat_T5, Mat_T6, Mat_T7)

# Case 3
# Begins with mstematicas question number: 13
#----------------------------------------------------------------------------------------------------------------------------------------------------
# List of Español questions
## T1: Lectura
Esp_first_col_T1  <- c(); Esp_second_col_T1  <- c(); Esp_third_col_T1  <- c(); Esp_fourth_col_T1  <- c(); Esp_fifth_col_T1  <- c()
## T2: Reflexión sobre lectura
Esp_first_col_T2 <- c(); Esp_second_col_T2 <- c()


for (i in seq(1,10, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_second_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_third_col_T1[[i]] <- paste("//html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_fourth_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[4]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_first_col_T2[[i]] <- paste("/html/body/span/table[2]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,8, by=1)){
  Esp_second_col_T2[[i]] <- paste("/html/body/span/table[2]/tbody/tr[3]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Esp_fifth_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[5]/td[",
                                 as.character(i), "]/a", sep="")
}
# paste all the elements
Esp_T1 <- c(Esp_first_col_T1, Esp_second_col_T1, Esp_third_col_T1, Esp_fourth_col_T1, Esp_fifth_col_T1)
Esp_T2 <- c(Esp_first_col_T2, Esp_second_col_T2)
pregs_esp_case3 <- c(Esp_T1, Esp_T2)

#--------------------------------------
# List of Matemáticas questions
## T1: NÚMEROS NATURALES
Mat_first_col_T1  <- c(); Mat_second_col_T1  <- c()
## T2: NÚMEROS FRACCIONARIOS Y DECIMALES
Mat_first_col_T2 <- c()
## T3: VARIACIÓN PROPORCIONAL 
Mat_first_col_T3 <- c()
## T4: GEOMETRÍA 
Mat_first_col_T4 <- c()
## T5: LONGITUD, ÁREA Y VOLUMEN (CÁLCULO) 
Mat_first_col_T5 <- c()
## T6: CAPACIDAD, PESO Y TIEMPO (UNIDADES Y EQUIVALENCIA) 
Mat_first_col_T6 <- c()
## T7: EXPERIMENTOS ALEATORIOS 
Mat_first_col_T7 <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Mat_first_col_T2[[i]] <- paste("/html/body/span/table[2]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,9, by=1)){
  Mat_first_col_T4[[i]] <- paste("/html/body/span/table[2]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
  Mat_first_col_T5[[i]] <- paste("/html/body/span/table[2]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,8, by=1)){
  Mat_third_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                 as.character(i), "]/a", sep="")
  Mat_first_col_T6[[i]] <- paste("/html/body/span/table[2]/tbody/tr[8]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Mat_second_col_T1[[i]] <- paste("/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  
}
for (i in seq(1,4, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/span/table[2]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_first_col_T7[[i]] <- paste("/html/body/span/table[2]/tbody/tr[9]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}

# paste all the elements
Mat_T1 <- c(Mat_first_col_T1, Mat_second_col_T1)
Mat_T2 <- c(Mat_first_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
Mat_T7 <- c(Mat_first_col_T7)
pregs_mat_case3 <- c(Mat_T1, Mat_T2, Mat_T3, Mat_T4, Mat_T5, Mat_T6, Mat_T7)

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

# write.csv(DataBase, file="CreatedData/2008/DataBase_ENLACE2008_Total.csv", row.names = FALSE)
# write.csv(DataBaseCorrecta, file="CreatedData/2008/DataBase_ENLACE2008_Correcta.csv", row.names = FALSE)


## function for retrying
retry <- function(.FUN, max.attempts = 3, sleep.seconds = 0.5) {
  expr <- substitute(.FUN)
  retry_expr(expr, max.attempts, sleep.seconds)
}

retry_expr <- function(expr, max.attempts = 3, sleep.seconds = 0.5) {
  x <- try(eval(expr))
  
  if(inherits(x, "try-error") && max.attempts > 0) {
    Sys.sleep(sleep.seconds)
    return(retry_expr(expr, max.attempts - 1))
  }
  
  x
}


print("Prelims - Done")