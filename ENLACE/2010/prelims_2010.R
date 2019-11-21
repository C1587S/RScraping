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
rawData_2010 <- fread('RawData/Basica2010.csv', header = FALSE, skip=1)
columnasN <- nrow(rawData_2010)
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
#--------------------------------------

# Case 1
# Begins with matematicas question number: 
# row 1 begins with question #11 and ends with question #22
#----------------------------------------------------------------------------------------------------------------------------------------------------
# List of Español questions
## T1: Compresion lectora
Esp_first_col_T1  <- c(); Esp_second_col_T1 <- c(); Esp_third_col_T1  <- c();
Esp_fourth_col_T1 <- c(); Esp_fifth_col_T1  <- c()
## T2: Reflexion sobre la lengua
Esp_first_col_T2 <- c()

for (i in seq(1,10, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_second_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_third_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_fourth_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[4]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,1, by=1)){
  Esp_fifth_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[5]/td[",
                                 as.character(i), "]/a", sep="")
}
# Pasting elements
Esp_T1 <- c(Esp_first_col_T1, Esp_second_col_T1, Esp_third_col_T1, Esp_fourth_col_T1, Esp_fifth_col_T1)#
Esp_T2 <- c(Esp_first_col_T2)
pregs_esp_case1 <- c(Esp_T1,Esp_T2)
#--------------------------------------
# List of Matemáticas questions
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
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                          as.character(i), "]/a", sep="")
  Mat_second_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,7, by=1)){
  Mat_third_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                          as.character(i), "]/a", sep="")
  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                          as.character(i), "]/a", sep="")
  Mat_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                          as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Mat_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                          as.character(i), "]/a", sep="")
}
Mat_first_col_T6[[1]] <- '/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td/a'
# Pasting elements
Mat_T1 <- c(Mat_first_col_T1, Mat_second_col_T1, Mat_third_col_T1)
Mat_T2 <- c(Mat_first_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
pregs_mat_case1 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6)

# Case 2
# Begins with matematicas question number: 
# row 1 begins with question #11 and ends with question #25
#----------------------------------------------------------------------------------------------------------------------------------------------------
# List of Español questions
## T1: Compresion lectora
Esp_first_col_T1  <- c(); Esp_second_col_T1 <- c(); Esp_third_col_T1  <- c(); 
Esp_fourth_col_T1 <- c(); Esp_fifth_col_T1  <- c()
## T2: Reflexion sobre la lengua
Esp_first_col_T2 <- c(); Esp_second_col_T2 <- c()

for (i in seq(1,10, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_second_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_third_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_fourth_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[4]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Esp_second_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[2]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Esp_fifth_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[5]/td[",
                                 as.character(i), "]/a", sep="")
}
# Pasting elements
Esp_T1 <- c(Esp_first_col_T1, Esp_second_col_T1, Esp_third_col_T1, Esp_fourth_col_T1, Esp_fifth_col_T1)#
Esp_T2 <- c(Esp_first_col_T2, Esp_second_col_T2)
pregs_esp_case2 <- c(Esp_T1,Esp_T2)
#--------------------------------------
# List of Matemáticas questions
## T1: Numeros naturales
Mat_first_col_T1  <- c(); Mat_second_col_T1 <- c(); Mat_third_col_T1  <- c();
Mat_fourth_col_T1  <- c();
## T2: Numeros fraccionarios y decimales
Mat_first_col_T2 <- c(); Mat_second_col_T2 <- c()
## T3: Variación proporcional y manejo de la información
Mat_first_col_T3 <- c();
## T4: Geometría
Mat_first_col_T4 <- c()
## T5: Longitud, área y volumen (cálculo)
Mat_first_col_T5 <- c()
## T6: Capacidad, peso y tiempo (unidades y equivalencia)
Mat_first_col_T6 <- c()
## T7: Experimentos aleatorios
Mat_first_col_T7 <- c()


for (i in seq(1,10, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Mat_second_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  Mat_third_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                  as.character(i), "]/a", sep="")
  Mat_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,9, by=1)){
  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,7, by=1)){
  Mat_first_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")  
}
for (i in seq(1,6, by=1)){
  Mat_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_fourth_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[4]/td[",
                                  as.character(i), "]/a", sep="")
}

Mat_second_col_T2[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[2]/td/a"

Mat_first_col_T7[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[8]/td[2]/table/tbody/tr/td/a"

# Pasting elements
Mat_T1 <- c(Mat_first_col_T1, Mat_second_col_T1, Mat_third_col_T1, Mat_fourth_col_T1)
Mat_T2 <- c(Mat_first_col_T2, Mat_second_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
Mat_T7 <- c(Mat_first_col_T7)
pregs_mat_case2 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6,Mat_T7)

# Case 3
# Begins with matematicas question number: 
# row 1 begins with question #9 and ends with question #51
#----------------------------------------------------------------------------------------------------------------------------------------------------
# List of Español questions
## T1: Compresion lectora
Esp_first_col_T1  <- c(); Esp_second_col_T1 <- c(); Esp_third_col_T1  <- c();
Esp_fourth_col_T1 <- c();
## T2: Reflexion sobre la lengua
Esp_first_col_T2 <- c(); Esp_second_col_T2 <- c()

for (i in seq(1,10, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_second_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_third_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_fourth_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[4]/td[",
                                  as.character(i), "]/a", sep="")
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Esp_second_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[2]/td[",
                                 as.character(i), "]/a", sep="")
}
# Pasting elements
Esp_T1 <- c(Esp_first_col_T1, Esp_second_col_T1, Esp_third_col_T1,Esp_fourth_col_T1)
Esp_T2 <- c(Esp_first_col_T2,Esp_second_col_T2)
pregs_esp_case3 <- c(Esp_T1,Esp_T2)
#--------------------------------------
# List of Matemáticas questions
## T1: Numeros naturales
Mat_first_col_T1  <- c(); Mat_second_col_T1 <- c(); Mat_third_col_T1  <- c()
## T2: Numeros fraccionarios y decimales
Mat_first_col_T2 <- c(); Mat_second_col_T2 <- c()
## T3: Variación proporcional
Mat_first_col_T3 <- c()
## T4: Geometría
Mat_first_col_T4 <- c()
## T5: Longitud, área y volumen (cálculo)
Mat_first_col_T5 <- c()
## T6: Capacidad, peso y tiempo (unidades y equivalencia)
Mat_first_col_T6 <- c()
## T7: Capacidad, peso y tiempo (unidades y equivalencia)
Mat_first_col_T7 <- c()
## T8: Experimentos aleatorios
Mat_first_col_T8 <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Mat_second_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                                  as.character(i), "]/a", sep="")
  Mat_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
}

for (i in seq(1,7, by=1)){

  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
  Mat_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Mat_second_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Mat_first_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                                  as.character(i), "]/a", sep="")
  Mat_first_col_T7[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[8]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_first_col_T8[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
Mat_third_col_T1[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[3]/td/a"
# Pasting elements
Mat_T1 <- c(Mat_first_col_T1, Mat_second_col_T1, Mat_third_col_T1)
Mat_T2 <- c(Mat_first_col_T2, Mat_second_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
Mat_T7 <- c(Mat_first_col_T7)
Mat_T8 <- c(Mat_first_col_T8)
pregs_mat_case3 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6,Mat_T7,Mat_T8)

# Case 4
# Begins with matematicas question number: 
# row 1 begins with question #11 and ends with question #89
#----------------------------------------------------------------------------------------------------------------------------------------------------
# List of Español questions
## T1: Propiedades y tipos de textos
Esp_first_col_T1  <- c(); 
## T2: Comprensión e interpretación
Esp_first_col_T2 <- c(); Esp_second_col_T2 <- c(); Esp_third_col_T2 <- c()
## T3: Aspectos sintácticos y semánticos de los textos
Esp_first_col_T3 <- c(); Esp_second_col_T3 <- c()
## T4: Conocimiento del sistema de escritura y ortografía
Esp_first_col_T4 <- c(); Esp_second_col_T4 <- c()

for (i in seq(1,10, by=1)){
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
  Esp_second_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T3[[i]] <- paste("",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Esp_third_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[3]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,1, by=1)){
  Esp_second_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr[2]/td/a",
                 as.character(i), "]/a", sep="")
}
Esp_second_col_T4[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr[2]/td/a"
# Pasting elements
Esp_T1 <- c(Esp_first_col_T1)
Esp_T2 <- c(Esp_first_col_T2,Esp_second_col_T2, Esp_third_col_T2)
Esp_T3 <- c(Esp_first_col_T3,Esp_second_col_T3)
Esp_T4 <- c(Esp_first_col_T4,Esp_second_col_T4)
pregs_esp_case4 <- c(Esp_T1,Esp_T2,Esp_T3,Esp_T4)
#--------------------------------------
# List of Matemáticas questions
## T1: Significado y uso de los números
Mat_first_col_T1  <- c(); Mat_second_col_T1 <- c(); 
## T2: Significado y uso de las operaciones
Mat_first_col_T2 <- c()
## T3: Figuras
Mat_first_col_T3 <- c()
## T4: Medidas
Mat_first_col_T4 <- c()
## T5: Ubicaciones espacial
Mat_first_col_T5 <- c()
## T6: Análisis de la información
Mat_first_col_T6 <- c(); Mat_second_col_T6 <- c()
## T7: Representación de la información
Mat_first_col_T7 <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,8, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Mat_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Mat_second_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
  Mat_second_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T7[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[8]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="") 
}
for (i in seq(1,2, by=1)){
  Mat_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
# Pasting elements
Mat_T1 <- c(Mat_first_col_T1, Mat_second_col_T1)
Mat_T2 <- c(Mat_first_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6,Mat_second_col_T6)
Mat_T7 <- c(Mat_first_col_T7)
pregs_mat_case4 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6,Mat_T7)


# Case 5
# Begins with matematicas question number: 
# row 1 begins with question #12 and ends with question #108
#----------------------------------------------------------------------------------------------------------------------------------------------------
# List of Español questions
## T1: Obtener y organizar información
Esp_first_col_T1  <- c(); Esp_second_col_T1 <- c();
## T2: Revisar y reescribir textos producidos en distintas áreas de estudio
Esp_first_col_T2 <- c();
## T3: Participar en eventos comunicativos formales
Esp_first_col_T3 <- c();
## T4: Leer y escribir para compartir la interpretación de textos literarios
Esp_first_col_T4 <- c();
## T5: Hacer el seguimiento de algún subgénero, temática o movimiento
Esp_first_col_T5 <- c();
## T6: Leer para conocer otros pueblos
Esp_first_col_T6 <- c();
## T7: Participar en eventos teatrales
Esp_first_col_T7 <- c();
## T8: Leer y utilizar distintos documentos administrativos y legales
Esp_first_col_T8 <- c();
## T9: Investigar y debatir sobre la diversidad lingüística
Esp_first_col_T9 <- c();
## T10: Investigar y debatir sobre la diversidad lingüística
Esp_first_col_T10 <- c();


for (i in seq(1,10, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,9, by=1)){
  Esp_first_col_T7[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[8]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,7, by=1)){
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Esp_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T10[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Esp_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Esp_first_col_T8[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T9[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[10]/td[2]/table/tbody/tr/td[1]/a",
                                 as.character(i), "]/a", sep="")
}

Esp_second_col_T1[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td/a"
Esp_first_col_T6[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td/a"

# Pasting elements
Esp_T1 <- c(Esp_first_col_T1, Esp_second_col_T1)
Esp_T2 <- c(Esp_first_col_T2)
Esp_T3 <- c(Esp_first_col_T3)
Esp_T4 <- c(Esp_first_col_T4)
Esp_T5 <- c(Esp_first_col_T5)
Esp_T6 <- c(Esp_first_col_T6)
Esp_T7 <- c(Esp_first_col_T7)
Esp_T8 <- c(Esp_first_col_T8)
Esp_T9 <- c(Esp_first_col_T9)
Esp_T10 <- c(Esp_first_col_T10)

pregs_esp_case5 <- c(Esp_T1,Esp_T2,Esp_T3,Esp_T4,Esp_T5,Esp_T6,
                     Esp_T7,Esp_T8,Esp_T9,Esp_T10)
#--------------------------------------
# List of Matemáticas questions
## T1: Significado y uso de los números
Mat_first_col_T1  <- c();
## T2: Significado y uso de las operaciones
Mat_first_col_T2 <- c()
## T3: Significado y uso de las literales
Mat_first_col_T3 <- c(); Mat_second_col_T3 <- c();
## T4: Formas geométricas
Mat_first_col_T4 <- c()
## T5: Medida
Mat_first_col_T5 <- c()
## T6: Transformaciones
Mat_first_col_T6 <- c()
## T7: Análisis de la información
Mat_first_col_T7 <- c()
## T8: Representación de la infromación
Mat_first_col_T8 <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,9, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,8, by=1)){
  Mat_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,7, by=1)){
  Mat_first_col_T7[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[8]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T8[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                                 as.character(i), "]/a", sep="")
}

Mat_second_col_T3[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr[2]/td/a"

# Pasting elements
Mat_T1 <- c(Mat_first_col_T1)
Mat_T2 <- c(Mat_first_col_T2)
Mat_T3 <- c(Mat_first_col_T3, Mat_second_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
Mat_T7 <- c(Mat_first_col_T7)
Mat_T8 <- c(Mat_first_col_T8)
pregs_mat_case5 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6,Mat_T7,Mat_T8)

# Case 6
# Begins with matematicas question number: 
# row 1 begins with question # and ends with question #
#----------------------------------------------------------------------------------------------------------------------------------------------------
# List of Español questions
## T1: Obtener y organizar información
Esp_first_col_T1  <- c();
## T2: Revisar y reescribir textos producidos en distintas áreas de estudio
Esp_first_col_T2 <- c();
## T3: Participar en eventos comunicativos formales
Esp_first_col_T3 <- c(); Esp_second_col_T3 <- c();
## T4: Leer y escribir para compartir la interpretación de textos literarios
Esp_first_col_T4 <- c();
## T5:Hacer el seguimiento de algún subgénero, temática o movimiento
Esp_first_col_T5 <- c();
## T6:Leer para conocer otros pueblos
Esp_first_col_T6 <- c();
## T7:Leer y utilizar distintos documentos administrativos y legales
Esp_first_col_T7 <- c();
## T8:Investigar y debatir sobre la diversidad lingüística
Esp_first_col_T8 <- c();
## T9: Analizar y valorar críticamente a los medios de comunicación 
Esp_first_col_T9 <- c(); Esp_second_col_T9 <- c();

for (i in seq(1,10, by=1)){
  Esp_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_first_col_T9[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[10]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,9, by=1)){
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,7, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Esp_first_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Esp_first_col_T8[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Esp_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Esp_first_col_T7[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[8]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Esp_second_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}
Esp_second_col_T9[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[10]/td[2]/table/tbody/tr[2]/td/a"
# Pasting elements
Esp_T1 <- c(Esp_first_col_T1)
Esp_T2 <- c(Esp_first_col_T2)
Esp_T3 <- c(Esp_first_col_T3, Esp_second_col_T3)
Esp_T4 <- c(Esp_first_col_T4)
Esp_T5 <- c(Esp_first_col_T5)
Esp_T6 <- c(Esp_first_col_T6)
Esp_T7 <- c(Esp_first_col_T7)
Esp_T8 <- c(Esp_first_col_T8)
Esp_T9 <- c(Esp_first_col_T9, Esp_second_col_T9)
pregs_esp_case6 <- c(Esp_T1,Esp_T2,Esp_T3,Esp_T4,Esp_T5,Esp_T6,Esp_T8,
                     Esp_T9)
#--------------------------------------
# List of Matemáticas questions
## T1: Significado y uso de las operaciones
Mat_first_col_T1  <- c();
## T2: Significado y uso de las literales
Mat_first_col_T2 <- c(); Mat_second_col_T2 <- c()
## T3: Formas geométricas
Mat_first_col_T3 <- c(); Mat_second_col_T3 <- c()
## T4: Medida
Mat_first_col_T4 <- c()
## T5: Transformaciones
Mat_first_col_T5 <- c()
## T6: Análisis de la información
Mat_first_col_T6 <- c()
# T7: Representación de la información
Mat_first_col_T7 <- c(); Mat_second_col_T7 <- c()


for (i in seq(1,10, by=1)){
  Mat_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T7[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[8]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Mat_second_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_second_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
  Mat_second_col_T7[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[8]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
Mat_first_col_T6[[1]] <- '/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td/a'
# Pasting elements
Mat_T1 <- c(Mat_first_col_T1)
Mat_T2 <- c(Mat_first_col_T2, Mat_second_col_T2)
Mat_T3 <- c(Mat_first_col_T3, Mat_second_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
Mat_T6 <- c(Mat_first_col_T7, Mat_second_col_T7)
pregs_mat_case6 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6, Mat_T7)

# Case 7
# Begins with matematicas question number: 
# row 1 begins with question #13 and ends with question #117
#----------------------------------------------------------------------------------------------------------------------------------------------------
# List of Español questions
## T1: Obtener y organizar información
Esp_first_col_T1  <- c(); Esp_second_col_T1 <- c();
## T2: Revisar y reescribir textos producidos en distintas áreas de estudio
Esp_first_col_T2 <- c()
## T3: Leer y escribir para compartir la interpretación de textos literarios
Esp_first_col_T3 <- c()
## T4: Participar en eventos comunicativos formales
Esp_first_col_T4 <- c()
## T5: Leer y utilizar distintos documentos administrativos y legales
Esp_first_col_T5 <- c()
## T6: Analizar y valorar críticamente a los medios de comunicación
Esp_first_col_T6 <- c()

for (i in seq(1,10, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  }

for (i in seq(1,8, by=1)){
  Esp_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="") 
}
for (i in seq(1,7, by=1)){
  Esp_first_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[8]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Esp_second_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}

# Pasting elements
Esp_T1 <- c(Esp_first_col_T1, Esp_second_col_T1)#
Esp_T2 <- c(Esp_first_col_T2)
Esp_T3 <- c(Esp_first_col_T3)
Esp_T4 <- c(Esp_first_col_T4)
Esp_T5 <- c(Esp_first_col_T5)
Esp_T6 <- c(Esp_first_col_T6)
pregs_esp_case7 <- c(Esp_T1,Esp_T2,Esp_T3,Esp_T4,Esp_T5,Esp_T6)
#--------------------------------------
# List of Matemáticas questions
## T1: Significado y uso de las operaciones
Mat_first_col_T1  <- c(); Mat_second_col_T1 <- c(); 
## T2: Significado y uso de las literales
Mat_first_col_T2 <- c()
## T3: Formas geométricas
Mat_first_col_T3 <- c()
## T4: Medida
Mat_first_col_T4 <- c()
## T5: Transformaciones
Mat_first_col_T5 <- c()
## T6: Análisis de la información
Mat_first_col_T6 <- c()
## T7: Representación de la información
Mat_first_col_T7 <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[4]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,9, by=1)){
  Mat_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T7[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[8]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,7, by=1)){
  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Mat_first_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Mat_second_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[6]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}

# Pasting elements
Mat_T1 <- c(Mat_first_col_T1, Mat_second_col_T1)
Mat_T2 <- c(Mat_first_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
Mat_T7 <- c(Mat_first_col_T7)
pregs_mat_case7 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6,Mat_T7)


#--------------------------------------
# email funcitons
# Send and e-mail if an error occurs
send_error_email <- function(){
  sender <- "servidorscrapingr@gmail.com"
  recipients <- c("Sebastian Cadavid Sanchez <s.cadavid1587@gmail.com>")
  send.mail(from = sender,
            to = recipients,
            subject = "El proceso de scraping ENLACE - 2010 se detuvo.",
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
          subject = "El proceso de scraping ENLACE - 2010 se detuvo.",
          body = "El proceso se detuvo porque finalizó sin errores.",
          smtp = list(host.name = "smtp.gmail.com", port = 465,
                      user.name = "servidorscrapingr@gmail.com",
                      passwd = "ServidorScrape1", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)
}

write.csv(DataBase, file="CreatedData/2010/DataBase_ENLACE2010_Total.csv", row.names = FALSE)
write.csv(DataBaseCorrecta, file="CreatedData/2010/DataBase_ENLACE2010_Correcta.csv", row.names = FALSE)

## function for retrying
retry <- function(.FUN, max.attempts = 10000, sleep.seconds = 0.5) {
  expr <- substitute(.FUN)
  retry_expr(expr, max.attempts, sleep.seconds)
}

retry_expr <- function(expr, max.attempts = 10000, sleep.seconds = 0.5) {
  x <- try(eval(expr))
  
  if(inherits(x, "try-error") && max.attempts > 0) {
    Sys.sleep(sleep.seconds)
    return(retry_expr(expr, max.attempts - 1))
  }
  
  x
}


print("Prelims - Done")
