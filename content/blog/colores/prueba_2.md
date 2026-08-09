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
<div style="background-color: #EEB422 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ;">goldenrod2</div>
<div style="background-color: #B3EE3A ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ;">olivedrab2</div>
<div style="background-color: #6B8E23 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ;">olivedrab</div>
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
<div style="background-color: #FFAEB9 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #DD5770 ;">lightpink1</div>
<div style="background-color: #6B6B6B ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ; border: solid 1px #4A4A4A ;">gray42</div>
<div style="background-color: #BFEFFF ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #31A9C3 ;">lightblue1</div>
<div style="background-color: #EEE8AA ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #A59E35 ;">palegoldenrod</div>
<div style="background-color: #FFFAFA ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #E89191 ;">snow</div>
<div style="background-color: #242424 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ; border: solid 1px #1B1B1B ;">grey14</div>
<div style="background-color: #CDCDB4 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #8B8B6C ;">lightyellow3</div>
<div style="background-color: #D4D4D4 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #8F8F8F ;">gray83</div>
<div style="background-color: #FFFACD ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #B3AA27 ;">lemonchiffon1</div>
<div style="background-color: #FCFCFC ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #A9A9A9 ;">grey99</div>
</div>
