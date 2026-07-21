# Shortcodes Reference

Todos los shortcodes están en `layouts/shortcodes/`. Usan la paleta morada del blog y soportan markdown en parámetros de texto (via `| markdownify`).

## Contenido

- [Imágenes](#imágenes)
- [Video](#video)
- [Cajas de texto](#cajas-de-texto)
- [Botones y enlaces](#botones-y-enlaces)
- [Layout](#layout)
- [Contenido relacionado](#contenido-relacionado)
- [Otros](#otros)

---

## Imágenes

### `imagen`
Imagen centrada y clickeable (abre original en nueva pestaña). Si se da un ancho, la imagen usa ese ancho máximo.
```
{{</* imagen "archivo.png" */>}}
{{</* imagen "archivo.png" "500px" */>}}
```
- Param 0: URL de imagen (requerido)
- Param 1: max-width (default: "700px")
- Ancho: 80%, centrada, border-radius 5px

### `imagen_alto`
Imagen con altura fija (para imágenes altas).
```
{{</* imagen_alto "archivo.png" "300px" */>}}
```
- Param 0: URL de imagen (requerido)
- Param 1: altura (default: "200px")

### `imagen_lateral`
Imagen flotante a la derecha con texto envolvente.
```
{{</* imagen_lateral "archivo.png" */>}}
{{</* imagen_lateral "archivo.png" "30%" */>}}
```
- Param 0: URL de imagen (requerido)
- Param 1: ancho (default: "40%")
- Responsive: se apila al centro en móvil (≤500px)

## Cajas de texto

### `aviso`
Caja de advertencia con ícono de triángulo.
```
{{</* aviso "Mensaje de advertencia" */>}}
```
Se usa para indicar que se requieren ciertas cosas antes de continuar, o que un post está en construcción. Para recomendar contenidos, mejor usar el shortcode `relacionada`

### `info`
Caja informativa con ícono de info.
```
{{</* info "Información importante" */>}}
```
Se usa para aclarar ciertos conceptos, o nociones acerca de la publicación, para guiar a les usuaries.

### `detalles`
Sección colapsable (HTML `<details>`).
```
{{</* detalles "Título clickeable" */>}}
Contenido oculto aquí
{{</* /detalles */>}}
```
Se usa cuando hay un texto técnico y opcional que se desea ocultar. Por ejemplo, el código del tema de los gráficos, la limpieza de los datos cuando no es relevante al post, o alguna explicación estadística más completa.

### `bajada`
Texto de subtítulo, centrado, pequeño (80%) y tenue (60% opacity).
```
{{</* bajada "Texto introductorio" */>}}
```

Se usa para poner texto debajo de una imagen, describiendo lo que contiene la imagen.

---

## Botones y enlaces

### `boton`
Botón estilizado con ícono Font Awesome.
```
{{</* boton "Texto" "https://url.com" "fas fa-download" */>}}
```
Se usa para enlaces de desacrgas, para enlaces a plataformas, u otros enlaces que se requiere que las o los usuarios aprieten, con textos como "Descargar datos", "Acceder a la plataforma", etc.

### `externo`
Tarjeta de enlace externo con imagen y descripción.
```
{{</* externo "Título" "https://url.com" "imagen.png" "Descripción" "Etiqueta" */>}}
```
- Param 0: título (requerido)
- Param 1: URL (requerido)
- Param 2: URL de imagen (opcional)
- Param 3: descripción (opcional)
- Param 4: etiqueta superior (default: "Recurso externo")
- Abre en nueva pestaña

Se usa para un enlace a un sitio externo, con una descripción completa y una imagen del sitio.

### `extension`
Tarjeta para destacar paquetes de R.
```
{{</* extension "Nombre" "https://url.com" "/imagen.png" "Descripción" */>}}
```
- Param 0: título
- Param 1: URL
- Param 2: URL de imagen (default: "/ggplot2_empty_hex.png")
- Param 3: descripción

Funciona similar a `externo`

---

## Layout

### `columnas` / `columna` / `fin_columnas`
Layout de dos columnas (48% cada una, apiladas en móvil ≤600px).
```
{{</* columnas */>}}
Contenido columna izquierda
{{</* columna */>}}
Contenido columna derecha
{{</* fin_columnas */>}}
```

---

## Contenido relacionado

### `relacionada`
Tarjeta de post relacionado con thumbnail y excerpt.
```
{{</* relacionada "blog/nombre-del-post" */>}}
{{</* relacionada "blog/nombre-del-post" "Ver también" */>}}
```
- Param 0: ruta relativa al post desde content/ (requerido)
- Param 1: etiqueta (default: "Publicaciones relacionadas")
- Muestra thumbnail, título y excerpt (max 200 chars)

Se usa cada vez que en una publicación se esté hablando de una temática que cuenta con un post o tutorial, y se inserta entremedio de párrafos, como si fuera publicidad. Usar frecuentemente para permitir que usuarios/as puedan avanzar hacia otras temáticas que podrían interesarles.

### `etiqueta`
Muestra hasta 5 posts recientes de un tag específico.
```
{{</* etiqueta "nombre-del-tag" */>}}
{{</* etiqueta "nombre-del-tag" "Más sobre esto" */>}}
```
- Param 0: nombre del tag (requerido)
- Param 1: etiqueta personalizada (opcional)
- Excluye la página actual

Se usa al final de todas las publicaciones, para darle a los lectores/as la posibilidad de encontrar más publicaciones relacionadas en base a la etiqueta del post que se está tratando, o entre medio de una publicación que trata sobre un tema muy amplio y se quieren mostrar ejemplos de cosas.


## Otros

### `indice`
Tabla de contenidos auto-generada desde headings del post.
```
{{</* indice */>}}
```
- Colapsable por defecto. Para abrirlo: `{{</* indice "" "" "open" */>}}`

Se usa en publicaciones muy extensas, para facilitar la navegación, al principio de la publicación pero debajo de un primer párrafo introductorio.

### `cafecito`
Widget "Buy Me a Coffee" (usuario: bastimapache).
```
{{</* cafecito */>}}
```

Se pone al final final de todas las publicaciones.

### `cursos`
Banner de promoción de cursos de R.
```
{{</* cursos */>}}
```
Se pone antes del `cafecito`, y sirve para que cuando esté promocionando un curso, el banner aparezca en publicaciones que tienen que ver estrictamente con aprender R.

### `icono`
Ícono Font Awesome con estilos inline opcionales.
```
{{</* icono "fas fa-star" "color: red; font-size: 24px;" */>}}
```


### `gist`
Embed de GitHub Gist.
```
{{</* gist "usuario" "gist-id" */>}}
{{</* gist "usuario" "gist-id" "archivo.R" */>}}
```

### `embed`
Iframe genérico.
```
{{</* embed "Título" "https://url.com" */>}}
```
- Altura: 500px, ancho: 100%, lazy loading

### Destacar líneas de código

No es un shortcode sino sintaxis de Hugo:
````
```r {hl_lines=["5-9"]}
código aquí
```
````
Las líneas no destacadas se atenúan automáticamente (opacity 0.4, via CSS custom). Pero solamente funciona cuando son bloques de código no interpretables.
