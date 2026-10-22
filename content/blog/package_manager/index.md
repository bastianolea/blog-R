---
title: Instalar paquetes de R desde Posit Package Manager
subtitle: Aumenta la velocidad de instalación y estabilidad instalando paquetes precompilados en binarios
author: Bastián Olea Herrera
date: '2026-10-22'
slug: []
categories: []
tags:
  - avanzado
  - consejos
  - optimización
  - reproducibilidad
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
excerpt: El servicio gratuito [Posit Package Manager](https://packagemanager.posit.co) es un repositorio de paquetes de R que vienen en formato binario, lo que significa que las instalaciones serán mucho más rápidas en cualquier computador, tendrás muchos menos problemas de dependencias, y no necesitarás compilar versiones de paquetes para tu sistema operativo. Un enorme problema menos!
links:
  - icon: box
    icon_pack: fas
    name: Package Manager
    url: https://packagemanager.posit.co
---

El servicio gratuito [Posit Package Manager](https://packagemanager.posit.co) es un repositorio de paquetes de R que vienen en formato binario, lo que significa que las instalaciones serán mucho más rápidas en cualquier computador.

<i class='fas fa-box-open icono-lateral'></i>

R permite configurar distintos espejos o _mirrors_ de repositorios de paquetes, como CRAN, para descargar tus paquetes de R desde distintos servidores.

<!---
Por ejemplo, puedes bajar tus paquetes de R desde el _mirror_ de CRAN alojado en Chile: [https://cran.dcc.uchile.cl/](https://cran.dcc.uchile.cl/)
--->

Pero también puedes configurar repositorios completamente distintos, como [Bioconductor](https://www.bioconductor.org) o [R-Universe](https://r-universe.dev/search) de [ROpenSci](https://ropensci.org), para acceder a otras fuentes de paquetes distintas a CRAN.

[Posit Package Manager](https://packagemanager.posit.co) es un repositorio que mantiene versiones compiladas y versionadas de los paquetes de CRAN, actualizadas diariamente, para facilitar y optimizar la instalación de paquetes en R.

{{< paso "1" "Obtener una URL de repositorio" >}}

Para configurarlo en tu RStudio, necesitas una **URL de repositorio**, que varía dependiendo de tus preferencias y sistema operativo, y que puedes obtener aquí: 

{{< boton "Obtener URL de repositorio" "https://packagemanager.posit.co/client/#/repos/cran/setup" "link" >}}

Aquí tienes que elegir tu **sistema operativo**, si quieres la **versión más nueva** de cada paquete o la **versión de una fecha específica** (para más reproducibilidad), y finalmente tu IDE para obtener instrucciones de configuración personalizadas.

Por ejemplo, para sistema Windows o macOS y las versiones más recientes, la URL sería:

````
https://packagemanager.posit.co/cran/latest
````

Copia el enlace resultante para el siguiente paso.

{{< paso "2" "Configurar el repositorio en RStudio" >}}

Luego necesitas configurar la URL en RStudio para que baje sus paquetes desde ahí:

1. Entra a las configuraciones de R en _Tools > Global Options_
2. Selecciona el panel _Packages_
3. Presiona _Change_
4. Pega la URL que obtuviste en el paso anterior

Para más información, revisa la [documentación oficial](https://docs.posit.co/rspm/).

También puedes configurar la URL con un comando de R:

```r
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/latest"))
```

Puedes hacer esto una vez, o agregarlo a tu `.Rprofile` de un proyecto o usuario con `usethis::edit_r_profile()` para que se aplique automáticamente al iniciar R.

Con esto, los paquetes que instales se bajarán mucho más rápido, tendrás muchos menos problemas de dependencias, ya que **no necesitarás compilar** versiones de paquetes para tu sistema operativo. Un enorme problema menos!

{{< cuadro "En mi experiencia, las instalaciones fueron muchísimo más rápidas, e incluso paquetes difíciles de instalar como `{sf}` se instalaron al tiro!" >}}

{{< etiqueta "consejos" >}}