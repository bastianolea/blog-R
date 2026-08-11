---
title: prueba
format: html
---


``` r
cuadritos <- purrr::map(
  # colores[45:55],
  # sample(colores, 10),
  sample(colores, 3),
  # colores,
  \(color) {
    shiny::div(
      color, 
      style = paste(
        paste("background-color:", gplots::col2hex(color), ";"),
        estilo,
        paste("color:", 
              ifelse(
                colorspace::contrast_ratio(color, "black") < 4, 
                "white", "black"),
              ";")
      ),
    )
  })

shiny::div(style = centrar,
           shiny::tagList(cuadritos)
)
```

<div style="align-items: center; justify-content: center; text-align: center;">
<div style="background-color: #8B5742 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ;">lightsalmon4</div>
<div style="background-color: #DDA0DD ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ;">plum</div>
<div style="background-color: #EED2EE ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ;">thistle2</div>
</div>

``` r
paleta <- function(colores) {
  
  # colores <- colors(distinct = T) |> 
  #   stringr::str_subset("gray", negate = T)
  
  tamaño <- "width: 90px; height: 90px; font-size: 12px;"
  forma <- "border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all;"
  centrar <- "align-items: center; justify-content: center; text-align: center;"
  
  estilo <- paste(tamaño, forma, centrar)
  
  cuadritos <- purrr::map(
    colores,
    \(color) {
      shiny::div(
        color, 
        style = paste(
          paste("background-color:", gplots::col2hex(color), ";"),
          estilo,
          paste("color:", 
                ifelse(
                  colorspace::contrast_ratio(color, "black") < 4, 
                  "white", "black"),
                ";"),
          paste("border: solid 1px", colorspace::darken(color, 0.3), ";")
        ),
      )
    })
  
  
  output <- shiny::div(style = centrar,
                       shiny::tagList(cuadritos)
  ) 
  
  return(output)
}
```

``` r
paleta(
  sample(colors(), 10)
  # sample(colors(), 3)
  # colors()
)
```

<div style="align-items: center; justify-content: center; text-align: center;">
<div style="background-color: #8B475D ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ; border: solid 1px #603341 ;">palevioletred4</div>
<div style="background-color: #FFF5EE ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #CC9D6E ;">seashell</div>
<div style="background-color: #EE9A49 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #AA6604 ;">tan2</div>
<div style="background-color: #D6D6D6 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #909090 ;">grey84</div>
<div style="background-color: #76EEC6 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #07A680 ;">aquamarine2</div>
<div style="background-color: #FF83FA ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #D604D1 ;">orchid1</div>
<div style="background-color: #EEE685 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #A49C06 ;">khaki2</div>
<div style="background-color: #8B6914 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #624903 ;">goldenrod4</div>
<div style="background-color: #9400D3 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ; border: solid 1px #6A0099 ;">darkviolet</div>
<div style="background-color: #EE9572 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #B65B26 ;">lightsalmon2</div>
</div>
