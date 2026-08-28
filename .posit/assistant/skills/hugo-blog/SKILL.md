---
name: hugo-blog
description: >
  Reference for Bastián Olea's Hugo blog structure, conventions, and workflows.
  Use when assisting with blog content creation, layout modifications, theme
  customization, shortcode usage, Hugo configuration, or any task involving this
  blog's file structure. Triggers on mentions of blog, post, Hugo, blogdown,
  shortcode, layout, theme, deploy, or Netlify.
---

# Referencia para blog Hugo

Blog de análisis de datos de Bastián Olea Herrera.
- **URL**: https://bastianolea.rbind.io/
- **Idioma**: Español (es-ES)

## Stack

- **Hugo** con tema **Hugo Apéro**
- **blogdown** para integración con RStudio
- **Formatos de contenido**: `.qmd` (Quarto), `.Rmd`, `.md`
- **Deploy**: Netlify (auto-deploy desde Git)
- **Markdown handler**: Goldmark (unsafe HTML habilitado)
- **Comentarios**: Utterances (repo: `bastianolea/blog-R`)
- **Analytics**: GoatCounter (`bastimapache`) https://bastimapache.goatcounter.com
- **Math**: KaTeX

## Estructura de contenido

```
content/
├── _index.md              # Homepage (type: home)
├── blog/                  # Posts principales (150+)
│   ├── _index.md          # Índice del blog con cascade config
│   ├── 2025-01-12/        # Posts con fecha (YYYY-MM-DD/index.md|qmd)
│   ├── mapas_sf/          # Posts con slug semántico
│   └── r_introduccion/    # Sección con sub-posts anidados
├── about/                 # Página "Sobre mí" (modular: header/, main/, sidebar/)
├── apps/                  # Apps Shiny
├── clases/                # Cursos
├── tutoriales/            # Sección Tutoriales (solo _index.md, listado real en /categories/tutoriales/)
├── paquetes/              # Sección Paquetes (solo _index.md, listado real en /categories/paquetes/)
└── form/                  # Formularios de contacto
```

**Convención de posts**: cada post es un bundle (carpeta con `index.md` o `index.qmd` + archivos asociados). Se usan dos patrones de nombre:
- Carpetas con fecha: `blog/2025-01-12/index.qmd`
- Carpetas con slug: `blog/mapas_sf/index.md`

## Front matter de posts (YAML)

```yaml
---
title: "Título del post"
subtitle: "Subtítulo opcional"
author: "Bastián Olea Herrera"
date: '2025-01-12'
slug: []
categories: [Tutoriales]
tags: [visualización de datos, mapas, ggplot2]
layout: single-sidebar
draft: false
excerpt: "Descripción breve para listados"
links:
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://github.com/...
---
```

El cascade en `content/blog/_index.md` aplica por defecto:
- `layout: single-sidebar`
- `show_author_byline: true`
- `show_comments: true`
- `show_post_date: true`
- `show_page_views: false` (medidas con GoatCounter)


## Taxonomías

- `tags` — etiquetas temáticas (visualización de datos, shiny, inteligencia artificial, etc.)
- `categories` — categorías principales: `Tutoriales`, `Paquetes`
- `series` — series de posts relacionados


### Cómo funcionan las secciones por categoría (Tutoriales, Paquetes)

Los posts viven en `content/blog/`, no en la carpeta de la sección. El listado de posts se obtiene via la taxonomía de Hugo:

- Un post con `categories: [Tutoriales]` aparece automáticamente en `/categories/tutoriales/`
- Un post con `categories: [Paquetes]` aparece automáticamente en `/categories/paquetes/`
- Las carpetas `content/tutoriales/` y `content/paquetes/` existen solo con su `_index.md` (metadata de sección), pero **no contienen posts**
- El menú en `config.toml` apunta directamente a la URL de taxonomía (ej. `/categories/paquetes/`)
- El layout usado para estas páginas de taxonomía es `layouts/taxonomy/term.html`

**Para agregar una nueva sección de categoría:**
1. Agregar `categories: [NombreCategoria]` en el front matter del post
2. Opcionalmente crear `content/nombre-categoria/_index.md` con metadata
3. Agregar entrada en `[[menu.header]]` en `config.toml` apuntando a `/categories/nombre-categoria/`


### Descripciones de páginas de etiquetas (tags)

El layout `layouts/taxonomy/term.html` ya renderiza `.Description` bajo el título en todas las páginas de taxonomía (tanto categorías como tags). Para agregar texto descriptivo a una página de etiqueta como `/tags/limpieza-de-datos/`, basta con crear un archivo `_index.md` dentro de `content/tags/{slug}/`:

```
content/tags/limpieza-de-datos/_index.md
```

```yaml
---
title: Limpieza de datos
description: |
  Texto descriptivo de la etiqueta.
---
```

**Notas sobre slugs**: Hugo slugifica los nombres de los tags eliminando acentos y reemplazando espacios con guiones. Ejemplos:
- `visualización de datos` → `visualizacion-de-datos`
- `gráficos` → `graficos`
- `básico` → `basico`
- `Chile` → `chile`

Los `_index.md` de tags ya creados con descripción: `chile`, `datos`, `visualizacion-de-datos`, `consejos`, `graficos`, `shiny`, `apps`, `basico`, `ggplot2`, `web-scraping`, `limpieza-de-datos`.


## Configuración clave (config.toml)

- `pagination.pagerSize = 20`
- `buildFuture = true` (permite posts con fecha futura)
- `ignoreFiles`: `.Rmd`, `.Rmarkdown`, `.qmd`, `.knit.md`, `.utf8.md`, `_cache`
- `mainSections = ["blog", "apps", "about"]`
- `outputs.home = ["HTML", "RSS", "JSON"]` (JSON para buscador)
- Syntax highlighting: estilo `rose-pine-moon` con CSS personalizado en `static/css/syntax.css`


## Flujo de trabajo (blogdown + RStudio)

El script `_instrucciones.R` incluye los pasos generales para trabajar en el blog.

Para encontrar publicaciones recientes hay 2 funciones de R cargadas al abrir el proyecto:

- `abrir_post_reciente("creado", cantidad = 10)`
- `abrir_post_reciente("modificado", cantidad = 10)`

Otras funciones:

```r
# Previsualizar
blogdown::serve_site()
blogdown::stop_server()

# Crear post normal (usar crear_publicacion() para posts .qmd, ver más abajo)
crear_publicacion(
  title = "Título",
  file = paste0("blog/", lubridate::today(), "/index.qmd"),
  author = "Bastián Olea Herrera",
  tags = c("tag1", "tag2")
)

# Crear post con slug semántico (.md no necesita _quarto.yml, blogdown::new_post() basta)
blogdown::new_post(
  title = "Título",
  file = "blog/nombre-slug/index.md",
  author = "Bastián Olea Herrera",
  tags = c("tag1"),
  categories = c("Tutoriales")
)

# Abrir post reciente (función custom en R/funciones.R)
abrir_post_reciente("creado", cantidad = 10)
abrir_post_reciente("modificado", cantidad = 10)

# Construir sitio
blogdown::build_site()
```

**Opciones de .Rprofile**: `blogdown.serve_site.startup = TRUE`, `blogdown.knit.on_save = TRUE`, `blogdown.method = 'markdown'`.

Para posts `.qmd`, agregar al front matter:
```yaml
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
```


## Botón Render de RStudio en posts `.qmd` (requiere `_quarto.yml`)

**Problema (detectado 2026-08-28):** al presionar el botón **Render** en un `.qmd` del blog, RStudio ejecuta `quarto preview index.qmd --to hugo-md --no-watch-inputs --no-browse`, y falla con:
```
Error in rmarkdown:::abs_path(input) : The file 'index.qmd' does not exist.
```
Esto ocurre **incluso ejecutando el comando desde la carpeta correcta del post** — no es un problema de directorio de trabajo. Se confirmó empíricamente que `quarto render index.qmd` (sin `preview`) funciona bien sin `_quarto.yml`, pero `quarto preview` (que es lo que usa el botón Render) en Quarto 1.9.37 **requiere que el documento pertenezca a un proyecto Quarto** para resolver la ruta del archivo; sin un `_quarto.yml` en la carpeta del post, falla con ese error de `abs_path`.

**Solución:** agregar un `_quarto.yml` vacío en la carpeta del post. Esto no tiene relación con los `_quarto.yml` de otros posts (`mapas_sf`, `mapas_hexagonales`, etc., usados para el patrón de `freeze`) — cada carpeta necesita el suyo de forma independiente, Quarto no considera carpetas hermanas.

**Automatizado:** la función `crear_publicacion()` en `R/funciones.R` (envoltorio de `blogdown::new_post()`) crea automáticamente el `_quarto.yml` cuando el post es `.qmd`, y además navega el panel Files a la carpeta nueva. Usarla en vez de `blogdown::new_post()` directamente para posts Quarto.

**Qué muestra el botón Render:** aun con `_quarto.yml`, el Viewer de RStudio tras un Render muestra el **markdown crudo** (`hugo-md`), no el sitio con el tema aplicado — eso es esperado, porque Quarto no conoce Hugo/el tema. Para ver el post integrado en el sitio, se debe usar `blogdown::serve_site()` (con `blogdown.knit.on_save = TRUE`, ya configurado en `.Rprofile`): al guardar el `.qmd`, blogdown lo re-renderiza y el sitio se actualiza solo. El botón Render sirve principalmente para confirmar que el `.qmd` ejecuta sin errores de R.

**Ruido inofensivo en consola:** con `_quarto.yml` presente, al usar Render (o al guardar el archivo) puede aparecer en consola:
```
Rendering content/blog/.../index.rmarkdown...
Error in abs_path(input) : The file 'index.rmarkdown' does not exist.
```
Es una condición de carrera benigna, no un fallo real: Quarto crea un archivo temporal `index.rmarkdown` de compatibilidad al renderizar un `.qmd` que pertenece a un proyecto, y el watcher de contenido de `blogdown::serve_site()` — que reconoce archivos vía el patrón `blogdown:::rmd_pattern` (`[.][Rr](md|markdown)$`, el cual calza con `.rmarkdown`) — intenta knitear ese archivo temporal justo cuando Quarto ya lo borró. El knit real del `.qmd` (el que sí actualiza el sitio) ya ocurrió por el canal normal de blogdown antes de esa carrera, así que el sitio se actualiza correctamente pese al error visible.


## Archetype de posts nuevos (`archetypes/blog.md`)

El front matter por defecto que se aplica a los posts creados con `blogdown::new_post()` (o `crear_publicacion()`, envoltorio en `R/funciones.R`) vive en **`archetypes/blog.md`** (archivo plano en la raíz del proyecto), no en un archetype de tipo directorio (`archetypes/blog/index.md`).

**Por qué debe ser un archivo plano y no un directorio:** `blogdown::new_post()` siempre construye la ruta de destino completa incluyendo `index.md` (ej. `blog/nombre/index.md`) antes de invocar `hugo new`. Con esa ruta explícita, Hugo trata la creación como un archivo normal, no como un "leaf bundle", así que **nunca llega a buscar/usar un archetype de tipo directorio** (`archetypes/blog/index.md`) — cae directo a `archetypes/default.md`. El archetype de directorio solo se activa si Hugo mismo crea el bundle, es decir, si se invocara `hugo new blog/nombre` (sin `/index.md` en la ruta) — algo que blogdown no hace.

**Autor vacío en el front matter:** `new_post()` sobrescribe explícitamente el campo `author` con `getOption("blogdown.author")`, así que aunque el archetype tenga un `author` seteado, siempre queda pisado. Por eso `.Rprofile` fija `blogdown.author = "Bastián Olea Herrera"` — sin esa opción, el post nuevo queda con `author: ''`.

**Al editar el front matter por defecto de posts nuevos**, modificar `archetypes/blog.md` (no crear ni editar `archetypes/blog/index.md`, que quedaría sin efecto).


## Gráficos con fondo transparente (mapas y ggplot2)

Los gráficos deben tener **fondo transparente** para integrarse con el color de fondo del blog (morado claro). Hay dos piezas necesarias:

**1. Dispositivo transparente** (front matter del `.qmd`):
```yaml
knitr:
  opts_chunk:
    dev: "ragg_png"
    dev.args:
      bg: transparent
      background: transparent
```

**2. `plot.background` transparente en el tema.** Ojo: en ggplot2 4.0 el argumento `paper` de los temas (`theme_void(paper = ...)`, `theme_grey(paper = ...)`) **rellena `plot.background` con un color opaco**, lo que anula la transparencia del dispositivo. Hay que sobrescribirlo explícitamente:
```r
theme_set(
  theme_void(paper = "#EAD1FA", ink = "#543A73", accent = "#9069C0") +
    theme(plot.margin = unit(c(2, 2, 2, 2), "mm")) +
    # imprescindible: paper deja fondo opaco, esto lo vuelve transparente
    theme(plot.background = element_rect(fill = "transparent", color = "transparent"))
)
```

Para verificar la transparencia de un PNG generado: `sips -g hasAlpha archivo.png` (debe decir `hasAlpha: yes`) y el pixel de esquina debe ser `srgba(0,0,0,0)`, no blanco.


## Doble render de figuras: `figure-html` con fondo blanco (usar `freeze`)

**Problema:** en algunos posts las figuras aparecen con **bordes/fondo blanco** en el sitio, aunque el `.qmd` esté bien configurado. Al renderizar aparecen **dos** carpetas de figuras:
- `index.markdown_strict_files/figure-markdown_strict/` → transparentes (salida real de `quarto render`, respeta `dev.args`).
- `index_files/figure-html/` → **blancas** (dispositivo por defecto, ignora `dev.args`).

**Causa:** no es Quarto ni el `.qmd` (renderizar el mismo `.qmd` en aislamiento con `quarto render` produce una sola carpeta transparente). El `figure-html` blanco lo genera el **re-render automático de blogdown** (`blogdown.knit.on_save = TRUE` + servidor `serve_site` activo), que reprocesa el post por su pipeline knitr clásico usando un dispositivo con fondo blanco.

**Solución (comprobada):** replicar lo que hace el post `mapas_sf`, que es inmune porque nunca re-ejecuta el código:
1. En el YAML del post: `freeze: true`.
2. Crear un `_quarto.yml` **vacío** en la carpeta del post (lo vuelve un proyecto Quarto para que `_freeze/` se guarde ahí).
3. Renderizar una vez con `quarto render` (con los datos disponibles) para poblar `_freeze/`.

Con freeze activo, tanto Quarto como blogdown reutilizan las figuras congeladas transparentes y no vuelve a ocurrir la pasada con dispositivo blanco. Los posts `mapas_sf` y `mapas_hexagonales` ya usan este patrón (`_quarto.yml` vacío + `freeze: true`).

Alternativa más ligera: desactivar `blogdown.knit.on_save` para que solo mande `quarto render`, pero el patrón con `freeze` es el recomendado.


## Resaltar líneas de código en `.qmd` (hl_lines vs code-line-numbers)

**Problema:** en archivos `.md` normales, Hugo (con Chroma) resalta líneas de un bloque de código con `{hl_lines=["4-6"]}`. En archivos `.qmd`, la opción equivalente de Quarto es el chunk option `#| code-line-numbers: "4-6"`, pero **no tiene efecto** al renderizar con `format: hugo-md`.

**Causa:** `code-line-numbers` solo funciona en formatos HTML propios de Quarto (`html`, `revealjs`), donde Quarto inyecta su propio marcado HTML/JS. Con `hugo-md`, Quarto genera markdown plano para que Hugo lo procese con Chroma, y esa opción simplemente se descarta.

Tampoco basta con escribir un bloque de código Markdown plano (no ejecutable) con la sintaxis `{hl_lines=[...]}` de Hugo directamente en el `.qmd`: el escritor final de `hugo-md` es **GFM** (`gfm+yaml_metadata_block+definition_lists+smart`), y GFM descarta los atributos de los bloques de código, dejando solo el identificador de lenguaje (ej. ``` ```r {hl_lines=["4-6"]} ``` se convierte en ``` ```r ```, perdiendo el atributo).

**Solución (comprobada):** envolver el bloque de código en un raw block de Pandoc (` ```{=markdown} `), usando cuatro backticks para la valla exterior (para no chocar con los tres backticks del bloque de código interno). Esto le indica a Quarto/Pandoc que pase el contenido literal sin reinterpretarlo ni reescribirlo:

````
````{=markdown}
```r {hl_lines=["4-6"]}
library(shiny)
library(bslib)

ui <- page_fillable(
  h1("Párrafo interactivo")
)
```
````
````

Nota: usar este patrón solo para bloques de código **no ejecutables** (de documentación), no para chunks `{r}` que efectivamente corren código — para esos, no hay forma de aplicar `hl_lines` vía chunk options; hay que convertirlos primero a bloque estático con el resultado ya calculado si se necesita resaltar líneas.

Verificar siempre el `.md` resultante tras `quarto render` (buscar el atributo `hl_lines` en el archivo) porque el raw block puede alterar el espaciado en líneas en blanco alrededor del bloque (ej. eliminar la línea vacía antes de un shortcode siguiente como `{{< imagen ... >}}`); conviene revisar visualmente el post tras el build de Hugo.


## Menús de navegación

**Header**: Yo, Blog, Buscar (`/buscar/`), Temas (`/tags/`), Tutoriales (`/categories/tutoriales/`), Paquetes (`/categories/paquetes/`), Aprende R (externo), Cursos, Apps (externo), Datos (externo), Enlaces

**Footer**: Licencia, Código de conducta, Contacto, Sobre mi, Buscar (`/buscar/`), Temas, Clases

El ícono de lupa en `params.social` (header) también apunta a `/buscar/`.


## Redirects

Archivo `static/_redirects` para migraciones de URL y dominios. Redirecciones de `bastianoleah.netlify.com` → `bastianolea.rbind.io`.


## Archivos clave (mapa rápido)

| Propósito | Archivo |
|-----------|---------|
| Configuración Hugo | `config.toml` |
| Tema de colores | `assets/tema-morado-hex.scss` |
| CSS personalizado | `assets/custom.scss` |
| Syntax highlighting CSS | `static/css/syntax.css` |
| Homepage layout | `layouts/index.html` |
| Post individual | `layouts/blog/single-sidebar.html` |
| Lista de blog | `layouts/blog/list-sidebar.html` |
| Post con serie | `layouts/blog/single-series.html` |
| Taxonomía (tags) | `layouts/taxonomy/term.html` |
| Sidebar del blog | `layouts/partials/shared/sidebar/sidebar-header.html` |
| Summaries (blog list) | `layouts/partials/shared/summary.html` |
| Summaries (tags) | `layouts/partials/shared/summary-thumbnail.html` |
| Meta/SEO tags (override raíz) | `layouts/partials/meta.html` |
| Paginación prev/next (override raíz) | `layouts/partials/shared/post-pagination.html` |
| Buscador JSON | `layouts/index.json` |
| Página buscador (iframe Shiny) | `content/buscar/_index.md` |
| Layout buscador con iframe | `layouts/buscar/list.html` |
| iframeResizer (script local) | `static/js/iframeResizer.min.js` |
| Redirects | `static/_redirects` |
| Funciones R custom | `R/funciones.R` |
| Instrucciones workflow | `_instrucciones.R` |


## Shortcodes

Ver [references/shortcodes.md](references/shortcodes.md) para la referencia completa.

Shortcodes más usados:
- `{{</* imagen "archivo.png" */>}}` — imagen clickeable centrada, con opción de limitar ancho
- `{{</* video "archivo.mp4" */>}}` — video autoplay
- `{{</* aviso "mensaje" */>}}` — caja de advertencia
- `{{</* info "mensaje" */>}}` — caja informativa
- `{{</* detalles "título" */>}} contenido {{</* /detalles */>}}` — sección colapsable
- `{{</* boton "texto" "url" "icono" */>}}` — botón con ícono
- `{{</* indice */>}}` — tabla de contenidos auto-generada
- `{{</* relacionada "blog/estudio_brechas_comunales/" */>}}` — caja con publicación relacionada, con imagen y resumen
- `{{</* etiqueta "apps" */>}}` — caja que contiene varias publicaciones recientes de un tag
- `{{</* paso "1" "Instrucciones del paso uno" */>}}` — paso numerado para tutoriales, círculo con número a la izquierda del texto


## Páginas personalizadas con iframe

La página `/buscar/` embebe la app Shiny del buscador (`https://bastianoleah.shinyapps.io/buscador/`) dentro del sitio, manteniendo el header y footer habituales.

**Patrón para crear una página de sección con layout propio:**
1. Crear `content/{seccion}/_index.md` con front matter mínimo
2. Crear `layouts/{seccion}/list.html` definiendo solo el bloque `{{ define "main" }}` — `baseof.html` inyecta el header y footer automáticamente

**iframeResizer** (v4) se usa para que el iframe ajuste su alto al contenido de la app:
- Blog (padre): `static/js/iframeResizer.min.js` + `iFrameResize({ checkOrigin: false }, '#buscador-iframe')` en el layout
- App Shiny (hijo): `www/iframeResizer.contentWindow.min.js` + `tags$script(src = "iframeResizer.contentWindow.min.js")` en el UI
- El script contentWindow vive en `/Users/baolea/R/blog_buscador/www/`
- Al modificar la app Shiny hay que redesplegarla a shinyapps.io

**JS estático en Hugo**: los archivos en `static/` se sirven desde la raíz del sitio. Por ej. `static/js/foo.js` → `/js/foo.js`. Preferir scripts descargados localmente sobre CDN externos.


## Layouts y templates

Ver [references/layouts.md](references/layouts.md) para el mapa completo de layouts.

**Nunca editar archivos dentro de `themes/hugo-apero/`.** Para modificar cualquier template (layout, partial o shortcode), copiar el archivo a la misma ruta bajo `layouts/` y modificar la copia: Hugo prioriza la carpeta `layouts/` raíz del proyecto sobre la del tema. Así las actualizaciones del tema no pisan los cambios locales. El tema está vendido en el repo (sin submódulo), pero igual conviene dejarlo intacto.

Pasos:
1. Copiar `themes/hugo-apero/layouts/<ruta>` → `layouts/<ruta>` (misma ruta relativa).
2. Modificar la copia.
3. Verificar en el build que el output cambió. Si el sitio no cambia, revisar que la ruta sea correcta y que no exista otro override que esté ganando.

Overrides raíz existentes: `layouts/blog/single-sidebar.html`, `layouts/blog/list-sidebar.html`, `layouts/blog/single-series.html`, `layouts/partials/shared/summary.html`, `layouts/partials/shared/summary-thumbnail.html`, `layouts/partials/meta.html`, `layouts/partials/shared/post-pagination.html`, `layouts/partials/shared/post-details.html`, `layouts/partials/shared/date-range.html`, `layouts/partials/shared/event-details.html`, entre otros.


## Limpieza de markdown en títulos (SEO, metadatos y paginación)

**Problema:** si el título del post contiene markdown (como backticks `` `{paquete}` ``), los símbolos aparecen crudos en los lugares donde Hugo imprime `.Title` directamente (paginación prev/next, breadcrumbs, listados, metadatos), y los buscadores pueden mostrarlos u omitir el texto dentro de los backticks.

**Regla clave (comprobada con Hugo 0.164, 2026-08-07):** `plainify` **NO** elimina markdown ni backticks — solo quita etiquetas HTML. El patrón correcto para dejar un título como texto plano es **`markdownify | plainify`**: primero se renderiza el markdown a HTML (`` `{paquete}` `` → `<code>{paquete}</code>`) y después se eliminan las etiquetas (→ `{paquete}`).

### Paginación prev/next (post-pagination)

El override raíz `layouts/partials/shared/post-pagination.html` (copia del partial del tema) usa el patrón correcto en ambos enlaces:

```html
<a class="prev dtc pr2 tl v-top fw6" href="{{.Permalink}}">&larr; {{.Title | markdownify | plainify}}</a>
<a class="next dtc pl2 tr v-top fw6" href="{{.Permalink}}">{{.Title | markdownify | plainify}} &rarr;</a>
```

> **Sobre la práctica:** para modificar cualquier template no se edita el tema — se copia el archivo a `layouts/` raíz y se modifica la copia (ver sección **Regla de oro: no editar el tema**).

### SEO y metadatos (meta.html)

El override raíz `layouts/partials/meta.html` (aplicado 2026-08-07) usa `markdownify | plainify` en `<title>` y `og:title` (el tema usa solo `plainify`, que **no** limpia backticks):

```html
<title>{{ if .IsHome }}{{ .Title | markdownify | plainify }}{{ else }}{{ .Page.Title | markdownify | plainify }} | {{ site.Title }}{{ end }}</title>
<meta property="og:title" content="{{ if .IsHome }}{{ .Title | markdownify | plainify }}{{ else }}{{ .Page.Title | markdownify | plainify }} | {{ site.Title }}{{ end }}">
```

Nota: `meta name="description"` y `og:description` usan `$desc` crudo (excerpt/subtitle/description del front matter). Si un excerpt contiene markdown con backticks, podría mostrarlo en buscadores; pendiente de revisar si conviene aplicar `markdownify | plainify` también ahí.

### Otros lugares con títulos crudos (no arreglados)

- `layouts/partials/shared/post-details.html` (sidebar "Ver también"): imprime `{{ .Title }}` crudo → muestra backticks.
- Tarjetas de listados (`summary.html`, `summary-thumbnail.html`): usan `{{ .Title | markdownify }}` → renderizan bien los backticks como `<code>`.

**Recomendación adicional:** en títulos con caracteres especiales como `{territorial}`, considerar usar nombres más SEO-friendly en el front matter del post, ej: `title: "territorial: un paquete de R para..."`.

## Formato de fecha inconsistente ("June 22, 2026" vs "22/6/2026")

**Problema (detectado 2026-08-27):** el formato de fecha estándar del blog es `2/1/2006` (día/mes/año, ej. `22/6/2026`), definido en la mayoría de partials del tema. Pero varios lugares quedaron con el formato original de Hugo Apéro (`January 2, 2006`, ej. `June 22, 2026`) porque nunca se sobrescribieron en `layouts/`, aunque otros partials del mismo tipo de página sí estaban corregidos. Esto se notó específicamente en la sección `clases/` (`type: talk`), que usa partials distintos a los de `blog/`.

**Partials afectados y ya corregidos (overrides en `layouts/partials/shared/`):**
- `post-details.html`: bloque colapsable "Fecha de publicación" al final del post (usado por `_default/single.html` y `talk/single.html`). Cambiado de `"January 2, 2006"` a `"2/1/2006"`.
- `date-range.html`: usado en `event-details.html` (fila "Fecha" del detalle de evento) y en `summary-compact.html` (listados tipo `talk`, ej. `/clases/`). Tenía tres formatos (`single_format`, `range_start_format`, `range_end_format`) todos en inglés con orden mes/día — se reescribieron a orden día/mes/año consistente con `2/1/2006`:
  ```
  {{ $single_format := "2/1/2006" }}
  {{ $range_start_format := "2" }}                  {{/* mismo mes: solo día */}}
  {{ $range_end_format := "2/1/2006" }}              {{/* mismo mes: día/mes/año completo */}}
  {{ $range_start_diff_month_format := "2/1" }}      {{/* distinto mes: día/mes */}}
  ```
- `event-details.html`: fila "Hora" — ver siguiente sección.

**Lección:** cuando se corrige un formato de fecha, buscar **todos** los partials que llaman a `.PublishDate.Format`, `.Date.Format` o `(time ...).Format` (no solo los que aparecen en la página que se está mirando), porque el tema tiene múltiples layouts para distintos tipos de contenido (`blog`, `talk`, `project`) que no siempre comparten los mismos partials de fecha.

**Comando útil para auditar:** `grep -rn '\.Format "' themes/hugo-apero/layouts layouts` para listar todos los formatos de fecha usados en plantillas y detectar cuáles siguen en formato inglés.


## Ocultar la hora cuando el evento no tiene horario definido (posts de `clases/`)

**Problema:** en `content/clases/`, los posts de tipo `talk` muestran una sección "Hora" (vía `event-details.html` → `time-range.html`) debajo de la fecha del evento. Si el front matter solo tiene `date: '2026-07-29'` (sin hora), Hugo interpreta la hora como medianoche (`00:00:00`) y el sitio muestra incorrectamente **"12:00 AM"**, en vez de omitir la fila. Los posts que sí especifican hora (ej. `date: "2025-08-22T18:00:00.000Z"`) se ven bien.

**Solución (override en `layouts/partials/shared/event-details.html`):** antes de renderizar la fila "Hora", se calcula si `.Date` (o `.Params.date_end`, si existe) tiene una hora distinta de medianoche, y solo entonces se muestra la fila:

```
{{ $has_time := or (ne (time .Date).Hour 0) (ne (time .Date).Minute 0) }}
{{ with .Params.date_end }}
  {{ if or (ne (time .).Hour 0) (ne (time .).Minute 0) }}{{ $has_time = true }}{{ end }}
{{ end }}
{{ if $has_time }}
  <!-- fila "Hora" -->
{{ end }}
```

**Limitación conocida:** si un evento real comenzara exactamente a medianoche (00:00), esta lógica ocultaría la hora igualmente (falso negativo). Se considera un caso lo bastante raro como para no justificar un parámetro explícito adicional (ej. `show_event_time` en el front matter), pero si llega a pasar, esa sería la alternativa.


## Tema y colores

Ver [references/theme.md](references/theme.md) para paleta de colores, tipografía y SCSS.


## Diagramas Mermaid

Los saltos de línea son con `<br>`, no con `\n`

Usar el tema de Mermaid `base`. Agregar al yaml:

```yaml
format:
  hugo-md:
    mermaid:
      theme: base
```

Por ejemplo, este es un diagrama Mermaid bien hecho:

```{mermaid}
flowchart TD
  subgraph A1[Contexto]
    A(transcripción) --> D(skills de escritura y blog)
    B(diapositivas) --> D
    C(tutorial previo) --> D
  end

  subgraph B1[" "]
    E(prompt inicial)
    E --> F["planificación (IA)"]
    F --> G(modificación manual de planificación)
  end

  D --> E
  G --> H(prompt para redacción)
  H --> I["generación de texto (IA)"]
  I --> J(revisión y mejora manual del texto final)
```
