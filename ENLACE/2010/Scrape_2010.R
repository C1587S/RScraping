# ----- SCRAPING starts Here
#shell('docker run -d -p 4445:4444 selenium/standalone-chrome')
# initialize the loop counter
Scrape_2010 <- function(){
longList <- nrow(rawData_2010)
# 1.Open the browser and navigate the URL
# eCaps <- list(chromeOptions = list(
#   args = c('--no-sandbox','--headless', '--disable-gpu', '--window-size=1280,800','--disable-dev-shm-usage')
# ))
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "firefox", extraCapabilities = list(marionette = TRUE)) # extraCapabilities = eCaps

remDr$open(silent = TRUE) #opens a browser
url_raw <- "http://143.137.111.105/Enlace/Resultados2010/Basica2010/R10Folio.aspx" # ENLACE URL
remDr$navigate(url_raw) # Navigate the page with the browser

DataBaseYa=try(fread("CreatedData/2010/DataBase_ENLACE2010_Total.csv", stringsAsFactors = F),silent=T)
if (!inherits(DataBaseYa, "try-error")) {
  rawData_2010 <- subset(rawData_2010, !(V1 %in% DataBaseYa$Folio))
}

for (folioID in rawData_2010$V1){ #rawData_2010
  try(remDr$close(),silent=T)
  remDr$open(silent = TRUE) #opens a browser
  url_raw <- "http://143.137.111.105/Enlace/Resultados2010/Basica2010/R10Folio.aspx" # ENLACE URL
  remDr$navigate(url_raw) # Navigate the page with the browser
# 2. Fill in the form to make the query with FOLIO keys
  print(paste("Now in folio ", folioID))

  suppressMessages(webElem<-try(remDr$findElement(using = 'xpath', value = '//*[(@id = "txtFolioAlumno")]'), silent = T))
  suppressMessages(
    while(inherits(webElem, "try-error")){
      #webElem$clickElement()
      webElem<-try(remDr$findElement(using = 'xpath', value = '//*[(@id = "txtFolioAlumno")]'), silent = T)
    }
  )  
  
  webElem$sendKeysToElement(list(folioID)) # fill in the form with the folio number
  ConsButton <- '//*[(@id = "imgButConsultar")]'
  
  suppressMessages(try(webElem <- remDr$findElement(value = ConsButton), silent = T))
  suppressMessages(
    while(inherits(webElem, "try-error")){
      #webElem$clickElement()
      try(webElem <- remDr$findElement(value = ConsButton), silent = T)
    }
  )  
  
  webElem$clickElement() # click on it
  Sys.sleep(0.5)
# 3. Extract general information
  suppressMessages(webElemTable <- try(remDr$findElement(using = 'xpath', value = '/html/body/form/div[3]/center/div[1]/div[2]/table'), silent=T)) # get into the table
  suppressMessages(
    while(inherits(webElemTable, "try-error")){
      #webElem$clickElement()
      webElemTable <- try(remDr$findElement(using = 'xpath', value = '/html/body/form/div[3]/center/div[1]/div[2]/table'), silent=T)
      }
    )

  GeneralTable_parsed <- htmlParse(remDr$getPageSource()[[1]]) # extract the parsed html table
  GeneralTable <- readHTMLTable(GeneralTable_parsed)
  GeneralTable <- GeneralTable[[2]]# 2 is the number of the df with the desired info
  #GeneralTable
  col1Values <- GeneralTable$V2
  col2Values <- GeneralTable$V4
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
  suppressMessages(try(webFrames <- remDr$findElements(using = 'xpath', value = FrameID)))
  suppressMessages(
    while(inherits(webElemTable, "try-error")){
      #webElem$clickElement()
      try(webFrames <- remDr$findElements(using = 'xpath', value = FrameID), silent=T)
    }
  )  
  sapply(webFrames, function(x){x$getElementAttribute("src")})
  remDr$switchToFrame(webFrames[[1]])
  # Resultados de español
  res_esp <- '//*[@id="lblAsig1"]'
  suppressMessages(try(ResultEspElem <- remDr$findElement(using = 'xpath', value = res_esp ), silent = T))
  suppressMessages(
    while(inherits(webElemTable, "try-error")){
      #webElem$clickElement()
      try(ResultEspElem <- remDr$findElement(using = 'xpath', value = res_esp ))
    }
  )    
  ResultEsp <- ResultEspElem$getElementText()
  # Resultados de matemáticas
  res_mat <- '//*[@id="lblAsig2"]'
  
  suppressMessages(try(ResultMatElem <- remDr$findElement(using = 'xpath', value = res_mat), silent = T))
  suppressMessages(
    while(inherits(webElemTable, "try-error")){
      #webElem$clickElement()
      try(ResultMatElem <- remDr$findElement(using = 'xpath', value = res_mat), silent = T)
    }
  )  
  ResultMat <- ResultMatElem$getElementText()
  DataBase$PuntajeTotalEsp[1]<- as.integer(ResultEsp)
  DataBase$PuntajeTotalMat[1]<- as.integer(ResultMat)
  
  remDr$switchToFrame(NULL) # Exiting the frame

  # 6. Respuesta de mi hija(o) en Matemáticas
  suppressMessages(try(webElem <- remDr$findElement(value = '//*[(@id = "__tab_TabContainer1_TabPanel3")]//div'), silent = T))
  suppressMessages(
    while(inherits(webElemTable, "try-error")){
      #webElem$clickElement()
      try(webElem <- remDr$findElement(value = '//*[(@id = "__tab_TabContainer1_TabPanel3")]//div'), silent = T)
    }
  )  
  
  resultado = try(webElem$clickElement(), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado <- try(webElem$clickElement(), silent=T)
    }
  )
  # Get into the dataframe
  FrameEspID <- '//*[(@id = "idframe3")]'
 
  suppressMessages(try(webFramesEsp <- remDr$findElements(using = 'xpath', value = FrameEspID), silent = T))
  suppressMessages(
    while(inherits(webElemTable, "try-error")){
      #webElem$clickElement()
      (try(webFramesEsp <- remDr$findElements(using = 'xpath', value = FrameEspID), silent = T))
    }
  )   
  sapply(webFramesEsp, function(x){x$getElementAttribute("src")})
  remDr$switchToFrame(webFramesEsp[[1]])
  # select the case
  pregunta_case_A <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[1]/a/font/strong"),silent=T)
  while(inherits(pregunta_case_A, "try-error")){
    Sys.sleep(0.5) # This part is mandatory
    pregunta_case_A <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[1]/a/font/strong"),silent=T)
  } 
  pregunta_case_B <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[1]/a/font/strong"),silent=T)
  while(inherits(pregunta_case_B, "try-error")){
    Sys.sleep(0.5) # This part is mandatory
    pregunta_case_B <- try(remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[7]/td/table[1]/tbody/tr[2]/td[2]/table/tbody/tr[2]/td[1]/a/font/strong"),silent=T)
  } 
  
  case_nroPreguntaA <- pregunta_case_A$getElementText()
  case_nroPreguntaB <- pregunta_case_B$getElementText()
  nroPregunta_1A <- gsub("(?<![0-9])0+", "", case_nroPreguntaA, perl = TRUE)
  nroPregunta1A_int <- as.integer(nroPregunta_1A)
  nroPregunta_1B <- gsub("(?<![0-9])0+", "", case_nroPreguntaB, perl = TRUE)
  nroPregunta1B_int <- as.integer(nroPregunta_1B)
  
  if (nroPregunta1A_int == 11 & nroPregunta1B_int == 44) {
    pregs_mat=pregs_mat_case1; pregs_esp=pregs_esp_case1
  } else if(nroPregunta1A_int == 11 & nroPregunta1B_int == 26) {
    pregs_mat=pregs_mat_case2; pregs_esp=pregs_esp_case2
  } else if(nroPregunta1A_int == 9 & nroPregunta1B_int == 52){
    pregs_mat=pregs_mat_case3; pregs_esp=pregs_esp_case3
  } else if(nroPregunta1A_int == 11 & nroPregunta1B_int == 91){
    pregs_mat=pregs_mat_case4; pregs_esp=pregs_esp_case4
  } else if(nroPregunta1A_int == 1 & nroPregunta1B_int == 114){
    pregs_mat=pregs_mat_case5; pregs_esp=pregs_esp_case5
  } else if(nroPregunta1A_int == 12 & nroPregunta1B_int == 13){
    pregs_mat=pregs_mat_case6; pregs_esp=pregs_esp_case6
  } else if(nroPregunta1A_int == 13 & nroPregunta1B_int == 118){
    pregs_mat=pregs_mat_case7; pregs_esp=pregs_esp_case7
  } else {print("The case is not identified, please include check and include it")}
  
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
      preg_marcadaID  <- tryCatch({remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[2]/td/b")}, silent=TRUE,error=function(err) NA)
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
  suppressMessages(try( webElem <- remDr$findElement(value = '//*[(@id = "__tab_TabContainer1_TabPanel2")]//div'), silent = T))
  suppressMessages(
    while(inherits(webElemTable, "try-error")){
      #webElem$clickElement()
      try( webElem <- remDr$findElement(value = '//*[(@id = "__tab_TabContainer1_TabPanel2")]//div'), silent = T)
    }
  )   
  resultado = try(webElem$clickElement(), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado <- try(webElem$clickElement(), silent=T)
    }
  )
  ###############################
  # Get into the frame
  FrameEspID <- '//*[(@id = "idframe2")]'
  suppressMessages(try(webFramesEsp <- remDr$findElements(using = 'xpath', value = FrameEspID), silent = T))
  suppressMessages(
    while(inherits(webElemTable, "try-error")){
      #webElem$clickElement()
      try(webFramesEsp <- remDr$findElements(using = 'xpath', value = FrameEspID), silent = T)
    }
  )   
  
  sapply(webFramesEsp, function(x){x$getElementAttribute("src")})
  remDr$switchToFrame(webFramesEsp[[1]])
### Exctract info
  suppressMessages(
  for (i in seq(1,length(pregs_esp), by=1)){
    preguntaID <- pregs_esp[[i]]
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
    resultado = try(remDr$executeScript("arguments[0].click();", list(regTablero)), silent=T)
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
  write.table(DataBase, file="CreatedData/2010/DataBase_ENLACE2010_Total.csv", row.names = FALSE, append = TRUE,col.names=F,sep=",")
  write.table(DataBaseCorrecta, file="CreatedData/2010/DataBase_ENLACE2010_Correcta.csv", row.names = FALSE,col.names=T,sep=",")

} # FOR loop for FOLIO-list ends here

#   
#   
} # function ends
