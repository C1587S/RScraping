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
rawData_2013 <- fread('RawData/Basica2013.csv', header = FALSE, skip=1)
columnasN <- nrow(rawData_2013)
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
#--------------------------------------

# Case 1
# Begins with mstematicas question number: 
#---------------------------------------------------------------------------------------------------------------------------------------------------- 
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
pregs_esp1 <- c(Esp_T1,Esp_T2,Esp_T3,Esp_T4,Esp_T5)

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
pregs_mat1 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4)
#--------------------------------------
# Case 2
# Begins with matematicas question number: 80
#---------------------------------------------------------------------------------------------------------------------------------------------------- 

# List of Español questions
## T1: Aspectos sintácticos y semánticos
Esp_first_col_T1  <- c()
## T2: Búsqueda y manejo de la información
Esp_first_col_T2  <- c()
## T3: Comprensión e interpretación
Esp_first_col_T3  <- c(); Esp_second_col_T3  <- c()
## T4: Conocimiento del sistema de escritura y ortografía
Esp_first_col_T4  <- c()
## T5: Propiedades y características de los textos
Esp_first_col_T5  <- c(); Esp_second_col_T5 <- c()


for (i in seq(1,10, by=1)){
  Esp_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[1]/td[",
                                 as.character(i), "]/a", sep="")
  Esp_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
  
}
for (i in seq(1,9, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  
}
for (i in seq(1,7, by=1)){
  Esp_second_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
  
}
for (i in seq(1,5, by=1)){
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  
}
for (i in seq(1,4, by=1)){
  Esp_second_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
  
}
for (i in seq(1,2, by=1)){
  Esp_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  
}

# paste all the elements
Esp_T1 <- c(Esp_first_col_T1)
Esp_T2 <- c(Esp_first_col_T2)
Esp_T3 <- c(Esp_first_col_T3, Esp_second_col_T3)
Esp_T4 <- c(Esp_first_col_T4)
Esp_T5 <- c(Esp_first_col_T5, Esp_second_col_T5)
pregs_esp2 <- c(Esp_T1, Esp_T2, Esp_T3, Esp_T4, Esp_T5)

#--------------------------------------

# List of Matemáticas questions
## T1: Análisis y representación de datos
Mat_first_col_T1  <- c()
## T2: Figuras y cuerpos
Mat_first_col_T2  <- c()
## T3: Medida
Mat_first_col_T3  <- c(); Mat_second_col_T3  <- c()
## T4: Números y sistemas de numeración
Mat_first_col_T4  <- c(); Mat_second_col_T4  <- c()
## T5: Problemas aditivos
Mat_first_col_T5  <- c()
## T6: Problemas multiplicativos
Mat_first_col_T6  <- c()
## T7: Proporcionalidad y funciones
Mat_first_col_T7  <- c()
## T8: Ubicación espacial
Mat_first_col_T8  <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,8, by=1)){
  Mat_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Mat_first_col_T7[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[17]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Mat_first_col_T8[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[19]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Mat_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[15]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_second_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}
Mat_second_col_T4[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr[2]/td/a"

# paste all the elements
Mat_T1 <- c(Mat_first_col_T1)
Mat_T2 <- c(Mat_first_col_T2)
Mat_T3 <- c(Mat_first_col_T3, Mat_second_col_T3)
Mat_T4 <- c(Mat_first_col_T4, Mat_second_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
Mat_T7 <- c(Mat_first_col_T7)
Mat_T8 <- c(Mat_first_col_T8)
pregs_mat2 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6,Mat_T7,Mat_T8)

# Case 3
# Begins with matematicas question number: 17
#---------------------------------------------------------------------------------------------------------------------------------------------------- 

# List of Español questions
## T1: Aspectos sintácticos y semánticos
Esp_first_col_T1  <- c(); Esp_second_col_T1  <- c(); Esp_third_col_T1  <- c();
## T2: Búsqueda y manejo de información
Esp_first_col_T2  <- c()
## T3: Comprensión e interpretación
Esp_first_col_T3  <- c(); Esp_second_col_T3  <- c()
## T4: Conocimiento del sistema de escritura y ortografía
Esp_first_col_T4  <- c()
## T5: Propiedades y tipos de textos
Esp_first_col_T5  <- c(); Esp_second_col_T5  <- c()


for (i in seq(1,10, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
  Esp_second_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Esp_third_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr[3]/td[",
                 as.character(i), "]/a", sep="")
  Esp_second_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Esp_second_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
Esp_first_col_T4[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr/td/a"

# paste all the elements
Esp_T1 <- c(Esp_first_col_T1, Esp_second_col_T1, Esp_third_col_T1)
Esp_T2 <- c(Esp_first_col_T2)
Esp_T3 <- c(Esp_first_col_T3, Esp_second_col_T3)
Esp_T4 <- c(Esp_first_col_T4)
Esp_T5 <- c(Esp_first_col_T5, Esp_second_col_T5)
pregs_esp3 <- c(Esp_T1, Esp_T2, Esp_T3, Esp_T4, Esp_T5)

#--------------------------------------

# List of Matemáticas questions
## T1: Análisis y representación de datos
Mat_first_col_T1  <- c()
## T2: Figuras y cuerpos
Mat_first_col_T2  <- c()
## T3: Medida
Mat_first_col_T3  <- c(); Mat_second_col_T3 <- c()
## T4: Números y sistemas de numeración
Mat_first_col_T4  <- c(); Mat_second_col_T4  <- c()
## T5: Problemas aditivos
Mat_first_col_T5  <- c()
## T6: Problemas multiplicativos
Mat_first_col_T6  <- c()
## T7: Proporcionalidad y funciones
Mat_first_col_T7  <- c()
## T8: Ubicación espacial
Mat_first_col_T8  <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,8, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Mat_second_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T7[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[17]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,3, by=1)){
  Mat_first_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[15]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T8[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[19]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_second_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}
Mat_first_col_T2[[1]] <- "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td/a"
# paste all the elements
Mat_T1 <- c(Mat_first_col_T1)
Mat_T2 <- c(Mat_first_col_T2)
Mat_T3 <- c(Mat_first_col_T3,Mat_second_col_T3)
Mat_T4 <- c(Mat_first_col_T4, Mat_second_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
Mat_T7 <- c(Mat_first_col_T7)
Mat_T8 <- c(Mat_first_col_T8)
pregs_mat3 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6,Mat_T7,Mat_T8)

# Case 4
# Begins with matematicas question number:47
#---------------------------------------------------------------------------------------------------------------------------------------------------- 

# List of Español questions
## T1: Aspectos sintácticos y semánticos
Esp_first_col_T1  <- c()
## T2: Búsqueda y manejo de información
Esp_first_col_T2  <- c()
## T3: Comprensión e interpretación
Esp_first_col_T3  <- c(); Esp_second_col_T3  <- c()
## T4: Conocimiento del sistema de escritura y ortografía
Esp_first_col_T4  <- c()
## T5:
Esp_first_col_T5  <- c(); Esp_second_col_T5  <- c()


for (i in seq(1,10, by=1)){
  Esp_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
  Esp_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,8, by=1)){
  Esp_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,7, by=1)){
  Esp_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,6, by=1)){
  Esp_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Esp_second_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,4, by=1)){
  Esp_second_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}

# paste all the elements
Esp_T1 <- c(Esp_first_col_T1)
Esp_T2 <- c(Esp_first_col_T2)
Esp_T3 <- c(Esp_first_col_T3, Esp_second_col_T3)
Esp_T4 <- c(Esp_first_col_T4)
Esp_T5 <- c(Esp_first_col_T5, Esp_second_col_T5)
pregs_esp4 <- c(Esp_T1, Esp_T2, Esp_T3, Esp_T4, Esp_T5)

#--------------------------------------

# List of Matemáticas questions
## T1: Análisis y representación de datos
Mat_first_col_T1  <- c()
## T2: Figuras y cuerpos
Mat_first_col_T2  <- c()
## T3: Medida
Mat_first_col_T3  <- c()
## T4: Números y sistemas de numeración
Mat_first_col_T4  <- c(); Mat_second_col_T4  <- c(); Mat_third_col_T4  <- c()
## T5: Problemas aditivos
Mat_first_col_T5  <- c()
## T6: Problemas multiplicativos
Mat_first_col_T6  <- c()

for (i in seq(1,10, by=1)){
  Mat_first_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr[1]/td[",
                 as.character(i), "]/a", sep="")
  Mat_second_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr[2]/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,9, by=1)){
  Mat_first_col_T6[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[15]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,7, by=1)){
  Mat_first_col_T3[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[9]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,5, by=1)){
  Mat_first_col_T5[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[13]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
}
for (i in seq(1,2, by=1)){
  Mat_first_col_T1[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_first_col_T2[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[7]/td[2]/table/tbody/tr/td[",
                 as.character(i), "]/a", sep="")
  Mat_third_col_T4[[i]] <- paste("/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[11]/td[2]/table/tbody/tr[3]/td[",
                 as.character(i), "]/a", sep="")
}
# paste all the elements
Mat_T1 <- c(Mat_first_col_T1)
Mat_T2 <- c(Mat_first_col_T2)
Mat_T3 <- c(Mat_first_col_T3)
Mat_T4 <- c(Mat_first_col_T4, Mat_second_col_T4, Mat_third_col_T4)
Mat_T5 <- c(Mat_first_col_T5)
Mat_T6 <- c(Mat_first_col_T6)
pregs_mat4 <- c(Mat_T1,Mat_T2,Mat_T3,Mat_T4,Mat_T5,Mat_T6)

#---------------------------------------------------------------------------------------------------------------------------------------------------- 

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

write.csv(DataBase, file="CreatedData/2013/DataBase_ENLACE2013_Total.csv", row.names = FALSE)
write.csv(DataBaseCorrecta, file="CreatedData/2013/DataBase_ENLACE2013_Correcta.csv", row.names = FALSE)

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
