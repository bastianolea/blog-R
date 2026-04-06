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
excerpt: "Al desarrollar aplicaciones web Shiny, tenemos que considerar que van a ser visitadas desde distintos dispositivos: celulares, tablets, computadores grandes, computadores pequeños... Por eso es importante diseñarlas pensando en la reactividad. Si bien Shiny crea aplicaciones reacgtivas, puede ser útil usar el ancho de la ventana para adaptar los contenidos de la app: mostrar u ocultar elementos, ajustar los gráficos, cambiar un layout, o elegir qué visualización presentar según si el usuario está en un computador de escritorio o en un dispositivo móvil."
---

Al desarrollar aplicaciones web [Shiny](/tags/shiny), tenemos que considerar que van a ser visitadas desde distintos dispositivos: celulares, tablets, computadores grandes, computadores pequeños... Por eso es importante diseñarlas pensando en la **reactividad**; es decir, que la aplicación se adapte a distintos tamaños de ventana o pantalla. Si bien Shiny hace gran parte de eso por sí sólo, puede ser útil usar el **ancho de la ventana** para adaptar los contenidos de la app: mostrar u ocultar elementos, ajustar los gráficos, cambiar un layout, o elegir qué visualización presentar según si el usuario está en un computador de escritorio o en un dispositivo móvil.

En este tutorial veremos cómo **capturar el ancho de la ventana** como un `input` reactivo de Shiny, para poder usar esta variable en nuestra app para adaptar sus contenidos.

---

## Capturar el ancho de la ventana

Para obtener el ancho actual de la ventana en cualquier momento de la ejecución de nuesra aplicación, usaremos **JavaScript**. Pero descuida, no es necesario aprender este elnguaje, sino solamente saber cómo integrarlo en la app Shiny.

Hay **dos formas** de incluir este código JavaScript en tu app:

### Cargar código de JavaScript externo

Puedes guardar el código JavaScript en un archivo separado llamado `ancho.js` dentro de la carpeta `www/` de tu aplicación, y hacer que tu aplicación lo cargue al ejecutarse, incluyéndolo en el código de la UI (interfaz):

```r
tags$head(
  tags$script(src = "ancho.js")
),
```

El archivo `www/ancho.js` contiene el código JavaScript necesario para **medir el ancho** tanto al abrir la app como al cambiar la ventana:

```js
$(document).on('shiny:connected', function() {
  Shiny.setInputValue('window_width', window.innerWidth);
});
$(window).on('resize', function() {
  Shiny.setInputValue('window_width', window.innerWidth);
});
```

El primer bloque envía el ancho apenas la app se conecta, y el segundo lo actualiza cada vez que cambia el tamaño de la ventana.

Si prefieres mantener todo en el mismo archivo de tu app, puedes escribir el JavaScript directamente en la UI usando `tags$script(HTML(...))`:

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

Ambas opciones producen el mismo resultado. La primera es más ordenada si tu app es grande; la segunda es más práctica para apps pequeñas o de un solo archivo.



## Crear una variable reactiva con el ancho

Una vez que el JavaScript está en la UI, Shiny recibirá el ancho de la ventana como `input$window_width`. Esto ya nos sirve para nuestro propósito, que es tener el ancho como una variable.

Si creamos un **observador**, podemos hacer que Shiny imprima el valor del `input`, y como los observadores se actualizan cada vez que cambia el valor de los inputs que incluye, veremos cómo se actualiza el ancho cada vez que cambiamos el tamaño de la ventana:

```r
observe({
  message(input$window_width)
})
```

Si jugamos con el ancho de la ventana (o del panel _Viewer_) veremos los cambios:

```
645
649
660
714
741
761
786
803
810
817
827
832
836
840
843
848
```

Notamos inmediatamente que los valores cambian demasiado rápido! El `input` se actualiza con demasiado detalle, lo que nos puede causar problemas.


## Suavizar las actualizaciones del `input`

Como el evento `resize` se dispara muy frecuentemente mientras el/la usuario/a arrastra el borde de la ventana, puede ocurrir que `input$window_width` se actualice decenas de veces por segundo, lo que puede generar cálculos innecesarios y hacer la app más lenta.

Para evitar esto, usamos `debounce()`, que **retarda la reactividad** hasta que el valor deje de cambiar por un tiempo determinado (en milisegundos):

Primero creamos una variable reactiva a partir del `input`:

```r
ancho <- reactive(input$window_width)
```

Luego, aplicamos `debounce()` a esta variable, indicando un tiempo de espera de 100 milisegundos:

```r
ancho <- debounce(ancho, 100)
```

Con este código, `ancho()` sólo se actualizará cuando el ancho de la ventana lleve al menos 100 milisegundos sin cambiar, reduciendo significativamente la cantidad de actualizaciones.

Puedes volver a probarlo con un `observe()`:

```r
observe({
  message(ancho())
})
```

```
725
891
762
904
```

Ahora los mensajes en la consola aparecerán de forma mucho más espaciada mientras cambias el tamaño de la ventana.


## Usar el ancho en un output

Ya puedes usar `ancho()` como cualquier otro objeto reactivo dentro de la sección `server` de tu app. Por ejemplo, para mostrar el ancho como un texto en tu app, imprimes el texto con `renderText()` en el `server`:

```r
texto_ancho <- renderText({
  paste("El ancho de la ventana es:", ancho())
})
```

Y luego ubicas el `output` en alguna parte de la interfaz (UI) de tu app:

```r
textOutput("texto_ancho")
```



## Adaptar los contenidos de la app según el ancho

Ahora podemos **mostrar u ocultar elementos** de la aplicación dependiendo del ancho de la ventana. Para esto podemos combinar `ancho()` con [las funciones `show()` y `hide()` del paquete `{shinyjs}`](/blog/shiny_ocultar/).

Por ejemplo, en una app que permite seleccionar ubicaciones desde un mapa (más adecuado para pantallas anchas) y un selector común (más adecuado para pantallas angostas o móviles), podemos alternar entre ambos según el ancho de la ventana:

```r
observe({
  req(ancho())
  
  if (ancho() > 600) {
    show("mapa")
    hide("selector")
  } else {
    hide("mapa")
    show("selector")
  }
})
```

Usamos `req(ancho())` para asegurarnos de que el valor ya esté disponible antes de intentar usarlo (en el primer instante de la app, antes de que el JavaScript se ejecute, `input$window_width` podría ser `NULL`).

Con este patrón, si el ancho de la ventana supera los 600 píxeles, se muestra el mapa y se oculta el selector; y si la ventana es más angosta (como en un celular), se oculta el mapa y se muestra el selector.

Así podemos adaptar la experiencia de usuario para optimizarla según el dispositivo que use.

{{< aviso "Tengo un [tutorial](/blog/shiny_ocultar/) más completo sobre mostrar y ocultar elementos en Shiny usando `{shinyjs}`! [Revisa este post](/blog/shiny_ocultar/) para aprender a usar `show()` y `hide()` para controlar la visibilidad de los elementos de tu app." >}}


## Adaptar una visualización de datos según el ancho

Si nuestra aplicación muestra gráficos, la mayoría de los paquetes como `{ggplot2}` adaptarán las visualizaciones al espacio disponible. 

Pero usando el ancho de la ventana, podemos tomar decisiones más específicas sobre qué mostrar, y adaptar mejor los gráficos.

Empecemos con un gráfico de prueba:


``` r
library(ggplot2)

grafico <- ggplot(iris) +
  aes(Sepal.Width, Sepal.Length, color = Species) + 
  geom_point(alpha = 0.7) +
  scale_color_discrete(
    palette = c("#AC558A", "#553A74", "#666BC7")) +
  theme_linedraw(paper = "#EAD2FA", 
                 ink = "#553A74", 
                 accent = "#9069C0")

grafico
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-1-1.png" width="672" />


Para incluirlo en la app, debería ir dentro de `renderPlot()`

```r
grafico <- renderPlot({
  ggplot(iris) +
    aes(Sepal.Width, Sepal.Length, color = Species) + 
    geom_point(alpha = 0.7) +
    scale_color_discrete(
      palette = c("#AC558A", "#553A74", "#666BC7")) +
    theme_linedraw(paper = "#EAD2FA", 
                   ink = "#553A74", 
                   accent = "#9069C0")
})
```

Este sería el gráfico normal, pero si queremos adaptarlo según el ancho, agregamos un `if` dentro de `renderPlot()` para **agregarle capas condicionales**:

```r
grafico <- renderPlot({
  
  # el gráfico normal
  grafico <- ggplot(iris) +
    aes(Sepal.Width, Sepal.Length, color = Species) + 
    geom_point(alpha = 0.7) +
    scale_color_discrete(
      palette = c("#AC558A", "#553A74", "#666BC7")) +
    theme_linedraw(paper = "#EAD2FA", 
                   ink = "#553A74", 
                   accent = "#9069C0")
  
  # condicionalidad
if (ancho() < 600) {
  # si el ancho es menor a 600, mover la leyenda a la parte superior
  grafico <- grafico +
    theme(legend.position = "top")
}
  
  return(grafico
})
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="672" />

Como el **espacio horizontal es más escaso en celulares**, adaptamos el gráfico para que la leyenda aparezca arriba, y así haya más espacio para los datos!


{{< cafecito >}}

{{< cursos >}}
