# ===============================
# Packages
# ===============================
MuteMessages <- suppressPackageStartupMessages
MuteMessages(library(tidyverse))
MuteMessages(library(RSelenium))
MuteMessages(library(XML))
MuteMessages(library(sendmailR))
MuteMessages(library(mailR))
MuteMessages(library(rJava))


# ===============================
# Empty Dataframe
# ===============================
DataFrame_colNames <- c("Delegacion", "Localidad","tipoPrestacion", "Guarderia",
                        "capacidadInstaladaNinos", "cuotaUnitaria", 
                        "inicioOperacion", "vigenciaContratoActual", "tipoContratacion",
                        "repLegalActual", "repLegalOrig", "sociosActuales", "sociosOriginales",
                        "Direct")

DataBase <- data.frame(matrix(ncol =  length(DataFrame_colNames), nrow = 1))
colnames(DataBase) <- DataFrame_colNames
DataBase <- data.frame(lapply(DataBase, as.character), stringsAsFactors=F)
# ===============================
# List of options for all the sections
# ===============================

  # Delegaciones (# options : fixed)
  ops_delegaciones <- 
  # Localidades (# options : variable)
  ops_localidades <- 
  # Tipo de prestación (# options : variable)
  ops_tipoPrestacion <-
  # Guardería (# options : variable)
  ops_guarderia <- 

# ===============================
# Create CSV file
# ===============================
write.csv(DataBase, file="DataBase_guarderias.csv", row.names = F)

# ===============================
# Some useful functions
# ===============================
retry <- function(.FUN, max.attempts = 10000, sleep.seconds = 0.5) {
  expr <- substitute(.FUN)
  retry_expr(expr, max.attempts, sleep.seconds)
}
retry_expr <- function(expr, max.attempts = 10000, sleep.seconds = 0.5) {
  x <- try(eval(expr))
  
  if(inherits(x, "try-error") && max.attempts > 0) {
    Sys.sleep(sleep.seconds)
    return(retry_expr(expr, max.attempts - 1))
  }
  
  x
}

do_nothing = function(){
  invisible()
}
# null result
null_result <- function(){
  resultado <- NULL
}

# do nothing function
do_nothing = function(){
  invisible()
}

# ===============================
# 
# ===============================