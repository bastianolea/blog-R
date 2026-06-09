---
name: hugo-blog
description: >
  Reference for Bastián Olea's Hugo blog structure, conventions, and workflows.
  Use when assisting with blog content creation, layout modifications, theme
  customization, shortcode usage, Hugo configuration, or any task involving this
  blog's file structure. Triggers on mentions of blog, post, Hugo, blogdown,
  shortcode, layout, theme, deploy, or Netlify.
---

# Hugo Blog Reference

Blog de análisis de datos de Bastián Olea Herrera.
- **URL**: https://bastianoleah.netlify.app/ (alias: https://bastianolea.rbind.io/)
- **Idioma**: Español (es-ES)

## Stack

- **Hugo** 0.136.5 con tema **Hugo Apéro**
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
├── tutoriales/            # Tutoriales
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
- `categories` — categorías principales (Tutoriales, etc.)
- `series` — series de posts relacionados

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

## Menús de navegación

**Header**: Yo, Blog, Buscar (`/buscar/`), Temas (`/tags/`), Tutoriales (`/categories/tutoriales/`), Aprende R (externo), Cursos, Apps (externo), Datos (externo), Enlaces

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
