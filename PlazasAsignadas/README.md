# Scraping_R
## Plazas Asignadas 
[Página](http://balanceador.cnspd.mx/AsignacionDePlazas/consulta/)


Anotaciones:
Antes de ejecutar los programas es encesario instalar docker, y el contenedor de Rselenium:

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

### Anotaciones y pendientes

- En algunas ocasiones los formularios no tienen el mismo número de opciones, o incluso no tienen ninguna.  

> Solucionar incluyendo `Trycatch` para todos los casos.

- Utilizar ajuste similar para cuando no existe información en la tabla del `pop-up`. (**falta**)
- Ajustar todos los loops anidados. (**falta**)
- Terminar de documentar e incluir a Github:
	- Parte que "scrapea" la tabla pop-up de información. 
	- parte que incorpora la información en la matriz.