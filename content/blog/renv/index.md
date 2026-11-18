---
title: Entornos reproducibles para análisis de datos con `{renv}`
subtitle: Mejora la reproducibilidad de tus proyectos fijando las versiones de los paquetes usados
author: Bastián Olea Herrera
date: '2026-11-18'
draft: false
categories:
  - Tutoriales
tags:
  - consejos
  - avanzado
  - reproducibilidad
links:
  - icon: registered
    icon_pack: fas
    name: renv
    url: https://rstudio.github.io/renv/
  - icon: chalkboard-user
    icon_pack: fas
    name: taller
    url: https://paocorrales.github.io/intro-renv/
excerpt: "La reproducibilidad es un concepto clave en proyectos de ciencia de datos. Es muy importante planificar tus proyectos a futuro para que puedan seguir funcionando en otros computadores o ser ejecutados por otras personas, y que los resultados sigan siendo exactamente los mismos. Para esto, el paquete de R `{renv}` te ayuda a _congelar_ las versiones de los paquetes que uses."
---

[La **reproducibilidad**](/tags/reproducibilidad/) es el conjunto de prácticas que permiten que tus procesos puedan ser repetidos, ya sea por ti o por otras personas, garantizando que los resultados pueden volver a regenerarse de manera exacta. Es un concepto clave en proyectos de ciencia de datos, y para las ciencias en general. 

Si bien la reproducibilidad es clave para las ciencias, también lo es para garantizar que tus procesos estén preparados para el futuro, puedan actualizarse, y puedan ser usados por otras personas.

{{< imagen_lateral "renv.png" "128px" >}}

Dentro de todas las cosas que pueden hacer que un proyecto **no sea reproducible** están todos los problemas que pueden impedir que tu proyecto se ejecute en el futuro, o que haga que sus resultados sean imposibles de repetir. Por ejemplo: datos faltantes o inexistentes, rutas a archivos fuera del [proyecto](/blog/r_introduccion/proyectos/) e imposibles de localizar, y las **versiones** de los paquetes usados. 

`{renv}` te ayuda a **congelar las versiones** de los paquetes que uses, para que puedas reinstalarlos en el futuro o en otros computadores y tu proyecto siga funcionando sin sorpresas.


{{< cuadro "Este tutorial se basa en parte en el taller [proyectos reproducibles con renv](https://paocorrales.github.io/intro-renv/), impartido por [Pao Corrales](https://paocorrales.github.io) en el marco de [Research Software Latinoamérica (RSLA26)](https://rs-latam.org)." >}}

{{< indice >}}


## Cómo funciona `{renv}`

Normalmente, todos los paquetes que instalas en R quedan en una **librería global** de tu computador (una carpeta misteriosa en las profundidades de tu sistema operativo), y todos tus proyectos usan esos mismos paquetes. El problema es que, si actualizas un paquete para un proyecto nuevo, la actualización también **afecta a tus proyectos antiguos**, que podrían dejar de funcionar o entregar resultados distintos.

Con `{renv}`, cada proyecto tiene su propia **librería** de paquetes, **aislada** del resto del sistema. 



<div class="cuadros-horizontales" style="flex-wrap: wrap; align-items: stretch; column-gap: 24px;">

  <div style="text-align: center; min-width: 220px; margin-bottom: 16px;">
    <strong>sin <code>{renv}</code></strong>
    <div class="cuadro" style="margin: 10px 0 0 0;">
      <i class="fas fa-desktop"></i> sistema
      <div class="cuadro" style="margin: 10px 0 0 0;"><i class="fas fa-cubes"></i> paquetes</div>
      <div style="display: flex; gap: 8px; justify-content: center;">
        <div class="cuadro" style="margin: 10px 0 0 0;"><i class="fas fa-folder"></i> proyecto A</div>
        <div class="cuadro" style="margin: 10px 0 0 0;"><i class="fas fa-folder"></i> proyecto B</div>
      </div>
    </div>
  </div>

  <div style="text-align: center; min-width: 220px;">
    <strong>con <code>{renv}</code></strong>
    <div class="cuadro" style="margin: 10px 0 0 0;">
      <i class="fas fa-desktop"></i> sistema
      <div class="cuadro" style="margin: 10px 0 0 0;"><i class="fas fa-box-archive"></i> caché de <code>{renv}</code></div>
      <div style="display: flex; gap: 8px; font-size: 1.3em; line-height: 1; margin: 6px 0;">
        <span style="flex: 1; text-align: center;">↓</span>
        <span style="flex: 1; text-align: center;">↓</span>
      </div>
      <div style="display: flex; gap: 8px; justify-content: center;">
        <div class="cuadro" style="margin: 0; flex: 1;"><i class="fas fa-folder"></i> proyecto A
          <div class="cuadro" style="margin: 8px 0 0 0;"><i class="fas fa-cubes"></i> paquetes</div>
        </div>
        <div class="cuadro" style="margin: 0; flex: 1;"><i class="fas fa-folder"></i> proyecto B
          <div class="cuadro" style="margin: 8px 0 0 0;"><i class="fas fa-cubes"></i> paquetes</div>
        </div>
      </div>
    </div>
  </div>

</div>

{{< bajada "Sin `{renv}`, todos los proyectos comparten los paquetes del sistema. Con `{renv}`, cada proyecto tiene sus propios paquetes, enlazados desde el caché." >}}

`{renv}` mantiene un **registro de paquetes usados** en el proyecto con sus versiones exactas en `renv.lock` (el _lockfile_). Este archivo es lo que permite que después los paquetes se puedan **volver a instalar de manera reproducible** en otro momento o en otro computador.

{{< icono "rocket" >}} Los paquetes instalados por `{renv}` se guardan en un **caché** que se enlaza desde ahí a cada proyecto, en la versión que corresponda. Así, si dos proyectos usan la misma versión de un paquete, no necesita reinstalarse!

{{< info "Para usar `{renv}` necesitas trabajar dentro de un [proyecto de RStudio](/blog/r_introduccion/proyectos/), que es la forma recomendada de organizar cualquier análisis en R." >}}


## Por qué usarlo

Algunas situaciones donde `{renv}` hace la diferencia:

- **Compartir un proyecto** con un/a colega, para que pueda ejecutarlo con los mismos paquetes que usaste tú, sin tener que adivinar qué instalar.
- **Migrar proyectos** a otro computador, instalando todos los paquetes necesarios con un solo comando.
- **Archivar proyectos terminados**, para asegurarte que en el futuro puedas volver a ejecutarlos y obtener los mismos resultados.
- **Desplegar proyectos a producción**, como [aplicaciones Shiny](/tags/shiny/) o procesos en servidores, para que las versiones de los paquetes queden fijas y ninguna actualización eche a perder nada.


## Empezar a usar `{renv}`

A grandes rasgos, lo que hará `{renv}` en tu proyecto es registrar los paquetes usados en tu código, registrar sus versiones actuales, bajarlos en un caché, e instalarlos.

Luego, el paquete nos servirá para poder **reinstalar** los paquetes, y será también la forma en que podremos **actualizar** los paquetes usados (ya sea agregando nuevos o sacando automáticamente los que ya no se usen!)

{{< imagen "renv_featured.png" >}}
{{< bajada "Esquema del funcionamiento de `{renv}` en tu sistema. Basado en [este diagrama](https://rstudio.github.io/renv/#workflow)." >}}



Primero instalamos `{renv}` como cualquier otro paquete:

```r
install.packages("renv")
```

Luego, con el [proyecto](/blog/r_introduccion/proyectos/) abierto, iniciamos `{renv}`:

```r
renv::init()
```

Esto revisará todos los scripts del proyecto para detectar qué paquetes se usan, los instala en la librería del proyecto, **registra sus versiones en el _lockfile_**, y reinicia la sesión de R. 

Desde ese momento, cada vez que abras el proyecto o inicies R en esa carpeta, `{renv}` se activará automáticamente.

Al iniciar `{renv}` se crean los siguientes archivos en el proyecto:

<div style="text-align: center;">
  <div class="contenedor-iconos">

<div class="icono-cuadro" style="flex-direction: column; gap: 16px; text-align: left;">

  <div style="display: flex; align-items: center; gap: 16px;">
    <div class="icono-v" style="min-width: 110px;">
      <i class='fas fa-lock'></i>
      <span>renv.lock</span>
    </div>
    <span>Registro de los paquetes usados en el proyecto y sus versiones exactas.</span>
  </div>

  <div style="display: flex; align-items: center; gap: 16px;">
    <div class="icono-v" style="min-width: 110px;">
      <i class='fas fa-folder'></i>
      <span>renv/library/</span>
    </div>
    <span>Librería del proyecto, donde quedan los paquetes instalados.</span>
  </div>

  <div style="display: flex; align-items: center; gap: 16px;">
    <div class="icono-v" style="min-width: 110px;">
      <i class='fas fa-file-code'></i>
      <span>renv/activate.R</span>
    </div>
    <span>Script que activa <code>{renv}</code> e instala la versión correcta del paquete si no está.</span>
  </div>

  <div style="display: flex; align-items: center; gap: 16px;">
    <div class="icono-v" style="min-width: 110px;">
      <i class='fas fa-file-alt'></i>
      <span>.Rprofile</span>
    </div>
    <span>Ejecuta <code>renv/activate.R</code> automáticamente al abrir el proyecto.</span>
  </div>

</div>
</div>
</div>


### Revisar el estado

Algo que haremos con cierta frecuencia será revisar si los paquetes **en uso** del proyecto, los que están **instalados** y los que están **registrados** en el _lockfile_ coinciden:

```r
renv::status()
```

Si todo está en orden, veremos este mensaje:

```
No issues found -- the project is in a consistent state.
```

Esto significa que los paquetes que se usan están registrados en el _lockfile_!

De lo contrario, `renv::status()` nos va a indicar **inconsistencias en el registro de paquetes y versiones**, y qué función ejecutar para solucionarlo.


### _Lockfile_

{{< icono-lateral "lock" >}}

En el _Lockfile_ (archivo `renv.lock`) se registran las **versiones** de los paquetes que usas, con toda la información necesaria para poder reinstalarlos en el futuro. 

Al principio el archivo registra la **versión de R** que usas y los **repositorios** desde los que instalas paquetes (yo uso [Posit Package Manager](/blog/package_manager/) y el [_mirror_ de CRAN](https://cran.r-project.org/mirrors.html) de la Universidad de Chile):


```json
{
  "R": {
    "Version": "4.6.1",
    "Repositories": [
      {
        "Name": "CRAN",
        "URL": "https://packagemanager.posit.co/cran/latest"
      },
      {
        "Name": "Chile",
        "URL": "https://cran.dcc.uchile.cl"
      }
    ]
  },
  ...
```

…y luego viene la lista de paquetes usados e instalados en tu proyecto:

```json
  "Packages": {
  "territorial": {
      "Package": "territorial",
      "Version": "0.9.13",
      "Source": "Repository",
      "Imports": [
        "cli",
        "dplyr",
        "forcats",
        "glue",
        "purrr",
        "stringr"
      ],
      # ...
      "Repository": "https://bastianolea.r-universe.dev",
      "RemoteType": "repository",
      "NeedsCompilation": "no",
      "RemoteUrl": "https://github.com/bastianolea/territorial",
      # ...
    },
```

Si te fijas, contiene información descriptiva, las dependencias de los paquetes, y los lugares desde donde tiene que instalarlos.

{{< icono "triangle-exclamation" >}} No necesitamos editar este archivo a mano, porque `renv` lo mantendrá actualizado!


### Flujo de trabajo

Los conceptos principales son el estado (_status_, con `renv::status()`) y la foto (_snapshot_, con `renv::snapshot()`) que tomamos a las versiones de los paquetes para fijarlas.

Una vez iniciado `{renv}`, el trabajo diario en el proyecto sigue este ciclo:

<div class="cuadros-verticales">

  <div class="cuadro-vertical">
  Usar un paquete nuevo en el código
  </div>

  <div class="flecha">↓</div>

  <div class="cuadro-vertical-oscuro">
  <p>Instalar un paquete nuevo</p>
  <code>renv::install()</code> o <code>install.packages()</code>
  </div>

  <div class="flecha">↓</div>

  <div class="cuadro-vertical-oscuro">
  <p>Revisar el estado de la librería</p>
  <code>renv::status()</code>
  </div>

  <div class="flecha">↓</div>

  <div class="cuadro-vertical-oscuro">
  <p>Registrar los paquetes y sus versiones</p>
  <code>renv::snapshot()</code>
  </div>

  <div class="flecha">↓</div>

  <div class="cuadro-vertical">
  Seguir trabajando
  </div>

</div>

La idea es que cada vez que el proyecto quede funcionando con un paquete nuevo o actualizado, **tomemos una _snapshot_** para que el _lockfile_ refleje el estado actual del proyecto.


## Casos de uso

### Registrar nuevos paquetes

Si empezamos a usar un paquete nuevo en el proyecto, lo instalamos y luego registramos su versión en el _lockfile_:

```r
install.packages("ggplot2")
library(ggplot2) # usar el paquete...
# renv::status()
renv::snapshot()
```

### Desinstalar un paquete

Para dejar de usar un paquete, es tan simple como borrar sus referencias en los scripts del proyecto. Luego `renv::status()` se va a dar cuenta que ya no lo usas, y te sugerirá hacer un `renv::snapshot()` que eliminará el paquete sobrante del _lockfile_. 

### Actualizar paquetes

Para actualizar todos los paquetes del proyecto a sus versiones más recientes, o solamente uno:

```r
# actualizar todos los paquetes
renv::update()

# actualizar un paquete
renv::update("dplyr")
```

Después de actualizar, ejecuta tu código para revisar que todo siga funcionando, y si es así, registra las nuevas versiones con `renv::snapshot()` para que queden en el _lockfile_. Si algo se echó a perder, `renv::restore()` vuelve a instalar las versiones que estaban registradas en el _lockfile_, deshaciendo la actualización. Seguridad!

### Restaurar un proyecto

Cuando abrimos el proyecto en otro computador, descargamos un proyecto de otra persona que usa `{renv}`, o un cambio rompió algo, abrimos el proyecto de RStudio y restauramos los paquetes desde el _lockfile_:

```r
renv::restore()
```

<div class="cuadros-horizontales" style="flex-wrap: wrap;">
  <div class="cuadro" style="margin: 0;"><i class="fas fa-lock" style="margin-right: 8px;"></i><code>renv.lock</code></div>
  <span style="font-size: 1.6em;">→</span>
  <div class="cuadro" style="margin: 0;"><code>renv::restore()</code></div>
  <span style="font-size: 1.6em;">→</span>
  <div class="cuadro" style="margin: 0;"><i class="fas fa-cubes" style="margin-right: 8px;"></i>librería del proyecto</div>
</div>

La función `renv::restore()` lee el _lockfile_ e instala cada paquete en la versión exacta que estaba registrada, dejando el proyecto tal como estaba cuando se tomó la última _snapshot_.

### Compartir un proyecto

Para que otra persona pueda restaurar tu proyecto, siempre es una buena práctica **compartir la carpeta entera** del proyecto. Así incluyes todos los scripts, datos, `readme.md` y otros archivos asociados. Esto incluye los archivos `renv.lock`, `.Rprofile` y `renv/activate.R`, que le permitirán a otras personas hacer `renv::restore()`. 

{{< info "No es necesario compartir la carpeta `renv/library`, porque los paquetes se vuelven a instalar con `renv::restore()`. Si usas Git, `{renv}` crea su propio `.gitignore` para que la librería no se suba al repositorio." >}}

### Actualizar R

Un clásico: cuando actualizas R, tienes que volver a instalar todos tus paquetes. Pero si usas `{renv}`, luego de actualizar R sólo ejecutas `renv::restore()` y se instala todito de una.

### Desactivar `{renv}`

Si queremos que el proyecto vuelva a usar la librería global del sistema, desactivamos `{renv}`:

```r
renv::deactivate()
```

Esto conserva el _lockfile_ y la carpeta `renv`, así que podemos volver a activarlo en cualquier momento con `renv::activate()`. Si queremos eliminar todo rastro de `{renv}` del proyecto, usamos `renv::deactivate(clean = TRUE)` o bien borramos todos los archivos y carpetas asociados a `renv`.


## Limitaciones

{{< icono "circle-exclamation" >}} `{renv}` fija las versiones de los paquetes, pero no controla la versión de R ni las dependencias del sistema operativo que algunos paquetes necesitan (por ejemplo, librerías geoespaciales para `{sf}`). 
  - Si necesitas ejecutar **varias versiones de R** en un mismo computador y cambiar entre ellas, usa [rig](https://rig.r-lib.org).
  - Si necesitas garantizar la reproducibilidad a nivel de versiones de R, existe [rix: entornos reproducibles con Nix](https://docs.ropensci.org/rix/), y si lo requieres a nivel de sistema operativo, existe [Docker](/blog/shiny_docker/).

{{< icono "circle-exclamation" >}} La restauración de un proyecto puede fallar si un paquete tiene que **compilarse** desde el código fuente. Esto pasa porque, si bien CRAN ofrece versiones compiladas de los paquetes, no las ofrece para versiones antiguas, por lo que se dificultan las restauraciones. Para evitarlo, conviene instalar paquetes desde [Posit Package Manager](/blog/package_manager/), que entrega paquetes binarios precompilados incluso de versiones antiguas, que se instalan más fácil y rápido.


{{< relacionada "blog/package_manager/" >}}

## Recursos

- [Introducción a `renv`](https://rstudio.github.io/renv/articles/renv.html)
- Taller [proyectos reproducibles con renv](https://paocorrales.github.io/intro-renv/), impartido por [Pao Corrales](https://paocorrales.github.io)
- [rix: entornos reproducibles para R con Nix](https://docs.ropensci.org/rix/), que llevan la reproducibilidad más allá que `{renv}`
- [Capítulo sobre flujos de trabajo en R](https://es.r4ds.hadley.nz/08-workflow-projects.html) del libro [R para Ciencia de Datos](https://es.r4ds.hadley.nz/), que trata en profundidad el concepto de _proyectos_ en RStudio.
- [Ease `renv::restore()` by updating your repository to Posit Public Package Manager](https://www.pipinghotdata.com/posts/2024-09-16-ease-renvrestore-by-updating-your-repositories-to-p3m/)
- [Instalar paquetes de R desde Posit Package Manager](/blog/package_manager/)

{{< etiqueta "reproducibilidad" >}}

{{< etiqueta "consejos" >}}

{{< cafecito >}}

