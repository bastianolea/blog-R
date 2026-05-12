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

## Estructura de una app Shiny

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

```r
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
Pon este código en el script `app.R`:
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

Ahora iremos poco a poco construyendo una app simple que cargue datos y los use para demostrar conceptos básicos de Shiny.

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


### Interacción básica con _inputs_

Hasta ahora la aplicación es estática. Pero la gracia es **agregar elementos interactivos** con los que l@s usuari@s puedan explorar los datos.

Un elemento con el que los usuarios interactúan en la app se denomina **input**. Los inputs se crearon con funciones, y se ponen en la interfaz de la aplicación.

Al crear cualquier input, el primer argumento de la función es su `inputId`, que es el **identificador** o nombre del input, que usaremos luego para obtener sus resultados.

#### Crear un selector de alternativas

Quizás el _input_ más simple es `selectInput()`, que agrega un **selector** de opciones. Estas opciones podemos escribirlas a mano en el argumento `choices`, o podemos usar un vector o la columna de un _dataframe_ como opciones para el selector.

Crearemos un _input_ que permita seleccionar una opción desde una lista de regiones. Haremos que las regiones posibles de elegir vengan directamente de los datos. El conjunto de datos [que descargamos](#cargar-datos-en-la-app) (y que cargamos como `datos`) tiene el nombre de la región a la que pertenece cada observación en la columna `region`, así que si usamos `unique(datos$region)` obtendremos un vector con sus valores únicos.

Entonces creamos el input con `selectInput()`, le damos el ID `"region"` (porque es un selector de regiones), y las elecciones posibles (`choices`) serán las regiones que vienen en el conjunto de datos:

```r {hl_lines=["5-9"]}
# interfaz
ui <- page_fillable(
  h1("Campamentos en Chile"),
  ...
  selectInput(
    inputId = "region", # ID único del input
    label = "Explorar regiones", # titular del input
    choices = sort(unique(datos$region)) # vector con regiones desde los datos
    )
  ...
)
```

Si probamos la app, veremos que aparece un cuadro donde se puede hacer la selección:

{{< imagen "shiny_selectInput.png" "340px" >}}


#### _Inputs_ de una app 
Por ahora, nuestro selector **no hace nada**, pero internamente, cuando seleccionamos una opción, Shiny actualiza un objeto especial: **el objeto `input`**. Este objeto contiene los **valores** de todos los _inputs_ de nuestra app, según el ID que le dimos. 

<div class="cuadros-horizontales">

  <div class="cuadro"><code>selectInput("selector")</code></div>
  
  <span style="font-size: 1.6em;">→</span>
  
  <div class="cuadro"><code>input$selector</code></div>
</div>

Al seleccionar una opción de un selector, inmediatamente se actualiza el objeto `input${inputId}`, donde `{inputId` corresponde al ID que le dimos al _input._ En nuestro ejemplo del selector de regiones, el valor elegido estaría en `input$region`, dado que el ID del input era `region`.

Pronto veremos cómo usar este valor!


### Uniendo _inputs_ y datos en _server_

Ahora que tenemos [datos](#cargar-datos-en-la-app) y un [input](#interacción-básica), pasamos a _hacer cosas_ con eso datos y esos inputs! ✨

Dentro de la sección **server** de una app (la función `server`) es **donde se conectan los inputs con los datos.**

En la función server es donde vamos a **usar R como el motor de la app**.

En `server`, lo que principalmente haremos será **crear _outputs_** o salidas. Los _outputs_ son la forma de hacer que un cálculo que haga la aplicación se muestre en la interfaz.

Considerando las secciones UI y server, el ciclo de interacción de una app es:

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

Naturalmente pueden haber pasos intermedios en operaciones más complejas, pero en resumen lo anterior describe el funcionamiento básico de una app Shiny.


#### Usando _inputs_ dentro de _server_

Pasemos un input al _server_ para hacer algo con su valor. Cuando hacemos esto, tenemos que tener una **idea** de qué es lo que queremos lograr, o para qué usaremos el input. Esto significa que tenemos que pensar en el **resultado** que esperamos poner en la app; es decir, en **el _output_ que se mostrará en la interfaz de la app.**

<div class="cuadros-verticales">

  <div class="cuadro-vertical">elegir input desde la app</div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical">input pasa a server</div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical">magia en <em>server</em></div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical"><em>output</em> aparece en la app</div>
  
</div>

Pensemos en un caso simple: queremos **contar la cantidad de observaciones por región.** Tenemos nuestro _dataframe_ `datos`, el cual podemos filtrar por región y luego contar las filas para saber la cantidad de campamentos en una región:

```r
casos_region <- datos |> 
  filter(region == "Maule") |> 
  nrow()
  
casos_region
```
```
[1] 25
```

{{< info "Como dijimos al principio, **la brecha entre un script de R y una aplicación es muy corta**. Así que siempre recomiendo empezar las aplicaciones como un script común y corriente, que luego podemos **convertir** en una aplicación Shiny." >}}

Entonces, lo que haremos en la sección _server_ de la app será algo equivalente a esto:

```r  {hl_lines=["2-3,6-7"]}
# definir input de prueba
region_elegida <- "Biobío"

casos_region <- datos |> 
  # aplicar input de prueba en el filtro
  filter(region == region_elegida) |> 
  nrow()
  
casos_region
```
```
[1] 225
```

En este ejemplo creamos un input "falso" en el objeto `region_elegida` para poder probar la lógica en un scirpt aparte, pero en la app podremos usar el objeto `input$region`:

```r  {hl_lines=["2-3,6-7"]}
casos_region <- datos |> 
  filter(region == input$region) |> 
  nrow()
```

{{< aviso "El objeto `input` sólo existe mientras la app Shiny se está ejecutando, así que el código anterior es sólo de ejemplo!" >}}

Esto lo haremos en _server_ a continuación.


#### Generando salidas o _outputs_

En la sección _server_ de la app, creamos el **output** que será la salida con lo que vamos a mostrar en la interfaz de la app. Aquí es donde podemos usar R normalmente para crear lo que queramos, pero dentro de ciertos _marcos_ que circunscriben el código de R a la lógica de una aplicación interactiva Shiny.

Uno de estos _marcos_ para apps interactivas es que, a diferencia de un script normal donde podemos generar resultados (cifras, tablas, gráficos) en cualquier parte, en una app tenemos que **definir las salidas** de manera clara, con un nombre y una función apropiada para crear la salida, y luego **ubicar las salidas en algún lugar** de la interfaz de la aplicación.

<div class="cuadros-verticales">

  <div class="cuadro-vertical">código de R</div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical">crear (<em>render</em>) la salida</div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical">ubicar salida en la app</div>
  
</div>

{{< aviso "Iremos explicando de a poco esta sección, ya que sólo funcionará cuando estén todos los elementos necesarios. Al final encontrarás el código completo de la app para probarla" >}}

La salida que crearemos (el conteo de casos por región) se va a llamar `casos_region`, y como hay que **explicitar que el código será una salida** para la app, asignamos el resultado que queremos mostrar a un objeto preexistente llamado **output** que se encargará de recibir todas las salidas de nuestra app. Empecemos simplemente creando el objeto `casos_region` asignado a `output`, lo que quedaría así: `output$casos_region`

```r {hl_lines=["3-7"]}
) # final de la ui
...
# servidor
server <- function(input, output) {
  # conteo de casos filtrados por región
  output$casos_region <- ... # aquí vamos...
}

# ejecutar la app
shinyApp(ui, server)
```

{{< info "El objeto `output`, al igual que `input`, son objetos creados y usados por Shiny para organizar la app, y sólo son accesibles dentro de la app y mientras se está ejecutando. " >}}

Ahora tenemos que pensar **qué tipo de _output_** crearemos, porque dependiendo del tipo de salida será la función que necesitamos usar para **convertir el resultado de R en algo visible en nuestra app**. En nuestro caso crearemos un **texto** con el conteo de casos, así que usaremos `renderText()` para crear o _renderizar_ la cifra en un texto legible para la aplicación.

```r {hl_lines=["6-10"]}
) # final de la ui
...
# servidor
server <- function(input, output) {
  # conteo de casos filtrados por región
  output$casos_region <- renderText({
    datos |>
      filter(region == "Maule") |>
      nrow()
  })
}

# ejecutar la app
shinyApp(ui, server)
```

La función `renderText()` convertirá el texto en un objeto HTML apropiado para la aplicación. Si quisiéramos hacer un gráfico, usaríamos `renderPlot()`, y así.

Ahora podemos reemplazar el filtro de prueba que hicimos por un filtro que **use el input**:

```r {hl_lines=[3]}
  output$casos_region <- renderText({
    datos |>
      filter(region == input$region) |>
      nrow()
  })
```

Esto significa que el/la usuario/a eligirá qué es lo que se filtra, y que cada vez que se cambie el selector, se actualizará el objeto `input$region`, y por consiguiente se volverá a ejecutar el código de `output$casos_region` para entregar el nuevo resultado!

Hasta ahora tenemos algo como esto:

<div class="cuadros-verticales">
  <div class="cuadro">
    <code>output$casos_region</code> que identifica la salida para poder usarla
  <div class="cuadro">
    <code>renderText()</code> que <em>renderiza</em> el código de R en una salida HTML para la app
  <div class="cuadro">
  código de R que produce lo que queremos mostrar
  </div>
  </div>
  </div>
</div>

El último paso es **conectar el output con el UI** para que nuestra salida aparezca en alguna parte de la app. Para ello, invocamos el nombre del _output_ en la función `textOutput()`, y la ubicamos en la UI de nuestra app; en este caso, debajo del selector mismo:

```r {hl_lines=["7-8"]}
selectInput(
    inputId = "region",
    label = "Explorar regiones",
    choices = sort(unique(datos$region))
  ),
  
  # salida de texto de conteo de observaciones
  textOutput("casos_region")
```

Lo que hicimos fue:
1. Crear un _input_
2. Crear un _output_
3. Hacer que el _output_ use el _input_
4. Poner el _output_ en la parte visible de nuestra app (UI)

Pasamos a tener esto:

<div class="cuadros-verticales">
  <div class="cuadro">
    app.R
  
  <div class="cuadro">
  <b>UI</b>
   <div class="cuadro">
    <code>textOutput()</code> que ubica la salida en la interfaz de la app
   </div>
  </div>
  
  <div class="cuadro">
  <b>server</b>
   <div class="cuadro">
    <code>renderText()</code> que <em>renderiza</em> la salida a partir de código R
   </div>
  </div>
  
  </div>
</div>

Veamos cómo funciona la aplicación!

{{< video "shiny_selector_1.mov" "320px" >}}

Mejoremos la salida de texto para que sea más descriptiva: volvamos a server, al _output_ que creamos, y hagamos que incluya más texto y el nombre de la región seleccionada:

```r {hl_lines=["2-6"]}
  output$casos_region <- renderText({
    conteo <- datos |>
      filter(region == input$region) |>
      nrow()
    
    glue("La región {input$region} tiene registrados {conteo} casos.")
  })
```

{{< imagen "shiny_selector_2.png" "320px" >}}

Siguiendo estas mismas ideas podemos crear un párrafo de texto más complejo usando distintas variables, combinando múltiples inputs, y más!


{{< detalles "**Ver código completo de la app hasta ahora**" >}}
Guarda este código en un script `app.R` para poder ejecutarlo:
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
    glue(
      "Aplicación Shiny para explorar 
         los datos de los {nrow(datos)} 
         campamentos registrados en Chile."
    )
  ),

  # párrafo markdown
  markdown(
    "Los **campamentos** son definidos por el 
           [Minvu](https://www.minvu.gob.cl/catastro-campamentos-2022/) 
           como _Asentamientos de ocho o más viviendas precarias que 
           habitan en posesión irregular un terreno, con carencia de 
           servicios básicos, agrupadas y contiguas._"
  ),

  # selector de regiones
  selectInput(
    inputId = "region",
    label = "Explorar regiones",
    choices = sort(unique(datos$region))
  ),

  # salida de texto de conteo de observaciones
  textOutput("casos_region")
)

# servidor
server <- function(input, output) {
  # conteo de casos filtrados por región
  output$casos_region <- renderText({
    conteo <- datos |>
      filter(region == input$region) |>
      nrow()

    glue("{input$region} tiene registrados {conteo} casos.")
  })
}

# ejecutar la app
shinyApp(ui, server)
```
{{< /detalles >}}


### Agregar un gráfico

**Repaso:** Ya vimos que, para poner algo en la app, necesitamos generar un output y ponerlo en la interfaz (UI) de la app con una función `{x}output()`, como `textOutput()`, mientras que el output se calcula en `server`, y necesita crearse con una función `render{x}()`, como `renderText()`.

#### Hacer un gráfico de prueba primero
Antes de poner un gráfico en una app, recomiendo empezar con una prueba del gráfico en un script separado, y luego portar el script a la app.

{{< relacionada "/blog/r_introduccion/tutorial_visualizacion_ggplot" >}}

[Haremos un **gráfico de barras**](/blog/r_introduccion/tutorial_visualizacion_ggplot/#barras-ordenado) que muestre los principales campamentos de cada región elegida por el/la usuario/a.

Cargamos los datos, los filtramos por región (pensando en cómo lo haríamos con el selector `input$region`), luego reducimos la cantidad de observaciones a las más relevantes con `slice_max()` para dejar sólo las con más hogares, y al final ordenamos las observaciones por la variable numérica `hogares`:

```r
library(dplyr)
library(readxl)
library(forcats)

datos <- read_xlsx("datos.xlsx")

# filtrar una región
region_elegida = "Biobío"

datos_region <- datos |> 
  filter(region == region_elegida)

# filtrar máximo de observaciones, y ordenarlas
datos_region_grafico <- datos_region |> 
  slice_max(hogares, n = 6) |> 
  mutate(nombre = fct_reorder(nombre, hogares))
```

Ahora procedemos a hacer el gráfico:

```r
library(ggplot2)

datos_region_grafico |> 
  ggplot() +
  aes(hogares, nombre) +
  geom_col(width = 0.7) +
  geom_text(
    aes(label = hogares),
    hjust = 1.3, color = "white", fontface = "bold") +
  scale_x_continuous(expand = 0) +
  theme_minimal() +
  theme(
    axis.title.y = element_blank(),
    axis.text.y = element_text(face = "bold"))
```

{{< imagen "grafico_1.jpg" "400px" >}}

#### Poner el gráfico en la app

Para poner el gráfico en la app Shiny, principalmente hay que hacer dos cosas:

1. Ubicar el output en donde queremos que aparezca en la interfaz de la app con `plotOutput()`
2. Generar (_render_) el gráfico desde `server` usando los datos e inputs necesarios.

Empecemos ubicando el gráfico (todavía inexistente) en algún lugar de la UI nuestra app, como debajo del selector y del texto que generamos más arriba.

```r {hl_lines=["11-12"]}
# selector de regiones
  selectInput(
    inputId = "region",
    label = "Explorar regiones",
    choices = sort(unique(datos$region))
  ),

  # salida de texto de conteo de observaciones
  textOutput("casos_region"),
  
  # salida de gráfico
  plotOutput("grafico_barras_region")
```

Pusimos `plotOutput("grafico_barras_region")` para que el output `output$grafico_barras_region` aparezca debajo del texto.

Si ejecutamos la app hasta ahora, no va a aparecer nada, porque la salida no recibe nada para mostrar.

Ahora vamos a la sección `server` y calculemos el gráfico. Tenemos que crear un `output` con el mismo nombre que pusimos arriba, y asignarle el resultado de la función `renderPlot()`:

```r {hl_lines=["4-7"]}
server <- function(input, output) {
  ...

  # gráfico de barras
  output$grafico_barras_region <- renderPlot({
    # aquí va el código del gráfico
  })
  ...
}
```

Dentro de `renderPlot()`, como tiene paréntesis de llave (`{}`), podemos escribrir cualquier sintaxis de R que queramos. En este punto podemos copiar y pegar el código del gráfico que hicimos más arriba, incluyendo el procesamiento de sus datos, para generar el mismo gráfico pero dentro de nuestra app:

```r {hl_lines=["6-32"]}
server <- function(input, output) {
  ...
  # gráfico de barras
  output$grafico_barras_region <- renderPlot({
    # filtrar por región
    datos_region <- datos |>
      filter(region == input$region) # usar input!

    # limitar cantidad de casos y ordenar
    datos_region_grafico <- datos_region |>
      slice_max(hogares, n = 6) |>
      mutate(nombre = fct_reorder(nombre, hogares))

    # gráfico
    datos_region_grafico |>
      ggplot() +
      aes(hogares, nombre) +
      geom_col(width = 0.7) +
      geom_text(
        aes(label = hogares),
        hjust = 1.3,
        color = "white",
        fontface = "bold"
      ) +
      scale_x_continuous(expand = 0) +
      theme_minimal(base_size = 13) +
      theme(
        axis.title.y = element_blank(),
        axis.text.y = element_text(face = "bold")
      )
  })
  ...
}
```

La única diferencia es que ponemos `input$region` en el `filter()` para que el filtro de regiones funcione sobre el gráfico!

{{< info "Recuerda que los inputs solamente estarán disponibles mientras ejecutes la aplicación, por lo que no puedes usarlos directamente para pruebas. Más adelante veremos cómo probar los inputs directamente!" >}}

**Recapitulando:**
- Hicimos un gráfico de prueba usando los mismos datos que la app
- Ubicamos el lugar donde va a ir el gráfico con `plotOutput()` en `ui`
- Calculamos el gráfico con `renderPlot()` en `server`
- Pusimos el código del gráfico dentro de `renderPlot()`
- Pusimos `input$region` dentro del código del gráfico para que se pueda cambiar el filtro interactivamente

Probemos la aplicación!

{{< video "shiny_grafico_1.mov" "320px" >}}

{{< detalles "Ver código de la app hasta ahora" >}}
```r
# global
library(shiny)
library(bslib)
library(readxl)
library(glue)
library(forcats)
library(ggplot2)

# cargar datos
datos <- read_excel("datos.xlsx")

# interfaz
ui <- page_fillable(
  # título
  h1("Campamentos en Chile"),

  # párrafo
  p(
    glue(
      "Aplicación Shiny para explorar 
         los datos de los {nrow(datos)} 
         campamentos registrados en Chile."
    )
  ),

  # párrafo markdown
  markdown(
    "Los **campamentos** son definidos por el 
           [Minvu](https://www.minvu.gob.cl/catastro-campamentos-2022/) 
           como _Asentamientos de ocho o más viviendas precarias que 
           habitan en posesión irregular un terreno, con carencia de 
           servicios básicos, agrupadas y contiguas._"
  ),

  # selector de regiones
  selectInput(
    inputId = "region",
    label = "Explorar regiones",
    choices = sort(unique(datos$region))
  ),

  # salida de texto de conteo de observaciones
  textOutput("casos_region"),

  # salida de gráfico
  plotOutput("grafico_barras_region")
)

# servidor
server <- function(input, output) {
  # conteo de casos filtrados por región
  output$casos_region <- renderText({
    conteo <- datos |>
      filter(region == input$region) |>
      nrow()

    glue("{input$region} tiene registrados {conteo} casos.")
  })

  # gráfico de barras
  output$grafico_barras_region <- renderPlot({
    # filtrar por región
    datos_region <- datos |>
      filter(region == input$region)

    # limitar cantidad de casos y ordenar
    datos_region_grafico <- datos_region |>
      slice_max(hogares, n = 6) |>
      mutate(nombre = fct_reorder(nombre, hogares))

    # gráfico
    datos_region_grafico |>
      ggplot() +
      aes(hogares, nombre) +
      geom_col(width = 0.7) +
      geom_text(
        aes(label = hogares),
        hjust = 1.3,
        color = "white",
        fontface = "bold"
      ) +
      scale_x_continuous(expand = 0) +
      theme_minimal(base_family = "Arial",
                    base_size = 13) +
      theme(
        axis.title.y = element_blank(),
        axis.text.y = element_text(face = "bold")
      )
  })
}

# ejecutar la app
shinyApp(ui, server)
```
{{< /detalles >}}


{{< etiqueta "visualización de datos" >}}



### Añadir un nuevo _input_

Dentro del gráfico que hicimos hay otro parámetro que podríamos entregar al usuario: cuando agregamos `slice_max()` limitamos el máximo de observaciones entregadas a `n = 6`, filtradas por las de mayor valor en la variable `hogares`. 

Hagamos que el valor del argumento `n` se cambie con un _slider_ o deslizador, para que las y los usuarios/as puedan elegir cuántas observaciones visualizar en el gráfico.

En la interfaz de la aplicación, pensemos dónde poner el _input_. Yo creo que 🤓☝🏼 un selector de este tipo debería ir debajo del gráfico, ya que es un ajuste que se haría _después_ de elegir la región, ya que no es tan relevante como para poner antes de la visualización misma.

Vamos al `ui` y agregamos un nuevo _input_, separado por comas de los elementos anteriores. En `sliderInput()`, como todos los inputs, empezamos poniendo el `inputId` (que es el nombre con el que llamaremos a su valor) y un `label` que es el título del selector. Los argumentos de este input son el mínimo y máximos, el valor que tiene seleccionado por defecto (`value`), y otros como `step` que son los saltos entre valores, y su ancho (`width`).

```r {hl_lines=["7-16"]}
# salida de texto de conteo de observaciones
  textOutput("casos_region"),

  # salida de gráfico
  plotOutput("grafico_barras_region"),

  # selector de observaciones máximas
  sliderInput(
    inputId = "maximo",
    label = "Cantidad de resultados",
    min = 3,
    max = 15,
    value = 8,
    step = 1,
    width = "100%"
  )
```

Debajo del gráfico va a aparecer el _slider_:

{{< imagen "app_shiny_slider.png" "400px" >}}

Ahora, conectar este **nuevo input** a cualquier paso de la app es simplemente reemplazar el valor del argumento de cualquier función de R por `input${nombre}`, en este caso `input$maximo`:


```r {hl_lines=["10-13"]}
server <- function(input, output) {
  ...
  # gráfico de barras
  output$grafico_barras_region <- renderPlot({
    # filtrar por región
    datos_region <- datos |>
      filter(region == input$region) # usando el input

    # limitar cantidad de casos y ordenar
    datos_region_grafico <- datos_region |>
      slice_max(hogares, n = input$maximo) |> # usando el input
      mutate(nombre = fct_reorder(nombre, hogares))

    # gráfico
    datos_region_grafico |>
      ggplot() +
      ...
  })
  ...
}
```

Entonces, el argumento `n` de `slice_max()` será por defecto 8 (lo que pusimos en el input), pero cambiará cuando muevas el _slider_!

{{< video "shiny_grafico_2.mov" "320px" >}}

{{< detalles "Ver código de la app hasta ahora" >}}
```r
# global
library(shiny)
library(bslib)
library(readxl)
library(glue)
library(forcats)
library(ggplot2)

# cargar datos
datos <- read_excel("datos.xlsx")

# interfaz
ui <- page_fillable(
  # título
  h1("Campamentos en Chile"),

  # párrafo
  p(
    glue(
      "Aplicación Shiny para explorar 
         los datos de los {nrow(datos)} 
         campamentos registrados en Chile."
    )
  ),

  # párrafo markdown
  markdown(
    "Los **campamentos** son definidos por el 
           [Minvu](https://www.minvu.gob.cl/catastro-campamentos-2022/) 
           como _Asentamientos de ocho o más viviendas precarias que 
           habitan en posesión irregular un terreno, con carencia de 
           servicios básicos, agrupadas y contiguas._"
  ),

  # selector de regiones
  selectInput(
    inputId = "region",
    label = "Explorar regiones",
    choices = sort(unique(datos$region))
  ),

  # salida de texto de conteo de observaciones
  textOutput("casos_region"),

  # salida de gráfico
  plotOutput("grafico_barras_region"),

  # selector de observaciones máximas
  sliderInput(
    inputId = "maximo",
    label = "Cantidad de resultados",
    min = 3,
    max = 15,
    value = 6,
    step = 1,
    width = "100%"
  )
)

# servidor
server <- function(input, output) {
  # conteo de casos filtrados por región
  output$casos_region <- renderText({
    conteo <- datos |>
      filter(region == input$region) |>
      nrow()

    glue("{input$region} tiene registrados {conteo} casos.")
  })

  # gráfico de barras
  output$grafico_barras_region <- renderPlot({
    # filtrar por región
    datos_region <- datos |>
      filter(region == input$region)

    # limitar cantidad de casos y ordenar
    datos_region_grafico <- datos_region |>
      slice_max(hogares, n = input$maximo) |>
      mutate(nombre = fct_reorder(nombre, hogares))

    # gráfico
    datos_region_grafico |>
      ggplot() +
      aes(hogares, nombre) +
      geom_col(width = 0.7) +
      geom_text(
        aes(label = hogares),
        hjust = 1.3,
        color = "white",
        fontface = "bold"
      ) +
      scale_x_continuous(expand = 0) +
      theme_minimal(base_family = "Arial", base_size = 13) +
      theme(
        axis.title.y = element_blank(),
        axis.text.y = element_text(face = "bold")
      )
  })
}

# ejecutar la app
shinyApp(ui, server)
```
{{< /detalles >}}


## Cómo funciona una app Shiny

{{< info "Esta sección del tutorial es teórica! Sirve para entender qué está pasando dentro de tu app. Puedes saltártela si gustas" >}}

En los pasos anteriores hicimos una app básica que usa datos para mostrar un selector, y al cambiar el selector se ejecuta código de R para entregar un resultado.

En otras palabras, tuvimos **código de R que se re-ejecutó automáticamente cada vez que cambió un elemento interactivo del cual dependía.**

Esta idea de que el código se ejecute cuando cambia algo se llama **reactividad**, y es la idea base detrás del funcionamiento de Shiny.

En términos resumidos, al ejecutar la aplicación por primera vez se crea la interfaz de la aplicación. Luego Shiny identifica todos los **outputs** que hay en la aplicación. Cada output tiene una **cadena de dependencias**; es decir, depende de otros elementos de la app, los que a su vez pueden depender de inputs.

Al iniciar la app, se identifica que existen outputs que requieren calcularse:

{{< imagen "shiny_reactividad_2.png" >}}
{{< bajada "Se identifican los outputs, y ahora hay que identificar sus dependencias (los resultados requeridos para calcular los outputs)" >}}

Pero al querer calcular los outputs se identifica que se requieren calcular otros elementos anteriores primero; es decir, los outputs dependen de otros resultados. En la mayoría de los casos estos son **objetos reactivos:**

{{< imagen "shiny_reactividad_3.png" >}}
{{< bajada "La cadena de dependencias va avanzando desde el final hacia el principio (el o los elementos sin dependencias)" >}}

Los objetos reactivos son código de R que son envueltos en funciones de Shiny que hacen que se re-calculen automáticamente cuando cambien sus dependencias. Son básicamente **pasos intermedios** entre los inputs o los datos y los outputs.

Entonces, estos pasos intermedios pueden requerir los **valores de inputs**, o bien, el resultado de **otros objetos reactivos**. En el caso de este ejemplo, los dos outputs dependen de un objeto reactivo, y éste depende de un input:

{{< imagen "shiny_reactividad_4.png" >}}
{{< bajada "La cadena de dependencias se identificó, y ahora puede ser calculada paso a paso" >}}

Con este paso se termina de determinar la cadena de dependencias; es decir, **Shiny identifica todos los pasos requeridos para calcular el output.** Entonces se empiezan a entregar los datos para iniciar los cálculos. Primero se identifican los inputs:

{{< imagen "shiny_reactividad_5.png" >}}
{{< bajada "El elemento sin dependencias se calcula y queda disponible para los pasos siguientes" >}}

Gracias a los inputs se pueden **calcular** los objetos reactivos o pasos intermedios:

{{< imagen "shiny_reactividad_6.png" >}}
{{< bajada "La cadena de dependencias se va calculando" >}}

Teniendo los objetos reactivos, los outputs ya cuentan con todo lo necesario, y pueden calcularse para **mostrarse en la app**.

{{< imagen "shiny_reactividad_7.png" >}}
{{< bajada "Finalmente se pueden calcular los outputs y mostrarse en la app" >}}

En este punto nuestra app ya está lista y mostrando los resultados! 

Cuando se calculan todos los pasos de la cadena, todo vuelve a un estado neutral, donde ya no necesita calcularse nada nuevo 😌

{{< imagen "shiny_reactividad_8.png" >}}
{{< bajada "Todo está calculado y en paz, la app está cargada y quieta" >}}

Pero si en la app **se cambia un input**, toda la cadena se marca como **_invalidada_**: los resultados que se tenían ya no son válidos, porque cambiaron elementos de la cadena! 

{{< imagen "shiny_reactividad_9.png" >}}
{{< bajada "Se detectó el cambio de un input!" >}}

Como la cadena se invalidó, Shiny nuevamente identifica que **los outputs deben calcularse**, y los marca como pendientes de cálculo, reiniciando el ciclo:

{{< imagen "shiny_reactividad_2.png" >}}
{{< bajada "Los outputs requieren recalcularse!" >}}

Los outputs requieren recalcularse, pero los outputs dependen de los reactivos, y los reactivos de otros reactivos o de inputs... entonces se navega hacia atrás por la cadena, marcando como pendiente de cálculo a los elementos requeridos por el output, hasta llegar a los inputs o a elementos sin ninguna dependencia, los cuales pueden calcularse y entregar sus resultados a los pasos siguientes. 

Podemos ver este proceso en vivo y en directo [usando el paquete `{reactlog}`](blog/shiny_reactlog/):

{{< video "/blog/shiny_reactlog/reactlog_shiny.mp4" >}}

{{< relacionada "blog/shiny_reactlog/" >}}


<!---
#### Outputs


### Temas

{{< relacionada "blog/shiny_temas" >}}



* mostrar u ocultar elementos según condiciones

{{< relacionada "blog/shiny_ocultar" >}}


* código condicional desde inputs





{{< relacionada "blog/shiny_optimizar" >}}




--->

{{< aviso "Este post está en construcción! Fastídiame para que lo termine [comentando en este post de LinkedIn](https://www.linkedin.com/posts/bastianolea_basti%C3%A1n-olea-herrera-activity-7458116493420130304-wWUA)" >}}

{{< etiqueta "shiny" >}}

{{< relacionada "clases/spatiallab_shiny_2/" "Diapositivas y código de mi curso de Shiny" >}}