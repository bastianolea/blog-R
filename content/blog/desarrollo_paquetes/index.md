---
title: Desarrollo de paquetes con R
subtitle: Crea tus propias herramientas para trabajar con datos en R y compártelas!
author: Bastián Olea Herrera
date: '2026-08-25'
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

{{< aviso "Este es un tutorial avanzado de R! Recomiendo seguirlo sólo si ya tienes experiencia." >}}

## Introducción

El desarrollo de paquetes es en cierto modo uno de los _objetivos finales_ del lenguaje R, donde puedes cristalizar tus ideas, herramientas y procesos en tu propio programa. De alguna forma, esto te convierte desde ser un simple usuari@ de R a ser parte activa de la construcción de la comunidad de R por medio de tus contribuciones!

### Ciclo de desarrollo de un paquete

Siempre sentí que desarrollar un paquete era muy difícil, pero la verdad R tiene muchas herramientas para hacer este proceso lo más sencillo posible, principalmente [el paquete `{usethis}`](https://usethis.r-lib.org). 

Para desarrollar un paquete de R naturalmente hay que **entender la estructura** de un paquete, y luego familiarizarse con el **proceso de desarrollo** del mismo.


### Estructura de un paquete de R


### Ciclo de desarrollo de un paquete de R

Luego de haber levantado los **cimientos** del paquete, el desarrollo es una especie de ciclo en el que vamos repitiendo la creación de funciones, documentación, creación de pruebas, chequeo del paquete, y repetir.

En detalle, el ciclo de desarrollo de un paquete es así:

1. **Creamos una función** nueva con `usethis::use_r()`
    * Se crea un script nuevo en `R/funcion.R` y se abre en RStudio
    * Programamos lo básico de la función en ese script
2. **Documentamos la función** con [comentarios de `{roxygen2}`](https://roxygen2.r-lib.org) directamente encima de la función que creamos
3. Creamos **pruebas unitarias** para la función creada con `usethis::use_test()`
    * Ponemos a prueba la función y especificamos qué debería retornar, para asegururarnos ahora y en el futuro de que funciona correctamente
4. **Chequeamos** que todo esté bien en el paquete con `devtools::check()`

Veremos todos estos pasos y más en este tutorial!

## Pasos previos

Antes de iniciar el desarrollo de un paquete, necesitamos confirmar que tenemos los paquetes necesarios. Como mínimo, serían `{devtools}`, `{usethis}` y `{pak}`.

```r
install.packages(c("devtools", "usethis", "pak"))
```

```r
devtools::has_devel()

devtools::dev_sitrep()
```

También necesitaremos tener configurado y funcionando Git en nuestra sesión de R, para poder ir respaldando las versiones del paquete, y también para hacerlo disponible e instalable en internet. Podemos revisar esto con la siguiente función:

```r
usethis::git_sitrep()
```

Si no has configurado Git con R aún, [revisa este tutorial.](https://bastianolea.rbind.io/blog/tutorial_github/)

{{< relacionada "/blog/tutorial_github/" >}}



## Creación de un paquete de R


```r
pak::pkg_name_check("nombre")
```

```r
usethis::create_package("nombre")

# revisar que todo esté bien
devtools::check()
```

### Documentos mínimos

```r
usethis::use_readme_rmd()
```

```r
usethis::use_mit_license()
# usethis::use_gpl3_license()
```


### Repositorio Git
En este punto se recomienda empezar a respaldar tu código con Git. Para eso creamos el repositorio local, guardando el estado del código en una nueva versión:

```r
# crear repositorio local
usethis::use_git()
```

Los avances futuros los irás guardando regularmente en versiones nuevas, y así mantendrás un **control de versiones** que te permitirá explorar estados pasados, deshacer cambios en el tiempo, ir registrando cambios nuevos al código, y más.

Pero el uso principal que le daremos al repositorio de control de cambios de Git es la posibilidad de mantener un positorio remoto que guarde tus versiones en internet por medio de **GitHub**. Github es la página que usa la mayoría de desarrolladores/as para subir su software, respaldarlo en la nube y hacerlo visible para el mundo. De este modo, otras personas podrán navegar tu código, clonarlo en sus computadores para ofrecer mejoras o funcionalidades nuevas, e instalar el paquete en sus computadores.

```r
# crear repositorio remoto
usethis::use_github()
```

{{< aviso "⚠️ Tutorial en construcción! A medida que voy aprendiendo, lo iré complementando" >}}

## Instalación local del paquete
```r
pak::local_install()
```

## Crear funciones para el paquete

https://bastianolea.rbind.io/blog/r_introduccion/r_intermedio/
```r
# funciones

# crear función
usethis::use_r("territorios")
```

## Explicitar dependencias
```r
# agregar dependencia a un paquete
usethis::use_package("dplyr")
usethis::use_package("cli")
```


## Revisiones
```r
# revisar que todo esté bien
devtools::check()

# recargar el paquete
devtools::load_all()
```

## Pruebas unitarias

https://bastianolea.rbind.io/blog/validacion_datos/#validación-con-testthat

```r
usethis::use_testthat()

# crear test para una función
use_test()
usethis::use_test("territorios")

# realizar todas las pruebas
devtools::test()
```

{{< relacionada "/blog/validacion_datos/" >}}

## Incluir datos

```r
# crear datos del paquete
usethis::use_data_raw("territorios")
```


## Iteración

```r
# crear función
usethis::use_r("comunas")

# recargar paquete
devtools::load_all()

# crear prueba para la función
usethis::use_test("comunas")

# realizar todas las pruebas
devtools::test()
```

y repetir!



```r
# documentación
# escribir documentación
devtools::document()

# crear viñeta
usethis::use_vignette("territorial.qmd") # si se llama como el paquete tiene un rol distinto

# instalar el propio paquete
pak::local_install()
knitr::knit("README.Rmd")

# sitio del paquete
# usethis::use_pkgdown()
# usethis::use_pkgdown_github_pages()

# reconstruir sitio
pkgdown::build_site()
# usethis::use_github_pages()
# poner enlace en _pkdown.yml y description
# usethis::use_github_action("pkgdown")
# cuando se haga push se construirá el sitio
```


{{< relacionada "/blog/territorial/" >}}

{{< etiqueta "avanzado" >}}
