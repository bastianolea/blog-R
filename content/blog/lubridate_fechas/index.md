---
title: Operaciones con fechas en R usando `{lubridate}`
author: Bastián Olea Herrera
date: '2026-09-01'
slug: []
categories: []
tags:
  - fechas
draft: true
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
excerpt: Resumen del post
links:
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://github.com/bastianolea
---


``` r
install.packages("lubridate")
```

``` r
library(lubridate)
```

días para el 18

``` r
today()
```

    [1] "2026-09-01"

``` r
now()
```

    [1] "2026-09-01 21:31:27 -04"

``` r
dieciocho <- as_date("2026-09-18")
```

``` r
días <- dieciocho - today()

días
```

    Time difference of 17 days

al momento de escribir esta publicación, faltan 17 días para el dieciocho de septiembre
