personas |> 
  head(600) |> 
  select(-comuna_bajo_umbral, -tipo_operativo, -edad_quinquenal, -p24_lug_resid5) |> 
  collect() |> 
  View()


nombres <- personas |> names()


cortos <- nombres[nchar(nombres) < 15]


personas |> 
  select(all_of(cortos)) |>
  head(600) |> 
  collect() |> 
  View()
