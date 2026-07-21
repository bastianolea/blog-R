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

# Crear post normal
blogdown::new_post(
  title = "Título",
  file = paste0("blog/", lubridate::today(), "/index.qmd"),
  author = "Bastián Olea Herrera",
  tags = c("tag1", "tag2")
)

# Crear post con slug semántico
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


## Tema y colores

Ver [references/theme.md](references/theme.md) para paleta de colores, tipografía y SCSS.
