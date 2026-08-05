# Theme Reference

## Base

Tema base: **Hugo Apéro** con tema custom `tema-morado-hex`.

## Tipografía

| Uso | Fuente | Tipo |
|-----|--------|------|
| Headings | EB Garamond | Serif |
| Body text | Atkinson Hyperlegible | Sans-serif (diseñada para legibilidad) |

Configurado en `config.toml`:
```toml
customtextFontFamily = "Atkinson Hyperlegible"
customheadingFontFamily = "EB Garamond"
```

Importación de fuentes en `assets/custom-fonts.scss`.

## Paleta de colores

### Variables SCSS (`assets/tema-morado-hex.scss`)

| Variable | Color | Uso |
|----------|-------|-----|
| `$siteBgColorCustom` | `#EAD1FA` | Fondo del sitio |
| `$sidebarBgColorCustom` | `#EAD1FA` | Fondo sidebar (= sitio) |
| `$textColorCustom` | `#543A74` | Texto principal |
| `$headlineColorCustom` | `#6E3998` | Títulos y headings |
| `$bodyLinkColorCustom` | `#9069C0` | Links en el cuerpo |
| `$navLinkColorCustom` | `#6E3998` | Links de navegación |
| `$footerTextColorCustom` | `#A885C6` | Texto del footer |
| `$borderColorCustom` | `#A885C6` | Bordes generales |
| `$buttonBgColorCustom` | `#6E3998` | Fondo de botones |
| `$buttonHoverBgColorCustom` | `#9069C0` | Botón hover |
| `$buttonTextColorCustom` | `#f7f7f4` | Texto de botones |

### Colores usados en CSS custom y shortcodes

| Color | Uso |
|-------|-----|
| `#9069C0` | Primary purple — botones, tags, links |
| `#A885C6` | Bordes, footer text |
| `#A885C6AA` | Bordes semi-transparentes (shortcodes) |
| `#A985C630` | Fondo de filas pares en tablas |
| `#A985C640` | Fondo de cajas (`.cuadro`, `.icono-cuadro`) |
| `#9069C020` | Fondo tenue (tarjeta externo) |
| `#9069C00d` | Fondo muy tenue |
| `#EAD1FA` / `#EAD2FA` | Fondo del sitio, texto claro en cajas oscuras |
| `#DEC4F2` | Fondo de caja info |
| `#F1DFFB` | Fondo de código inline |
| `#493365` | Fondo de caja aviso (oscuro) |
| `#543A74` | Texto principal |
| `#6E3998` | Headlines, botones |
| `#31253B` / `#232136` | Fondos oscuros (syntax) |
| `#3b2c46` | Líneas de código destacadas |
| `#8662a4` | Texto de `.titulo-panel` |

## Archivos SCSS (`assets/`)

| Archivo | Propósito |
|---------|-----------|
| `tema-morado-hex.scss` | Variables de color del tema (21 líneas) |
| `custom.scss` | CSS personalizado principal (313 líneas) |
| `custom-fonts.scss` | Importación de web fonts |
| `base.scss` | Estilos base |
| `scaffold.scss` | Layout scaffold |
| `named-colors.scss` / `hex-colors.scss` | Sistemas de colores |
| `tachyons.scss` | Clases utilitarias (Tachyons CSS) |
| `panelset.scss` / `headroom.scss` | Componentes |

## CSS personalizado (`assets/custom.scss`) — secciones principales

1. **Código**: tamaño de fuente reducido (85-90%), fondo inline `#F1DFFB`, border-radius
2. **Imágenes**: border-radius 6px en `.post-body img`
3. **Tablas**: padding 8px, font-size 80%, filas alternas con fondo `#A985C630`
4. **TOC**: max-height con scroll, padding compacto
5. **Shortcodes**: estilos para `.contenedor-extension`, `.imagen_lateral`, `.externo-card`, `.cuadro`, etc.
6. **Syntax highlighting**: líneas destacadas (`.hl`) con fondo `#3b2c46`, líneas no destacadas se atenúan (opacity 0.4)
7. **Responsive**: media queries para ≤500px (imagen lateral, tarjeta externo)
8. **AI output**: estilo `.texto-ia` — monospace, borde izquierdo púrpura

## Syntax highlighting

- Estilo base: `rose-pine-moon` (configurado en config.toml)
- CSS custom: `static/css/syntax.css`
- `noClasses = false` → usa clases CSS en vez de estilos inline
- Destacar líneas: `` ```r {hl_lines=["5-9"]} ``

## Íconos

- **Font Awesome 6.5.2** (brands + solid + regular)
- **Academicons** para símbolos académicos
- Packs usados en front matter: `fab` (brands), `fas` (solid), `far` (regular)

## JavaScript

| Archivo | Propósito |
|---------|-----------|
| `assets/js/panelset.js` | Funcionalidad de pestañas |
| `assets/js/main.js` | Interacciones principales |
