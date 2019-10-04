
# SCRAPING STARTS HERE
# -----------------------------
# Open browser / navigate the page
#  > docker run -d -p 4445:4444 selenium/standalone-firefox
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome")
remDr$open(silent = TRUE) # opens a browser
url_raw <- 'http://balanceador.cnspd.mx/AsignacionDePlazas/consulta/'
remDr$navigate(url_raw) # Navigate the page with the browser
remDr$screenshot(display = TRUE)
#remDr$executeScript("arguments[0].click();", list(webElem))

# -----------------------------
# 1. ciclo escolar / ENTER
cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div')
cicloEscolar_elem$clickElement()
remDr$screenshot(display = TRUE)

for (option in ops_cicloEscolar){
  click_cicloEsc <- ops_cicloEscolar[[1]]
  cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc)
  cicloEscolar_elemX$clickElement()
  remDr$screenshot(display = TRUE)

  # -----------------------------
  # 2. Entidad / ENTER
  entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[2]/div/div')
  entidad_elem$clickElement()
  remDr$screenshot(display = TRUE)
  
  for (option in ops_entidad){
    click_entidad <- ops_Entidad[[1]]
    entidad_elemX <- remDr$findElement(value = click_entidad)
    entidad_elemX$clickElement()
    remDr$screenshot(display = TRUE)
    
    # -----------------------------
    # 3. Nivel educativo / ENTER
    NivelEducativo_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[3]/div/div')
    NivelEducativo_elem$clickElement()
    remDr$screenshot(display = TRUE)
    
    for (option in ops_NivelEduc){
      click_NivelEduc<- ops_NivelEduc
      Entidad_elemX <- remDr$findElement(value = click_NivelEduc)
      Entidad_elemX$clickElement()
      remDr$screenshot(display = TRUE)  
  
      # -----------------------------
      # 4. Councurso / ENTER
      concurso_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[4]/div/div')
      concurso_elem$clickElement()
      remDr$screenshot(display = TRUE)
      
      for (option in ops_concurso){
        click_concurso <- ops_concurso[[1]]
        concurso_elemX <- remDr$findElement(value = click_concurso)
        concurso_elemX$clickElement()
        remDr$screenshot(display = TRUE)  
        
        # -----------------------------
        # 5. tipo de Councurso / ENTER
        tipoConcurso_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[5]/div/div')
        tipoConcurso_elem$clickElement()
        remDr$screenshot(display = TRUE)
        
        for (option in ops_tipoConcurso){
          click_tipoConcurso <- ops_tipoConcurso[[1]]
          tipoConcurso_elemX <- remDr$findElement(value = click_tipoConcurso)
          tipoConcurso_elemX$clickElement()
          remDr$screenshot(display = TRUE)
          
          # -----------------------------
          # 6. Subsistema 
          
          subsistema_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[6]/div/div')
          subsistema_elem$clickElement()
          remDr$screenshot(display = TRUE)
          
          for (option in ops_subsistema){
            click_subsistema<- ops_tipoEvaluacion[[1]]
            subsistema_elemX <- remDr$findElement(value = click_subsistema)
            subsistema_elemX$clickElement()
            remDr$screenshot(display = TRUE)
            # -----------------------------
            # 7. tipo de evaluacion / ENTER
            tipoEvaluacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[7]/div/div')
            tipoEvaluacion_elem$clickElement()
            remDr$screenshot(display = TRUE)
            
            for (option in ops_tipoEvaluacion){
              click_tipoEvaluacion <- ops_tipoEvaluacion[[1]]
              tipoEvaluacion_elemX <- remDr$findElement(value = click_tipoEvaluacion)
              tipoEvaluacion_elemX$clickElement()
              remDr$screenshot(display = TRUE)
              
              # -----------------------------
              # 8. Sostenimiento / ENTER
              sostenimiento_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[8]/div/div')
              sostenimiento_elem$clickElement()
              remDr$screenshot(display = TRUE)
              
              for (option in ops_sostenimiento){
                click_sostenimiento <- ops_sostenimiento[[1]]
                sostenimiento_elemX <- remDr$findElement(value = click_sostenimiento)
                sostenimiento_elemX$clickElement()
                remDr$screenshot(display = TRUE)
                
                # -----------------------------
                # 9. Tipo de vacante / ENTER
                tipoVacante_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[9]/div/div')
                tipoVacante_elem$clickElement()
                remDr$screenshot(display = TRUE)
                
                for (option in ops_tipoVacante){
                  click_tipoVacante <- ops_tipoVacante[[1]]
                  tipoVacante_elemX <- remDr$findElement(value = click_tipoVacante)
                  tipoVacante_elemX$clickElement()
                  remDr$screenshot(display = TRUE)
                  
                  # -----------------------------
                  # 10. Tipo de Plaza / ENTER
                  tipoPlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[10]/div/div')
                  tipoPlaza_elem$clickElement()
                  remDr$screenshot(display = TRUE)
                  
                  for (option in ops_tipoPlaza){
                    click_tipoPlaza <- ops_tipoPlaza[[1]]
                    tipoPlaza_elemX <- remDr$findElement(value = click_tipoPlaza)
                    tipoPlaza_elemX$clickElement()
                    remDr$screenshot(display = TRUE)
                    
                    
                    # -----------------------------
                    # Consultar button / click
                    click_consultar <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[2]/a')
                    click_consultar$clickElement()
                    remDr$screenshot(display = TRUE)
                    Sys.sleep(0.5)
                  
                    
                    # Extract information:
                    #### Once we've done the click on info button
                    # Idóneos
                    idoneos_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[1]/p[1]')
                    idoneos_info <- idoneos_elem$getElementText()
                    # Idóneos asignados
                    ideonesAsignados_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[2]/p[1]')
                    ideonesAsignados_info <-ideonesAsignados_elem$getElementText()
                    # + from information button
                    
                    # Filling the information
                    DataFrame$cicloEscolar[rowCounter]
                    DataFrame$entidad[rowCounter]
                    DataFrame$nivelEducativo[rowCounter]
                    DataFrame$concurso[rowCounter]
                    DataFrame$tipoConcurso[rowCounter]
                    DataFrame$subsistema[rowCounter]
                    DataFrame$tipoEvaluacion[rowCounter]
                    DataFrame$idoneos[rowCounter] <- idoneos_info
                    DataFrame$idoneosAsignados[rowCounter] <- ideonesAsignados_info
                    DataFrame$concurso_info[rowCounter]
                    DataFrame$entidad_info[rowCounter]
                    DataFrame$subsistema_info[rowCounter]
                    DataFrame$folio_info[rowCounter]
                    DataFrame$prelacion_info[rowCounter]
                    DataFrame$tipoPlaza_info[rowCounter]
                    DataFrame$curp_info[rowCounter]
                    DataFrame$tipoEvaluacion_info[rowCounter]
                    DataFrame$tipoVacante_info[rowCounter]
                    DataFrame$sostenimiento_info[rowCounter]
                    DataFrame$numeroroHoras_info[rowCounter]
                    DataFrame$fechaInicioVacante_info[rowCounter]
                    DataFrame$fechaFinVacante_info[rowCounter]
                    DataFrame$CCTlabora_info[rowCounter]
                    DataFrame$clavePlaza_info[rowCounter]
                    
                    # Paste the new information to the main dataframe
                    DataFrame_CreatedData <- DataFrame_CreatedData %>% bind_rows()
                    
                    # goint back to  freshmain page
                    remDr$navigate(url_raw)
                    
                    } # ends loop for 10. Tipo de Plaza  
                } # ends loop for 9. Tipo de vacante  
              } # ends loop for 8. Sostenimiento  
            } # ends loop for 7. tipo de evaluacion  
          } # ends loop for 6. subsistema   
        } # ends loop for 5. tipo de Councurso
      } # ends loop for 4. Councurso    
    } # ends loop for 3. Nivel educativo  
  } # ends loop for 2. Entidad 
} # ends loop for 1. ciclo escolar


# -----------------------------
# Export the table to a CSV file
write.csv(DataBase, file="/Users/c1587s/Dropbox/PlazasAsignadas/tablaPlazasAsignadas.csv", row.names = FALSE, append = TRUE)

  








  






















