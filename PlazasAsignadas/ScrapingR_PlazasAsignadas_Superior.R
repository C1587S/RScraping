
# SCRAPING STARTS HERE
# -----------------------------
# Open browser / navigate the page
#  > docker run -d -p 4445:4444 selenium/standalone-firefox
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome")
remDr$open(silent = TRUE) #opens a browser
url_raw <- 'http://balanceador.cnspd.mx/AsignacionDePlazas/consulta/'
remDr$navigate(url_raw) # Navigate the page with the browser
remDr$screenshot(display = TRUE)
#remDr$executeScript("arguments[0].click();", list(webElem))

# -----------------------------
# ciclo escolar / ENTER
cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div')
cicloEscolar_elem$clickElement()
remDr$screenshot(display = TRUE)

# There is a problem when using the following function for creating the list of option-elements
# ops1_cicloEscolar <- c()
# 6 options
# for (j in seq(1,6, by=1) {ops1_cicloEscolar[[j]] <- paste(//*[(@id='react-select-2--option-"', as.character(j-1), '")]')], sep="")})
# The problem is that R protects the character " by including \", we just need the ".
ops1_cicloEscolar <- c( '//*[(@id="react-select-2--option-0")]',  '//*[(@id="react-select-2--option-1")]',  '//*[(@id="react-select-2--option-2")]', 
                        '//*[(@id="react-select-2--option-3")]',  '//*[(@id="react-select-2--option-4")]',  '//*[(@id="react-select-2--option-5")]')

# # FOR to go through all the options of Ciclo escolar
# for (i in seq(1,5, by=5)){
#   click_cicloEsc <- ops_cicloEscolar[[i]]
#   cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc)
#   cicloEscolar_elemX$clickElement()
#   remDr$screenshot(display = TRUE)
# }

click_cicloEsc <- ops1_cicloEscolar[[1]]
cicloEscolar_elemX <- remDr$findElement(value = click_cicloEsc)
cicloEscolar_elemX$clickElement()
remDr$screenshot(display = TRUE)

# -----------------------------
# Entidad / ENTER
entidad_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[2]/div/div')
entidad_elem$clickElement()
remDr$screenshot(display = TRUE)

# Same problem
# ops1_entidad <- c()
# 32 options
# for (j in seq(1,32, by=1) {ops1_entidad[[j]] <- paste(//*[(@id='react-select-3--option-"', as.character(j-1), '")]')], sep="")})
ops1_entidad <- c('//*[(@id="react-select-3--option-0")]')

click_entidad <- ops1_Entidad[[1]]
entidad_elemX <- remDr$findElement(value = click_entidad)
entidad_elemX$clickElement()
remDr$screenshot(display = TRUE)


# -----------------------------
# Nivel educativo / ENTER
NivelEducativo_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[3]/div/div')
NivelEducativo_elem$clickElement()
remDr$screenshot(display = TRUE)

ops1_NivelEduc <- '//*[(@id="react-select-4--option-1")]'

# we have created two programs - This branch is for EDUCACIÓN SUPERIOR
click_NivelEduc<- ops1_NivelEduc
Entidad_elemX <- remDr$findElement(value = click_NivelEduc)
Entidad_elemX$clickElement()
remDr$screenshot(display = TRUE)

# -----------------------------
# Councurso / ENTER
concurso_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[4]/div/div')
concurso_elem$clickElement()
remDr$screenshot(display = TRUE)

# Same problem
# ops1_concurso <- c()
# 2 options
# for (j in seq(1,2, by=1) {ops1_concurso[[j]] <- paste(//*[(@id='react-select-3--option-"', as.character(j-1), '")]')], sep="")})
ops1_concurso <- c('//*[(@id="react-select-5--option-0")]', '//*[(@id="react-select-5--option-1")]')

click_concurso <- ops1_concurso[[1]]
concurso_elemX <- remDr$findElement(value = click_concurso)
concurso_elemX$clickElement()
remDr$screenshot(display = TRUE)


# -----------------------------
# tipo de Councurso / ENTER
tipoConcurso_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[5]/div/div')
tipoConcurso_elem$clickElement()
remDr$screenshot(display = TRUE)

# Same problem
# ops1_tipoConcurso <- c()
# 2 options
# for (j in seq(1,2, by=1) {ops1_tipoConcurso[[j]] <- paste(//*[(@id='react-select-36-option-"', as.character(j-1), '")]')], sep="")})
ops1_tipoConcurso <- c('//*[(@id="react-select-6--option-0")]', '//*[(@id="react-select-6--option-1")]')

click_tipoConcurso <- ops1_tipoConcurso[[1]]
tipoConcurso_elemX <- remDr$findElement(value = click_tipoConcurso)
tipoConcurso_elemX$clickElement()
remDr$screenshot(display = TRUE)

# -----------------------------
# Subsistema (appears fotr media superior SO we need to add one to the forms since here)
## appears for: Estado de Mexico
subsistema_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[6]/div/div')
subsistema_elem$clickElement()
remDr$screenshot(display = TRUE)

# Same problem
# ops1_subsistema <- c()
# 41 options
# for (j in seq(1,41, by=1) {ops1_subsistema[[j]] <- paste(//*[(@id='react-select-7--option-"', as.character(j-1), '")]')], sep="")})
ops1_tipoEvaluacion <- c('//*[(@id="react-select-7--option-0")]')

click_subsistema<- ops1_tipoEvaluacion[[1]]
subsistema_elemX <- remDr$findElement(value = click_subsistema)
subsistema_elemX$clickElement()
remDr$screenshot(display = TRUE)

# -----------------------------
# tipo de evaluacion / ENTER
tipoEvaluacion_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[7]/div/div')
tipoEvaluacion_elem$clickElement()
remDr$screenshot(display = TRUE)

# Same problem
# ops1_tipoEvaluacion <- c()
# 15 options
# for (j in seq(1,15, by=1) {ops1_tipoEvaluacion[[j]] <- paste(//*[(@id='react-select-7--option-"', as.character(j-1), '")]')], sep="")})
ops1_tipoEvaluacion <- c('//*[(@id="react-select-8--option-0")]')

click_tipoEvaluacion <- ops1_tipoEvaluacion[[1]]
tipoEvaluacion_elemX <- remDr$findElement(value = click_tipoEvaluacion)
tipoEvaluacion_elemX$clickElement()
remDr$screenshot(display = TRUE)

# -----------------------------
# Sostenimiento / ENTER
sostenimiento_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[8]/div/div')
sostenimiento_elem$clickElement()
remDr$screenshot(display = TRUE)

# Same problem
# ops1_sostenimiento <- c()
# 4 options
# for (j in seq(1,4, by=1) {ops1_sostenimiento[[j]] <- paste(//*[(@id='react-select-8--option-"', as.character(j-1), '")]')], sep="")})
ops1_sostenimiento <- c('//*[(@id="react-select-9--option-0")]')

click_sostenimiento <- ops1_sostenimiento[[1]]
sostenimiento_elemX <- remDr$findElement(value = click_sostenimiento)
sostenimiento_elemX$clickElement()
remDr$screenshot(display = TRUE)

# -----------------------------
# Tipo de vacante / ENTER
tipoVacante_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[9]/div/div')
tipoVacante_elem$clickElement()
remDr$screenshot(display = TRUE)

# Same problem
# ops1_tipoVacante <- c()
# 2 options
# for (j in seq(1,2, by=1) {ops1_tipoVacante[[j]] <- paste(//*[(@id='react-select-9--option-"', as.character(j-1), '")]')], sep="")})
ops1_tipoVacante <- c('//*[(@id="react-select-10--option-0")]')

click_tipoVacante <- ops1_tipoVacante[[1]]
tipoVacante_elemX <- remDr$findElement(value = click_tipoVacante)
tipoVacante_elemX$clickElement()
remDr$screenshot(display = TRUE)

# -----------------------------
# Tipo de Plaza / ENTER
tipoPlaza_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[10]/div/div')
tipoPlaza_elem$clickElement()
remDr$screenshot(display = TRUE)

# Same problem
# ops1_tipoPlaza <- c()
# 2 options
# for (j in seq(1,2, by=1) {ops1_tipoPlaza[[j]] <- paste(//*[(@id='react-select-9--option-"', as.character(j-1), '")]')], sep="")})
ops1_tipoPlaza <- c('//*[(@id="react-select-11--option-0")]')

click_tipoPlaza <- ops1_tipoPlaza[[1]]
tipoPlaza_elemX <- remDr$findElement(value = click_tipoPlaza)
tipoPlaza_elemX$clickElement()
remDr$screenshot(display = TRUE)

# -----------------------------
# Consultar button / click
click_consultar <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[2]/a')
click_consultar$clickElement()
remDr$screenshot(display = TRUE)
Sys.sleep(0.5)


#### Once we've done the click
# Idóneos
idoneos_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[1]/p[1]')
idoneos_info <- idoneos_elem$getElementText()
# Idóneos asignados
ideonesAsignados_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[2]/p[1]')
ideonesAsignados_info <-ideonesAsignados_elem$getElementText()


# # Information button
# 
# + Informacion
# info_elem_but <- remDr$findElement(value = '/html/body/div[2]/div/div/div[3]/div/div[1]/table/tbody/tr[1]/td[9]/span')
# info_elem_but <- remDr$findElement(value = '/html/body/div[2]/div/div/div[3]/div/div[1]/table/tbody/tr[51]/td[9]/span')
# CONCURSO
# ENTIDAD
# SUBSISTEMA
# FOLIO
# PRELACIÓN
# TIPO_PLAZA
# CURP
# TIPO_EVALUACION
# TIPO_VACANTE
# SOSTENIMIENTO
# NUMERO_HORAS
# FECHA_INICIO_VACANTE
# FECHA_FIN_VACANTE
# CCT_LABORA
# CLAVE_PLAZA
# 
# # Filling the information
# DataFrame$cicloEscolar[rowCounter]
# DataFrame$entidad[rowCounter]
# DataFrame$nivelEducativo[rowCounter]
# DataFrame$concurso[rowCounter]
# DataFrame$tipoConcurso[rowCounter]
# DataFrame$subsistema[rowCounter]
# DataFrame$tipoEvaluacion[rowCounter]
# DataFrame$idoneos[rowCounter]
# DataFrame$idoneosAsignados[rowCounter]
# DataFrame$concurso_info[rowCounter]
# DataFrame$entidad_info[rowCounter]
# DataFrame$subsistema_info[rowCounter]
# DataFrame$folio_info[rowCounter]
# DataFrame$prelacion_info[rowCounter]
# DataFrame$tipoPlaza_info[rowCounter]
# DataFrame$curp_info[rowCounter]
# DataFrame$tipoEvaluacion_info[rowCounter]
# DataFrame$tipoVacante_info[rowCounter]
# DataFrame$sostenimiento_info[rowCounter]
# DataFrame$numeroroHoras_info[rowCounter]
# DataFrame$fechaInicioVacante_info[rowCounter]
# DataFrame$fechaFinVacante_info[rowCounter]
# DataFrame$CCTlabora_info[rowCounter]
# DataFrame$clavePlaza_info[rowCounter]
# 
# # Paste the new information to the main dataframe
# DataFrame_CreatedData <- DataFrame_CreatedData %>% bind_rows() 
# 
# 
# # -----------------------------
# # Export the table to a CSV file
# write.csv(DataBase, file="/Users/c1587s/Dropbox/PlazasAsignadas/tablaPlazasAsignadas.csv", row.names = FALSE, append = TRUE)
