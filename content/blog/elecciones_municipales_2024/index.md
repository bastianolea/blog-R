---
title: Visualización y scraping de resultados en vivo de las elecciones municipales 2024
author: Bastián Olea Herrera
format: hugo-md
date: 2024-10-30
tags:
  - procesamiento de datos
  - web scraping
  - visualización de datos
  - gráficos
  - tablas
  - datos
  - Chile
excerpt: Con motivo de las elecciones municipales, estuve generando algunas visualizaciones ”en tiempo real” de los resultados de las elecciones de alcaldías. Los datos de conteo de votos los fui obteniendo minuto a minuto mediante web scraping con `{RSelenium}`, que permite programar un navegador web para que interactúe con un sitio como si fuera humano. Finalmente desarrollé un sistema que, con un solo comando, ejecutaba el scraping, la limpieza y procesamiento de los datos, y retornaba tablas y gráficos listos para compartir.
links:
- icon: github
  icon_pack: fab
  name: código
  url: https://github.com/bastianolea/servel_scraping_votaciones
---

![](servel_resultados_multi_featured.png)

Con motivo de las elecciones municipales, estuve generando algunas visualizaciones ”en tiempo real” de los resultados de las elecciones de alcaldías. Los datos de conteo de votos los fui obteniendo minuto a minuto mediante web scraping con `{RSelenium}`, que permite programar un navegador web para que interactúe con un sitio como si fuera humano. Entonces, el navegador robot (marioneta, le llaman) iba apretando todos los botones, sin intervención de mi parte, para encontrar y copiar los resultados de cada comuna del país.

![](servel_tabla_Peñalolen_28-10-24_0101.png)

![](servel_resultados_multi_featured)

Los nuevos resultados llegaban con frecuencia, así que había que echar a correr el proceso bajo presión, cada 10 minutos aprox. Todo iba bien: presionaba ejecutar, el proceso pasaba por todas las comunas, limpiaba los datos y retornaba visualizaciones. Hasta que, en la mitad del conteo, el sitio del Servel cambió! Por algún motivo, cambiaron a una versión similar del sitio, pero que internamente funcionaba distinto, entonces se desconfiguró todo el web scraping. Tuve que luchar contra el tiempo para reestablecerlo (terrible para mi, porque estaba aprendiendo Selenium 😭). Lo otro que me jugó en contra fue que no se me ocurrió automatizar la redacción de textos y posteo en redes sociales, que al final fue lo que me quitó más tiempo 😒

![](servel_alcaldes_sector_28-10-24_1054.jpg)

También faltó hacer visualizaciones más entretenidas, pero se hizo lo que se pudo para una idea que salió a la rápida. Es gratificante hacer andar un flujo largo de procesamiento de datos solo con un par de comandos, desde la obtención de los datos hasta que te arroja decenas o cientos de salidas ✨

![](servel_votos_sector_28-10-24_1054.jpg)

Para los nerds, usé `{RSelenium}` para un script que recibía un vector de comunas e iteraba por ellas con `{furrr}`, y retornaba una lista con la tabla de resultados, el párrafo de las mesas escrutadas, y el nombre de la comuna. Luego, otro script de R cargaba el scraping más reciente y limpiaba los datos, calculaba porcentajes, coincidía partidos con sectores políticos, corregía a "independientes" que en realidad tienen sector político claro, arreglaba nombres (Servel usa eñes pero no tildes, por alguna razón), interpretaba el texto de las mesas como cifras individuales, sumaba votos nulos y blancos, entre otras cosas. Después tenía un script desde el que comandaba todos los demás pasos, que para partir borraba todas las salidas antiguas, y según las comunas que le pedía, generaba nuevos gráficos/tablas en una carpeta nueva. Sobre los gráficos y tablas, nada interesante, salvo que el alto de los gráficos dependía de la cantidad de candidatos, para que siempre mantuvieran espaciados correctos y no se deformaran si eran muchos o muy pocos candidatos/as.

![](servel_grafico_Puente_Alto_27-10-24_2314.jpg)

Finalmente, el flujo de procesamientos de datos en R generó 238 gráficos y 240 tablas, de las cuales les comparto algunas. Esa fue mi experiencia intentando generar reportes en tiempo real sobre datos de elecciones. Para la siguiente votación espero tener algo más elaborado!

![](servel_tabla_ganadores_rm_28-10-24_1054.png)