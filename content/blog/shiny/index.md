---
title: Crea aplicaciones web interactivas en R con Shiny
author: Bastián Olea Herrera
date: '2026-04-25'
draft: true
categories:
  - Tutoriales
tags:
  - shiny
  - apps
format:
  hugo-md:
    output-file: index
    output-ext: md
---

[Shiny](https://shiny.posit.co) es un paquete para **desarrollar aplicaciones web interactivas** con R. Con Shiny puedes crear aplicaciones que tus usuarios/as podrán ver desde su navegador, y pueden contener todo tipo de contenido: gráficos, tablas, botones, textos dinámicos, mapas, etc. Es una forma de usar R para crear aplicaciones web centradas en datos que simplifica muchos aspectos complejos del desarrollo web.

Shiny le da vida a todo lo que hayas desarrollado con R **sin cambiarte a otro lenguaje ni aprender uno distinto**. Esto significa que **la distancia se acorta** entre el gráfico que hiciste o el resultado de tus estudios y el tener un producto presentable para tu público o clientes. 

En este tutorial veremos cómo crear una aplicación Shiny desde cero!

{{< indice >}}

{{< externo "Galería de apps Shiny" "https://bastianolea.github.io/shiny_apps/" 
"shiny_apps.png" 
"Visita esta página para explorar las más de 20 aplicaciones Shiny centradas en datos sociales y abiertos que he desarrollado. Todas tienen su código fuente disponible para que las revises, modifiques y copies!"
"Página recomendada" >}}


## Beneficios de Shiny
**Control del _stack_ completo de la aplicación desde un mismo lenguaje:**

- Shiny se encarga de que todas las piezas (HTML, CSS, JavaScript) funcionen desde R
- No necesitas ningún aprender ningún lenguaje nuevo porque todo funciona con R
- Todo lo que hayas hecho en R se podrá incluir en tu aplicación sin necesidad de cambios, como tus gráficos, tablas y más.


**Tiempo de desarrollo reducido incluso para personas sin experiencia en informática:**
- El trabajo necesario para producir una aplicación es muy bajo; en unos minutos puedes tener algo funcional
- No necesitas expertos o equipos externos para desarrollar una aplicación, ya que Shiny simplifica al máximo el proceso


## Cómo funciona una app Shiny

Las aplicaciones Shiny son, en su forma más básica, un solo archivo: `app.R`. 

<div class="icono-v">
  <i class='fas fa-file-code'></i>
  <span>app.R</span>
</div>

En este script estará **todo** lo que necesita la aplicación para funcionar!

Obviamente este script debe estar dentro de una **carpeta**, idealmente un [proyecto de R](/blog/r_introduccion/proyectos/). Todo lo que esté en la carpeta donde se encuentre `app.R` estará al alcance de tu app.

<div style="text-align: center;">
  <div class="contenedor-iconos">

  <div>
    <i class='fas fa-folder' style='font-size: 200%; vertical-align: middle;'></i>
    <span style="padding: 4px; font-weight: bold;">Proyecto</span>
  </div>

<div class="icono-cuadro">
  
  <div class="icono-v">
    <i class='fas fa-file-code'></i>
    <span>app.R</span>
  </div>
  
  <div class="icono-v">
    <i class='fas fa-file'></i>
    <span>funciones.R</span>
  </div>
  
  <div class="icono-v">
    <i class='fas fa-file-excel'></i>
    <span>datos.xls</span>
  </div>
  
</div>
</div>
</div>

Dentro de `app.R`, la aplicación se divide en tres secciones principales:

<div style="max-width: 400px; margin: auto;">

<div style="margin-left: 22px;">
  <i class='fas fa-file-code' 
  style='font-size: 200%; vertical-align: middle;'></i>
  <span style="padding: 4px; font-weight: bold;">App.R</span>
</div>

<div class="cuadro">
<b>Global:</b> código general que aplica a toda la app
  <div class="cuadro">
  <b>Interfaz (UI):</b> disposición de los elementos visuales, temas, textos
  </div>
  
  <div class="cuadro">
  <b>Server:</b> lógica, cálculos y procesamiento de la app
  </div>
  
  <div style="margin-bottom: 2px;">
    <code>shinyApp()</code>
  </div>
  
</div>
</div>

En cada una de estas secciones usaremos código de R para establecer lo que necesita la aplicación, como paquetes, datos, configuraciones (**global**), para diseñar la interfaz gráfica (**UI**), y para procesar los datos y _outputs_ de la aplicación (**server**).

Al final de `app.R`, una línea mágica transformará el script en una aplicación: `shinyApp()` 



## Creando una aplicación básica

Si no tienes Shiny instalado, instálalo con:

```r
install.packages("shiny")
```

Todas las aplicaciones Shiny empiezan muy sencillas, con unas cuantas líneas que definen lo mínimo para que funcione, y después van creciendo en complejidad.

Para ir aprendiendo, primero veremos una aplicación muy básica.

{{< info "Revisa este [otro tutorial mucho más básico de Shiny](/blog/r_introduccion/tutorial_shiny_1/) si crees que necesitas ir más lento" >}}

### Global

Lo inicial simple va a ser **cargar los paquetes necesarios** en la sección **global** de la aplicación, que corresponde a las primeras líneas del script `app.R`.

Crea un script `app.R`, y en la primera línea agrega:

```r
library(shiny)
```

### Interfaz

Luego tenemos que crear la interfaz de la aplicación. Esto es todos los aspectos visuales e interactivos de la aplicación, lo que las y los usuarios/as verán.

La interfaz de la aplicación se crea con una función. Hay varias disponibles, pero usaremos la más común, `page_fluid()` [del paquete `{bslib}`.](https://rstudio.github.io/bslib/)

```r
# install.packages("bslib")
library(bslib)

ui <- page_fluid()
```

{{< info "`{bslib}` es un paquete que nos ofrece herramientas modernas para crear las interfaces de aplicaciones Shiny, basadas en Bootstrap, un _framework frontend_ muy popular." >}}

La función `page_fluid()` creará el objeto `ui`, que es necesario para que la aplicación funcione. Este objeto va a **contener toda la interfaz** de la aplicación, por lo tanto, dentro de la función que usemos para construir la app iremos poniendo todo lo que la app contenga, separado por comas.

Agreguemos un **título** y un **texto** a nuestra aplicación:

```r
ui <- page_fluid(
    h1("Título"),
    p("Texto dentro de la app")
  )
```

Si ejecutamos el código y vemos lo que contiene `ui`, veremos la interfaz de nuestra aplicación en el visor de RStudio.

### Server

En la sección _server_ de la aplicación es donde ocurren todos los cálculos que normalmente hacemos en R. Por ejemplo, filtrar datos y crear gráficos.

El _server_ consiste en una función, dentro de la cual se ejecutan todos los cálculos:

```r
server <- function(input, output) {
}
```

Dentro de la función `server`, lo que principalmente haremos será **crear _outputs_** o salidas. Los _outputs_ son la forma de hacer que un cálculo que haga la aplicación se muestre en la interfaz.




{{< relacionada "blog/r_introduccion/tutorial_shiny_1" >}}





{{< relacionada "blog/shiny_temas" >}}

{{< relacionada "blog/shiny_ocultar" >}}
{{< relacionada "blog/shiny_optimizar" >}}

{{< detalles >}}
Hola
{{< /detalles >}}

{{< info "Prueba" >}}




{{< etiqueta "apps" "Algunas aplicaciones hechas con Shiny" >}}

{{< etiqueta "shiny" >}}
