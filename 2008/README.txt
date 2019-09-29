# 28 de Septiembre de 2019

El ejercicio se ejecuta siguiendo los siguientes pasos:

1 - En la terminal correr la siguiente línea de código (una vez se ha instalado el contenedor de rselenium en docker):
	$ docker run -d -p 4445:4444 selenium/standalone-firefox
2 - Ejecutar en R o Rstudio:
	> source("Main:2008.R")

Nota1: En prelims_2008 es necesario ajustar el tamaño del dataframe vacío para que tenga un número total de filas igual a las observaciones de folios (El ajuste se hace en DataBase = data.frame(matrix(ncol=531,nrow=2))).
Nota2: Está enviando mensajes de error incluso cuando el proceso parece seguir corriendo sin probelma aparente (y viceversa).
Nota3: El código depende bastante de la estabilidad de la conexión y del ancho de banda. Dado lo anterior, es necesario ajustar la forma en que se guardan los datos. Se podría incluir que en cada iteración se hiciera un append de la fila creada a un .csv. 
> Una posible forma de hacer esto es que se vuelva a iniciar el proceso verificando el ultimo folio que se añadió en el archivo csv, y empezar a partir del siguiente?


