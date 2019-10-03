
MuteMessages <- suppressPackageStartupMessages
MuteMessages(library(rvest))
MuteMessages(library(tidyverse))
MuteMessages(library(RSelenium))
MuteMessages(library(XML))
MuteMessages(library(data.table))
MuteMessages(library(sendmailR))
MuteMessages(library(mailR))
MuteMessages(library(rJava))

# -----------------------------
## Create an empty dataframe with the name of variables
DataFrame <- data.frame(cicloEscolar = character(0),
                        entidad= character(0),
                        nivelEducativo = character(0),
                        concurso = character(0),
                        tipoConcurso = character(0),
                        subsistema= character(0),
                        tipoEvaluacion= character(0),
                        idoneos = character(0),
                        idoneosAsignados= character(0),
                        concurso_info = character(0),
                        entidad_info= character(0),
                        subsistema_info= character(0),
                        folio_info= character(0),
                        prelacion_info= character(0),
                        tipoPlaza_info= character(0),
                        curp_info= character(0),
                        tipoEvaluacion_info= character(0),
                        tipoVacante_info= character(0),
                        sostenimiento_info= character(0),
                        numeroroHoras_info= character(0),
                        fechaInicioVacante_info= character(0),
                        fechaFinVacante_info= character(0),
                        CCTlabora_info= character(0),
                        clavePlaza_info= character(0))





# -----------------------------
# Open browser / navigate the page
#  > docker run -d -p 4445:4444 selenium/standalone-firefox
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "firefox")
remDr$open(silent = TRUE) #opens a browser
url_raw <- 'http://balanceador.cnspd.mx/AsignacionDePlazas/consulta/'
remDr$navigate(url_raw) # Navigate the page with the browser
remDr$screenshot(display = TRUE)
remDr$executeScript("arguments[0].click();", list(webElem))

# ciclo escolar / ENTER

cicloEscolar_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div')
cicloEscolar_elem$clickElement()
remDr$screenshot(display = TRUE)
cicloEscolar_elem1 <- remDr$findElement(using = 'xpath', value ='/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div/input')


cicloEscolar_elem$sendKeysToElement(list('2015-2016',key="enter")) 

# hidden
/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[1]/div/input

a <- '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div/div'
cicloEscolar_elem1 <- remDr$findElement(using = 'xpath', value =a)
cicloEscolar_elem1$clickElement()
cicloEscolar_elem1$sendKeysToElement(list('2015-2016', "\uE007")) 
remDr$screenshot(display = TRUE)

ops_cicloEscolar <- c('2014-2015', '2015-2016', '2016-2017', '2018-2019', '2019-2020')
for (opciones in ops_cicloEscolar) {
  
}

# esto es lo que


remDr$executeScript("arguments[0].click();", list(cicloEscolar_elem))

# Forms:





# Entidad / ENTER
'/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[2]/div/div'
ops_Entidad <- c("Aguascalientes", "Baja California", "Baja California Sur", "Campeche", "Chiapas",
                  "Chihuahua", " 	Ciudad de Mexico", "Coahuila", "Colima", "Durango", "Guanajuato",
                  "Guerrero", " Hidalgo", "Jalisco", "Estado de Mexico", "Michoacán", "Morelos",
                  "Nayarit", "Nuevo León", "Oaxaca", "Puebla", "Querétaro", "Quintana Roo",
                  "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala",
                  "Veracruz", "Yucatán", "Zacatecas")

# Nivel educativo / ENTER
'/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div/div[3]/div/div'
ops_nivelEducativo <- c('EDUCACIÓN BÁSICA', 'EDUCACIÓN MEDIA SUPERIOR')
# Councurso / ENTER
'/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[4]/div/div'
ops_concurso <- c('INGRESO', 'PROMOCIÓN')
# tipo de Councurso / ENTER
'/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[5]/div/div'
# Subsistema (appears fotr media superior)
## appears for: Estado de Mexico
'/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[5]/div/div'
ops_tipoConcurso <- c('EXTRAORDINARIO', 'ORDINARIO')
# tipo de evaluacion / ENTER
'/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[6]/div/div'
ops_tipoEvaluacion <- c("EDUCACIÓN SECUNDARIA DE BIOLOGÍA", "EDUCACIÓN SECUNDARIA DE DANZA", "EDUCACIÓN SECUNDARIA DE DISEÑO DE CIRCUITOS ELÉCTRICOS",
                        "EDUCACIÓN SECUNDARIA DE DISEÑO Y MECATRÓNICA AUTOMOTRIZ", "EDUCACIÓN SECUNDARIA DE ESPAÑOL", "EDUCACIÓN SECUNDARIA DE FÍSICA",
                        "EDUCACIÓN SECUNDARIA DE FORMACIÓN CÉVICA Y ÉTICA","EDUCACIÓN SECUNDARIA DE GEOGRAFÍA","EDUCACIÓN SECUNDARIA DE HISTORIA",
                        "EDUCACIÓN SECUNDARIA DE INGLÉS", "EDUCACIÓN SECUNDARIA DE MATEMÁTICAS", "EDUCACIÓN SECUNDARIA DE OFIMÁTICA", 
                        "EDUCACIÓN SECUNDARIA DE QUÍMICA", "EDUCACIÓN SECUNDARIA ELECTRÓNICA, COMUNICACIÓN Y SISTEMAS DE CONTROL")
# Sostenimiento / ENTER
'/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[7]/div/div'
ops_sostenimiento <- c("ESTATAL", "FEDERAL", "FEDERALIZADO", "MUNICIPAL")
# Tipo de vacante / ENTER
'/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[8]/div/div'
ops_tipoVacante <- c("DEFINITIVA", "TEMPORAL")
# Tipo de Plaza / ENTER
'/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[1]/div[9]/div/div'
ops_tipoPlaza <- c("HORA/SEMANA/MES", "JORNADA", "MEDIO TIEMPO (20 HORAS)", "TIEMPO COMPLETO (40 HORAS)",
                   "TRES CUARTOS DE TIEMPO (30 HORAS)")
# Consultar button / click
webElem <- remDr$findElement(value = '/html/body/div[2]/div/div/section/div/div/div/div[2]/div/div/div[2]/a')
remDr$executeScript("arguments[0].click();", list(webElem))
Sys.sleep(1)


#### Once we've done the click
# Idóneos
idoneos_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[1]/p[1]')
# Idóneos asignados
ideonesAsignados_elem <- remDr$findElement(value = '/html/body/div[2]/div/div/div[2]/div[1]/div[2]/p[1]')

# If 
if this part says == "Sin información disponibles para los filtros seleccionados
" stop right there
//*[contains(concat( " ", @class, " " ), concat( " ", "noBottom", " " ))]//h4
  
  
if (ideonesAsignados_info > 0) {
  None
} else if (ideonesAsignados_info == 0) {
  None
} 
# not necessarly for example see 2016-2017 aguascalientes media superior
### Plaza asignadas
TipoPlaza
CURP
TipoEvaluacion
TipoVacante
Horas
FechaInicio
FechaFin
CCT

# Information button

  + Informacion
info_elem_but <- remDr$findElement(value = '/html/body/div[2]/div/div/div[3]/div/div[1]/table/tbody/tr[1]/td[9]/span')
info_elem_but <- remDr$findElement(value = '/html/body/div[2]/div/div/div[3]/div/div[1]/table/tbody/tr[51]/td[9]/span')
CONCURSO
ENTIDAD
SUBSISTEMA
FOLIO
PRELACIÓN
TIPO_PLAZA
CURP
TIPO_EVALUACION
TIPO_VACANTE
SOSTENIMIENTO
NUMERO_HORAS
FECHA_INICIO_VACANTE
FECHA_FIN_VACANTE
CCT_LABORA
CLAVE_PLAZA
  



