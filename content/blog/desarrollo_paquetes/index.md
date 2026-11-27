---
title: Desarrollo de paquetes con R
subtitle: Crea tus propias herramientas para trabajar con datos en R y compártelas!
author: Bastián Olea Herrera
date: '2026-08-25'
modified: '2026-11-17'
categories:
  - Tutoriales
tags:
  - paquetes
  - funciones
  - avanzado
links:
  - icon: registered
    icon_pack: fas
    name: usethis
    url: https://usethis.r-lib.org
  - icon: registered
    icon_pack: fas
    name: devtools
    url: https://devtools.r-lib.org
excerpt: "En este tutorial veremos cómo crear tu propio paquete de R, para agrupar funciones y datos en un software que puedes usar a través de varios proyectos y compartir con otras personas. El desarrollo de paquetes es en cierto modo el objetivo final del lenguaje R, donde puedes cristalizar tus ideas, herramientas y procesos en su propio programa, pasando de ser un simple usuari@ a ser parte activa de la construcción de la comunidad de R por medio de tus contribuciones!"
---

En este tutorial veremos cómo crear tu propio paquete de R, para agrupar funciones y datos en un software que puedes usar a través de varios proyectos y compartir con otras personas. 

{{< aviso "Este es un tutorial avanzado de R! Recomiendo seguirlo sólo si ya tienes experiencia. También está en **constante actualización** a medida que aprendo más y necesito anotar mis aprendizajes." >}}

{{< indice >}}

## Introducción

El desarrollo de paquetes es en cierto modo uno de los _objetivos finales_ del lenguaje R, donde puedes cristalizar tus ideas, herramientas y procesos en tu propio programa. De alguna forma, esto te convierte desde ser un simple usuari@ de R a ser parte activa de la construcción de la comunidad de R por medio de tus contribuciones!

Si llevas un tiempo programando en R, seguramente te ha pasado que tienes **funciones que copias y pegas** de un proyecto a otro, o un script `funciones.R` que cargas con `source()` en todos lados. Cada vez que mejoras una de esas funciones, tienes que acordarte de actualizarla en todos los proyectos donde la usas, y si alguien más quiere usarla, tienes que mandarle el script y explicarle cómo funciona. Un paquete resuelve todos estos problemas: tus funciones quedan en **un solo lugar**, se instalan con una línea de código, vienen con su **documentación** (la que aparece al escribir `?función`), y tienen **pruebas** que aseguran que siguen funcionando a medida que las vas modificando.

Además, un paquete no tiene por qué ser algo gigante ni ambicioso: puede tener dos o tres funciones que te sirvan para tu trabajo diario, o un conjunto de datos que uses frecuentemente. Por ejemplo, yo desarrollé [`{territorial}`](/blog/territorial/) para limpiar nombres de comunas y regiones de Chile, [`{rutera}`](/blog/rutera/) para validar RUTs, y [`{poblador}`](/blog/poblador/) para agregar datos de población a tablas de comunas, porque eran tareas que repetía constantemente en distintos proyectos.

### Herramientas para desarrollar paquetes

Siempre sentí que desarrollar un paquete era muy difícil, pero la verdad R tiene muchas herramientas para hacer este proceso lo más sencillo posible, principalmente [el paquete `usethis`](https://usethis.r-lib.org). Este paquete automatiza la creación de todos los archivos y carpetas que necesita un paquete, así que en vez de tener que aprender de memoria dónde va cada cosa, simplemente ejecutamos una función que lo hace por nosotros/as.

El otro paquete fundamental es [`devtools`](https://devtools.r-lib.org), que nos entrega las funciones para **cargar, documentar, probar y revisar** el paquete mientras lo desarrollamos.

Para desarrollar un paquete de R naturalmente hay que **entender la estructura** de un paquete, y luego familiarizarse con el **proceso de desarrollo** del mismo.


### Estructura de un paquete de R

Un paquete de R es, en el fondo, una **carpeta con una estructura específica** de archivos y subcarpetas. R espera encontrar ciertas cosas en ciertos lugares, y si las encuentra, puede instalar la carpeta como un paquete.

<div style="text-align: center;">
  <div class="contenedor-iconos">

  <div>
    <i class='fas fa-folder' style='font-size: 200%; vertical-align: middle;'></i>
    <span style="padding: 4px; font-weight: bold;">paquete</span>
  </div>

<div class="icono-cuadro" style="flex-direction: column; gap: 16px; text-align: left;">
  
  <div style="display: flex; align-items: center; gap: 16px;">
    <div class="icono-v" style="min-width: 110px;">
      <i class='fas fa-file-alt'></i>
      <span>DESCRIPTION</span>
    </div>
    <span>Metadatos y dependencias del paquete: nombre, descripción, versión, autoría, licencia y dependencias.</span>
  </div>
  
  <div style="display: flex; align-items: center; gap: 16px;">
    <div class="icono-v" style="min-width: 110px;">
      <i class='fas fa-file-code'></i>
      <span>README.md</span>
    </div>
    <span>Presentación del paquete, con instrucciones de instalación, uso básico y ejemplos.</span>
  </div>
  
  <div style="display: flex; align-items: center; gap: 16px;">
    <div class="icono-v" style="min-width: 110px;">
      <i class='fas fa-folder'></i>
      <span>R/</span>
    </div>
    <span>Carpeta con scripts de las funciones del paquete.</span>
  </div>
  
  <div style="display: flex; align-items: center; gap: 16px;">
    <div class="icono-v" style="min-width: 110px;">
      <i class='fas fa-folder'></i>
      <span>tests/</span>
    </div>
    <span>Carpeta con pruebas unitarias, creada con <code>usethis::use_testthat()</code></span>
  </div>
  
  <div style="display: flex; align-items: center; gap: 16px;">
    <div class="icono-v" style="min-width: 110px;">
      <i class='fas fa-folder'></i>
      <span>data/</span>
    </div>
    <span>Carpeta con datos incluidos en el paquete, creados en scripts dentro de la carpeta <code>data-raw</code></span>
  </div>
  
  <div style="display: flex; align-items: center; gap: 16px;">
    <div class="icono-v" style="min-width: 110px;">
      <i class='fas fa-folder'></i>
      <span>vignettes/</span>
    </div>
    <span>Tutoriales largos sobre cómo usar el paquete, explicaciones de conceptos o temas, y ejemplos de uso. Se crean con <code>usethis::use_vignette()</code></span>
  </div>
  
</div>
</div>
</div>

Hay otros archivos indispensables, como `NAMESPACE` y `man/`, pero se generan automáticamente al construir el paquete.


### Ciclo de desarrollo de un paquete de R

Luego de haber levantado los **cimientos** del paquete, [el desarrollo es una especie de ciclo](#iteración) en el que vamos repitiendo la creación de funciones, documentación, creación de pruebas, chequeo del paquete, y repetir.

En detalle, el ciclo de desarrollo de un paquete es así:

1. **Creamos una función** nueva con `usethis::use_r()`
    * Se crea un script nuevo en `R/funcion.R` y se abre en RStudio
    * Programamos lo básico de la función en ese script
2. **Documentamos la función** con [comentarios de `{roxygen2}`](https://roxygen2.r-lib.org) directamente encima del script de la función que creamos
3. Creamos **pruebas unitarias** para la función creada con `usethis::use_test()`
    * Ponemos a prueba la función y especificamos qué debería retornar, para asegurarnos ahora y en el futuro de que funciona correctamente
4. **Chequeamos** que todo esté bien en el paquete con `devtools::check()` y `devtools::test()`

Veremos todos estos pasos y más en este tutorial!

## Pasos previos

Antes de iniciar el desarrollo de un paquete, necesitamos confirmar que tenemos los paquetes necesarios. Como mínimo, serían `{devtools}`, `{usethis}` y `{pak}`.

```r
install.packages(c("devtools", "usethis", "pak"))
```

Además de los paquetes, necesitamos que nuestro computador tenga las **herramientas de compilación** que R usa para construir paquetes. En Windows esto corresponde a [Rtools](https://cran.r-project.org/bin/windows/Rtools/), y en Mac a las _Command Line Tools_ de Xcode (que se instalan ejecutando `xcode-select --install` en la Terminal). En Linux usualmente ya vienen instaladas.

Para confirmar que todo esté en orden, `{devtools}` nos ofrece dos funciones de diagnóstico:

```r
# revisar si están las herramientas de compilación
devtools::has_devel()

# revisar el estado general del entorno de desarrollo
devtools::dev_sitrep()
```

También necesitaremos [tener configurado y funcionando Git en nuestra sesión de R](/blog/tutorial_github/), para poder ir respaldando las versiones del paquete, y hacerlo disponible e instalable en internet. Revisamos esto con la siguiente función:

```r
usethis::git_sitrep()
```

{{< relacionada "/blog/tutorial_github/" >}}



## Creación de un paquete de R

{{< cuadro "Para empezar, veremos lo básico de un paquete de R. En resumen, necesitas [crear el paquete](#crear-paquete), crear una [documentación mínima](#documentar-funciones), y si quieres compartirlo con otras personas, [publicar el paquete en GitHub](#repositorio-git)." >}}

{{< icono-lateral "box-open" >}}

Lo primero es decidir el **nombre** del paquete. La función `pak::pkg_name_check()` revisa si el nombre es válido, si está disponible en CRAN y Bioconductor, y además busca si la palabra tiene algún significado que pueda resultar problemático:

```r
pak::pkg_name_check("nombre")
```

<a id="crear-paquete"></a>Luego **creamos el paquete** con `create_package()`, indicando la ruta donde queremos crear la carpeta del paquete:

```r
usethis::create_package("nombre")
```

Esta función crea la carpeta del paquete con su estructura mínima, la convierte en un [proyecto de RStudio](/blog/r_introduccion/proyectos/), y abre el proyecto en una nueva sesión. A partir de ahora, todo el desarrollo lo haremos desde este proyecto.

<a id="revisar-paquete"></a>Luego podemos verificar que todo esté bien con `devtools::check()`, procurando hacernos el hábito de hacer este tipo de revisiones:

```r
devtools::check()
```

Esta función te va entregando avisos sobre cositas que debemos ir resolviendo. También se puede hacer con el botón _Check_ del panel _Build_ de RStudio.


### Descripción del paquete

El archivo `DESCRIPTION` contiene los **metadatos** del paquete. Al crear el paquete, este archivo viene con textos que tenemos que reemplazar.

El `DESCRIPTION` se ve más o menos así:

```
Package: territorial
Title: Funciones para trabajar con datos comunales y regionales de Chile
Version: 0.9.1
Authors@R: 
    person("Bastián", "Olea Herrera", , "correo@ejemplo.com", role = c("aut", "cre"))
Description: Funciones para limpiar y validar nombres de comunas 
    y regiones de Chile, y datos con información territorial.
License: GPL (>= 3)
Language: es
Encoding: UTF-8
```

Más adelante, cuando [agreguemos dependencias](#dependencias), este archivo se irá completando automáticamente.

### Documentos mínimos

#### Archivo _léeme_

Todo paquete debe tener un **README**, que es la presentación del paquete: explica para qué sirve, cómo instalarlo y muestra algunos ejemplos de uso. 

```r
usethis::use_readme_rmd()
```

{{< icono-lateral "file-text" >}}

Este archivo es lo primero que se ve al entrar al repositorio del paquete en GitHub, y también será la página de inicio del [sitio de documentación del paquete](#sitio-web). 

Esta función crea un archivo `README.Rmd`, que es un documento R Markdown (también podría ser Quarto `.qmd`) donde podemos escribir texto e  incluir código de R que se ejecuta, para mostrar ejemplos reales del funcionamiento del paquete. Al _renderizar_ este documento se genera el `README.md`, que es el archivo que se muestra.

#### Licencia

Las licencias establecen las condiciones bajo las cuales otras personas pueden usar, modificar y distribuir nuestro código, así que son clave para su gobernanza.

```r
usethis::use_mit_license()
# usethis::use_gpl3_license()
```

- La [licencia MIT](https://choosealicense.com/licenses/mit/) es una de las más permisivas y más usadas en el ecosistema R: permite que cualquier persona use tu código para lo que quiera, siempre que mantenga el aviso de autoría. 
- La [licencia GPL-3](https://choosealicense.com/licenses/gpl-3.0/), en cambio, exige que cualquier software que use tu código también sea de código abierto. Es más conocida como _copyleft_ porque busca incentivar que los proyectos derivados sean de código abierto.

Cualquiera de las dos funciones crea los archivos de licencia y actualiza el campo `License` del archivo `DESCRIPTION`.


#### Registro de cambios

Opcionalmente, podemos crear un archivo de texto para ir registrando los cambios que vamos haciendo en cada versión del paquete:

```r
usethis::use_news_md()
```
No es tan importante, pero es entretenido y te ayuda a organizar mentalmente el trabajo que has hecho.

### Repositorio Git

En este punto se recomienda empezar a [respaldar tu código con Git](/blog/tutorial_github/). Primero creamos el repositorio local:

```r
# crear repositorio local
usethis::use_git()
```

{{< icono-lateral "fab fa-git" >}}

Cada vez que hagas un cambio significativo, lo podrás ir guardando en versiones nuevas (_commits_), y así mantendrás un **control de versiones** que te permitirá explorar estados pasados, deshacer cambios en el tiempo, ir registrando cambios nuevos al código, y más.

{{< relacionada "blog/git_comandos/" >}}

{{< icono-lateral "fab fa-github" >}}

Pero el uso principal que le daremos al repositorio de control de cambios de Git es la posibilidad de mantener un **repositorio remoto** que guarde tus versiones en internet por medio de **GitHub**. GitHub es la página que usa la mayoría de desarrolladores/as para subir su software, respaldarlo en la nube y hacerlo visible para el mundo. De este modo, otras personas podrán navegar tu código, clonarlo en sus computadores para ofrecer mejoras o funcionalidades nuevas, e instalar el paquete en sus computadores.

```r
# crear repositorio remoto
usethis::use_github()
```

Esta función crea el repositorio en tu cuenta de GitHub, sube el código, y agrega los enlaces al repositorio en los campos `URL` y `BugReports` del archivo `DESCRIPTION`. Desde ahí en adelante podrías ir haciendo `git push` para que los _commits_ que hayas hecho queden disponibles online.

{{< info "Publicar tu paquete en Git es clave para que otras personas [puedan instalarlo después](#instalación-desde-internet)!" >}}

## Instalación del paquete

Aunque el paquete aún no tenga funciones, ya es instalable. Para instalarlo en nuestro computador usamos:

```r
pak::local_install()
```

O bien, presionamos el botón _Install_ del panel _Build_ de RStudio.

Una vez instalado, podemos cargarlo con `library(nombre)` desde **cualquier otro proyecto** de R en nuestro computador. Así podemos probarlo! 

{{< info "Mientras estamos desarrollando no necesitamos instalar el paquete a cada rato: para eso usaremos `devtools::load_all()`, como veremos [más adelante](#probar-las-funciones)." >}}

### Instalación desde internet

Si subiste tu paquete a GitHub, **cualquier persona puede instalarlo** indicando tu nombre de usuario/a y el nombre del repositorio:

```r
pak::pak("usuario/nombre")
```

Por ejemplo, para instalar [mi paquete `territorial`](/blog/territorial/):

```r
pak::pak("bastianolea/territorial")
``` 

Pero **antes** de invitar a otras personas a instalar tu paquete, tienes que asegurarte de que tu paquete [funciona bien](#revisiones), que tiene [documentación que explique su uso](#documentación), y que [pasa todas sus pruebas](#pruebas-unitarias)


----

Hasta ahora hemos visto los **fundamentos** de un paquete de R. Ahora veremos cómo ir dándole forma!


## Crear funciones

{{< icono-lateral "fab fa-r-project" >}}

En la mayoría de los casos, las funciones son lo principal de un paquete: es la forma de **crear y compartir nuevas herramientas** para procesamiento y análisis de datos!

Creamos una función con `use_r()`:

```r
usethis::use_r("sumar")
```

Esto crea el script `R/sumar.R` y lo abre. En este script [escribimos nuestra función](/blog/r_introduccion/r_intermedio/#crear-funciones) de la misma forma en que lo haríamos en cualquier script de R. Por ejemplo, una función sencilla para sumar dos valores:

```r
sumar <- function(x, y) {
  message(
    paste("suma entre", x, "y", y)
  )
  x + y
}
```

{{< relacionada "/blog/r_introduccion/r_intermedio/" >}}

Algunas diferencias al crear funciones para un paquete:

- Si necesitas una función de un paquete, **no se usa `library()`**, sino que se llaman usando _dos_ dos puntos (`::`) así: `paquete::función()`, por ejemplo `stringr::str_squish()`. Además, si tu paquete depende de otros paquetes, debemos [explicitar las dependencias](#dependencias).
- Los scripts de `R/` **sólo deben contener definiciones de funciones**, sin código suelto que cargue datos, cree gráficos o modifique opciones.
- Si las funciones dependen de datos, tienes que [incluírlos en el paquete](#incluir-datos) para que estén disponibles.
- Todas las funciones [deben ser documentadas](#documentación) para que cualquier persona pueda entender cómo se usan.


### Probar las funciones

{{< icono-lateral "arrows-rotate" >}}

Al crear una función, la podemos probar con `devtools::load_all()`. Esta función **simula la instalación y carga del paquete** en la sesión actual. Cada vez que cambiamos algo en una función (siempre y cuando la función quede _completa_, en el sentido de que es _funcional_) ejecutamos `load_all()` y luego probamos la función en la consola:

```r
devtools::load_all()

sumar(2, 5)
```
```
> suma entre 2 y 5
[1] 7
```


### Documentar funciones

{{< icono-lateral "file-invoice" >}}

En la parte superior del script de cada función agregamos su documentación. Esto es su **nombre visible** y su **descripción**, como mínimo, y otros aspectos que enseñan a usar la función. Probablemente has visto documentación de funciones antes al usar `?función` en la consola o en el menú _Help_ de RStudio.

La documentación de funciones se escriben con [`roxygen2`](https://roxygen2.r-lib.org), un estándar en la comunidad de R.

A grandes rasgos, la documentación de la [función de ejemplo que vimos más arriba](#crear-funciones) se vería así:

```r
#' Sumar dos valores
#'
#' Muestra un mensaje con los valores y devuelve su suma.
#'
#' @param x Primer valor numérico.
#' @param y Segundo valor numérico.
#'
#' @return Resultado de la suma de `x` e `y`.
#' @seealso Funciones [restar()] y [multiplicar()] para otras operaciones.
#' @export
#'
#' @examples
#' sumar(2, 5)
```

Podemos ayudarnos si presionamos dentro de la función y en el menú _Code_ elegimos _Insert Roxygen Skeleton_, o si seleccionamos el código y usamod un [agente de IA como `gander`](/blog/gander/) para que escriba la documentación por nosotres.

### Dependencias

{{< icono-lateral "cubes" >}}

Si tus funciones usan funciones de **otros paquetes**, tenemos que declararlos como dependencias, para que se instalen automáticamente cuando alguien instale nuestro paquete. De lo contrario no funcionarían!

Declaramos dependencias con `usethis::use_package()`:

```r
# agregar dependencia a un paquete
usethis::use_package("dplyr")
usethis::use_package("cli")
usethis::use_package("stringr")
```

Esta función agrega automáticamente el paquete a la sección `Imports` del archivo `DESCRIPTION`.

{{< info "Cada dependencia que agregas es un paquete más que tus usuarios/as tienen que instalar, y un posible punto de falla si ese paquete cambia en el futuro. Por eso conviene mantener la cantidad de dependencias al mínimo." >}}


## Incluir datos

{{< icono-lateral "database" >}}

Los paquetes también pueden contener **conjuntos de datos**, que quedan disponibles para quien instale el paquete. Esto es útil para compartir datos que se usan frecuentemente, para crear tablas de datos necesarias para las funciones, para entregar datos de ejemplo para la documentación, o incluso para crear paquetes que sean exclusivamente de datos.

```r
# crear datos del paquete
usethis::use_data_raw("territorios")
```

Esta función crea el script `data-raw/territorios.R`. En este script escribimos el código que obtiene, limpia y prepara los datos, igual que en un script de análisis común. La carpeta `data-raw/` no se incluye en el paquete instalado, pero queda guardada para que siempre sepamos cómo se crearon los datos. El script debe terminar con `use_data()`, que guarda el objeto en la carpeta `data/`:

```r
library(dplyr)
library(readr)

territorios <- read_csv("data-raw/territorios.csv") |>
  select(codigo_comuna, comuna, region) |>
  arrange(codigo_comuna)

usethis::use_data(territorios, overwrite = TRUE)
```

Luego de ejecutar el script, los datos quedan guardados en `data/territorios.rda`, y cualquier persona que cargue el paquete podrá acceder a ellos directamente escribiendo `territorios`.

### Documentar datos

Los datos también tienen que **documentarse**. Para esto, creamos un script `R/data.R` (con `usethis::use_r("data")`) y describimos los datos con comentarios de `roxygen2`. Por ejemplo:

```r
#' Comunas y regiones de Chile
#'
#' Tabla con las comunas de Chile y la región a la que pertenecen.
#'
#' @format Un _dataframe_ con 346 filas y 3 columnas:
#' \describe{
#'   \item{codigo_comuna}{Código único territorial de la comuna}
#'   \item{nombre_comuna}{Nombre de la comuna}
#'   \item{codigo_region}{Código único territorial de la región}
#'   \item{nombre_region}{Nombre de la región}
#' }
#' @seealso [comunas()], [regiones()] y [codigos_comunas()] para vectores derivados de esta tabla, y [contextualizar()] para agregar sus columnas a tus datos.
#' @source <https://www.subdere.gov.cl>
"territorios"
```

## Revisiones

{{< icono-lateral "heart-pulse" >}}

Como vimos [al crear el paquete](#revisar-paquete), `devtools::check()` ejecuta el `R CMD check`: más de 50 revisiones automáticas que verifican que el paquete esté bien construido.

El objetivo es llegar a 0 errores, e idealmente a 0 _warnings_ y 0 notas. Recomiendo ejecutarlo seguido, por si las moscas, porque es mucho más fácil corregir un problema justo después de introducirlo que resolver diez problemas acumulados.

### Pruebas unitarias

{{< icono-lateral "list-check" >}}

Las pruebas unitarias son pequeños fragmentos de código que **verifican que una función entregue el resultado esperado**. 

La idea es que, en vez de probar una vez que la función funciona, que las pruebas queden guardadas y se ejecuten automáticamente y con frecuencia. De esta forma, cada vez que apliques un cambio, se confirma que no hemos echado a perder nada más, y confirmamos que todo funciona. 

{{< icono "circle-check" >}} Muy recomendado para reducir la ansiedad!

Para crear pruebas usamos el [paquete `testthat`](/blog/validacion_datos/#validación-con-testthat). Veamos cómo agregarle pruebas a la función `sumar()` que [creamos más arriba](#crear-funciones).

{{< paso "1" "Preparar el paquete para usar pruebas." >}}

```r
usethis::use_testthat()
```

Esta función se ejecuta una sola vez en el paquete: crea la carpeta `tests/testthat/` y agrega `{testthat}` al archivo `DESCRIPTION`.

{{< paso "2" "Crear el archivo de pruebas de la función." >}}

```r
usethis::use_test("sumar")
```

Se crea el archivo `tests/testthat/test-sumar.R`, donde irán las pruebas de las funciones de `R/sumar.R`. Si ejecutamos `use_test()` sin argumentos mientras tenemos abierto el script de una función, se crea (o se abre) automáticamente su archivo de pruebas correspondiente.

El archivo viene con una prueba de ejemplo:

```r
test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})
```

Cada prueba se define con `test_that()`, con una descripción de lo que se está probando, y una o más **expectativas** que comparan un resultado con lo que debería entregar.

{{< paso "3" "Escribir las pruebas." >}}

Reemplazamos la prueba de ejemplo por pruebas de nuestra función. Pensamos en qué debería hacer `sumar()`: entregar la suma correcta, mostrar un mensaje con los valores, y fallar si le damos algo que no se puede sumar:

```r
test_that("sumar() entrega la suma de dos números", {
  expect_equal(sumar(2, 5), 7)
  expect_equal(sumar(-1, 1), 0)
})

test_that("sumar() muestra un mensaje con los valores", {
  expect_message(sumar(2, 5), "suma entre 2 y 5")
})

test_that("sumar() da error si recibe texto", {
  expect_error(sumar("dos", 5))
})
```

La función `expect_equal()` compara el resultado con el valor esperado, `expect_message()` confirma que la función muestre un mensaje, y `expect_error()` confirma que la función entregue un error cuando corresponde. Existen muchas otras expectativas, como `expect_true()` para confirmar que algo sea verdadero, o `expect_length()` para revisar el largo de un resultado.

{{< paso "4" "Ejecutar las pruebas." >}}

```r
devtools::test()
```

Se ejecutan todas las pruebas del paquete, y obtenemos un resumen de las que pasaron y las que fallaron:

```
ℹ Testing nombre
✔ | F W  S  OK | Context
✔ |          4 | sumar

══ Results ═══════════════════════════════════════════════════════
[ FAIL 0 | WARN 0 | SKIP 0 | PASS 4 ]
```

Ahora imaginemos que en el futuro modificamos `sumar()` y por error escribimos `x - y` en vez de `x + y`. Al volver a ejecutar las pruebas, nos enteramos inmediatamente de qué se rompió y dónde:

```
── Failure (test-sumar.R:2:3): sumar() entrega la suma de dos números ──
Expected `sumar(2, 5)` to equal 7.
Differences:
1/1 mismatches
[1] -3 - 7 == -10

[ FAIL 1 | WARN 0 | SKIP 0 | PASS 3 ]
```

Las pruebas también se ejecutan como parte de `devtools::check()`, así que cada vez que revisemos el paquete vamos a confirmar que todas las funciones sigan haciendo lo que deben.

{{< info "El código de ejemplo que pongamos en la documentación de cada función en `@examples` también se ejecuta durante `check()`, así que también sirve para confirmar que la función funcione!" >}}

{{< relacionada "/blog/validacion_datos/" >}}


#### Cobertura de pruebas unitarias

{{< icono-lateral "check-double" >}}

Luego de [escribir pruebas unitarias para validar el código](/blog/validacion_datos/#validación-con-testthat), podemos confirmar si todo el código está _cubierto_ por las pruebas. Con esto nos referimos al **porcentaje de líneas de código revisadas por las pruebas**, ya que si las pruebas no cubren todo el código, significa que podría estar echándose a perder sin que nos demos cuenta.

La cobertura sirve para **encontrar qué partes del paquete aún no tienen pruebas**, y así ir mejorándolas de a poco. Usamos el paquete `{covr}` para revisar la cobertura:

```r
usethis::use_package("covr", type = "Suggests")
```

Luego calculamos la cobertura con `package_coverage()`, que ejecuta las pruebas de `tests/testthat/` y registra qué líneas de código se ejecutaron:

```r
# calcula cobertura ejecutando las pruebas de tests/testthat
cobertura <- covr::package_coverage()
```

Con `percent_coverage()` obtenemos el **porcentaje total de cobertura**, y si imprimimos el objeto, aparece el porcentaje de cada archivo, de menor a mayor cobertura:

```
territorial Coverage: 85.54%
R/contextualizar.R: 90.41%
R/agregar_clasificacion.R: 91.43%
R/acortar_regiones.R: 91.89%
R/contar_comunas.R: 92.11%
R/validar_comunas.R: 97.25%
R/abreviar_comunas.R: 97.50%
R/agregar_macrozona.R: 97.50%
R/preposicion_region.R: 97.87%
R/limpiar_comunas.R: 99.58%
R/limpiar_regiones.R: 99.59%
R/actualizar_codigo_comuna.R: 100.00%
R/agregar_orden_region.R: 100.00%
R/as_capital_regional.R: 100.00%
```

Con el ejemplo anterior, nos damos cuenta que a la función `R/contextualizar.R` le falta cobertura; es decir, tiene código que no se pone a prueba nunca!

Para saber exactamente qué falta probar, `zero_coverage(cobertura)` entrega las **líneas sin cobertura**, que no se ejecutaron en ninguna prueba, indicando el archivo y el número de línea. Además, `report(cobertura)` crea un reporte HTML interactivo para revisar el código línea por línea.

Las líneas sin cobertura muchas veces son los casos extremos o los errores que la función debería entregar, que son los que más cuesta recordar al escribir pruebas!

Se recomienda automatizar el cálculo de cobertura para que se ejecute en GitHub cada vez que subamos cambios por medio del servicio [Codecov](https://about.codecov.io):

```r
usethis::use_github_action("test-coverage")
```


## Documentación

{{< icono-lateral "book-open" >}}

Ya vimos cómo escribir la documentación de [las funciones](#documentación) y de [los datos](#documentar-datos) con comentarios de `roxygen2`. Pero esos comentarios por sí solos no hacen nada: hay que convertirlos en las páginas de ayuda del paquete con `document()`:

```r
devtools::document()
```

La función `document()` lee los comentarios de `roxygen2`, crea los archivos de ayuda en la carpeta `man/`, y actualiza el archivo `NAMESPACE` con las funciones exportadas (es decir, las que puede usar qiuen instale el paquete). 

Después de ejecutar `document()`, si cargamos el paquete con `load_all()` podremos ver la ayuda de nuestra función con `?sumar`.

{{< info "Sólo las funciones con la etiqueta **`@export`** en su documentación quedan disponibles para quienes carguen el paquete. Las demás quedan como funciones internas, que puedes usar dentro de tu paquete pero que no estarán disponibles para tus usuarios/as." >}}


### Viñetas

{{< icono-lateral "bookmark" >}}

Las **viñetas** (_vignettes_) son documentos más extensos, tipo tutorial, que explican cómo usar el paquete en su conjunto, combinando varias funciones para resolver un problema.

```r
usethis::use_vignette("territorial.qmd")
```

La función `use_vignette()` crea el documento en la carpeta `vignettes/`, y puede ser un documento R Markdown o Quarto (`.qmd`). 

Puedes usarlas para escribir en extenso usos del paquete. También sirven como confirmación de que el paquete funciona para casos de uso más complejos que los usos independientes revisados en las [pruebas unitarias](#pruebas-unitarias).[^1]

[^1]: Gracias [Maëlle Salmon](https://masalmon.eu) por la idea!


{{< info "Si la viñeta tiene el **mismo nombre que el paquete**, como `territorial.qmd` para el paquete `{territorial}`, se convierte en la **viñeta principal** del paquete, y en el sitio web de documentación aparecerá como la sección _Primeros pasos_." >}}


### Sitio web

{{< icono-lateral "book-bookmark" >}}

Gracias a `{pkgdown}` podemos obtener sitios web estandarizados para presentar nuestros paquetes y su documentación al mundo. 

Lo mejor es que no hay que hacer casi nada "extra" para tener el sitio bonito y funcionando! Si te diste el trabajo de [documentar tus funciones](#documentar-funciones) y [crear un buen `README.md`](#archivo-léeme), ya tendrás un sitio aceptable!


```r
pak::local_install() # instalar el propio paquete

# sitio del paquete
# usethis::use_pkgdown()
# usethis::use_pkgdown_github_pages()

# reconstruir sitio
pkgdown::build_site()
# usethis::use_github_pages()
# poner enlace en _pkgdown.yml y description
# usethis::use_github_action("pkgdown")
# cuando se haga push se construirá el sitio
```

Antes de construir el sitio, conviene actualizar el `README.md`. Como el `README.Rmd` probablemente usa funciones de nuestro paquete en sus ejemplos, primero instalamos la versión más reciente del paquete con `pak::local_install()`, y luego _kniteamos_ el README para que el código se ejecute con la versión actualizada. Una alternativa es `devtools::build_readme()`, que hace ambas cosas en un solo paso.

Para crear el sitio tenemos dos caminos:

- **Construirlo localmente**: `usethis::use_pkgdown()` crea el archivo de configuración `_pkgdown.yml`, y luego `pkgdown::build_site()` construye el sitio en la carpeta `docs/` y lo abre en el navegador. Esto es útil para previsualizar cómo va quedando.
- **Publicarlo en GitHub Pages**: `usethis::use_pkgdown_github_pages()` hace todo lo necesario para que el sitio se publique gratis en internet: configura `{pkgdown}`, activa GitHub Pages en el repositorio, agrega una GitHub Action que reconstruye el sitio, y pone el enlace del sitio en `_pkgdown.yml` y en el archivo `DESCRIPTION`.

Con la segunda opción, cada vez que hagamos _push_ de cambios a GitHub, el sitio se va a reconstruir automáticamente, así que la documentación siempre estará al día con el código.

{{< relacionada "blog/quarto_reportes/" >}}


## Iteración

Luego de haberte familiarizado con el proceso de desarrollo, te darás cuenta que hay un ciclo bien claro para ir progresando:


<div class="cuadros-verticales">

  <div class="cuadro-vertical-oscuro">
  <p>Crear una función</p>
  <code>
  use_r("función")
  </code>
  </div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical">
  Escribir/modificar la función
  </div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical-oscuro">
  <p>Recargar el paquete</p>
  <code>
  devtools::load_all()
  </code>
  </div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical">
  Probar la función
  </div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical-oscuro">
  <p>Crear pruebas para casos de uso</p>
  <code>
  usethis::use_test("función")<br>
  devtools::test()
  </code>
  </div>
  
</div>


…y repetir!

Cada cierto tiempo, cuando tengamos avances relevantes, documentamos con `devtools::document()`, revisamos con `devtools::check()`, y si todo está bien, guardamos los cambios en Git (_commit_) y los subimos a GitHub (_push_).

## Recomendaciones

Recomiendo editar tu archivo `.Rprofile` local con `usethis::edit_r_profile()` y agregarle el siguiente código para que los paquetes indispensables para el desarrollo se carguen solitos al iniciar tu sesión de R:

```r
if (interactive()) {
  library(devtools)
  library(usethis)
  library(testthat)

  # options(.gander_chat = ellmer::chat_claude()) # opcional, si usas {gander}
}
```


### Avanzado

#### Sitio web en español

Cambia el idioma del sitio `pkgdown` a español agregando lo siguiente a `.github/workflows/pkgdown.yaml`:

```yaml
- name: Set locale to Spanish
  run: |
    sudo locale-gen es_ES.UTF-8
    sudo update-locale LANG=es_ES.UTF-8
  shell: bash

- name: Build site
  run: pkgdown::build_site_github_pages(new_process = FALSE, install = TRUE, quiet = FALSE)
  shell: Rscript {0}
  env:
    LANG: es_ES.UTF-8
```


## Recursos

- Libro [R Packages](https://r-pkgs.org), de Hadley Wickham y Jennifer Bryan, la referencia principal sobre desarrollo de paquetes.
- Libro [Paquetes de rOpenSci: Desarrollo, mantenimiento y revisión por pares](https://devguide.ropensci.org/es/index.es.html), con buenas prácticas para desarrollar paquetes de calidad.
- Documentación de [`usethis`](https://usethis.r-lib.org), [`devtools`](https://devtools.r-lib.org), [`roxygen2`](https://roxygen2.r-lib.org), [`testthat`](https://testthat.r-lib.org) y [`pkgdown`](https://pkgdown.r-lib.org).


{{< etiqueta "paquetes" >}}

{{< etiqueta "avanzado" >}}


{{< cafecito >}}
