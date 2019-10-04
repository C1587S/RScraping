
# SCRAPING STARTS HERE
# -----------------------------
# Open browser / navigate the page
#  > docker run -d -p 4445:4444 selenium/standalone-firefox
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome")
remDr$open(silent = TRUE) # opens a browser
url_raw <- 'http://balanceador.cnspd.mx/AsignacionDePlazas/consulta/'
remDr$navigate(url_raw) # Navigate the page with the browser
Sys.sleep(0.5)
remDr$screenshot(display = TRUE)


# -----------------------------
# 1. ciclo escolar / ENTER
cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div')
cicloEscolar_elem$clickElement()
remDr$screenshot(display = TRUE)

for (options in ops_cicloEscolar){
  click_cicloEsc <- ops_cicloEscolar[[1]]
  cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc)
  cicloEscolar_elemX$clickElement()
  remDr$screenshot(display = TRUE)
  
  cicloEsco_info_elem <- remDr$findElement(value = '//*[@id="react-select-2--value-item"]')
  cicloEsco_info <- cicloEsco_info_elem$getElementText()
  
  
  # -----------------------------
  # 2. Entidad / ENTER
  entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[2]/div/div')
  entidad_elem$clickElement()
  remDr$screenshot(display = TRUE)
  
  for (options in ops_entidad){
    click_entidad <- ops_entidad[[1]]
    entidad_elemX <- remDr$findElement(value = click_entidad)
    entidad_elemX$clickElement()
    Sys.sleep(1)
    remDr$screenshot(display = TRUE)
    
    # -----------------------------
    # 3. Nivel educativo / ENTER
    NivelEducativo_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[3]/div/div')
    NivelEducativo_elem$clickElement()
    remDr$screenshot(display = TRUE)
    
      click_NivelEduc<- ops_NivelEduc
      Entidad_elemX <- remDr$findElement(value = click_NivelEduc)
      Entidad_elemX$clickElement()
      remDr$screenshot(display = TRUE)  
      
      # Click on consultar
      Consultar_boton <- remDr$findElement(value= '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[2]/a')
      Consultar_boton$clickElement()
      remDr$screenshot(display = TRUE)
      Sys.sleep(0.5)
      
        # Extract information:
        # Idóneos
        idoneos_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[1]/p[1]')
        idoneos_info <- idoneos_elem$getElementText()
        # DataFrame$idoneos[element] <- idoneos_info
        
        
        # Idóneos asignados
        ideonesAsignados_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[2]/p[1]')
        ideonesAsignados_info <-ideonesAsignados_elem$getElementText()
        # DataFrame$idoneosAsignados[element] <- ideonesAsignados_info
        
        
        ## Nota: number of folios asignados != number of elements in the table of Plazas Asignadas
        
        nro_elementos_elem <- remDr$findElement(value ='//*[contains(concat( " ", @class, " " ), concat( " ", "paging", " " ))]')
        nro_elementos_info_ch <- as.character(nro_elementos_elem$getElementText())
        nro_elementos_info <- tail(strsplit(nro_elementos_info_ch,split=" ")[[1]],1) # Last word of the character phrase
        nro_elementos_info <- as.integer(nro_elementos_info)

        for (element in seq(1, nro_elementos_info, by=1) ){
          print(paste("Entidad:", cicloEsco_info, "Element:", element), sep = " ")
          
          element_i_xpath <- paste0('//tr[(((count(preceding-sibling::*) + 1) = ', 
                                  as.character(element),
                                  ') and parent::*)]//*[contains(concat( " ", @class, " " ), concat( " ", "glyphicon-info-sign", " " ))]')
          
          
          element_i_xpath <- paste0('//tr[(((count(preceding-sibling::*) + 1) = ', 
                                    as.character(1),
                                    ') and parent::*)]//*[contains(concat( " ", @class, " " ), concat( " ", "glyphicon-info-sign", " " ))]')
          
          plazaAsignada_elemento_i <- remDr$findElement(value =element_i_xpath)
          plazaAsignada_elemento_i$clickElement()
          remDr$screenshot(display = TRUE)
          
          # fill-in the table
          
          # Filling the information
          DataFrame$nivelEducativo[element]  <- "EDUCACIÓN SUPERIOR"
          DataFrame$cicloEscolar[element]    <- cicloEsco_info
          # Row 1
            # concurso
            concurso_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[1]/span')
            concurso_elem_info <- concurso_elem$getElementText()
            DataFrame$concurso[element] <- concurso_elem_info
            # entidad
            entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[2]/span')
            entidad_info <- entidad_elem$getElementText()    
            DataFrame$entidad[element] <- entidad_info
            # subsistema
            subsistema_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[3]/span')
            subsistema_info <- subsistema_elem$getElementText()
            DataFrame$subsistema[element] <- subsistema_info
          # Row 2
            # folio
            folio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[4]/span')
            folio_info <- folio_elem$getElementText()
            DataFrame$folio_info[element] <- folio_info
            # prelacion
            prelacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[5]/span')
            prelacion_info <- prelacion_elem$getElementText()
            DataFrame$prelacion_info[element] <- prelacion_info
            # tipoPlaza
            tipoPlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[6]/span')
            tipoPlaza_info <- tipoPlaza_elem$getElementText()
            DataFrame$tipoPlaza_info[element] <- tipoPlaza_info
          # Row 3
            # CURP
            curp_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[7]/span')
            curp_info <- curp_elem$getElementText()
            DataFrame$curp_info[element] <- curp_info
            # tipoEvaluacion
            tipoEvaluacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[8]/span')
            tipoEvaluacion_info <- tipoEvaluacion_elem$getElementText()
            DataFrame$tipoEvaluacion_info[element] <- tipoEvaluacion_info
            # tipoVacante
            tipoVacante_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[9]/span')
            tipoVacante_info <- tipoVacante_elem$getElementText()
            DataFrame$tipoVacante_info[element] <- tipoVacante_info
          # Row 4
            # sostenimiento
            sostenimiento_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[10]/span')
            sostenimiento_info <- sostenimiento_elem$getElementText()
            DataFrame$sostenimiento_info[element] <- sostenimiento_info
            # horas
            horas_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[11]/span')
            horas_info <- horas_elem$getElementText()  
            DataFrame$numeroroHoras_info[element] <- horas_info
            #  fechaInicio
            fechaInicio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[12]/span')
            fechaInicio_info <- fechaInicio_elem$getElementText()
            DataFrame$fechaInicioVacante_info[element] <- fechaInicio_info        
          # Row 5
            # fechaFin
            fechaFin_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[13]/span')
            fechaFin_info <- fechaFin_elem$getElementText()
            DataFrame$fechaFinVacante_info[element] <- fechaFin_info
            # CCTlabora
            CCTlabora_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[14]/span')
            CCTlabora_info <- CCTlabora_elem$getElementText()
            DataFrame$CCTlabora_info[element] <- CCTlabora_info
            # clavePlaza
            clavePlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[15]/span')
            clavePlaza_info <- clavePlaza_elem$getElementText()
            DataFrame$clavePlaza_info[element] <- clavePlaza_info
            
              # click on "Cerrar buton"
            cerrar_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[2]/button')
            cerrar_boton$clickElement()
            remDr$screenshot(display = TRUE)
           # DataFrame$tipoConcurso[element]
           # DataFrame$subsistema[element]
           # DataFrame$tipoEvaluacion[element]
           # DataFrame$idoneos[element] <- idoneos_info
           # DataFrame$idoneosAsignados[element] <- ideonesAsignados_info
           # DataFrame$concurso_info[element]
           # DataFrame$entidad_info[element]

          # if multiple of 100, click on the next button
          if (element/100 == 1) {verMas_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[3]/div/div[2]/a')}  
          else {next}  
        }
        
  } # ends loop for 2. Entidad 
} # ends loop for 1. ciclo escolar


# -----------------------------
# Export the table to a CSV file
write.csv(DataBase, file="/Users/c1587s/Dropbox/PlazasAsignadas/tablaPlazasAsignadas.csv", row.names = FALSE, append = TRUE)

