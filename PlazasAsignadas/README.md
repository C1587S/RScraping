# Scraping_R
## Plazas Asignadas 
[Página](http://balanceador.cnspd.mx/AsignacionDePlazas/consulta/)


Anotaciones:
Antes de ejecutar los programas es encesario instalar docker, y el contenedor de Rselenium (Para esta aplicación es necesario que sea de chrome, firefox está presentando algunas fallas):

```Bash
$ docker pull selenium/standalone-chrome
```

1. Ejecutar el contenedor de Docker desde la línea de comandos:

```Bash
docker run -d -p 4445:4444 selenium/standalone-chrome
```
**Después de resolver las anotaciones y pendientes**

2.1 Ejecutar el Script `Main_Superior.R` para descargar los datos de Nivel Educativo: Media Superior.

2.2 Ejecutar el Script `Main_Basica.R` para descargar los datos de Nivel Educativo: Media SUperior.

### Anotaciones
- En superior se añade la información de _subsistema_.
- En algunas ocasiones los formularios no tienen el mismo número de opciones, o incluso no tienen ninguna.  
- Los scrappers trabajan de forma diferente para pulsar el botón de "ver más". Particularmente, para el caso de _superior_ es posible que el número de elementos "disponibles" no estén reportados, en ese caso el scrapper pulsa el botón, no los encuentra y continúa.
- No se ha incorporado la opción de que el scrapper coninúe de nuevo si falla.


```
