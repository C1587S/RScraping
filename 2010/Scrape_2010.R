# ----- SCRAPING starts Here
#shell('docker run -d -p 4445:4444 selenium/standalone-firefox')
# initialize the loop counter
longList <- nrow(rawData_2010)
# 1.Open the browser and navigate the URL
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "firefox")
remDr$open(silent = TRUE) #opens a browser
url_raw <- "http://143.137.111.105/Enlace/Resultados2010/Basica2010/R10Folio.aspx" # ENLACE URL

folio_test <- as.array(t(rawData_2010[4:5]))
remDr$navigate(url_raw)
Sys.sleep(1)
#remDr$screenshot(display = TRUE)
for (folioID in seq(1,3,by=1)){ #rawData_2010
  remDr$navigate(url_raw)
# 2. Fill in the form to make the query with FOLIO keys
  folio<-folio_test[[folioID]]; print(paste("Now in folio ", folio))
  webElem<-remDr$findElement(using = 'xpath', value = '//*[(@id = "txtFolioAlumno")]') # find the form
  webElem$sendKeysToElement(list(folio)) # fill in the form with the folio number
  ConsButton <- '//*[(@id = "imgButConsultar")]'
  webElem <- remDr$findElement(value = ConsButton) # find the button
  webElem$clickElement() # click on it
  Sys.sleep(1)
# 3. Extract general information
  webElemTable <- remDr$findElement(using = 'xpath', value = '/html/body/form/div[3]/center/div[1]/div[2]/table') # get into the table
  GeneralTable_parsed <- htmlParse(remDr$getPageSource()[[1]]) # extract the parsed html table
  GeneralTable <- readHTMLTable(GeneralTable_parsed)
  GeneralTable <- GeneralTable[[2]]# 2 is the number of the df with the desired info
  #GeneralTable
  col1Values <- GeneralTable$V2
  col2Values <- GeneralTable$V4
  DataBase$Folio[folioID] <- (levels(col1Values)[1])
  DataBase$Grado[folioID] <- (levels(col1Values)[6])
  DataBase$Grupo[folioID] <- (levels(col1Values)[2])
  DataBase$Turno[folioID] <- (levels(col1Values)[5])
  DataBase$TipoDeEscuela[folioID] <- (levels(col1Values)[3])
  DataBase$NombreDeLaEscuela[folioID] <- (levels(col1Values)[4])
  DataBase$CCT[folioID] <- as.character(levels(col2Values)[1])
  DataBase$Entidad[folioID] <- as.character(levels(col2Values)[2])
  DataBase$GradoDeMarginacion[folioID]<- as.character(levels(col2Values)[3])

# 4. General results for: español and matemáticas
  FrameID <- '//*[(@id = "idframe1")]'
  webFrames <- remDr$findElements(using = 'xpath', value = FrameID)
  sapply(webFrames, function(x){x$getElementAttribute("src")})
  remDr$switchToFrame(webFrames[[1]])
  # Resultados de español
  res_esp <- '//*[@id="lblAsig1"]'
  ResultEspElem <- remDr$findElement(using = 'xpath', value = res_esp ) # get into the table
  ResultEsp <- ResultEspElem$getElementText()
  # Resultados de matemáticas
  res_mat <- '//*[@id="lblAsig2"]'
  ResultMatElem <- remDr$findElement(using = 'xpath', value = res_mat) # get into the table
  ResultMat <- ResultMatElem$getElementText()
  DataBase$PuntajeTotalEsp[folioID]<- as.integer(ResultEsp)
  DataBase$PuntajeTotalMat[folioID]<- as.integer(ResultMat)

  remDr$switchToFrame(NULL) # Exiting the frame

# 5. Respuesta de mi hija(o) en Español
  webElem <- remDr$findElement(value = '//*[(@id = "__tab_TabContainer1_TabPanel2")]//div')
  webElem$clickElement()
  Sys.sleep(1)
  # Get into the frame
  FrameEspID <- '//*[(@id = "idframe2")]'
  webFramesEsp <- remDr$findElements(using = 'xpath', value = FrameEspID)
  sapply(webFramesEsp, function(x){x$getElementAttribute("src")})
  remDr$switchToFrame(webFramesEsp[[1]])
### Exctract info
  for (i in seq(1,length(pregs_esp), by=1)){
    preguntaID<- pregs_esp[[i]]

    nroPreguntaID <- paste(preguntaID, "/font/strong", sep ="")
    nroPreguntaElem <- remDr$findElement(value = nroPreguntaID)
    nroPregunta <- nroPreguntaElem$getElementText()
    nroPregunta_i <- gsub("(?<![0-9])0+", "", nroPregunta, perl = TRUE) # for omitting leading zeroes
    nroPregunta_int <- as.integer(nroPregunta_i)
    print(nroPregunta_int)
    # Now, click on each question
    elemento_preg <- remDr$findElement(value = preguntaID)
    remDr$executeScript("arguments[0].click();", list(elemento_preg))
    Sys.sleep(1.2) # This part is mandatory, we need to include a pause to load the data correctly
    preg_correctaID <- remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[1]/td/b")
    correctaInfo    <- preg_correctaID$getElementText()
    preg_marcadaID  <- remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[2]/td/b")
    marcadaInfo     <- preg_marcadaID$getElementText()
    # Asign values to the database using the question number
    DataBase[folioID, nroPregunta_int+11] <-as.character(correctaInfo) # Esp correcta (+11 is the correction to math the position in the DF)
    DataBase[folioID, nroPregunta_int+141] <-as.character(marcadaInfo)# Esp marcada (+131 is the correction to math the position in the DF)
    # going back to the frame
    regTablero <- remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[3]/tbody/tr/td/span")
    remDr$executeScript("arguments[0].click();", list(regTablero))
    Sys.sleep(1.2)
  }
  ## Exiting the frame
  remDr$switchToFrame(NULL)

# 6. Respuesta de mi hija(o) en Matemáticas
  webElem <- remDr$findElement(value = '//*[(@id = "__tab_TabContainer1_TabPanel3")]//div')
  webElem$clickElement()
  Sys.sleep(1)
# Get into the dataframe
  FrameEspID <- '//*[(@id = "idframe3")]'
  webFramesEsp <- remDr$findElements(using = 'xpath', value = FrameEspID)
  sapply(webFramesEsp, function(x){x$getElementAttribute("src")})
  remDr$switchToFrame(webFramesEsp[[1]])
### Extract info
  for (i in seq(1,length(pregs_mat), by=1)){
    preguntaID<- pregs_mat[[i]]

    nroPreguntaID <- paste(preguntaID, "/font/strong", sep ="")
    nroPreguntaElem <- remDr$findElement(value = nroPreguntaID)
    nroPregunta <- nroPreguntaElem$getElementText()
    nroPregunta_i <- gsub("(?<![0-9])0+", "", nroPregunta, perl = TRUE) # for omitting leading zeroes
    nroPregunta_int <- as.integer(nroPregunta_i)
    print(nroPregunta_int)
    # Now, click on each question
    elemento_preg <- remDr$findElement(value = preguntaID)
    remDr$executeScript("arguments[0].click();", list(elemento_preg))
    Sys.sleep(1.2) # This part is mandatory, we need to include a pause to load the data correctly
    preg_correctaID <- remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[1]/td/b")
    correctaInfo    <- preg_correctaID$getElementText()
    preg_marcadaID  <- remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[2]/tbody/tr[2]/td/b")
    marcadaInfo     <- preg_marcadaID$getElementText()
    # Asign values to the database using the question number
    DataBase[folioID, nroPregunta_int+271] <-as.character(correctaInfo) # Mat correcta (+251 is the correction to math the position in the DF)
    DataBase[folioID, nroPregunta_int+401] <-as.character(marcadaInfo)# Esp marcada (+371 is the correction to math the position in the DF)
    # going back to the frame
    regTablero <- remDr$findElement(value = "/html/body/form/div[3]/div/table/tbody/tr[5]/td/table[3]/tbody/tr/td/span")
    remDr$executeScript("arguments[0].click();", list(regTablero))
    Sys.sleep(1.2)
  }
  # Exiting the frame
  remDr$switchToFrame(NULL)
  
  
# 7.  Refreshing main page to the main page
  remDr$navigate(url_raw) # refresh the main page
  # Random pause before next query - add one to the counter
  random_num <- runif(1,1,3)
  Sys.sleep(random_num)
  remDr$navigate(url_raw) #
} # FOR loop for FOLIO-list ends here

### After the loop finishes, write a CSV file
 write.csv(DataBase, file="/Users/c1587s/Dropbox/Webscrape_Puntajes/CreatedData/2010/DataBase_ENLACE2010_Test.csv", row.names = FALSE)
