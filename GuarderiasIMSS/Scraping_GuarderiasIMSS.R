
# SCRAPING STARTS HERE
# -----------------------------
# Open browser / navigate the page
#  > docker run -d -p 4445:4444 selenium/standalone-firefox
eCaps <- list(chromeOptions = list(
  args = c('--no-sandbox','--headless', '--disable-gpu', '--window-size=1280,800','--disable-dev-shm-usage')
))
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome",extraCapabilities = eCaps)

remDr$open(silent = TRUE) #opens a browser
url_raw <- 'http://aplicaciones.imss.gob.mx/guarderias/principal.htm'
remDr$navigate(url_raw) # Navigate the page with the browser
Sys.sleep(0.2)


remDr$screenshot(display = TRUE)

# ===============================
# Lista de delegaciones (esta es fija)
ops_delegaciones <- c()
for (j in seq(1,37, by=1)){
  ops_delegaciones[[j]] <- paste0('/html/body/div[2]/div/center/div/div[1]/div[2]/table[1]/tbody/tr[1]/td[2]/select/option[', 
                                  as.character(j+1), ']')} 
# ===============================

for (opcion_del in ops_delegaciones){
  remDr$navigate(url_raw)
  Sys.sleep(0.2)
  resultado = try(deleg_elem <- remDr$findElement(value = opcion_del), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
     Sys.sleep(0.2) # This part is mandatory
     resultado = try(deleg_elem <- remDr$findElement(value = opcion_del), silent=T)
    }
  )  

  resultado = try(deleg_elem$clickElement(), silent=T)
  suppressMessages(
    while(inherits(resultado, "try-error")){
     Sys.sleep(0.2) # This part is mandatory
     resultado = try(deleg_elem$clickElement(), silent=T)
    }
  ) 

  remDr$screenshot(display = TRUE)
  Sys.sleep(0.5)
  
      # ===============================
      # Lista de localidades (esta lista no es fija, pongo 30 como max., y cuando falle quiebra el loop)
      ops_localidades <- c()
      for (j in seq(1,30, by=1)){
        ops_localidades[[j]] <- paste0('/html/body/div[2]/div/center/div/div[1]/div[2]/table[1]/tbody/tr[2]/td[2]/select/option[',
                                        as.character(j+1), ']')} 
      # ===============================

      for (opcion_loc in ops_localidades){
          resultado = tryCatch({remDr$findElement(value = opcion_loc)}, error = function(e){NULL})
          Sys.sleep(0.86)
      
      
         if (is.null(resultado)){
          break
         } else if (typeof(resultado)=="S4"){
         resultado = try(resultado$clickElement(),silent=T)
         remDr$screenshot(display = TRUE)
         Sys.sleep(0.2)
        # ===============================
        # Lista de prestación (esta es fija con 2 opciones)
         ops_prestacion <- c()
         for (j in seq(1,2, by=1)){
           ops_prestacion[[j]] <- paste0('/html/body/div[2]/div/center/div/div[1]/div[2]/table[1]/tbody/tr[3]/td[2]/select/option[',
                                         as.character(j+1), ']')} 
        # ===============================
         
        
        # loop 
        for (opcion_pres in ops_prestacion){
          resultado = tryCatch({remDr$findElement(value = opcion_pres)}, error = function(e){NULL})
          Sys.sleep(0.86)
          
          if (is.null(resultado)){
            break
          } else if (typeof(resultado)=="S4"){
            resultado = try(resultado$clickElement(),silent=T)
            remDr$screenshot(display = TRUE)
            Sys.sleep(0.2)
            # ===============================
            # Lista de guardería (esta lista no es fija, le ponemos como límite 100, si falla, entonces avanza en el anterior loop)
            ops_guarderia <- c()
            for (j in seq(1,100, by=1)){
              ops_guarderia[[j]] <- paste0('/html/body/div[2]/div/center/div/div[1]/div[2]/table[1]/tbody/tr[4]/td[2]/select/option[',
                                            as.character(j+1), ']')} 
            # ===============================
            # loop
            for (opcion_guar in ops_guarderia){
              resultado = tryCatch({remDr$findElement(value = opcion_guar)}, error = function(e){NULL})
              Sys.sleep(1)
              
              if (is.null(resultado)){
                break
              } else if (typeof(resultado)=="S4"){
                resultado = try(resultado$clickElement(),silent=T)
                
                Sys.sleep(1)
                remDr$screenshot(display = TRUE)
                
                
                # ajustar estas en ops
                  caps_ins <- '//*[@id="infoCapacidadInstalada"]'
                  capacidadInstaladaNinos_info  = tryCatch({remDr$findElement(using = 'xpath', value = caps_ins)}, error = function(e){NULL})
                  if (capacidadInstaladaNinos_info$getElementText()==""){
                    break
                  } else if (capacidadInstaladaNinos_info$getElementText()!=""){
                 
                  
                  Sys.sleep(1)
                  remDr$screenshot(display = TRUE)
                
                  DataBase$capacidadInstaladaNinos <- as.character(capacidadInstaladaNinos_info$getElementText())
                
                  cuotaUnitaria_info <- remDr$findElement(using = 'xpath', value = '//*[@id="infoCuotaUnitaria"]' )
                  DataBase$cuotaUnitaria <- as.character(cuotaUnitaria_info$getElementText())
                
                  inicioOperacion_info <- remDr$findElement(using = 'xpath', value =  '//*[@id="infoInicioOperacion"]')
                  DataBase$inicioOperacion <- as.character(inicioOperacion_info$getElementText())
                
                  vigenciaContratoActual_info <- remDr$findElement(using = 'xpath', value = '//*[@id="infoVigenciaInicio"]' )
                  DataBase$vigenciaContratoActual <- as.character(vigenciaContratoActual_info$getElementText())
                
                  tipoContratacion_info <- remDr$findElement(using = 'xpath', value =  '//*[@id="infoEsquemaContratacion"]')
                  DataBase$tipoContratacion <- as.character(tipoContratacion_info$getElementText())
                
                  repLegalActual_info <- remDr$findElement(using = 'xpath', value =  '//*[@id="infoRepLegal"]')
                  DataBase$repLegalActual <- as.character(repLegalActual_info$getElementText())
                
                  repLegalOrig_info <- remDr$findElement(using = 'xpath', value =  '//*[@id="infoRepLegalOriginario"]')
                  DataBase$repLegalOrig <- as.character(repLegalOrig_info$getElementText())
                
                  sociosActuales_info <- remDr$findElement(using = 'xpath', value =  '//*[@id="infoSocioPrestador"]')
                  DataBase$sociosActuales <- as.character(sociosActuales_info$getElementText())
                
                  sociosOriginales_info <- remDr$findElement(using = 'xpath', value =  '//*[@id="infoSociosOriginarios"]')
                  DataBase$sociosOriginales <- as.character(sociosOriginales_info$getElementText())
                
                  Direct_info <- remDr$findElement(using = 'xpath', value = '//*[@id="infoDirectora"]' )
                  DataBase$Direct <- as.character(Direct_info$getElementText())
                
                  ultimaModificacion_info <- remDr$findElement(using = 'xpath', value = '/html/body/div[2]/div/center/div/div[1]/div[2]/div[2]/strong' )
                  DataBase$ultimaModificacion <- as.character(ultimaModificacion_info$getElementText())
                
                  Delegacion_info <- remDr$findElement(using = 'xpath', value =  opcion_del)
                  DataBase$Delegacion <- as.character(Delegacion_info$getElementText())
                
                  Localidad_info <- remDr$findElement(using = 'xpath', value =  opcion_loc)
                  DataBase$Localidad <- as.character(Localidad_info$getElementText())
                
                  tipoPrestacion_info <- remDr$findElement(using = 'xpath', value = opcion_pres )
                  DataBase$tipoPrestacion <- as.character(tipoPrestacion_info$getElementText())
                
                  Guarderia_info <- remDr$findElement(using = 'xpath', value =  opcion_guar)
                  DataBase$Guarderia <- as.character(Guarderia_info$getElementText())                
                  Sys.sleep(1)
                  write.table(DataBase, file="DataBase_guarderias.csv", row.names = FALSE, append = TRUE,col.names=F,sep=",")
                  head(DataBase)
                  } # termina S4 en capacidad instalada niños
              } # termina el S4 en guarderías
              
              random_num <- runif(1,1,10)
              Sys.sleep(random_num)
              
            } #termina FOR de guarderías
              
          } # termina loop para S4 en prestación 
        } # termina FOR prestacion

      } # termina S4 dentro de localidades
    } # termina localidades
  
  #print("continua")
} # termina delegaciones
