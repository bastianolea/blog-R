---
title: "Medir el ancho de una aplicación Shiny como una variable reactiva y usarla
  para adaptar sus contenidos"
author: Bastián Olea Herrera
date: '2026-04-06'
draft: true
slug: []
categories: []
tags:
  - shiny
format:
  hugo-md:
    output-file: index
    output-ext: md
---

```r
tags$head(
    tags$script(src = "altura.js")
  ),
```

```js
$(document).on('shiny:connected', function() {
  Shiny.setInputValue('window_width', window.innerWidth);
});
$(window).on('resize', function() {
  Shiny.setInputValue('window_width', window.innerWidth);
});
```


```r
tags$head(
  tags$script(HTML("
    $(document).on('shiny:connected', function() {
      Shiny.setInputValue('window_width', window.innerWidth);
    });
    $(window).on('resize', function() {
      Shiny.setInputValue('window_width', window.innerWidth);
    });
  "))
)
```

```r
ancho <- reactive(input$window_width)
```

```r
observe({
  message(ancho())
})
```

```r
ancho <- debounce(ancho, 100)
```