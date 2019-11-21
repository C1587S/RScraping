# ----- SCRAPING starts Here
#shell('docker run -d -p 4445:4444 selenium/standalone-firefox')
# initialize the loop counter
Scrape_2013 <- function(){
longList <- nrow(rawData_2013)
# 1.Open the browser and navigate the URL
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "firefox")
remDr$open(silent = TRUE) #opens a browser
url_raw <- "http://143.137.111.105/Enlace/Resultados2013/Basica2013/R13Folio.aspx"
remDr$navigate(url_raw)

DataBaseYa=try(fread("CreatedData/2013/DataBase_ENLACE2013_Total.csv", stringsAsFactors = F),silent=T)
if (!inherits(DataBaseYa, "try-error")) {
  rawData_2013 <- subset(rawData_2013, !(V1 %in% DataBaseYa$Folio))
}

for (folioID in rawData_2013$V1){ #rawData_2013
  try(remDr$close(),silent=T)
  remDr$open(silent = TRUE) #opens a browser
  url_raw <- "http://143.137.111.105/Enlace/Resultados2013/Basica2013/R13Folio.aspx"
  remDr$navigate(url_raw)
# 2. Fill in the form to make the query with FOLIO keys
  print(paste("Now in folio ", folioID))

  suppressMessages(try(webElem<-remDr$findElement(using = 'xpath', value = '//*[(@id = "txtFolioAlumno")]'), silent=T))
  suppressMessages(
    while(inherits(webElem, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      webElem<-remDr$findElement(using = 'xpath', value = '//*[(@id = "txtFolioAlumno")]')
    }
  )
  
  webElem$sendKeysToElement(list(folioID)) # fill in the form with the folio number
  ConsButton <- '//*[(@id = "btnConsulta")]'
  
  suppressMessages(try(webElem <- remDr$findElement(value = ConsButton), silent=T))
  suppressMessages(
    while(inherits(webElem, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      webElem <- remDr$findElement(value = ConsButton)
    }
  )

  webElem$clickElement() # click on it
  Sys.sleep(0.5)

# 3. Extract general information
  suppressMessages(webElemTable <- try(remDr$findElement(using = 'xpath', value = '/html/body/form/div[4]/center/div[1]/div[2]/div/div/table'), silent = T))
  suppressMessages(
    while(inherits(webElemTable, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      webElemTable <- try(remDr$findElement(using = 'xpath', value = '/html/body/form/div[4]/center/div[1]/div[2]/div/div/table'), silent = T)
    }
  )

  GeneralTable_parsed <- htmlParse(remDr$getPageSource()[[1]]) # extract the parsed html table
  GeneralTable <- readHTMLTable(GeneralTable_parsed)
  GeneralTable <- GeneralTable[[2]]# 2 is the number of the df with the desired info
  #GeneralTable
  col1Values <- GeneralTable$V3
  col2Values <- GeneralTable$V5
  DataBase$Folio[1] <- (levels(col1Values)[1])
  DataBase$Grado[1] <- (levels(col1Values)[6])
  DataBase$Grupo[1] <- (levels(col1Values)[2])
  DataBase$Turno[1] <- (levels(col1Values)[5])
  DataBase$TipoDeEscuela[1] <- (levels(col1Values)[3])
  DataBase$NombreDeLaEscuela[1] <- (levels(col1Values)[4])
  DataBase$CCT[1] <- as.character(levels(col2Values)[1])
  DataBase$Entidad[1] <- as.character(levels(col2Values)[2])
  DataBase$GradoDeMarginacion[1]<- as.character(levels(col2Values)[3])

# 4. General results for: español and matemáticas
  
  FrameID <- '//*[(@id = "idframe1")]'
  suppressMessages(try(webFrames <- remDr$findElements(using = 'xpath', value = FrameID), silent=T))
  suppressMessages(
    while(inherits(webFrames, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      webFrames <- remDr$findElements(using = 'xpath', value = FrameID)
    }
  )
  sapply(webFrames, function(x){x$getElementAttribute("src")})
  remDr$switchToFrame(webFrames[[1]])
  # Resultados de español
  res_esp <- '//*[@id="lblAsig1"]'
  suppressMessages(try(ResultEspElem <- remDr$findElement(using = 'xpath', value = res_esp))) # get into the table, silent=T))
  suppressMessages(
    while(inherits(ResultEspElem, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      ResultEspElem <- remDr$findElement(using = 'xpath', value = res_esp) # get into the table
    }
  )
  
  ResultEsp <- ResultEspElem$getElementText()
  # Resultados de matemáticas
  res_mat <- '//*[@id="lblAsig2"]'
  suppressMessages(try(ResultMatElem <- remDr$findElement(using = 'xpath', value = res_mat))) # get into the table, silent=T))
  suppressMessages(
    while(inherits(ResultMatElem, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      ResultMatElem <- remDr$findElement(using = 'xpath', value = res_mat) # get into the table
    }
  )
  
  ResultMat <- ResultMatElem$getElementText()
  
  DataBase$PuntajeTotalEsp[1]<- as.integer(ResultEsp)
  DataBase$PuntajeTotalMat[1]<- as.integer(ResultMat)
  remDr$switchToFrame(NULL) # Exiting the frame
 
  # 6. Respuesta de mi hija(o) en Matemáticas
  CalifMatematicasButton <- '//*[@id="__tab_TabContainer1_TabPanel3"]'
  
  suppressMessages(try(webElem <- remDr$findElement(value = CalifMatematicasButton), silent=T))
  suppressMessages(
    while(inherits(webElem, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      webElem <- remDr$findElement(value = CalifMatematicasButton)
    }
  )
  
  resultado = try(remDr$executeScript("arguments[0].click();", list(webElem)), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado <- try(remDr$executeScript("arguments[0].click();", list(webElem)), silent=T)
    }
  )
  
  # Get into the dataframe
  
  FrameEspID <- '//*[(@id = "idframe3")]'
  webFramesEsp = try(remDr$findElements(using = 'xpath', value = FrameEspID), silent=T)
  while(inherits(webFramesEsp, "try-error")){
    Sys.sleep(0.5) # This part is mandatory
    webFramesEsp = try(remDr$findElements(using = 'xpath', value = FrameEspID), silent=T)
  }
  
  sapply(webFramesEsp, function(x){x$getElementAttribute("src")})
  remDr$switchToFrame(webFramesEsp[[1]])
  
  # select the case
  # find question number 1
  
  pregunta_case1 <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[1]/a"),silent=T)
  while(inherits(pregunta_case1, "try-error")){
    Sys.sleep(0.5) # This part is mandatory
    pregunta_case1 <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[5]/td[2]/table/tbody/tr/td[1]/a"),silent=T)
  } 
  case_nroPregunta1 <- pregunta_case1$getElementText()
  nroPregunta_1 <- gsub("(?<![0-9])0+", "", case_nroPregunta1, perl = TRUE)
  nroPregunta1_int <- as.integer(nroPregunta_1)
  # find question number 2 en caso de necesitar una segunda pregunta para hacer la diferencia
  # pregunta_case2 <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[2]/a"),silent=T)
  # while(inherits(pregunta_case2, "try-error")){
  #   Sys.sleep(0.5) # This part is mandatory
  #   pregunta_case2 <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[3]/td[2]/table/tbody/tr[1]/td[2]/a"),silent=T)
  # } 
  # case_nroPregunta2 <- pregunta_case2$getElementText()
  # nroPregunta_2 <- gsub("(?<![0-9])0+", "", case_nroPregunta2, perl = TRUE)
  # nroPregunta2_int <- as.integer(nroPregunta_2)
  
  
  if (nroPregunta1_int == 50) {
    pregs_mat=pregs_mat1; pregs_esp=pregs_esp1
  } else if(nroPregunta1_int == 80) {
    pregs_mat=pregs_mat2; pregs_esp=pregs_esp2
  } else if(nroPregunta1_int == 17) {
    pregs_mat=pregs_mat3; pregs_esp=pregs_esp3
  } else if(nroPregunta1_int == 47) {
    pregs_mat=pregs_mat4; pregs_esp=pregs_esp4
  } else {
    print("The case is not identified, please check and include it in prelims_2013.R")
  }
  ### Extract info
  suppressMessages(
    for (i in seq(1,length(pregs_mat), by=1)){
      preguntaID<- pregs_mat[[i]]
      nroPreguntaID <- paste(preguntaID, "/font/strong", sep ="")
      resultado = try(nroPreguntaElem <- remDr$findElement(value = nroPreguntaID), silent=T)
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado <- try(nroPreguntaElem <- remDr$findElement(value = nroPreguntaID), silent=T)
      }
      
      nroPregunta <- nroPreguntaElem$getElementText()
      nroPregunta_i <- gsub("(?<![0-9])0+", "", nroPregunta, perl = TRUE) # for omitting leading zeroes
      nroPregunta_int <- as.integer(nroPregunta_i)
      print(paste("Matemáticas - Scraping question #", nroPregunta_int, "From folio", folioID, "of", longList , sep =" "))
      # Now, click on each question
      elemento_preg <- remDr$findElement(value = preguntaID)
      resultado = try(remDr$executeScript("arguments[0].click();", list(elemento_preg)), silent=T)
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado <- try(remDr$executeScript("arguments[0].click();", list(elemento_preg)), silent=T)
      }
      preg_correctaID <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[1]/td/b"), silent=T)
      while(inherits(preg_correctaID, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        preg_correctaID <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[1]/td/b"), silent=T)
      }
      correctaInfo    <- preg_correctaID$getElementText()
      # when there is no answer
      preg_marcadaID <- tryCatch({remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[2]/td/b")}, silent=TRUE,error=function(err) NA)
      if (typeof(preg_marcadaID)=="S4"){
        marcadaInfo <- preg_marcadaID$getElementText()
      } else {
        marcadaInfo <- "sin_respuesta"
        print(marcadaInfo)
      }
      # Asign values to the database using the question number
      if(is.na(DataBaseCorrecta[1, paste0("MatCorrecta_",nroPregunta_int)]))  DataBaseCorrecta[1, paste0("MatCorrecta_",nroPregunta_int)]<-as.character(correctaInfo)
      DataBase[1, paste0("MatMarcada_",nroPregunta_int)] <-as.character(marcadaInfo)
      # going back to the frame
      regTablero <- remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[3]/tbody/tr/td/span")
      resultado = try(remDr$executeScript("arguments[0].click();", list(regTablero)), silent=T)
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado <- try(remDr$executeScript("arguments[0].click();", list(regTablero)), silent=T)
      }
    }
  )
  # Exiting the frame
  remDr$switchToFrame(NULL)
  
# 5. Respuesta de mi hija(o) en Español
  CalifEspanolButton <- '//*[@id="__tab_TabContainer1_TabPanel2"]'
  webElem <- remDr$findElement(value = CalifEspanolButton)
  resultado = try(remDr$executeScript("arguments[0].click();", list(webElem)), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado <- try(remDr$executeScript("arguments[0].click();", list(webElem)), silent=T)
    }
  )
  ###############################
  Sys.sleep(0.5)
  FrameEspID <- '//*[(@id = "idframe2")]'
  webFramesEsp <- try(remDr$findElements(using = 'xpath', value = FrameEspID), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      webFramesEsp <- try(remDr$findElements(using = 'xpath', value = FrameEspID), silent=T)
    }
  )  
  
  sapply(webFramesEsp, function(x){x$getElementAttribute("src")})
  remDr$switchToFrame(webFramesEsp[[1]])
### Extract info
  suppressMessages(
  for (i in seq(1,length(pregs_esp), by=1)){
      preguntaID<- pregs_esp[[i]]
      nroPreguntaID <- paste(preguntaID, "/font/strong", sep ="")
      resultado = try(nroPreguntaElem <- remDr$findElement(value = nroPreguntaID), silent=T)
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado <- try(nroPreguntaElem <- remDr$findElement(value = nroPreguntaID), silent=T)
      }
      nroPregunta <- nroPreguntaElem$getElementText()
      nroPregunta_i <- gsub("(?<![0-9])0+", "", nroPregunta, perl = TRUE) # for omitting leading zeroes
      nroPregunta_int <- as.integer(nroPregunta_i)
      print(paste("Español - Scraping question #", nroPregunta_int, "From folio", folioID, "of", longList , sep =" "))
      # Now, click on each question
      elemento_preg <- remDr$findElement(value = preguntaID)
      resultado = try(remDr$executeScript("arguments[0].click();", list(elemento_preg)), silent=T)
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado <- try(remDr$executeScript("arguments[0].click();", list(elemento_preg)), silent=T)
      }


      preg_correctaID <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[1]/td/b"), silent=T)
      while(inherits(preg_correctaID, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        preg_correctaID <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[1]/td/b"), silent=T)
      }
      correctaInfo    <- preg_correctaID$getElementText()
      # when there is no answer
      preg_marcadaID  <- tryCatch({remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[2]/td/b")}, silent=TRUE,error=function(err) NA)
      if (typeof(preg_marcadaID)=="S4"){
        marcadaInfo <- preg_marcadaID$getElementText()
      } else {
        marcadaInfo <- "sin_respuesta"
        print(marcadaInfo)
      }

      # Asign values to the database using the question number
      if(is.na(DataBaseCorrecta[1, paste0("EspCorrecta_", nroPregunta_int)]))  DataBaseCorrecta[1, paste0("EspCorrecta_",nroPregunta_int)]<-as.character(correctaInfo)
      DataBase[1, paste0("EspMarcada_",nroPregunta_int)] <- as.character(marcadaInfo)
      # going back to the frame
      regTablero <- remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[3]/tbody/tr/td/span")
      resultado= try(remDr$executeScript("arguments[0].click();", list(regTablero)), silent=T)
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado <- try(remDr$executeScript("arguments[0].click();", list(regTablero)), silent=T)
        }
    }
    )
  ## Exiting the frame
  remDr$switchToFrame(NULL)

# 7.  Refreshing main page to the main page
# Random pause before next query - add one to the counter
random_num <- runif(1,1,3)
Sys.sleep(random_num)
remDr$navigate(url_raw)
write.table(DataBase, file="CreatedData/2013/DataBase_ENLACE2013_Total.csv", row.names = FALSE, append = TRUE,col.names=F,sep=",")
write.table(DataBaseCorrecta, file="CreatedData/2013/DataBase_ENLACE2013_Correcta.csv", row.names = FALSE,col.names=T,sep=",")
} # FOR loop for FOLIO-list ends here

} # function ends here
