---
title: "Tutorial: Crea aplicaciones web interactivas en R con Shiny"
author: Bastián Olea Herrera
date: '2026-05-07'
draft: false
categories:
  - Tutoriales
tags:
  - shiny
  - apps
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "Shiny es un paquete para desarrollar aplicaciones web interactivas con R. Con Shiny puedes crear aplicaciones que tus usuarios/as podrán ver desde su navegador, y pueden contener todo tipo de contenido: gráficos, tablas, botones, textos dinámicos, mapas, etc. Es una forma de usar R para crear aplicaciones web centradas en datos que simplifica muchos aspectos complejos del desarrollo web.

Shiny le da vida a todo lo que hayas desarrollado con R sin cambiarte a otro lenguaje ni aprender uno distinto. Esto significa que la distancia se acorta entre el gráfico que hiciste o el resultado de tus estudios y el tener un producto presentable para tu público o clientes.

¡Da el salto desde tu script y aprende a programar apps en este tutorial!"
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

{{< etiqueta "apps" "Algunas aplicaciones hechas con Shiny" >}}

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
  
  <div class="icono-v" style="padding:0px 10px;">
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



## Creando una aplicación vacía

Si no tienes Shiny instalado, instálalo con:

```r
install.packages("shiny")
```

Todas las aplicaciones Shiny empiezan muy sencillas, con unas cuantas líneas que definen lo mínimo para que funcione, y después van creciendo en complejidad.

Para **entender los conceptos básicos**, haremos una aplicación completamente vacía. Empezamos **creando un nuevo script**, que llamaremos `app.R`.

{{< info "Revisa este [otro tutorial mucho más básico de Shiny](/blog/r_introduccion/tutorial_shiny_1/) si crees que necesitas ir más lento" >}}

### Global

Lo inicial siempre va a ser **cargar los paquetes necesarios** en la sección **global** de la aplicación, que corresponde a las primeras líneas del script `app.R`.

En la primera línea de `app.R` agrega:

```r
library(shiny)
```

### Interfaz

Luego tenemos que crear la interfaz de la aplicación. Esto es todos los **aspectos visuales** e **interactivos** de la aplicación, lo que las y los usuarios/as verán y usarán.

La interfaz de la aplicación se crea con una función. Hay varias disponibles, pero usaremos una muy básica, `page_fillable()` [del paquete `{bslib}`.](https://rstudio.github.io/bslib/)

```r {hl_lines=[2,3,4]}
library(shiny)
library(bslib)

ui <- page_fillable()
```

{{< info "`{bslib}` es un paquete que nos ofrece herramientas modernas para crear las interfaces de aplicaciones Shiny, basadas en Bootstrap, un _framework frontend_ muy popular." >}}

La función `page_fillable()` creará el objeto `ui`, que es necesario para que la aplicación funcione. Este objeto va a **contener toda la interfaz** de la aplicación.

Agreguemos un **título** y un **texto** a la interfaz de nuestra aplicación:

```r {hl_lines=[5,6]}
library(shiny)
library(bslib)

ui <- page_fillable(
    h1("Título"),
    p("Texto dentro de la app")
  )
```

Los elementos que pongamos dentro de la `ui` tienen que ir separados por comas!


### Server

En la sección _server_ de la aplicación es donde ocurren todos los **cálculos** que normalmente hacemos en R. Por ejemplo, filtrar datos, procesar información y crear gráficos.

El _server_ es simplemente una función:

```r
server <- function(input, output) {
}
```
Dentro de `server` iremos poniendo más funciones que creen las partes de la aplicación que requieren de cálculos y/o datos. Podemos dejarla vacía por mientras.


### Aplicación vacía

Unamos las piezas en un solo script `app.R`, agregando la última pieza para que la aplicación sea ejecutable: `shinyApp()`

```r {hl_lines=[15,16]}
# global
library(shiny)
library(bslib)

# interfaz
ui <- page_fillable(
    h1("Título"),
    p("Texto dentro de la app")
    )

# servidor
server <- function(input, output) {
}

# ejecutar la app
shinyApp(ui, server)
```

Estas son las **partes básicas** de una app Shiny. Si guardas esto en un script, notarás que aparece el botón **_Run App_** en la parte superior derecha del panel de _scripts:_

{{< imagen "app_shiny_vacia.png" "300px" >}}

{{< bajada "Botón _Run App_ en un script de aplicación Shiny" >}}


Al presionarlo, tu aplicación se ejecutará en el panel _Viewer_ de RStudio. Si hiciste todo bien (cargar los paquetes, separar elementos de UI con comas, poner `shinyApp()` al final) debería aparecer la aplicación en el panel!

{{< imagen "app_shiny_vacia_run.png" "300px" >}}

Hasta ahora hemos hecho lo más simple posible: una aplicación con un poco de texto, pero sin datos, sin interacción, ni nada.

{{< detalles "Ver código de la app vacía" >}}
Pon ste código en el script `app.R`:
```r
# global
library(shiny)
library(bslib)

# interfaz
ui <- page_fluid(
  h1("Título"),
  p("Texto dentro de la app")
  )

# servidor
server <- function(input, output) {
}

# ejecutar la app
shinyApp(ui, server) 
```
{{< /detalles >}}

{{< relacionada "blog/r_introduccion/tutorial_shiny_1" " Tutorial básico recomendado" >}}



## Creando una aplicación básica con datos

La gracia de las aplicaciones Shiny es que usen datos y permitan a sus usuarios **explorar y visualizar información** de manera interactiva.

### Cargar datos en la app

Bajemos un conjunto de datos para probar: el [catastro de campamentos 2024](https://www.minvu.gob.cl/catastro-campamentos-2022/) realizado por el Ministerio de Vivienda y Urbanismo de Chile. Esta versión de los datos corresponde a una base previamente limpiada con código de [este repositorio.](https://github.com/bastianolea/campamentos_chile)

{{< boton "Descargar datos" "datos.xlsx" "fas fa-file-download" >}}

El archivo Excel se llama `datos.xlsx`. Guardamos el archivo en la carpeta de nuestra aplicación:

<div style="text-align: center;">
  <div class="contenedor-iconos">

<div class="icono-cuadro">
  
  <div class="icono-v" style="padding:0px 10px;">
    <i class='fas fa-file-code'></i>
    <span>app.R</span>
  </div>
  
  <div class="icono-v">
    <i class='fas fa-file-excel'></i>
    <span>datos.xlsx</span>
  </div>
  
</div>
</div>
</div>

Al estar el archivo de datos en la misma carpeta que `app.R`, se puede cargar tan solo llamando su nombre. Entonces, cargamos con la función apropiada _antes_ de la interfaz de la app:


```r {hl_lines=[3, 4, 5]}
library(shiny)
library(bslib)
library(readxl)

datos <- read_excel("datos.xlsx")

ui <- page_fillable(
# ...
```

Todo lo que se ejecute en la [sección global](#global) (al inicio de la app y antes de la UI) estará disponible constantemente durante tu aplicación.

{{< detalles "Código de la app hasta ahora" >}}
```r
library(shiny)
library(bslib)
library(readxl)

datos <- read_excel("datos.xlsx")

# interfaz
ui <- page_fillable(
    h1("Título"),
    p("Texto dentro de la app")
    )

# servidor
server <- function(input, output) {
}

# ejecutar la app
shinyApp(ui, server)
```
{{< /detalles >}}



### Textos básicos

Agreguemos un título y una descripción breve a la app. Estos cambios los hacemos en la interfaz de la app:

```r
ui <- page_fillable(
  # título
  h1("Campamentos en Chile"),
  
  # párrafo
  p("Aplicación Shiny para explorar datos 
    de campamentos registrados en Chile.")
)
```

En HTML (el código usado para **construir páginas web**) los titulares se definen como `h1`, `h2`, hasta `h5`, donde el número representa la **jerarquía**, en 1 correspondiendo al título principal de la página.

Shiny también crea sus aplicaciones web con HTML, pero nos ayuda a usarlo desde R. Creamos **títulos** con las funciones `h1()`, `h2()`, `h3()`, etc.

Los **párrafos** se crean con la función `p()`.

### Componer textos con datos

Podemos usar objetos de R para crear **textos estáticos** (que no cambian) en la app. Para ello podemos ayudarnos de la función `glue()` que nos facilita pegar textos. Veamos la comparación entre usar `paste()` versus `glue()` para componer textos:

```r
x <- "gatos"
y <- "patos"

paste("me gustan los", x, "y los", y, "también")

glue::glue("me gustan los {x} y los {y} también")
```

Con `glue()` el código resulta mucho más legible, porque te ahorra tener que poner tantas comas y comillas!

Mejoremos entonces el párrafo `p()` de la app:

```r {hl_lines=[1,"8-12"]}
library(glue)

ui <- page_fillable(
  # título
  h1("Campamentos en Chile"),
  
  # párrafo
  p(
    glue("Aplicación Shiny para explorar los datos de 
    los {nrow(datos)} campamentos registrados en Chile.")
  ),
)
```

Ahora el texto del párrafo muestra el número de filas de la tabla de datos!

### Textos con Markdown

Escribir textos con estilos como negrita o itálicas, o textos con enlaces en HTML puede ser engorroso, pero podemos usar [Markdown](https://es.wikipedia.org/wiki/Markdown), un lenguaje de marcado que nos facilita la escritura de HTML mediante símbolos que representan las propiedades del texto:

| texto    | código            | resultado       |
|----------|-------------------|-----------------|
| Negrita  | `**hola**`        | **hola**        |
| Itálica  | `_hola_`          | _hola_          |
| Enlace   | `[hola](www.com)` | [hola](www.com) |
| Tachado  | `~~hola~~`        | ~~hola~~        |
| Código   | `` `hola` ``      | `hola`          |

La función `markdown()` nos permite incluir este tipo de textos en nuestras apps Shiny. En una sola función, y usando algunos símbolos, podemos escribir un párrafo con enlaces, negritas e itálicas:

```r {hl_lines=["7-12"]}
  # párrafo
  p(
    glue("Aplicación Shiny para explorar los datos de 
    los {nrow(datos)} campamentos registrados en Chile.")
  ),
  
  # párrafo markdown
  markdown("Los **campamentos** son definidos por el 
           [Minvu](https://www.minvu.gob.cl/catastro-campamentos-2022/) 
           como _Asentamientos de ocho o más viviendas precarias que 
           habitan en posesión irregular un terreno, con carencia de 
           servicios básicos, agrupadas y contiguas._")
```

Así va quedando la app:

{{< imagen "app_shiny_textos.png" >}}
{{< bajada "Aplicación Shiny con textos" >}}

Fíjate que los elementos dentro de la UI van separados por comas (porque en realidad son argumentos dentro de la función que genera la UI!), así que después de cada cierre de paréntesis no olvides la coma!

{{< detalles "Código de la app hasta ahora" >}}
```r
# global
library(shiny)
library(bslib)
library(readxl)
library(glue)

# cargar datos
datos <- read_excel("datos.xlsx")

# interfaz
ui <- page_fillable(
  
  # título
  h1("Campamentos en Chile"),
  
  # párrafo
  p(
    glue("Aplicación Shiny para explorar 
         los datos de los {nrow(datos)} 
         campamentos registrados en Chile.")
  ),
  
  # párrafo markdown
  markdown("Los campamentos son definidos por el 
           [Minvu](https://www.minvu.gob.cl/catastro-campamentos-2022/) 
           como _Asentamientos de ocho o más viviendas precarias que 
           habitan en posesión irregular un terreno, con carencia de 
           servicios básicos, agrupadas y contiguas._")
)

# servidor
server <- function(input, output) {}

# ejecutar la app
shinyApp(ui, server)
```
{{< /detalles >}}


### Interacción básica

Hasta ahora la aplicación es estática. Pero la gracia es **agregar elementos interactivos** con los que l@s usuari@s puedan explorar los datos.

Un elemento con el que los usuarios interactúan en la app se denomina **input**. Los inputs se crearon con funciones, y se ponen en la interfaz de la aplicación.

Quizás el _input_ más simple es `selectInput()`, que agrega un selector de opciones. Al crear cualquier input, el primer argumento de la función es su `inputId`, que es el **identificador** o nombre del input, que usaremos luego para obtener sus resultados.

Creemos un input que permita seleccionar de una lista de regiones, que naturalmente vienen de los datos. El conjunto de datos `datos` [que descargamos](#cargar-datos-en-la-app) tiene en la columna `region` el nombre de la región a la que pertenece cada observación, así que si usamos `unique(datos$region)` obtendremos un vector con sus valores únicos.

Entonces creamos el input con `selectInput()`, le damos el ID `"region"` (porque es un selector de regiones), y las elecciones posibles (`choices`) serán las regiones que vienen en el conjunto de datos:

```r {hl_lines=["5-9"]}
# interfaz
ui <- page_fillable(
  h1("Campamentos en Chile"),
  ...
  selectInput(
    inputId = "region",
    label = "Explorar regiones",
    choices = sort(unique(datos$region))
    )
  ...
)
```

Si probamos la app, veremos que aparece un cuadro donde se puede hacer la selección:

{{< imagen "shiny_selectInput.png" "340px" >}}

Por ahora esto no hace nada, pero internamente, cuando seleccionamos una opción, Shiny actualiza un objeto especial: el objeto `input`. Este objeto contiene los valores de todos los _inputs_ de nuestra app, según el ID que le dimos. 

<div style="display: flex; align-items: center; justify-content: center; gap: 12px; margin: 20px 0;">

  <div class="cuadro" style="margin: 0; font-size: 1.1em;"><code>selectInput("selector")</code></div>
  
  <span style="font-size: 1.6em;">→</span>
  
  <div class="cuadro" style="margin: 0; font-size: 1.1em;"><code>input$selector</code></div>
</div>

Al seleccionar una opción del selector, inmediatamente se actualiza el objeto `input$region`, dado que el ID del input que creamos era `region`.

Pronto veremos cómo usar este valor!


### Server

Ahora que tenemos datos y un input, pasamos a _hacer cosas_ con eso datos y esos inputs! ✨

Dentro de la sección **server** de una app (la función `server`) es donde se conectan los inputs con los datos.

En `server`, lo que principalmente haremos será **crear _outputs_** o salidas. Los _outputs_ son la forma de hacer que un cálculo que haga la aplicación se muestre en la interfaz.

Naturalmente pueden haber pasos intermedios en operaciones más complejas, pero el ciclo de la interacción es:

1. En la interfaz de la app hay **inputs**
2. El/la usuario/a **interactúa** con un input
3. El input se usa en server para _producir_ una **salida**
4. La salida se muestra en la **interfaz** de la app.

<div style="display: flex; justify-content: center; margin: 24px 0;">
  <div class="cuadro" style="margin: 0; text-align: center;">
    <strong>app</strong>
    <div style="display: flex; align-items: center; gap: 8px; margin-top: 8px;">
      <div class="cuadro" style="margin: 0; text-align: center; min-width: 90px;">
        <strong>UI</strong>
        <div class="cuadro" style="margin: 8px 0 0 0;">inputs</div>
        <div class="cuadro" style="margin: 8px 0 0 0;">outputs</div>
      </div>
      <div style="display: flex; flex-direction: column; align-items: center; gap: 16px; font-size: 1.4em; padding: 0 4px;">
        <span>→</span>
        <span>←</span>
      </div>
      <div class="cuadro" style="margin: 0; text-align: center; min-width: 90px;">
        <strong>server</strong>
        <div class="cuadro" style="margin: 8px 0 0 0;">render</div>
      </div>
    </div>
  </div>
</div>

{{< bajada "Esquema simplificado de una app Shiny básica" >}}

<!---
#### Outputs


### Temas

{{< relacionada "blog/shiny_temas" >}}



* mostrar u ocultar elementos según condiciones

{{< relacionada "blog/shiny_ocultar" >}}


* código condicional desde inputs





{{< relacionada "blog/shiny_optimizar" >}}

{{< detalles >}}
Hola
{{< /detalles >}}

{{< info "Prueba" >}}




### Maqueta de la aplicación

Como dijimos, **la brecha entre un script de R y una aplicación es muy corta**. Así que siempre recomiendo empezar las aplicaciones como un script común y corriente, que luego podemos **convertir** en una aplicación Shiny.


--->

{{< aviso "Este post está en construcción! Fastídiame para que lo termine [comentando en este post de LinkedIn](https://www.linkedin.com/posts/bastianolea_basti%C3%A1n-olea-herrera-activity-7458116493420130304-wWUA)" >}}

{{< etiqueta "shiny" >}}
