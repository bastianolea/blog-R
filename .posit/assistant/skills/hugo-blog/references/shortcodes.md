# Shortcodes Reference

Todos los shortcodes están en `layouts/shortcodes/`. Usan la paleta púrpura del blog y soportan markdown en parámetros de texto (via `| markdownify`).

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
Imagen centrada y clickeable (abre original en nueva pestaña).
```
{{</* imagen "archivo.png" */>}}
{{</* imagen "archivo.png" "500px" */>}}
```
- Param 0: URL de imagen (requerido)
- Param 1: max-width (default: "700px")
- Ancho: 80%, centrada, border-radius 5px

### `imagen_tamaño`
Imagen con ancho personalizado.
```
{{</* imagen_tamaño "archivo.png" "60%" */>}}
```
- Param 0: URL de imagen (requerido)
- Param 1: ancho (default: "50%")

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

### `imagen_cuadricula`
Imágenes en grilla de 2 columnas. Usar múltiples shortcodes seguidos sin espacios entre ellos.
```
{{</* imagen_cuadricula "img1.png" "Caption 1" */>}}
{{</* imagen_cuadricula "img2.png" "Caption 2" */>}}
```
- Param 0: URL de imagen (requerido)
- Param 1: texto de caption (opcional)
- Max-width: 128px por imagen

---

## Video

### `video`
Video autoplay en loop, contenedor con max-width 70%.
```
{{</* video "video.mp4" */>}}
{{</* video "video.mp4" "80%" */>}}
```
- Param 0: URL del video (requerido)
- Param 1: max-width (default: "100%")

### `video_ancho`
Video autoplay a ancho completo (100%).
```
{{</* video_ancho "video.mp4" */>}}
```
- Param 0: URL del video (requerido)

---

## Cajas de texto

### `aviso`
Caja de advertencia con ícono de triángulo.
```
{{</* aviso "Mensaje de advertencia" */>}}
```
- Fondo oscuro (#493365), texto claro (#EAD2FA), ícono `fa-triangle-exclamation`

### `info`
Caja informativa con ícono de info.
```
{{</* info "Información importante" */>}}
```
- Fondo claro (#DEC4F2), ícono `fa-info-circle`

### `detalles`
Sección colapsable (HTML `<details>`).
```
{{</* detalles "Título clickeable" */>}}
Contenido oculto aquí
{{</* /detalles */>}}
```
- Param 0: texto del summary (default: "**Ver código**")
- Borde púrpura, fondo tenue

### `bajada`
Texto de subtítulo, centrado, pequeño (80%) y tenue (60% opacity).
```
{{</* bajada "Texto introductorio" */>}}
```

---

## Botones y enlaces

### `boton`
Botón estilizado con ícono Font Awesome.
```
{{</* boton "Texto" "https://url.com" "fas fa-download" */>}}
```
- Param 0: texto del botón (requerido)
- Param 1: URL (requerido)
- Param 2: clase de ícono FA (default: "fab fa-github")
- Fondo: #9069C0

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

### `extension`
Tarjeta para paquetes/extensiones de ggplot2.
```
{{</* extension "Nombre" "https://url.com" "/imagen.png" "Descripción" */>}}
```
- Param 0: título
- Param 1: URL
- Param 2: URL de imagen (default: "/ggplot2_empty_hex.png")
- Param 3: descripción

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

### `rawhtml`
Pasar HTML sin procesar por Markdown.
```
{{</* rawhtml */>}}
<div>HTML directo</div>
{{</* /rawhtml */>}}
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

### `etiqueta`
Muestra hasta 5 posts recientes de un tag específico.
```
{{</* etiqueta "nombre-del-tag" */>}}
{{</* etiqueta "nombre-del-tag" "Más sobre esto" */>}}
```
- Param 0: nombre del tag (requerido)
- Param 1: etiqueta personalizada (opcional)
- Excluye la página actual

### `categoria`
Muestra hasta 5 posts recientes de una categoría.
```
{{</* categoria "Tutoriales" */>}}
{{</* categoria "Tutoriales" "Otros tutoriales" */>}}
```
- Mismos parámetros que `etiqueta`

---

## Otros

### `indice`
Tabla de contenidos auto-generada desde headings del post.
```
{{</* indice */>}}
```
- Colapsable por defecto. Para abrirlo: `{{</* indice "" "" "open" */>}}`

### `cafecito`
Widget "Buy Me a Coffee" (usuario: bastimapache).
```
{{</* cafecito */>}}
```

### `cursos`
Banner de promoción de cursos de R.
```
{{</* cursos */>}}
```

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
Las líneas no destacadas se atenúan automáticamente (opacity 0.4, via CSS custom).
