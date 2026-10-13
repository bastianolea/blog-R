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

## Inventario del sitio (relevado 2026-10-13)

Resumen del estado del sitio para no tener que re-explorarlo. Las cifras son aproximadas y cambian con cada post; re-verificar si una tarea depende de un número exacto.

**Versión y build**
- Hugo **0.164.0 extended** (local y en Netlify, fijado en `netlify.toml` con `HUGO_VERSION`).
- `netlify.toml`: `command = 'hugo'`, `publish = 'public'`; branch-deploy y deploy-preview usan `hugo -F -b $DEPLOY_PRIME_URL`; producción define `HUGO_ENV = 'production'`. Netlify **no** corre R ni Quarto: compila los `.md`/`.markdown` ya commiteados.
- `public/` y `resources/` están en `.gitignore`.
- Un build completo local toma ~8–13 s.

**Contenido** (en `content/blog/`)
- ~230 `index.md` + ~54 `index.markdown` (Rmarkdown antiguo, vía blogdown) + 1 `index.html` (`blog/2025-07-27`, HTML crudo) + ~33 `.md`/`.markdown` sueltos (no `index`). Algunos bundles tienen tanto `index.md` como `index.markdown` sobrante.
- ~132 posts con fuente `.qmd` (renderizados a `index.md` con `hugo-md`); 0 `.Rmd`/`.Rmarkdown` en uso.
- ~220 posts publicados en `blog/` (descontando ~20 con `draft: true`). Otras secciones: `clases/` (12), `about/` (5, modular), páginas sueltas (`contacto`, `license`, `code-of-conduct`, `contributors`).
- Front matter: casi todos tienen `excerpt` (~248); ~62 tienen `subtitle`; **ninguno** usa `description`. Muchos tienen `links:` (icono + url).
- Categorías: `Tutoriales` (~111 posts), `Paquetes`.
- Tags más usados: Chile (59), visualización de datos (56), datos (43), consejos (39), gráficos (38), ggplot2 (37), blog (34), mapas (33), limpieza de datos (30), shiny (26), básico (26), apps (25), texto, inteligencia artificial, procesamiento de datos, curiosidades, web scraping (21–23).

**Layouts**
- Se usa el sistema **antiguo** de plantillas (`layouts/_default/`, `layouts/partials/`, `layouts/shortcodes/`), no el de Hugo 0.146+ (`_partials`, `_shortcodes`, `home.html`); Hugo 0.164 los sigue leyendo.
- Top-level de `layouts/`: `_default/`, `_markup/`, `about/`, `blog/`, `buscar/`, `form/`, `index.html`, `index.json`, `index.llms.txt`, `partials/`, `robots.txt`, `shortcodes/`, `taxonomy/`.
- El `<head>` está en `layouts/partials/head.html`; recorre `.AlternativeOutputFormats` para emitir los `<link rel="alternate">` (RSS, JSON, Markdown).
- `config.toml` no tenía `[outputFormats]`/`[mediaTypes]` antes de la salida para LLMs.

**Shortcodes propios** (`layouts/shortcodes/`, 30 + `blogdown/postref`) y usos aproximados en el contenido:

| Shortcode | Usos | | Shortcode | Usos |
|---|---|---|---|---|
| `blogdown/postref` | 451 | | `cursos` | 83 |
| `imagen` | 444 | | `imagen_tamaño` | 38 |
| `relacionada` | 193 | | `indice` | 31 |
| `detalles` | 161 | | `extension` | 27 |
| `info` | 155 | | `video` | 23 |
| `boton` | 153 | | `paso`, `imagen_cuadricula` | 15 c/u |
| `cafecito` | 135 | | `imagen_lateral` | 10 |
| `bajada` | 115 | | `columnas`/`columna`/`fin_columnas`, `video_ancho`, `externo` | 6–8 |
| `etiqueta` | 112 | | `youtube` (integrado), `paquete`, `gist`, `figure` (integrado), `categoria`, `imagen_alto`, `embed` | 1–6 |
| `aviso` | 98 | | | |

Del tema (`themes/hugo-apero/layouts/shortcodes/`): `here`, `panel`, `panelset`. `blogdown/postref` imprime el permalink del post y aparece dentro de `<img src="...">` en los `.markdown` antiguos.

**Posts con salidas pesadas** (htmlwidgets embebidos en el `.md`): `mapas_mapgl`, `mapas_censo_2024` (JSON de varios MB), `ggiraph`, `ggrepel` (SVG en JSON), `tablas_gt`, `gt_pildoras` (tablas gt con CSS), `colores`. `excel_openxlsx` imprime un data frame gigante (~3.5 MB).

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
├── blog/                  # Posts principales (~220 publicados)
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
seo_title: "Título para buscadores (opcional, reemplaza el <title> completo)"
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
- `timeZone = "America/Santiago"`
- `enableRobotsTXT = true` con plantilla en `layouts/robots.txt` (incluye la línea `Sitemap:`)
- `[sitemap] changeFreq = "weekly"`
- `[minify] minifyOutput = true` (Netlify compila con `hugo` sin `--minify`; si algo se ve raro en un post, probar quitando este bloque)
- `params.favicon = "/favicon.ico"` (antes era `false` y generaba `href="false"`)
- `params.description`: descripción por defecto del sitio, usada en páginas sin `description`/`subtitle`/`excerpt`
- `textFontFamily`/`headingFontFamily` parecen redundantes con las fuentes custom, pero `assets/scaffold.scss` los usa como respaldo: no borrarlos
- Limpieza 2026-10-12: se eliminaron claves obsoletas (`preserveTaxonomyNames`, `metaDataFormat`, `footnoteReturnLinkContents`, `googleAnalytics`) y la configuración sin uso de Disqus y giscus. Comentarios: solo queda configurado utterances, pero `params.comments = ""` los mantiene desactivados


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

**Solución:** agregar un `_quarto.yml` vacío en la carpeta del post. Esto no tiene relación con los `_quarto.yml` de otros posts (`mapas_sf`, `mapas_hexagonales`, etc., usados para el patrón de `freeze`) — cada carpeta necesita el suyo de forma independiente, Quarto no considera carpetas hermanas. **Ojo:** el `_quarto.yml` es solo para el botón Render y el patrón `freeze`; **no** corrige la reescritura de enlaces absolutos que hace Quarto (ver sección «Enlaces internos rotos» más abajo) — se comprobó que un post con `_quarto.yml` igual queda con los enlaces rotos al renderizar.

**Automatizado:** la función `crear_publicacion()` en `R/funciones.R` (envoltorio de `blogdown::new_post()`) crea automáticamente el `_quarto.yml` cuando el post es `.qmd`, y además navega el panel Files a la carpeta nueva. Usarla en vez de `blogdown::new_post()` directamente para posts Quarto.

**Qué muestra el botón Render:** aun con `_quarto.yml`, el Viewer de RStudio tras un Render muestra el **markdown crudo** (`hugo-md`), no el sitio con el tema aplicado — eso es esperado, porque Quarto no conoce Hugo/el tema. Para ver el post integrado en el sitio, se debe usar `blogdown::serve_site()` (con `blogdown.knit.on_save = TRUE`, ya configurado en `.Rprofile`): al guardar el `.qmd`, blogdown lo re-renderiza y el sitio se actualiza solo. El botón Render sirve principalmente para confirmar que el `.qmd` ejecuta sin errores de R.

**Ruido inofensivo en consola:** con `_quarto.yml` presente, al usar Render (o al guardar el archivo) puede aparecer en consola:
```
Rendering content/blog/.../index.rmarkdown...
Error in abs_path(input) : The file 'index.rmarkdown' does not exist.
```
Es una condición de carrera benigna, no un fallo real: Quarto crea un archivo temporal `index.rmarkdown` de compatibilidad al renderizar un `.qmd` que pertenece a un proyecto, y el watcher de contenido de `blogdown::serve_site()` — que reconoce archivos vía el patrón `blogdown:::rmd_pattern` (`[.][Rr](md|markdown)$`, el cual calza con `.rmarkdown`) — intenta knitear ese archivo temporal justo cuando Quarto ya lo borró. El knit real del `.qmd` (el que sí actualiza el sitio) ya ocurrió por el canal normal de blogdown antes de esa carrera, así que el sitio se actualiza correctamente pese al error visible.


## Enlaces internos rotos: Quarto reescribe rutas absolutas (`/seccion/` → `./seccion/`)

**Problema (diagnosticado 2026-08-31):** en posts `.qmd`, los enlaces markdown a secciones del sitio escritos como rutas absolutas de Hugo (ej. `[texto](/tags/reproducibilidad/)`, `[texto](/blog/otro-post/)`) aparecen en el `index.md` generado con un punto antepuesto: `[texto](./tags/reproducibilidad/)`. Ese `./` hace que Hugo los resuelva **relativos a la página actual** (ej. `/blog/mi-post/tags/...`) en vez de a la raíz del sitio, produciendo 404.

**Causa (confirmada empíricamente):** es comportamiento propio de **Quarto/Pandoc**, no de Hugo ni del `_quarto.yml`. Para Hugo, `/x` = raíz del **sitio**; para Quarto, `/x` = raíz del **proyecto Quarto**, y al escribir a `hugo-md` reescribe esas rutas como relativas al documento de salida, anteponiendo `./`. Ocurre con `quarto render` a secas y **da igual si existe o no un `_quarto.yml`** en la carpeta (`mapas_sf`, que sí lo tiene, también se rompe al re-renderizarlo). Posts antiguos se veían bien solo porque fueron renderizados con una versión previa de Quarto que no reescribía; al re-renderizarlos con Quarto 1.9.37 se rompen.

**Qué sintaxis sobreviven la reescritura** (probado con Quarto 1.9.37):

| Sintaxis en el `.qmd` | Resultado en el `.md` |
|---|---|
| `[t](/blog/x/)` markdown normal | `./blog/x/` — roto |
| `[t](/blog/x/#ancla)` con ancla | `./blog/x/#ancla` — roto |
| `[t][ref]` estilo referencia | `./blog/x/` — roto |
| `<a href="/blog/x/">t</a>` HTML crudo | `/blog/x/` — intacto |
| `{{< aviso "[t](/blog/x/)" >}}` shortcode | `/blog/x/` — intacto |

Solo el HTML crudo y el contenido de shortcodes esquivan la reescritura, porque Quarto los pasa literales sin meterlos en el AST de Pandoc.

**Solución (implementada):** la función `corregir_enlaces_qmd()` en `R/funciones.R` recorre los `index.md` generados y devuelve la barra inicial (`./seccion/` → `/seccion/`) **solo** a los enlaces cuyo primer segmento es una sección/taxonomía del sitio (`blog`, `tags`, `categories`, `series`, `apps`, `about`, `clases`, `tutoriales`, `paquetes`, `buscar`, `form`). Restringir a esas secciones evita tocar figuras y recursos del bundle (`./index_files/...`, `./datos.csv`), que sí deben quedar relativos.

Se ejecuta desde **`R/build.R`**, que blogdown corre **antes** de que Hugo construya (dentro de `blogdown::build_site()`), de modo que el sitio publicado siempre queda con los enlaces correctos:
```r
# R/build.R
source("R/funciones.R")
corregir_enlaces_qmd()
```
La contraparte `revisar_enlaces_qmd()` (que solo **detecta** enlaces `](./...)` sin corregir) sigue llamándose desde `R/build2.R` como verificación post-build.

**Cuándo corre `build.R` (comprobado empíricamente 2026-08-31):** `build.R` se ejecuta en el build **completo** — es decir, en `blogdown::build_site()` y en el build **inicial** de `blogdown::serve_site()` — pero **no** en los rebuilds **incrementales** que hace `serve_site()` mientras está activo (esos los hace Hugo solo, sin pasar por R). Se verificó instrumentando `build.R` con un marcador con timestamp: aparece una entrada al arrancar `serve_site()`, pero un `quarto render` posterior (con el servidor activo) no agrega otra y el enlace queda roto.

**Ojo con el editing en vivo:** como `blogdown.knit.on_save = TRUE` re-renderiza el `.qmd` al guardar, el `index.md` vuelve a quedar con `./` tras cada guardado, y como el rebuild incremental no corre `build.R`, esos enlaces **no** se auto-corrigen durante la sesión de preview. Por eso: (1) para el sitio publicado, la corrección la garantiza `build.R` durante `build_site()` — pero como Netlify compila con `hugo` directo (ver `netlify.toml`), los `.md` commiteados ya deben estar corregidos: correr `corregir_enlaces_qmd()` (o `build_site()`) antes del `git push`; (2) durante la previsualización, tras guardar hay que volver a correr `corregir_enlaces_qmd()` a mano (o reiniciar `serve_site()`, que sí dispara el build inicial) para ver bien los enlaces internos.

**Alternativa para casos puntuales:** escribir el enlace interno como HTML crudo (`<a href="/tags/x/">texto</a>`) o dentro de un shortcode, que son inmunes a la reescritura.

> Este es un caso particular de un patrón más general — ver «HTML y bloques crudos en `.qmd`: qué sobrevive y qué no al pasar por Pandoc» más abajo.


## HTML y bloques crudos en `.qmd`: qué sobrevive y qué no al pasar por Pandoc

**Contexto general:** varios problemas aparentemente distintos y ya documentados en este archivo (enlaces rotos, `hl_lines` perdido, un `<div>` descartado al envolver una tabla) comparten la **misma causa raíz**. Quarto renderiza `.qmd` → `hugo-md` usando Pandoc internamente, con un escritor deliberadamente limitado (`markdown_strict+raw_html+...`, sin extensiones como `fenced_divs` o `attributes`). Cualquier cosa que Pandoc interprete como una estructura "enriquecida" de su AST (en vez de HTML/markdown crudo literal) puede perderse o transformarse silenciosamente al escribir en ese formato.

**Regla mental clave:** nada de lo escrito en el `.qmd` es texto opaco por defecto. Pandoc **siempre** interpreta el documento completo al leerlo (incluyendo HTML embebido), lo convierte a su propio árbol (AST), y luego ese árbol se reescribe según las capacidades del formato de salida. Si la interpretación transforma algo en un nodo del AST que el escritor de salida no sabe representar, ese nodo se **degrada silenciosamente** (normalmente perdiendo atributos o el wrapper, pero conservando el contenido interno) — no hay error ni advertencia visible.

### Matriz de comportamientos comprobados (Quarto 1.9.37, target `hugo-md`)

| Qué se escribe en el `.qmd` | Qué sobrevive | Por qué |
|---|---|---|
| Enlace markdown con ruta absoluta `[t](/x/)` | Se reescribe a `./x/` (relativo, rompe navegación) | Pandoc interpreta `/x` relativo a la raíz del **proyecto Quarto**, no del sitio Hugo |
| `<div class="x">contenido</div>` suelto, sin fences | El `<div>` se **descarta** (pierde su clase); el contenido interno sobrevive | Pandoc convierte el div crudo en un nodo "Div" nativo al leer; el escritor `markdown_strict` no soporta `fenced_divs`, así que al escribir omite el wrapper y solo imprime los hijos |
| `<table>` crudo suelto, con o sin `colspan`/`rowspan` | Sobrevive intacto como HTML | Pandoc no tiene forma de convertirlo a su AST nativo sin perder información, así que lo deja como bloque raw |
| Chunk de código markdown con atributos (` ```r {hl_lines=[...]} ` ``) | El atributo se descarta, solo queda el identificador de lenguaje | El escritor final es GFM, que no preserva atributos de bloques de código |
| ```` ```{=html}<br>contenido<br>``` ```` (raw block explícito) | El contenido sobrevive **tal cual**, incluyendo wrappers como `<div>` | El bloque `{=html}` le indica a Pandoc "no reinterpretes esto como tu AST nativo, pásalo literal" |
| ```` ```{=html} ``` ```` envolviendo una tabla simple (sin `colspan`/`rowspan`) | Esa tabla se **convierte** a tabla markdown nativa (pipe table) | Dentro de un raw block, Quarto aplica sus propios filtros de procesamiento de tablas; si la tabla es convertible sin pérdida a sintaxis nativa, Pandoc prefiere esa forma — el raw block no es un escape absoluto |
| ```` ```{=html} ``` ```` envolviendo una tabla con `colspan`/`rowspan` | Sobrevive como HTML, con atributos extra agregados por Quarto (`data-quarto-postprocess`, etc.) | No es representable sin pérdida en markdown nativo |
| ```` ```{=markdown}contenido``` ```` (raw block de markdown) | Sobrevive literal, sin reinterpretación | Mismo mecanismo que `{=html}`, pero fuerza a tratar el contenido como markdown ya-formateado (útil para preservar atributos de bloques de código, ver sección de `hl_lines` más arriba) |
| `<a href="/x/">t</a>` HTML crudo en línea | Sobrevive intacto | Pandoc no tiene un nodo nativo equivalente a "enlace con atributos arbitrarios" que valga la pena construir — lo deja raw |
| `{{< shortcode >}}contenido{{< /shortcode >}}` (shortcode par de Hugo) | Los delimitadores sobreviven literales, pero el **contenido interno se procesa como markdown normal** y puede sufrir cualquiera de los problemas anteriores | Quarto no reconoce el shortcode, pero tampoco aísla su contenido del parser — solo preserva el texto `{{< ... >}}` porque no se parece a sintaxis markdown/HTML conocida |
| Argumento de shortcode en una sola línea, como string: `{{< aviso "[t](/x/)" >}}` | Sobrevive literal, inmune | Quarto no lo trata como contenido markdown a interpretar, sino como un string-argumento opaco que pasa directo a Hugo |

### Receta práctica

1. **Si el elemento final se puede escribir también en markdown nativo** (ej. una tabla sin `colspan`), prefiere esa opción. El render hook de Hugo (`layouts/_markup/render-table.html`) y los estilos de `custom.scss`/`scaffold.scss` están pensados para markdown nativo, y evitas por completo estos problemas.
2. **Si necesitas que un wrapper (`<div>`, atributos) sobreviva intacto alrededor de HTML que sí debe quedar crudo** (ej. tabla con `colspan`): envuelve **todo el bloque** (wrapper + contenido) en un raw block de Pandoc (` ```{=html} `). Pero no es un escape total: dentro de ese bloque, Pandoc/Quarto puede seguir convirtiendo partes del HTML que sí sepa representar nativamente.
3. **Nunca asumas que un shortcode de Hugo en formato par protege su contenido interno.** Solo los argumentos de shortcode en una sola línea, como string entre comillas, son inmunes a la reescritura de Pandoc.
4. **Siempre verificar el `.md` resultante tras `quarto render`** cuando se usa HTML o markdown "no trivial" (atributos, wrappers, tablas complejas) — la ausencia de errores o warnings no significa que el resultado sea el esperado.

### Cómo probar rápido sin re-renderizar el post completo

Para entender cómo Pandoc/Quarto va a tratar un fragmento antes de tocar el post real, crear un `.qmd` mínimo en una carpeta temporal (ej. `/tmp/qtest/test.qmd`) con un front matter mínimo:
```yaml
---
title: "test"
format:
  hugo-md:
    output-file: index
    output-ext: md
---
```
y pegar debajo el fragmento a probar. Correr `quarto render test.qmd` ahí mismo y leer el `index.md` resultante. Esto evita re-ejecutar código R pesado del post real y evita chocar con el watcher de `blogdown::serve_site()` (ver condición de carrera en la sección «Botón Render» más arriba).


## Salida para LLMs (`/llms.txt` e `index.md` por publicación)

Implementado 2026-10-13, equivalente a `llms-txt: true` de Quarto. Hugo genera en cada build (también en Netlify):

- **`/llms.txt`**: índice según llmstxt.org. Plantilla `layouts/index.llms.txt`. Agrupa los posts de `blog/` por tema según la lista **`params.llms.temas`** de `config.toml` (orden de prioridad, de más específico a más general); cada post aparece una sola vez, en el primer tema que calce con sus tags, y los que no calzan van a «Otras publicaciones». Para cambiar la agrupación, editar esa lista.
- **`index.md` junto a cada `index.html`** (todas las páginas regulares, no solo blog): versión Markdown limpia. Plantilla `layouts/_default/single.markdown.md` (encabezado con título, excerpt, URL, fecha, tags y `links`) + `.RenderShortcodes`, pasado por el partial `layouts/partials/llms/limpiar.html`, que quita los JSON de htmlwidgets (mapgl, ggiraph: varios MB), scripts/CSS de librerías y bloques `<style>`, y convierte rutas relativas (`./index_files/...`, `imagen.png`, `../../../blog/x/`, `/blog/x/`) en URLs absolutas.
- Config en `config.toml`: media type `text/markdown`, output formats `markdown` (`rel = "alternate"`, por eso `head.html` emite `<link rel="alternate" type="text/markdown">` en cada post) y `llms` (`notAlternative`); `outputs.home` incluye `llms` y `outputs.page` incluye `markdown`.
- `static/_headers`: `charset=utf-8` para `.md` y `llms.txt`, y `X-Robots-Tag: noindex` en los `.md` (evita contenido duplicado en Google).

**Botón «Copiar texto para IA»:** partial `layouts/partials/llms/boton-copiar.html`, incluido en `layouts/blog/single-sidebar.html` debajo del índice (ambos dentro del contenedor sticky `#PageTableOfContents`, que ahora se muestra aunque el post no tenga encabezados). Usa la clase `.boton` de `custom.scss` e ícono `fas fa-clone`. El JS descarga el `index.md` y lo copia con `ClipboardItem` (con promesa, necesario para Safari) o `writeText`; si falla, abre el `.md` en otra pestaña. En los posts de serie (`single-series.html`, ej. `r_introduccion`) se incluye desde el override `layouts/partials/shared/series-sidebar.html`, en la columna del índice de la página, debajo de este. Ojo: `scaffold.scss` le da `.w-50` a `details#PageTableOfContents`; al envolverlo en un contenedor, ese ancho pasa al contenedor (`w-50-l`) y `details` va con `width: 100%` inline, si no el índice queda a la mitad de angosto. En esa columna el botón se achica (`.serie-sidebar-ia .boton` en `custom.scss`) y `.boton-copiar-ia` usa `white-space: nowrap`.

**Cuándo se actualizan:** los genera Hugo a partir del `content/.../index.md` (o `.markdown`) en cada build; no se guardan en el repo. Flujo: editar `.qmd` → render (Quarto/blogdown) actualiza `content/.../index.md` → `serve_site()` lo refleja en local y, en producción, Netlify recompila al hacer `git push`. Con `freeze: true`, el render del archivo individual (botón Render o guardar con blogdown) sí re-ejecuta el código; revisar que `_freeze/` se haya actualizado y commitearlo junto al `index.md`. Corregir un post cambia su `index.md` publicado; `/llms.txt` solo cambia si cambian el título, el excerpt o los tags.

**Regla: todo shortcode nuevo necesita su variante `layouts/shortcodes/<nombre>.markdown.md`.** Hugo elige la plantilla del shortcode según el formato de salida; si no existe la variante, usa la `.html` y el `index.md` queda con HTML y estilos inline. Las variantes devuelven Markdown mínimo (imagen → `![](src)`, aviso/info → blockquote, botón → enlace, relacionada/etiqueta → enlaces a los `index.md`, decorativos → vacío). También hay variantes para los integrados `youtube` y `figure`, para `blogdown/postref` (sin salto de línea final: se usa dentro de `src="..."`) y para `panel`/`panelset`/`here` del tema.

**Verificar tras cambios:** `hugo -d /tmp/x` y revisar `/tmp/x/llms.txt`; buscar residuos con `grep -rl 'style=' --include=index.md /tmp/x` y ver los más pesados con `find /tmp/x -name index.md -exec wc -c {} + | sort -rn | head`. Lo que queda de HTML en los `.md` es contenido propio de los posts (tablas gt, bloques HTML escritos a mano), no de shortcodes.


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

> Este es un caso particular de un patrón más general — ver «HTML y bloques crudos en `.qmd`: qué sobrevive y qué no al pasar por Pandoc» más abajo.


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
| Índice para LLMs (`/llms.txt`) | `layouts/index.llms.txt` |
| Markdown por publicación (`index.md`) | `layouts/_default/single.markdown.md` + `layouts/partials/llms/limpiar.html` + `layouts/shortcodes/*.markdown.md` |
| Encabezados HTTP Netlify | `static/_headers` |
| Página buscador (iframe Shiny) | `content/buscar/_index.md` |
| Layout buscador con iframe | `layouts/buscar/list.html` |
| iframeResizer (script local) | `static/js/iframeResizer.min.js` |
| Redirects | `static/_redirects` |
| robots.txt (plantilla) | `layouts/robots.txt` |
| Funciones R custom | `R/funciones.R` |
| Hook pre-build (corrige enlaces con `corregir_enlaces_qmd()`) | `R/build.R` |
| Hook post-build (verifica enlaces con `revisar_enlaces_qmd()`) | `R/build2.R` |
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

El override raíz `layouts/partials/meta.html` genera `<title>`, la descripción, la etiqueta canonical y las etiquetas Open Graph/Twitter. Estado actual (actualizado 2026-10-12):

**Título (`<title>` y `og:title`) y campo `seo_title`:** el título se calcula una sola vez en `$seo_title` y se reutiliza en ambas etiquetas:

```html
{{ $seo_title := "" }}
{{ with .Params.seo_title }}
  {{ $seo_title = . }}
{{ else }}
  {{ $seo_title = cond .IsHome .Title (printf "%s | %s" .Title site.Title) }}
{{ end }}
{{ $seo_title = $seo_title | markdownify | plainify | htmlUnescape }}
<title>{{ $seo_title }}</title>
```

- Sin `seo_title`: la home usa su `title` tal cual; el resto de las páginas usa `Título de la página | Bastián Olea` (`site.Title` de `config.toml`, que conviene mantener corto porque Google corta en ~60 caracteres).
- Con `seo_title` en el front matter: **reemplaza el título completo**, sin agregar el sufijo ` | Bastián Olea`. Sirve para dar a una página un título distinto en buscadores sin cambiar el título visible.
- La home lo usa (`content/_index.md`): `seo_title: "Bastián Olea Herrera | Tutoriales de R y análisis de datos"`. Esto es necesario porque el `title` de la home también es el `<h1>` visible de la portada (`layouts/index.html` imprime `.Params.title`), así que no se puede alargar sin cambiar el encabezado.
- Para usarlo en un post, agregar `seo_title: "..."` al front matter (opcional; no está en el archetype).

**Descripción (`meta description` y `og:description`):** se toma de `description` > `subtitle` > `excerpt` > `site.Params.description`, y luego se limpia:

```html
{{ $desc = $desc | markdownify | plainify | htmlUnescape | replaceRE `\s+` " " | strings.TrimSpace }}
```

`htmlUnescape` es necesario porque `markdownify` convierte comillas en entidades tipográficas (`&rdquo;`) y Go las volvería a escapar dentro del atributo (`&amp;rdquo;`). Antes de este cambio la descripción de la home salía con `**` y `[texto](url)` literales.

**Canonical:** `<link rel="canonical" href="{{ .Permalink }}">` en todas las páginas. Limitación conocida: en páginas paginadas (`/blog/page/2/`) `.Permalink` apunta a la primera página (`/blog/`) en vez de a sí misma. No se corrigió porque usar `.Paginator` en el `<head>` puede chocar con cómo los layouts de listado inicializan la paginación.

**`og:type`:** `article` en páginas individuales (`.IsPage`), `website` en home, listados y taxonomías (antes decía `page`, que no es un valor válido de Open Graph).

**Imágenes para compartir:** si la página define `images:` en el front matter (como la home, con `img/collage_vertical.jpg`), se emiten `og:image` y `twitter:image` con esa imagen (antes solo salía `twitter:image`, así que WhatsApp/LinkedIn/Facebook no mostraban imagen de la home). Si no, se busca en el bundle una imagen `*hex*` o `*feature*`, luego `*sidebar*` de la sección, y como último recurso `params.sharing_image`.

**Pendiente:** `twitter:card`, `twitter:site` y `twitter:creator` usan `property=` en vez de `name=`.

**Al verificar cambios en el HTML generado:** `[minify]` está activado en `config.toml`, así que el HTML compilado quita comillas de atributos simples (ej. `<meta name=description content="...">`, `<link rel=canonical href=...>`) y deja todo en una línea; ajustar los `grep` en consecuencia (y contar con `grep -o ... | wc -l`, no `grep -c`).

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
