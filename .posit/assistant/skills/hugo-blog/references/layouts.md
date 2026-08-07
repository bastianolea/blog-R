# Layouts Reference

## Estructura de directorios

```
layouts/
├── _default/
│   ├── baseof.html              # Template base para todas las páginas
│   └── single.html              # Página individual por defecto
├── about/
│   └── list.html                # Página "Sobre mí" (modular)
├── blog/
│   ├── list-sidebar.html        # Listado del blog con sidebar
│   ├── single-sidebar.html      # Post individual con sidebar + TOC
│   └── single-series.html       # Post con sidebar de serie
├── partials/
│   ├── head.html                # Meta, CSS, scripts
│   ├── header.html              # Navegación superior
│   ├── footer.html              # Pie de página + scripts math
│   ├── analytics.html           # GoatCounter tracking
│   ├── page_views.html          # Contador de visitas
│   └── shared/
│       ├── summary.html             # Tarjeta de post (lista del blog)
│       ├── summary-thumbnail.html   # Tarjeta con thumbnail (tags)
│       ├── summary-compact.html     # Resumen mínimo
│       ├── sidebar-scaffold.html    # Sidebar por defecto
│       ├── series-sidebar.html      # Sidebar de serie
│       ├── social-links.html        # Íconos sociales
│       ├── tags.html / tags-long.html / tags-wide.html  # Displays de tags
│       ├── btn-links.html           # Botones de acción
│       ├── post-pagination.html     # Navegación prev/next
│       ├── list-pagination.html     # Paginación de listas
│       ├── comments.html            # Sistema de comentarios
│       └── sidebar/                 # Sub-componentes de sidebar
├── taxonomy/
│   ├── term.html                # Página de tag/categoría individual
│   └── taxonomy.html            # Taxonomía legacy
├── shortcodes/                  # Ver references/shortcodes.md
├── index.html                   # Homepage
└── index.json                   # Índice JSON para buscador
```

**Nota sobre lookup order:** Hugo prioriza `layouts/` (raíz del proyecto) sobre `themes/hugo-apero/layouts/`. Regla: no editar el tema; copiar el template a la misma ruta bajo `layouts/` y modificar la copia (ej: `layouts/blog/single-sidebar.html`, `layouts/partials/meta.html`, `layouts/partials/shared/post-pagination.html` son overrides raíz). El título de la paginación y los metadatos SEO usan `{{ .Title | markdownify | plainify }}` para limpiar markdown/backticks.

## Mapeo de páginas a layouts

| Página | URL | Layout | Notas |
|--------|-----|--------|-------|
| Homepage | `/` | `index.html` | Hero + bio + botones de acción |
| Lista del blog | `/blog/` | `blog/list-sidebar.html` | Posts paginados + sidebar categorías |
| Post individual | `/blog/{slug}/` | `blog/single-sidebar.html` | Post + TOC sticky en sidebar derecho |
| Post en serie | `/blog/{slug}/` | `blog/single-series.html` | Post + navegación de serie en sidebar |
| Sobre mí | `/about/` | `about/list.html` | Modular (header/, main/, sidebar/) |
| Tag | `/tags/{tag}/` | `taxonomy/term.html` | Usa `summary-thumbnail` |
| Categoría | `/categories/{cat}/` | `taxonomy/term.html` | Usa `summary-thumbnail` |
| Otras páginas | `/{slug}/` | `_default/single.html` | Layout genérico sin sidebar |

## Templates principales

### `baseof.html` — Template base
Envuelve todas las páginas. Estructura:
1. `<head>` → llama a `partials/head.html`
2. Grid container con clase de layout dinámica
3. Header → `partials/header.html`
4. Block `main` (inyectado por cada template)
5. Analytics → `partials/analytics.html`
6. Footer → `partials/footer.html`

Aplica clase especial `home` cuando `{{ .IsHome }}`.

### `index.html` — Homepage
- Sección hero con título, subtítulo, descripción
- Imagen de perfil (posicionamiento configurable via `image_left`)
- Botones de acción (Blog, Cursos, Apps)
- Íconos sociales
- Tags del homepage

### `blog/single-sidebar.html` — Post individual
Layout principal de posts. Elementos:
- Título (soporta markdown)
- Subtítulo, autor, fecha
- Tags como pills púrpura (#9069C0)
- Botones de links (código, datos, etc.)
- Cuerpo del post
- Paginación prev/next
- Comentarios (Utterances)
- **Sidebar derecho**: TOC auto-generado sticky (top: 108px), solo aparece si hay h2+

### `blog/list-sidebar.html` — Lista del blog
- Filtra posts tipo "blog" ordenados por fecha (más recientes primero)
- Paginación (20 por página)
- Cada post usa partial `summary.html`
- Sidebar con navegación de categorías/tags

### `blog/single-series.html` — Post en serie
Similar a `single-sidebar` pero:
- Sidebar muestra navegación de la serie en vez de TOC
- Sin sidebar header genérico
- Links a otros posts de la misma serie

### `about/list.html` — Sobre mí
Sistema modular con headless bundles:
- `content/about/header/index.md` → header
- `content/about/main/index.md` → contenido principal
- `content/about/sidebar/index.md` → sidebar con avatar
- Avatar configurable (círculo o redondeado)
- Audio embed opcional
- Layout flexible (sidebar izquierda o derecha via `sidebar_left`)

### `taxonomy/term.html` — Página de tag/categoría
- Título del término centrado
- Lista de posts con ese tag/categoría
- Usa `summary-thumbnail` para tarjetas visuales
- Sin sidebar

### `index.json` — Índice de búsqueda
Genera JSON para buscador externo (app Shiny). Incluye:
- Filtra tipos: "post", "blog", "tutoriales"
- Campos: date, title, content, tags, href

## Cascade de configuración

El archivo `content/blog/_index.md` configura defaults para todos los posts del blog:
```yaml
cascade:
  author: "Bastián Olea Herrera"
  show_author_byline: true
  show_comments: true
  show_post_date: true
  show_page_views: true
  layout: single-sidebar
```

## Partials clave para modificaciones comunes

| Quiero cambiar... | Editar |
|-------------------|--------|
| Meta tags, CSS imports | `partials/head.html` |
| Navegación superior | `partials/header.html` |
| Pie de página | `partials/footer.html` |
| Cómo se ve un post en la lista | `partials/shared/summary.html` |
| Cómo se ve un post en tags | `partials/shared/summary-thumbnail.html` |
| Sidebar del blog | `partials/shared/sidebar-scaffold.html` |
| Íconos sociales | `partials/shared/social-links.html` |
| Tracking | `partials/analytics.html` |
