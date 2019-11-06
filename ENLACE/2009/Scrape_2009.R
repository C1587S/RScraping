# ----- SCRAPING starts Here
#shell('docker run -d -p 4445:4444 selenium/standalone-chrome')
# initialize the loop counter

Scrape_2009 <- function(){
longList <- nrow(rawData_2009)
# 1.Open the browser and navigate the URL
eCaps <- list(chromeOptions = list(
  args = c('--no-sandbox','--headless', '--disable-gpu', '--window-size=1280,800','--disable-dev-shm-usage')
))
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome",extraCapabilities = eCaps)

remDr$open(silent = TRUE) #opens a browser
url_raw <- "http://143.137.111.105/Enlace/Resultados2009/Basica2009/r09Folio.asp"
remDr$navigate(url_raw) # Navigate the page with the browser

DataBaseYa=try(fread("CreatedData/2009/DataBase_ENLACE2009_Total.csv", stringsAsFactors = F),silent=T)
if (!inherits(DataBaseYa, "try-error")) {
  rawData_2009 <- subset(rawData_2009, !(V1 %in% DataBaseYa$Folio))
}


for (folioID in rawData_2009$V1){ #rawData_2009
  try(remDr$close(),silent=T)
  remDr$open(silent = TRUE) #opens a browser
  url_raw <- "http://143.137.111.105/Enlace/Resultados2009/Basica2009/r09Folio.asp"
  remDr$navigate(url_raw) # Navigate the page with the browser
  # 2. Fill in the form to make the query with FOLIO keys
  print(paste("Now in folio ", folioID))
  
  webElem<-remDr$findElement(using = 'xpath', value = '//*[(@id = "Usuario")]') # find the form
  webElem$sendKeysToElement(list(folioID)) # fill in the form with the folio number
  webElem <- remDr$findElement(value = '//td//td//img') # find the button
  webElem$clickElement() # click on it
  Sys.sleep(0.5)
  # 3. Extract general information
  suppressMessages(webElemTable <- try(remDr$findElement(using = 'xpath', value = '/html/body/table[3]'))) # get into the table
  suppressMessages(
    while(inherits(webElemTable, "try-error")){
      webElem$clickElement()
      Sys.sleep(0.5) # This part is mandatory
      webElemTable <- try(remDr$findElement(using = 'xpath', value = '/html/body/table[3]'),silent=T)
    }
  )
  
  GeneralTable_parsed <- htmlParse(remDr$getPageSource()[[1]]) # extract the parsed html table
  GeneralTable <- readHTMLTable(GeneralTable_parsed)
  GeneralTable <- GeneralTable[[3]] # 2 is the number of the df with the desired info
  #GeneralTable
  col1Values <- GeneralTable$V3
  col2Values <- GeneralTable$V6
  DataBase$Folio[1] <- (levels(col1Values)[1])
  DataBase$Grado[1] <- (levels(col1Values)[7])
  DataBase$Grupo[1] <- (levels(col1Values)[2])
  DataBase$Turno[1] <- (levels(col1Values)[6])
  DataBase$TipoDeEscuela[1] <- (levels(col1Values)[4])
  DataBase$NombreDeLaEscuela[1] <- (levels(col1Values)[5])
  DataBase$CCT[1] <- as.character(levels(col2Values)[1])
  DataBase$Entidad[1] <- as.character(levels(col2Values)[3])
  #  we dont have grado de marginacion for this year
  # 4. General results for: español and matemáticas
  res_esp <- '/html/body/span/table[2]/tbody/tr[4]/td[2]'
  ResultEspElem <- remDr$findElement(using = 'xpath', value = res_esp ) # get into the table
  ResultEsp <- ResultEspElem$getElementText()
  # Resultados de matemáticas
  res_mat <- '/html/body/span/table[2]/tbody/tr[4]/td[4]'
  ResultMatElem <- remDr$findElement(using = 'xpath', value = res_mat) # get into the table
  ResultMat <- ResultMatElem$getElementText()
  DataBase$PuntajeTotalEsp[1] <- as.integer(ResultEsp)
  DataBase$PuntajeTotalMat[1] <- as.integer(ResultMat)
  
  # 7 Respuesta de mi hija(o) en Matemáticas
  
  CalifMatematicasButton <- '/html/body/map/area[3]'
  webElem <- remDr$findElement(value = CalifMatematicasButton)
  resultado = remDr$executeScript("arguments[0].click();", list(webElem))
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado <- try(remDr$executeScript("arguments[0].click();", list(webElem)),silent=T)
    }
  )
  # select the case
  pregunta_case <- try(remDr$findElement(value = "/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[1]/a/font/strong"),silent=T)
  while(inherits(pregunta_case, "try-error")){
    Sys.sleep(0.5) # This part is mandatory
    pregunta_case <- try(remDr$findElement(value = "/html/body/span/table[2]/tbody/tr[2]/td[2]/table/tbody/tr[1]/td[1]/a/font/strong"),silent=T)
  } 
  case_nroPregunta <- pregunta_case$getElementText()
  nroPregunta_1 <- gsub("(?<![0-9])0+", "", case_nroPregunta, perl = TRUE)
  nroPregunta1_int <- as.integer(nroPregunta_1)
  if (nroPregunta1_int == 10) {
    pregs_mat=pregs_mat_case1; pregs_esp=pregs_esp_case1
  } else if(nroPregunta1_int == 12) {
    pregs_mat=pregs_mat_case2; pregs_esp=pregs_esp_case2
  } else if(nroPregunta1_int == 23) {
    pregs_mat=pregs_mat_case3; pregs_esp=pregs_esp_case3
  } else {
    print("The case is not identified, please check and include it in prelims_2009.R")
  }
  
  ###############################
  suppressMessages(
    for (i in seq(1,length(pregs_mat), by=1)){
      preguntaID<- pregs_mat[[i]]
      nroPreguntaID <- paste0(preguntaID, "/font/strong")
      
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
      preg_correctaID <- try(remDr$findElement(value = "/html/body/span/table[3]/tbody/tr[1]/td/b"), silent = T)
      while(inherits(preg_correctaID, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        preg_correctaID <- try(remDr$findElement(value = "/html/body/span/table[3]/tbody/tr[1]/td/b"), silent = T)
      }  
      correctaInfo    <- preg_correctaID$getElementText()
      # when there is no answer
      preg_marcadaID  <- tryCatch({remDr$findElement(value = "/html/body/span/table[3]/tbody/tr[2]/td/b")}, silent=TRUE,error=function(err) NA)
      if (typeof(preg_marcadaID)=="S4"){
        marcadaInfo <- preg_marcadaID$getElementText()
      } else {
        marcadaInfo <- "sin_respuesta"
        print(marcadaInfo)
      }
      
      if(is.na(DataBaseCorrecta[1, paste0("MatCorrecta_",nroPregunta_int)]))  DataBaseCorrecta[1, paste0("MatCorrecta_",nroPregunta_int)]<-as.character(correctaInfo) 
      DataBase[1, paste0("MatMarcada_",nroPregunta_int)] <-as.character(marcadaInfo) 
      
      # going back to the table
      regTablero <- remDr$findElement(value = "/html/body/span/table[4]/tbody/tr/td/span")
      resultado = try(remDr$executeScript("arguments[0].click();", list(regTablero)), silent = T)
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado <- try(remDr$executeScript("arguments[0].click();", list(regTablero)), silent = T)
      }
    }
  )  
  
  # 5. Respuesta de mi hija(o) en Español
  CalifEspanolButton <- '/html/body/map/area[2]'
  webElem <- remDr$findElement(value = CalifEspanolButton)
  resultado = try(remDr$executeScript("arguments[0].click();", list(webElem)), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado <- try(remDr$executeScript("arguments[0].click();", list(webElem)),silent=T)
    }
  )
  ###############################
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
  preg_correctaID <- try(remDr$findElement(value="/html/body/span/table[3]/tbody/tr[1]/td/b"), silent=T)
  while(inherits(preg_correctaID, "try-error")){
    Sys.sleep(0.5) # This part is mandatory
    preg_correctaID <- try(remDr$findElement(value="/html/body/span/table[3]/tbody/tr[1]/td/b"), silent=T)
  }
  correctaInfo    <- preg_correctaID$getElementText()
  # when there is no answer
  preg_marcadaID  <- tryCatch({remDr$findElement(value = "/html/body/span/table[3]/tbody/tr[2]/td/b")}, silent=TRUE,error=function(err) NA)
  if (typeof(preg_marcadaID)=="S4"){
    marcadaInfo <- preg_marcadaID$getElementText()
  } else {
    marcadaInfo <- "sin_respuesta"
    print(marcadaInfo)
  }

  # Asign values to the database using the question number
  if(is.na(DataBaseCorrecta[1, paste0("EspCorrecta_", nroPregunta_int)]))  DataBaseCorrecta[1, paste0("EspCorrecta_",nroPregunta_int)]<-as.character(correctaInfo)
  DataBase[1, paste0("EspMarcada_",nroPregunta_int)] <- as.character(marcadaInfo)


  # going back to the table
  regTablero <- remDr$findElement(value = "/html/body/span/table[4]/tbody/tr/td/span")
  resultado = try(remDr$executeScript("arguments[0].click();", list(regTablero)), silent=T)
  while(inherits(resultado, "try-error")){
    Sys.sleep(0.5) # This part is mandatory
    resultado <- try(remDr$executeScript("arguments[0].click();", list(regTablero)), silent=T)
  }
  }
)
  # Random pause before next query - add one to the counter
  random_num <- runif(1,1,3)
  Sys.sleep(random_num)
  remDr$navigate(url_raw) # refresh the main page 
  write.table(DataBase, file="CreatedData/2009/DataBase_ENLACE2009_Total.csv", row.names = FALSE, append = TRUE,col.names=F,sep=",")
  write.table(DataBaseCorrecta, file="CreatedData/2009/DataBase_ENLACE2009_Correcta.csv", row.names = FALSE,col.names=T,sep=",")

} # FOR loop for FOLIO-list ends here

 } #function ends