
# SCRAPING STARTS HERE
# -----------------------------
# Open browser / navigate the page
#  > docker run -d -p 4445:4444 selenium/standalone-firefox
# 1.Open the browser and navigate the URL
eCaps <- list(chromeOptions = list(
  args = c('--no-sandbox','--headless', '--disable-gpu', '--window-size=1280,800','--disable-dev-shm-usage')
))
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome",extraCapabilities = eCaps)

Scrape_PlazasAsignadas <- function(){
remDr$open(silent = TRUE) #opens a browser
url_raw <- 'http://balanceador.cnspd.mx/AsignacionDePlazas/consulta/'
remDr$navigate(url_raw) # Navigate the page with the browser
Sys.sleep(0.2)
# -----------------------------
# 1. ciclo escolar / ENTER
# click en opciones de ciclo escolar
for (optionCE in ops_cicloEscolar){
  resultado = try(cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div'), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.2) # This part is mandatory
      resultado = try(cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div'), silent=T)
    }
  )   
  # click
  result = try(cicloEscolar_elem$clickElement(), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.2) # This part is mandatory
      result = try(cicloEscolar_elem$clickElement(), silent=T)
    }
  )   
  click_cicloEsc <- optionCE
  resultado = try(cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.2) # This part is mandatory
      resultado = try(cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc), silent=T)
    }
  )    
  resultado = try(cicloEscolar_elemX$clickElement(), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.2) # This part is mandatory
      resultado <- try(cicloEscolar_elemX$clickElement(), silent=T)
    }
  )  
  ## obtener información del ciclo escolar
  resultado = try(cicloEsco_info_elem <- remDr$findElement(value = '//*[@id="react-select-2--value-item"]'), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
      Sys.sleep(0.2) # This part is mandatory
      resultado = try(cicloEsco_info_elem <- remDr$findElement(value = '//*[@id="react-select-2--value-item"]'), silent=T)
    }
  ) 
  cicloEsco_info <- cicloEsco_info_elem$getElementText()
  # -----------------------------
  # 2. Entidad / ENTER
  for (optionEnt in ops_entidad){
    resultado = try(entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[2]/div/div'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        resultado = try(entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[2]/div/div'), silent=T)
      }
    )
    result = try(entidad_elem$clickElement(), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        result = try(entidad_elem$clickElement(), silent=T)
      }
    ) 
    # Here is when whe select Entidad from the list
    click_entidad <- optionEnt
    resultado = try(entidad_elemX <- remDr$findElement(value = click_entidad), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        resultado = try(entidad_elemX <- remDr$findElement(value = click_entidad), silent=T)
      }
    )  
    
    result = try(entidad_elemX$clickElement(), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        result = try(entidad_elemX$clickElement(), silent=T)
      }
    ) 
    Sys.sleep(0.3)
    # -----------------------------
    # 3. Nivel educativo / ENTER
    resultado = try(NivelEducativo_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[3]/div/div'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        NivelEducativo_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[3]/div/div')
      }
    )      
    resultado = try(NivelEducativo_elem$clickElement(), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        resultado <- try(NivelEducativo_elem$clickElement(), silent=T)
      }
    )  
    click_NivelEduc<- ops_NivelEduc
    resultado = try(Entidad_elemX <- remDr$findElement(value = click_NivelEduc), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        resultado <- try(Entidad_elemX <- remDr$findElement(value = click_NivelEduc), silent=T)
      }
    )  
    # click
    result = try(Entidad_elemX$clickElement(), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        result = try(Entidad_elemX$clickElement(), silent=T)
      }
    )   
    # Click on consultar
    resultado = try(Consultar_boton <- remDr$findElement(value= '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[2]/a'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2)
        resultado = try(Consultar_boton <- remDr$findElement(value= '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[2]/a'), silent=T)
      }
    )      
    resultado = try(Consultar_boton$clickElement(), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2)
        resultado <- try(Consultar_boton$clickElement(), silent=T)
      }
    )  
    # Extract information:
    # se guarda la información de las casillas amarilla y verde
    # Idóneos
    resultado = try(idoneos_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[1]/p[1]'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        resultado = try(idoneos_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[1]/p[1]'), silent=T)
      }
    )     
    idoneos_info <- idoneos_elem$getElementText()
    DataBase$idoneos[1] <- as.character(idoneos_info) 
    # Idóneos asignados
    resultado = try(ideonesAsignados_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[2]/p[1]'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        resultado = try(ideonesAsignados_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[2]/p[1]'), silent=T)
      }
    )  
    ideonesAsignados_info <-ideonesAsignados_elem$getElementText()
    DataBase$idoneosAsignados[1] <- as.character(ideonesAsignados_info)
    ## Nota: numero de folios asignados  no coincide con # de elementos en la tabla de Plazas Asignadas
    resultado = try(nro_elementos_elem <- remDr$findElement(value ='//*[contains(concat( " ", @class, " " ), concat( " ", "paging", " " ))]'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        resultado = try(nro_elementos_elem <- remDr$findElement(value ='//*[contains(concat( " ", @class, " " ), concat( " ", "paging", " " ))]'), silent=T)
      }
    )  
    nro_elementos_info_ch <- as.character(nro_elementos_elem$getElementText())
    nro_elementos_info <- tail(strsplit(nro_elementos_info_ch,split=" ")[[1]],1) # Last word of the character phrase
    primeros_elementos_info <- head(strsplit(nro_elementos_info_ch,split=" ")[[1]],1) # Last word of the character phrase
    nro_elementos_info <- as.character(nro_elementos_info)
    primeros_elems<- as.integer(primeros_elementos_info)
    
    for (element in seq(1, nro_elementos_info, by=1)){
      if (element != 1 & (element-1)/primeros_elems == 1) {
        resultado = try(verMas_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[3]/div/div[2]/a'), silent=T)
        suppressMessages(
          while(inherits(resultado, "try-error")){
            Sys.sleep(0.2) # This part is mandatory
            resultado = try(verMas_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[3]/div/div[2]/a'), silent=T)
          }
        ) 
        verMas_boton$clickElement()
        Sys.sleep(0.2)
      }  else {
        do_nothing()
      } 
      # find: Sin información disponibles para los filtros seleccionados
      element_i_xpath <- paste0('/html/body/div[2]/div/div/div[3]/div/div[1]/table/tbody/tr[',
                                as.character(element),
                                ']/td[9]/span')    
      suppressMessages(
        elemento_encontrado <- try(remDr$findElement(value ='//*[@id=\"consultaAsignacionContainer\"]/div/div[3]/div/div[1]/table/tbody/tr/td/h4'),silent=T)
      )
      suppressMessages(
        if (typeof(elemento_encontrado)=="S4"){
          next()
        } else {
          
          resultado = try(plazaAsignada_elemento_i <- remDr$findElement(value =element_i_xpath), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2)
              resultado = try(plazaAsignada_elemento_i <- remDr$findElement(value =element_i_xpath), silent=T)
            }
          ) 
          Sys.sleep(0.2)
          resultado = try(plazaAsignada_elemento_i$clickElement(), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2)
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
          resultado = try(concurso_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[1]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(concurso_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[1]/span'), silent=T)
            }
          ) 
          concurso_elem_info <- concurso_elem$getElementText()
          DataBase$concurso[1] <- concurso_elem_info
          # entidad
          resultado = try( entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[2]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try( entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[2]/span'), silent=T)
            }
          ) 
          entidad_info <- entidad_elem$getElementText()    
          DataBase$entidad[1] <- entidad_info
          # subsistema
          resultado = try(subsistema_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[3]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(subsistema_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[3]/span'), silent=T)
            }
          ) 
          subsistema_info <- subsistema_elem$getElementText()
          DataBase$subsistema[1] <- subsistema_info
          # Row 2
          # folio
          resultado = try(folio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[4]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(folio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[4]/span'), silent=T)
            }
          ) 
          folio_info <- folio_elem$getElementText()
          DataBase$folio[1] <- folio_info
          # prelacion
          resultado = try(prelacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[5]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(prelacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[5]/span'), silent=T)
            }
          ) 
          prelacion_info <- prelacion_elem$getElementText()
          DataBase$prelacion[1] <- prelacion_info
          # tipoPlaza
          resultado = try(tipoPlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[6]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(tipoPlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[6]/span'), silent=T)
            }
          ) 
          tipoPlaza_info <- tipoPlaza_elem$getElementText()
          DataBase$tipoPlaza[1] <- tipoPlaza_info
          # Row 3
          # CURP
          resultado = try(curp_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[7]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(curp_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[7]/span'), silent=T)
            }
          ) 
          curp_info <- curp_elem$getElementText()
          DataBase$curp[1] <- curp_info
          # tipoEvaluacion
          resultado = try(tipoEvaluacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[8]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(tipoEvaluacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[8]/span'), silent=T)
            }
          ) 
          tipoEvaluacion_info <- tipoEvaluacion_elem$getElementText()
          DataBase$tipoEvaluacion[1] <- tipoEvaluacion_info
          # tipoVacante
          resultado = try(tipoVacante_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[9]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(tipoVacante_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[9]/span'), silent=T)
            }
          ) 
          tipoVacante_info <- tipoVacante_elem$getElementText()
          DataBase$tipoVacante[1] <- tipoVacante_info
          # Row 4
          # sostenimiento
          resultado = try(sostenimiento_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[10]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(sostenimiento_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[10]/span'), silent=T)
            }
          ) 
          sostenimiento_info <- sostenimiento_elem$getElementText()
          DataBase$sostenimiento[1] <- sostenimiento_info
          # horas
          resultado = try(horas_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[11]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(horas_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[11]/span'), silent=T)
            }
          ) 
          horas_info <- horas_elem$getElementText()  
          DataBase$numeroHoras[1] <- horas_info
          #  fechaInicio
          resultado = try(fechaInicio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[12]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(fechaInicio_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[12]/span'), silent=T)
            }
          ) 
          fechaInicio_info <- fechaInicio_elem$getElementText()
          DataBase$fechaInicioVacante[1] <- fechaInicio_info        
          # Row 5
          # fechaFin
          resultado = try(fechaFin_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[13]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(fechaFin_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[13]/span'), silent=T)
            }
          ) 
          fechaFin_info <- fechaFin_elem$getElementText()
          DataBase$fechaFinVacante[1] <- fechaFin_info
          # CCTlabora
          resultado = try(CCTlabora_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[14]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(CCTlabora_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[14]/span'), silent=T)
            }
          ) 
          CCTlabora_info <- CCTlabora_elem$getElementText()
          DataBase$CCTlabora[1] <- CCTlabora_info
          # clavePlaza
          resultado = try(clavePlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[15]/span'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(clavePlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[1]/div/div[15]/span'), silent=T)
            }
          ) 
          clavePlaza_info <- clavePlaza_elem$getElementText()
          DataBase$clavePlaza[1] <- clavePlaza_info
          
          # click on "Cerrar buton"
          resultado = try(cerrar_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[2]/button'), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2) # This part is mandatory
              resultado = try(cerrar_boton <- remDr$findElement(value = '/html/body/div[2]/div/div/div[5]/div/div[2]/button'), silent=T)
            }
          ) 
          resultado = try(cerrar_boton$clickElement(), silent=T)
          suppressMessages(
            while(inherits(resultado, "try-error")){
              Sys.sleep(0.2)
              resultado <- try(cerrar_boton$clickElement(), silent=T)
            }
          )  
          Sys.sleep(0.2)
          # mostrar progreso
          print(paste("Elemento",element, "Entidad:", entidad_info, " - Ciclo escolar", cicloEsco_info, "- ClavePlaza:", clavePlaza_info), sep = " ")
          
          # Añadir fila al archivo csv
          DataBase <- data.frame(lapply(DataBase, as.character), stringsAsFactors=FALSE)
          write.table(DataBase, file="DataBase_PlazasAsignadas_Superior.csv", row.names = FALSE, append = TRUE,col.names=F,sep=",")
        }
      ) # end - supress messages
    }
    # reload page and load again ciclo escolar - then change entidad whitin the for loop
    remDr$navigate(url_raw) # Navigate the page with the browser
    resultado = try(cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        resultado = try(cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div'), silent=T)
      }
    )  
    result = try(cicloEscolar_elem$clickElement(), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        result = try(cicloEscolar_elem$clickElement(), silent=T)
      }
    ) 
    click_cicloEsc <- optionCE
    resultado = try(cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        resultado = try(cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc), silent=T)
      }
    )   
    
    result = try(cicloEscolar_elemX$clickElement(), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        result = try(cicloEscolar_elemX$clickElement(), silent=T)
      }
    ) 
    resultado = try(cicloEsco_info_elem <- remDr$findElement(value = '//*[@id="react-select-2--value-item"]'), silent=T)
    suppressMessages(
      while(inherits(resultado, "try-error")){
        Sys.sleep(0.2) # This part is mandatory
        resultado = try(cicloEsco_info_elem <- remDr$findElement(value = '//*[@id="react-select-2--value-item"]'), silent=T)
      }
    )    
  } # ends loop for 2. Entidad 
} # ends loop for 1. ciclo escolar

} # unction ends
