# R_scraping
This repository contains files with scraping code using R programming language.

Hay varias carpetas que contienen los respectivos scrappers para diferentes páginas del sector público en México. 

La forma usual de correrlos es inicializar `docker` con `Rselenium`, posteriormente ejecutar el archivo `main.R`.

* Posibles mejoras al código para mejorar tiempos de ejecuciónel código:

**1-** Paralelizar el procreso de scraping, descargando simultáneamente distintas secciones de la lista.
	ver: Rcrawler (An R package for parallel web crawling and scraping)
  
**2-** Guardar de manera iterativa las filas de los archivos csv. De forma que no se pierdan los datos si el proceso presenta algún
  error.

