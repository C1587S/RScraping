
# SCRAPING STARTS HERE
# -----------------------------
# Open browser / navigate the page
#  > docker run -d -p 4445:4444 selenium/standalone-firefox
eCaps <- list(chromeOptions = list(
  args = c('--no-sandbox','--headless', '--disable-gpu', '--window-size=1280,800','--disable-dev-shm-usage')
))
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome",extraCapabilities = eCaps)

remDr$open(silent = TRUE) #opens a browser
url_raw <- 'http://balanceador.cnspd.mx/AsignacionDePlazas/consulta/'
remDr$navigate(url_raw) # Navigate the page with the browser
Sys.sleep(0.5)
remDr$screenshot(display = TRUE)

# -----------------------------
for (optionsCE in ops_cicloEscolar){
  resultado = try(cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div'), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado = try(cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div'), silent=T)
    }
  )  
  cicloEscolar_elem$clickElement()
  click_cicloEsc <- optionsCE
  resultado = try(cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado = try(cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc), silent=T)
    }
  )    
  
  cicloEscolar_elemX$clickElement()
  
  resultado = try(cicloEsco_info_elem <- remDr$findElement(value = '//*[@id="react-select-2--value-item"]'), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado = try(cicloEsco_info_elem <- remDr$findElement(value = '//*[@id="react-select-2--value-item"]'), silent=T)
    }
  )    
  cicloEsco_info <- cicloEsco_info_elem$getElementText()
  # -----------------------------
  # 2. Entidad / ENTER
  resultado = try(entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[2]/div/div'), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.5) # This part is mandatory
      resultado = try(entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[2]/div/div'), silent=T)
    }
  )    
  entidad_elem$clickElement()
   remDr$screenshot(display = TRUE)
  for (optionEnt in ops_entidad){
    click_entidad <- optionEnt
    resultado = try(entidad_elemX <- remDr$findElement(value = click_entidad), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado = try(entidad_elemX <- remDr$findElement(value = click_entidad), silent=T)
      }
    )    
    entidad_elemX$clickElement()
    # -----------------------------
    # 3. Nivel educativo / ENTER
    resultado = try(NivelEducativo_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[3]/div/div'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado = try(NivelEducativo_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[3]/div/div'), silent=T)
      }
    )    
    
    NivelEducativo_elem$clickElement()
    click_NivelEduc<- ops_NivelEduc
    resultado = try(Entidad_elemX <- remDr$findElement(value = click_NivelEduc), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado = try(Entidad_elemX <- remDr$findElement(value = click_NivelEduc), silent=T)
      }
    )    
    
    Entidad_elemX$clickElement()
    # Click on consultar
    resultado = try(Consultar_boton <- remDr$findElement(value= '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[2]/a'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado = try(Consultar_boton <- remDr$findElement(value= '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[2]/a'), silent=T)
      }
    )    
    Consultar_boton$clickElement()
    # Extract information:
    # se guarda la información de las casillas amarilla y verde
    # Idóneos
    resultado = try(idoneos_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[1]/p[1]'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado = try(idoneos_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[1]/p[1]'), silent=T)
      }
    )    
    idoneos_info <- idoneos_elem$getElementText()
    DataBase$idoneos[1] <- idoneos_info
    
    # Idóneos asignados
    resultado = try(ideonesAsignados_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[2]/p[1]'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado = try(ideonesAsignados_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[2]/p[1]'), silent=T)
      }
    )    
    ideonesAsignados_info <-ideonesAsignados_elem$getElementText()
    DataBase$idoneosAsignados[1] <- ideonesAsignados_info
    
    ## Nota: number of folios asignados != number of elements in the table of Plazas Asignadas
    resultado = try(nro_elementos_elem <- remDr$findElement(value ='//*[contains(concat( " ", @class, " " ), concat( " ", "paging", " " ))]'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.5) # This part is mandatory
        resultado = try(nro_elementos_elem <- remDr$findElement(value ='//*[contains(concat( " ", @class, " " ), concat( " ", "paging", " " ))]'), silent=T)
      }
    )    
    nro_elementos_info_ch <- as.character(nro_elementos_elem$getElementText())
    nro_elementos_info <- tail(strsplit(nro_elementos_info_ch,split=" ")[[1]],1) # Last word of the character phrase
    nro_elementos_info <- as.integer(nro_elementos_info)
    
    for (element in seq(1, nro_elementos_info, by=1) ){
      if ((element-1)%%100 == 0) {
        resultado = try(verMas_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[3]/div/div[2]/a'), silent=T)
        suppressMessages(
          while(inherits(resultado, "try-error")){
            Sys.sleep(0.5) # This part is mandatory
            resultado = try(verMas_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[3]/div/div[2]/a'), silent=T)
          }
        ) 
        verMas_boton$clickElement()
        Sys.sleep(0.5)
      }  else {next} 
      
      element_i_xpath <- paste0('/html/body/div[2]/div/div/div[3]/div/div[1]/table/tbody/tr[',
                                as.character(element),
                                ']/td[9]/span')
      # element_i_xpath <- paste0('//tr[(((count(preceding-sibling::*) + 1) = ', 
      #                           as.character(element),
      #                           ') and parent::*)]//*[contains(concat( " ", @class, " " ), concat( " ", "glyphicon-info-sign", " " ))]')
      resultado = try(plazaAsignada_elemento_i <- remDr$findElement(value =element_i_xpath), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(plazaAsignada_elemento_i <- remDr$findElement(value =element_i_xpath), silent=T)
        }
      )    
      plazaAsignada_elemento_i$clickElement()
      Sys.sleep(0.5)
      # fill-in the table
      # Filling the information
      DataBase$nivelEducativo[1]  <- "EDUCACIÓN BASICA"
      DataBase$cicloEscolar[1]    <- cicloEsco_info
      # Row 1
      # concurso
      resultado = try(concurso_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[1]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(concurso_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[1]/span'), silent=T)
        }
      ) 
      concurso_elem_info <- concurso_elem$getElementText()
      DataBase$concurso[1] <- concurso_elem_info
      
      # entidad
      resultado = try(entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[2]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[2]/span'), silent=T)
        }
      ) 
      entidad_info <- entidad_elem$getElementText()    
      DataBase$entidad[1] <- entidad_info
      # folio
      resultado = try(folio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[3]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(folio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[3]/span'), silent=T)
        }
      ) 
      folio_info <- folio_elem$getElementText()
      DataBase$folio[1] <- folio_info
      # Row 2
      # prelacion
      resultado = try(prelacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[4]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(prelacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[4]/span'), silent=T)
        }
      ) 
      prelacion_info <- prelacion_elem$getElementText()
      DataBase$prelacion[1] <- prelacion_info
      # tipoPlaza
      resultado = try(tipoPlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[5]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(tipoPlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[5]/span'), silent=T)
        }
      ) 
      tipoPlaza_info <- tipoPlaza_elem$getElementText()
      DataBase$tipoPlaza[1] <- tipoPlaza_info
      # CURP
      resultado = try(curp_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[6]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(curp_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[6]/span'), silent=T)
        }
      ) 
      curp_info <- curp_elem$getElementText()
      DataBase$curp[1] <- curp_info
      # Row 3
      # tipoEvaluacion
      resultado = try(tipoEvaluacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[7]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(tipoEvaluacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[7]/span'), silent=T)
        }
      ) 
      tipoEvaluacion_info <- tipoEvaluacion_elem$getElementText()
      DataBase$tipoEvaluacion[1] <- tipoEvaluacion_info
      # tipoVacante
      resultado = try(tipoVacante_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[8]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(tipoVacante_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[8]/span'), silent=T)
        }
      ) 
      tipoVacante_info <- tipoVacante_elem$getElementText()
      DataBase$tipoVacante[1] <- tipoVacante_info
      # sostenimiento
      resultado = try(sostenimiento_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[9]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(sostenimiento_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[9]/span'), silent=T)
        }
      ) 
      sostenimiento_info <- sostenimiento_elem$getElementText()
      DataBase$sostenimiento[1] <- sostenimiento_info
      # Row 4
      # horas
      resultado = try(horas_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[10]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(horas_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[10]/span'), silent=T)
        }
      ) 
      horas_info <- horas_elem$getElementText()  
      DataBase$numeroHoras[1] <- horas_info
      #  fechaInicio
      resultado = try(fechaInicio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[11]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(fechaInicio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[11]/span'), silent=T)
        }
      ) 
      fechaInicio_info <- fechaInicio_elem$getElementText()
      DataBase$fechaInicioVacante[1] <- fechaInicio_info
      # fechaFin
      resultado = try(fechaFin_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[12]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(fechaFin_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[12]/span'), silent=T)
        }
      ) 
      fechaFin_info <- fechaFin_elem$getElementText()
      DataBase$fechaFinVacante[1] <- fechaFin_info
      # Row 5
      # CCTlabora
      resultado = try(CCTlabora_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[13]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(CCTlabora_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[13]/span'), silent=T)
        }
      ) 
      CCTlabora_info <- CCTlabora_elem$getElementText()
      DataBase$CCTlabora[1] <- CCTlabora_info
      # clavePlaza
      resultado = try(clavePlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[14]/span'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(clavePlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[14]/span'), silent=T)
        }
      ) 
      clavePlaza_info <- clavePlaza_elem$getElementText()
      DataBase$clavePlaza[1] <- clavePlaza_info
      # click on "Cerrar buton"
      resultado = try(cerrar_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[2]/button'), silent=T)
      suppressMessages(
        while(inherits(resultado, "try-error")){
          Sys.sleep(0.5) # This part is mandatory
          resultado = try(cerrar_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[2]/button'), silent=T)
        }
      ) 
      cerrar_boton$clickElement()
      Sys.sleep(0.7) 
      # mostrar progreso
      print(paste("Elemento",element, "Entidad:", entidad_info, " - Ciclo escolar", cicloEsco_info, "- Folio:", folio_info), sep = " ")      
      # Añadir fila al archivo csv
      DataBase <- data.frame(lapply(DataBase, as.character), stringsAsFactors=FALSE)
      write.table(DataBase, file="DataBase_PlazasAsignadas_Basica.csv", row.names = FALSE, append = TRUE,col.names=F,sep=",")
      }
  } # ends loop for 2. Entidad 
} # ends loop for 1. ciclo escolar

