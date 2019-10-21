
# SCRAPING STARTS HERE
# -----------------------------
# Open browser / navigate the page
#  > docker run -d -p 4445:4444 selenium/standalone-firefox
# 1.Open the browser and navigate the URL
eCaps <- list(chromeOptions = list(
  args = c('--no-sandbox','--headless', '--disable-gpu', '--window-size=1280,800','--disable-dev-shm-usage')
))
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome",extraCapabilities = eCaps)

remDr$open(silent = TRUE) #opens a browser
url_raw <- 'http://balanceador.cnspd.mx/AsignacionDePlazas/consulta/'
remDr$navigate(url_raw) # Navigate the page with the browser
Sys.sleep(0.5)

# -----------------------------
# 1. ciclo escolar / ENTER
cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div')
cicloEscolar_elem$clickElement()

# click en opciones de ciclo escolar
for (optionCE in ops_cicloEscolar){
  click_cicloEsc <- optionCE
  cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc)
  resultado = try(cicloEscolar_elemX$clickElement(), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado <- try(cicloEscolar_elemX$clickElement(), silent=T)
    }
  )  
  ## obtener información del ciclo escolar
  cicloEsco_info_elem <- remDr$findElement(value = '//*[@id="react-select-2--value-item"]')
  cicloEsco_info <- cicloEsco_info_elem$getElementText()
  
  # -----------------------------
  # 2. Click en opciones de Entidad
  entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[2]/div/div')
  entidad_elem$clickElement()
  
  for (optionEnt in ops_entidad){
    # click_entidad <- ops_entidad[[1]]
    click_entidad <- optionEnt
    entidad_elemX <- remDr$findElement(value = click_entidad)
    resultado = try(entidad_elemX$clickElement(), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5)
        resultado <- try(entidad_elemX$clickElement(), silent=T)
      }
    )  
    # -----------------------------
    # 3. Nivel educativo / ENTER
    NivelEducativo_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[3]/div/div')
    
    resultado = try(NivelEducativo_elem$clickElement(), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        resultado <- try(NivelEducativo_elem$clickElement(), silent=T)
      }
    )  
    
    click_NivelEduc<- ops_NivelEduc
    Entidad_elemX <- remDr$findElement(value = click_NivelEduc)
    Entidad_elemX$clickElement()
    
    
    # Click on consultar
    Consultar_boton <- remDr$findElement(value= '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[2]/a')
    resultado = try(Consultar_boton$clickElement(), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5)
        resultado <- try(Consultar_boton$clickElement(), silent=T)
      }
    )  
    Sys.sleep(1)
    # se guarda la información de las casillas amarilla y verde
    # Idóneos
    idoneos_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[1]/p[1]')
    idoneos_info <- idoneos_elem$getElementText()
    DataBase$idoneos[1] <- as.character(idoneos_info) 
    # Idóneos asignados
    ideonesAsignados_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[2]/p[1]')
    ideonesAsignados_info <-ideonesAsignados_elem$getElementText()
    DataBase$idoneosAsignados[1] <- as.character(ideonesAsignados_info)
    
    ## Nota: numero de folios asignados  no coincide con # de elementos en la tabla de Plazas Asignadas
    nro_elementos_elem <- remDr$findElement(value ='//*[contains(concat( " ", @class, " " ), concat( " ", "paging", " " ))]')
    nro_elementos_info_ch <- as.character(nro_elementos_elem$getElementText())
    nro_elementos_info <- tail(strsplit(nro_elementos_info_ch,split=" ")[[1]],1) # Last word of the character phrase
    nro_elementos_info <- as.character(nro_elementos_info)
    
    for (element in seq(1, nro_elementos_info, by=1) ){
      
      element_i_xpath <- paste0('//tr[(((count(preceding-sibling::*) + 1) = ', 
                                as.character(element),
                                ') and parent::*)]//*[contains(concat( " ", @class, " " ), concat( " ", "glyphicon-info-sign", " " ))]')
      
      
      element_i_xpath <- paste0('//tr[(((count(preceding-sibling::*) + 1) = ', 
                                as.character(1),
                                ') and parent::*)]//*[contains(concat( " ", @class, " " ), concat( " ", "glyphicon-info-sign", " " ))]')
      
      plazaAsignada_elemento_i <- remDr$findElement(value =element_i_xpath)
      resultado = try(plazaAsignada_elemento_i$clickElement(), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5)
          resultado <- try(plazaAsignada_elemento_i$clickElement(), silent=T)
        }
      )  
      Sys.sleep(1)
      # Llenar los datos
      # Filling the information
      DataBase$nivelEducativo[1]  <- "educacion_superior"
      DataBase$cicloEscolar[1]    <- cicloEsco_info
      # Row 1
      # concurso
      concurso_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[1]/span')
      concurso_elem_info <- concurso_elem$getElementText()
      DataBase$concurso[1] <- concurso_elem_info
      # entidad
      entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[2]/span')
      entidad_info <- entidad_elem$getElementText()    
      DataBase$entidad[1] <- entidad_info
      # subsistema
      subsistema_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[3]/span')
      subsistema_info <- subsistema_elem$getElementText()
      DataBase$subsistema[1] <- subsistema_info
      # Row 2
      # folio
      folio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[4]/span')
      folio_info <- folio_elem$getElementText()
      DataBase$folio[1] <- folio_info
      # prelacion
      prelacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[5]/span')
      prelacion_info <- prelacion_elem$getElementText()
      DataBase$prelacion[1] <- prelacion_info
      # tipoPlaza
      tipoPlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[6]/span')
      tipoPlaza_info <- tipoPlaza_elem$getElementText()
      DataBase$tipoPlaza[1] <- tipoPlaza_info
      # Row 3
      # CURP
      curp_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[7]/span')
      curp_info <- curp_elem$getElementText()
      DataBase$curp[1] <- curp_info
      # tipoEvaluacion
      tipoEvaluacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[8]/span')
      tipoEvaluacion_info <- tipoEvaluacion_elem$getElementText()
      DataBase$tipoEvaluacion[1] <- tipoEvaluacion_info
      # tipoVacante
      tipoVacante_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[9]/span')
      tipoVacante_info <- tipoVacante_elem$getElementText()
      DataBase$tipoVacante[1] <- tipoVacante_info
      # Row 4
      # sostenimiento
      sostenimiento_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[10]/span')
      sostenimiento_info <- sostenimiento_elem$getElementText()
      DataBase$sostenimiento[1] <- sostenimiento_info
      # horas
      horas_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[11]/span')
      horas_info <- horas_elem$getElementText()  
      DataBase$numeroroHoras[1] <- horas_info
      #  fechaInicio
      fechaInicio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[12]/span')
      fechaInicio_info <- fechaInicio_elem$getElementText()
      DataBase$fechaInicioVacante[1] <- fechaInicio_info        
      # Row 5
      # fechaFin
      fechaFin_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[13]/span')
      fechaFin_info <- fechaFin_elem$getElementText()
      DataBase$fechaFinVacante[1] <- fechaFin_info
      # CCTlabora
      CCTlabora_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[14]/span')
      CCTlabora_info <- CCTlabora_elem$getElementText()
      DataBase$CCTlabora[1] <- CCTlabora_info
      # clavePlaza
      clavePlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[15]/span')
      clavePlaza_info <- clavePlaza_elem$getElementText()
      DataBase$clavePlaza[1] <- clavePlaza_info
      
      # click on "Cerrar buton"
      cerrar_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[2]/button')
      resultado = try(cerrar_boton$clickElement(), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5)
          resultado <- try(cerrar_boton$clickElement(), silent=T)
        }
      )  
      Sys.sleep(0.5)
      # mostrar progreso
      print(paste("Entidad:", entidad_info, " - Ciclo escolar", cicloEsco_info, "- Folio:", folio_info), sep = " ")
    }
    # Añadir columna al archivo csv
    DataBase <- data.frame(lapply(DataBase, as.character), stringsAsFactors=FALSE)
    write.table(DataBase, file="DataBase_PlazasAsignadas_Superior.csv", row.names = F, append = T, col.names=F,sep=",")

    
    # if multiple of 100, click on the next button
    if (element/100 == 1) {verMas_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[3]/div/div[2]/a')}  
    else {next} 
  } # ends loop for 2. Entidad 
} # ends loop for 1. ciclo escolar

