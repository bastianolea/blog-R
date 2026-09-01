---
title: ¿Cuántos días faltan para el dieciocho?
subtitle: Calculando días para una fecha con R
author: Bastián Olea Herrera
date: '2026-09-01'
slug: []
categories: []
tags:
  - fechas
  - curiosidades
  - Chile
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
excerpt: >-
  El paquete `{lubridate}` facilita todas las operaciones con fechas en R! Aquí
  un ejemplo sobre calcular los días faltantes para una fecha dada.
links:
  - icon: registered
    icon_pack: fas
    name: Lubridate
    url: https://lubridate.tidyverse.org
---


En Septiembre se celebran las fiestas patrias de Chile, y celebramos con vino, empanadas, dulces chilenos y juegos típicos. ¿Cuánto falta para el dieciocho? Calculémoslo con R y de pasadita veamos lo útil que es [el paquete de R `{lubridate}`](https://lubridate.tidyverse.org) para cualquier operación que implique fechas.

Si no tienes `{lubridate}`, instálalo primero! Aunque si ya [instalaste Tidyverse](https://tidyverse.org/packages/) antes, viene incluído.

``` r
install.packages("lubridate")
```

Luego cargamos el paquete en la sesión de R:

``` r
library(lubridate)
```

Con la función `today()` obtenemos fácilmente la fecha de hoy:

``` r
today()
```

    [1] "2026-09-01"

Ahora creamos un objeto con la fecha que nos interesa; en este caso, el 18 de septiembre de 2026, escribiendo la fecha en el formato `año-mes-día`:

``` r
fecha <- as_date("2026-09-18")
```

Inspeccionemos el objeto creado:

``` r
fecha
```

    [1] "2026-09-18"

``` r
class(fecha)
```

    [1] "Date"

El resultado es un objeto de tipo *fecha* (`Date`), por lo que calcular la diferencia de días es tan simple como restar las dos fechas!

``` r
días <- fecha - today()

días
```

    Time difference of 17 days

Al momento de escribir esta publicación, **faltan 17 días** para el dieciocho de septiembre. Tiquitiquití! 🇨🇱

¿Y para el del año siguiente? Simplemente le sumamos 1 año a la fecha:

``` r
días <- fecha + years(1) - today()

días
```

    Time difference of 382 days

A partir del día 01 de septiembre de 2026, faltan 382 días para el dieciocho de septiembre del 2027!

{{< etiqueta "fechas" >}}
