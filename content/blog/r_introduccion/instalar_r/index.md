---
title: 'Primer paso: instalar R'
author: Bastián Olea Herrera
format: hugo-md
date: 2024-11-07T00:00:00.000Z
draft: false
weight: 1
series_weight: 1
series: Introducción a R
tags:
  - básico
categories:
  - Tutoriales
excerpt: Instrucciones básicas para que descargues e instales R y RStudio, dirigidas a personas sin conocimientos previos o principiantes. ¡Es tu primer paso al mundo de la programación!
---

Para adentrarte en el mundo del análisis de datos, la visualización de datos, y la programación, el primer paso es **instalar R**, el lenguaje de programación estadística, e **instalar RStudio**, la interfaz que nos va a permitir trabajar con el lenguaje.

R, como cualquier otro lenguaje de programación, suele usarse _dentro_ de otros programas que te ayudan a usarlo; en este caso, el entorno de desarrollo RStudio. 

{{< info "Es importante entender que R es el lenguaje que necesitamos tener instalado, pero **RStudio es la aplicación que usaremos** día a día para aprender y trabajar con datos." >}}


### 1. Descargar e instalar R
R es el lenguaje de programación y análisis estadístico base, el cual se caracteriza por operar mediante paquetes o librerías que expanden sus prestaciones.

<div style="text-align: center; opacity: 0.8;">
{{< figure src="logo_r_morado-featured.png" width="128">}}
</div>

Necesitamos instalar R en nuestros computadores para que RStudio funcione.

{{< boton "Descargar R" "https://cran.r-project.org" "fas fa-download" >}}

Elige la descarga correspondiente a tu sistema operativo, e instálalo. Si usas Windows, es probable que tengas que instalar otro software llamado _Rtools,_ cuyo enlace aparece en el mismo enlace anterior cuando eliges Windows.


### 2. Descargar e instalar RStudio
RStudio es el entorno de desarrollo integrado (IDE) que facilita el trabajo con R. También funciona con Python, y también hay otras alternativas de IDE, pero RStudio es la más usada.

<div style="text-align: center; opacity: 0.8;">
{{< figure src="logo_rstudio_morado.png" width="128">}}
</div>

Principalmente, lo que hace RStudio es presentarnos una consola de R junto a otros paneles: el panel de visualización, donde exploramos los gráficos, la ventana de entorno (environment) donde vemos los elementos con los que estamos trabajando, y la ventana de script o source, donde podemos ir elaborando uno o varios documentos con instrucciones para R. Además de estos paneles, RStudio facilita tareas como la importación de datos, la instalación de paquetes, la gestión de cambios, y otros.

{{< boton "Descargar RStudio" "https://posit.co/download/rstudio-desktop/#download" "fas fa-download" >}}

Teniendo ambas cosas instaladas, podemos abrir RStudio y verificar está funcionando escribiendo en la consola: `2+2`, y presionamos enter. Si obtenemos una respuesta, significa que la instalación funciona!

Para trabajar con R, usaremos **RStudio**. 

### Alternativa: usar RStudio en la nube

Si no quieres o no puedes instalar R y/o RStudio en tu computador, o si tienes problemas con la instalación, puedes usar RStudio desde el navegador web con [Posit Cloud](https://posit.cloud/). Debes crearte una cuenta, y luego en la parte superior derecha eliges _New project > New RStudio Project_. Así tendrás una instancia para usar R en el navegador, con las mismas características que en el computador.

{{< etiqueta "básico" >}}

{{< categoria "tutoriales" >}}

{{< cursos >}}