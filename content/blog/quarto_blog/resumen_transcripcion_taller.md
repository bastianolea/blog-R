# Resumen de la transcripción del taller (29 de julio, 2026)

> Documento de referencia interno, generado a partir de `transcripcion_taller.vtt`, para apoyar la redacción del tutorial de blogs con Quarto, RStudio y GitHub Pages. No es contenido publicable, sino material de trabajo.

## 1. Estructura temática y flujo del taller

El taller fue conducido por **Bastián** (con apoyo en logística de Carolina Morales) y cubrió los siguientes temas en orden:

1. **Introducción y contexto del grupo** (00:10:18 - 00:19:10)
   - Presentación del grupo de usuarios de R Santiago, Chile
   - Objetivos del taller y del grupo (hacer comunidad, aprendizaje colaborativo)

2. **Por qué crear un blog: motivación y casos de uso** (00:19:25 - 00:25:27)
   - Argumentos filosóficos sobre soberanía digital
   - Ejemplos reales de blogs/sitios hechos con Quarto

3. **Herramientas necesarias** (00:26:00 - 00:28:52)
   - Presentación de Quarto, RStudio, GitHub y GitHub Pages

4. **Creación del proyecto inicial** (00:29:00 - 00:32:22)
   - Paso a paso: crear proyecto Quarto Blog en RStudio

5. **Estructura de archivos y publicaciones** (00:32:30 - 00:50:53)
   - Explicación del `_quarto.yml`
   - Archivos por defecto (`index.qmd`, `about.qmd`, `posts/`)
   - Creación de publicaciones (automática con función o manual)
   - Previsualización con `quarto preview`

6. **Escritura de contenido con Markdown y código R** (00:56:40 - 01:10:19)
   - Sintaxis básica de Markdown
   - Bloques de código (chunks) de R
   - Opciones de chunks (echo, eval, message, warning)
   - Código en línea (inline)

7. **Personalización básica del sitio** (01:18:00 - 01:39:04)
   - Cambio de temas Quarto predefinidos
   - Modificación de menú de navegación
   - Agregación de páginas adicionales
   - Iconos de redes sociales (Font Awesome)

8. **Personalización avanzada con CSS y SCSS** (01:27:30 - 01:44:52)
   - Creación de archivo `tema.scss`
   - Variables de color personalizadas
   - Google Fonts: importación y aplicación
   - Modificación de tipografías

9. **Configuración técnica previa a publicación** (01:45:00 - 01:49:42)
   - `output-dir: docs` en `_quarto.yml`
   - Archivo `.nojekyll`
   - `quarto render` para compilación final

10. **Git y autenticación con GitHub** (01:49:45 - 02:06:08)
    - Conceptos de Git (control de versiones)
    - Instalación del paquete `usethis`
    - Configuración de credenciales: `use_git_config()`, crear token de GitHub, `gitcreds_set()`

11. **Subida del repositorio a GitHub** (02:03:50 - 02:07:27)
    - `use_git()` para inicializar repositorio local
    - `use_github()` para subir a GitHub

12. **Publicación en GitHub Pages** (02:07:30 - 02:12:37)
    - Configuración en Settings > Pages
    - Selección de branch (main) y carpeta (docs)
    - Espera a que la acción se complete
    - Obtención de URL pública

13. **Mantenimiento y actualizaciones futuras** (02:13:00 - 02:15:57)
    - Workflow para cambios posteriores: `git add`, `git commit`, `git push`
    - Panel Git en RStudio como alternativa

## 2. Explicaciones técnicas extendidas no presentes en las diapositivas

### A. Motivación filosófica de tener un blog propio

Bastián enfatizó (00:21:22 - 00:23:06) la importancia de la soberanía digital: "En esta época donde la Internet está mediada por grandes corporaciones, grandes empresas, casi nada es nuestro… El día de mañana cualquier red social nos va a bloquear nuestra cuenta o va a eliminar cierta publicación o a cerrar cierta plataforma y nos vamos a quedar sin nuestros contenidos o sin nuestra vida digital, porque es gran parte de donde vivimos nuestras vidas hoy en día."

Beneficios mencionados:
- Presencia digital propia y permanente
- Espacio para aprender jugando (proponiéndose objetivos)
- Compartir proyectos y análisis con la comunidad (reciprocidad: "aprendimos todo por Internet… así que a mí me parece justo retribuir un poco también a los demás")
- Conectar con comunidad y explorar trabajo de otros

### B. Diferencia entre Quarto y R Markdown

Bastián aclaró (00:28:04 - 00:28:52): "Quarto es una sucesión a R Markdown porque es más completo. Tiene más formas de generar contenido a partir de los scripts… Si ustedes trabajan con R o han trabajado con R Markdown, el cambio a Quarto es súper sencillo. Es casi lo mismo, prácticamente lo mismo."

### C. Estructura de archivos del blog y creación de publicaciones

**Archivo `_quarto.yml`:** archivo YAML de configuración general. La indentación es crucial (2 espacios para subniveles). Contiene:
- `title`: título del blog
- `description`: descripción
- `website`: opciones del sitio (navbar, links de redes sociales)

**Carpeta `posts/`:** cada publicación es una carpeta dentro de `posts/` que contiene un archivo `index.qmd`. La estructura de la URL se determina por el nombre de la carpeta. Ejemplo: `posts/mi-primer-post/index.qmd` genera `/posts/mi-primer-post` como URL.

**Creación de publicaciones (00:39:00 - 00:46:21):**
- Opción automática: `quarto::create_blog_post("titulo")` (función en R Console)
- Opción manual: crear carpeta manualmente + archivo `index.qmd`

Bastián reveló que prefiere hacer la creación manual: "Yo siempre lo hago a mano. En realidad, de hecho, no sabía que existía esa función `new_blog_post`."

### D. Diferencia entre `quarto preview` y `quarto render`

- **`quarto preview`:** modo "vivo" o servidor local. Actualiza automáticamente al guardar cambios. No reconstruye todo el sitio.
- **`quarto render`:** reconstruye el sitio completo desde cero. Garantiza que todos los cambios estén aplicados. Recomendado antes de publicar.

Bastián explicó (00:42:33 - 00:43:10): "Hay 2 cosas que se necesitan hacer… Una cosa es como crear el sitio que es con el Comando Render… Y otra cosa es como previsualizar el sitio para poder verlo y que se vaya actualizando con los cambios que es Quarto preview."

### E. Front matter YAML de las publicaciones

Cada publicación tiene un bloque YAML al inicio con:
```
---
title: "Título"
date: YYYY-MM-DD
categories: [categoría1, categoría2]
image: "ruta/imagen.jpg"
---
```

Hay dos sintaxis válidas para categorías: horizontal (`categories: ["pruebas"]`) o vertical (con guiones y líneas nuevas).

El bloque **debe** cerrarse con `---`. Si faltan los tres guiones de cierre, Quarto genera un error: "se espera que en el Front Matter YAML termine con 3 líneas."

### F. Markdown: sintaxis práctica

Bastián demostró negritas (`**texto**`), itálicas (`_texto_`), títulos (`##`), párrafos separados por línea en blanco, enlaces (`[texto](url)`) e imágenes (`![alt](ruta/imagen.jpg)`).

### G. Bloques de código (chunks) de R

Opciones importantes mencionadas:
- `#| echo: false` → no mostrar código, solo resultado
- `#| eval: false` → mostrar código, no ejecutarlo
- `#| message: false` / `#| warning: false` → suprimir mensajes de paquetes (ej: al cargar ggplot2)

Bastián confesó (01:06:25 - 01:07:46): "Cuando 1 carga ggplot2 aparecen estos mensajes… a mí no me gusta que aparezcan en el blog. Hay una configuración que es para que no aparezcan los mensajes que es `message: false`."

### H. Código en línea (inline R code)

En el texto se pueden incrustar resultados con `` `r variable` ``, insertando el valor de una variable calculada anteriormente. Bastián ejemplificó (01:09:01 - 01:10:06): "Si ustedes cambian los datos, el texto se actualice… es súper poderoso. Pueden usarlo para que se redacten partes de los párrafos… Por ejemplo, 'la correlación es muy alta o muy baja, dependiendo del valor'."

### I. Configuración del entorno de bloques de código

Carolina Morales preguntó (01:05:59 - 01:06:18) si los `library()` deben ir en cada chunk o en el environment. Bastián respondió: "Todos los bloques de código son compartidos. Entonces, si yo creo un objeto acá voy a poder usar ese objeto abajo… Hay gente que empieza como cargando los paquetes y otra gente los carga a medida que los usa. Es decisión tuya."

## 3. Preguntas del público y respuestas

**¿Cómo se cambia el tamaño de la letra?** (Jorge Valenzuela, 01:00:26 - 01:01:22)
Bastián: "En teoría, en el markdown, el tamaño de letra no se modifica… porque con los gatos yo puedo poner títulos, pero poner un título no es lo mismo que modificar la letra. La lógica del markdown es la misma lógica del látex… tú, por un lado escribes el contenido y por otro lado, das como el estilo a las cosas." Intentó usar HTML `<size>` pero no funcionó en el momento; recomendó hacerlo después con CSS.

**¿Los comentarios en el CSS cómo se hacen?** (Carolina Morales, 01:42:23 - 01:42:31)
Bastián: "Son así: `/* comentario */` o también puede ser `// comentario`, pero son solamente en este tipo de archivo."

**¿Cómo protejo para que no se roben el blog?** (María, 01:52:39 - 01:53:34)
Bastián: "Nadie se lo va a robar porque todo lo que está en Internet ya es público de por sí… no hay nada privado en tu blog que no quieras que aparezca en Internet. En general, todas estas cosas las subimos de manera pública porque estamos usando software público y gratuito… Pero sí puedes crear un repositorio privado. Aunque entiendo que si tu repositorio es privado, no puedes hacer un sitio web público… Hay que usar otros métodos que en general son o pagados o más difíciles."

**¿Hay layout de barra lateral / menú desplegable para hacer un libro?** (Franco, 01:34:32 - 01:36:52)
Bastián: "Si quieres hacer un libro, libro, te recomiendo que revises cómo es el Bookdown… Pero en Quarto, tú puedes poner en el navbar uno que se llama `sidebar`… y puedes poner ahí tus posts y te van a aparecer en el sidebar: `website: sidebar:`. Así aparecen los contenidos con sus secciones y sus links."

**¿Cómo se actualiza el blog después de publicarlo?** (Franco, 02:13:24 - 02:15:57)
Workflow estándar: hacer cambios → `quarto render` → abrir terminal → `git add .` → `git commit -m "mensaje descriptivo"` → `git push`. "Se sube solamente lo cambiado, pero eso es automático." También mencionó que RStudio tiene un panel Git opcional para hacer esto sin terminal.

**Otras preguntas técnicas menores:**
- Valentina (01:18:02): no veía el blog en el Viewer → hay que hacer render en un post y seleccionar "Preview in Viewer Panel"
- Alex Navarro (01:14:08): no veía botón "Edit" en el Viewer → aparece al hacer render a posts individuales, no con `quarto preview`
- Alonso (01:52:54): problema con el token de Git → recomendó ejecutar `use_git_config()` primero

## 4. Anécdotas, opiniones y consejos personales

- Sobre el aprendizaje colaborativo: "Aprendimos todo por Internet. Fuimos buscando, googleando. Entonces a mí me parece justo al menos que retribuyamos un poco también a los demás." (00:22:39 - 00:23:01)
- Sobre la dificultad y frustración: "Que no se ha ido gente porque a veces uno piensa que con las cosas difíciles la gente se va… Pero no hay que sucumbir ante la frustración." (01:48:40 - 01:48:50)
- Mostró múltiples ejemplos reales de blogs hechos con Quarto (blog del grupo de R Santiago, blog de Nicolás Rennie, sitios con animaciones CSS más avanzadas): "Con paciencia y con la ayuda de documentación, tutoriales y un poquito de inteligencia artificial, se van a hacer sitios bastante profesionales." (00:25:24 - 00:25:27)
- Sobre el precio: "Sí, es gratis. Todo esto es gratis. Y todo esto va a salir gratis por siempre… nunca vamos a pagar ni un peso ni un dólar." (00:51:31 - 00:51:35)
- Sobre las elecciones de diseño: recomendó dejar configurado el tema y la apariencia general antes de empezar a escribir publicaciones, para que estas hereden la visualización.
- Tono conversacional relajado y humorístico durante la demostración en vivo (comentarios sobre ocultar el token de GitHub en pantalla, bromas varias).

## 5. Detalles técnicos verbales no presentes en las diapositivas

- **Crear proyecto:** File > New Project > New Directory > Quarto Blog (o el botón del cubo celeste en la barra de herramientas de RStudio).
- **Render vs Preview:** con `quarto preview` se inicia un servidor local; si se cierra la pestaña o el viewer, a veces hay que volver a ejecutar render o preview.
- **Nombres de carpetas de posts:** sin espacios, sin mayúsculas, preferentemente con guion o guion bajo. Ejemplo: `posts/mi-primer-post/` → URL `/posts/mi-primer-post`.
- **Imagen de perfil:** el proyecto viene con una imagen genérica de perfil que se puede reemplazar, usada en la página About.
- **Archivo `.nojekyll`:** archivo oculto y vacío, necesario para que GitHub Pages no procese el sitio con Jekyll.
- **Responsividad automática:** el sitio generado es responsivo por defecto (menú hamburguesa en celulares, columnas adaptables).
- **Rutas de imágenes:** deben estar en la misma carpeta que el `index.qmd` del post, referenciadas con ruta relativa.
- **Buscar colores:** recomendó sitios para explorar paletas de colores y obtener códigos hexadecimales.
- **Google Fonts:** buscar tipografía → "Get Fonts" → "Get embed code" → copiar `@import url(...)` → pegar en `tema.scss` → usar el nombre en variables SCSS.

## 6. Contenido extra no cubierto en tutoriales anteriores

### A. Configuración de credenciales de Git en R mediante `usethis`

1. `usethis::use_git_config(user.name = "tu_usuario", user.email = "tu_email@github.com")`
2. `usethis::create_github_token()` → se abre el navegador, genera token
3. Copiar el token (no se muestra en pantalla por seguridad)
4. `gitcreds::gitcreds_set()` → pedir token, pegarlo y presionar Enter

Bastián aclaró por qué la contraseña no aparece en pantalla: "porque aparece un código que si ustedes ven ese código, me pueden hackear la cuenta."

### B. Configuración de GitHub Pages desde la interfaz web

1. Ir al repositorio en GitHub.com
2. Settings (esquina superior derecha)
3. Menú izquierdo: "Pages"
4. "Source" → seleccionar rama **main**
5. Seleccionar carpeta **docs** (no root)
6. Save

Esperar 1-2 minutos (indicador de estado cambia de naranja a verde).

### C. Obtener la URL pública del sitio

Dos formas: desde el ícono de engranaje junto a "About" en el repositorio, o desde Settings > Pages. También se puede construir manualmente: `https://usuario.github.io/nombre-repositorio`. Para un dominio más corto, renombrar el repositorio a `usuario.github.io`.

### D. Iconos de Font Awesome

Quarto usa Font Awesome automáticamente para los íconos del navbar (`github`, `linkedin`, `instagram`, etc.). Es posible usar imágenes personalizadas para íconos que no están en Font Awesome (ej. Slack, Meetup).

### E. Inspeccionar elementos con las herramientas de desarrollador del navegador

Click derecho > Inspeccionar elemento, para encontrar clases CSS específicas y probar cambios antes de codificarlos en el `.scss`.

## 7. Errores comunes y soluciones

- **Front matter YAML mal cerrado** (falta el `---` de cierre): produce un error indicando que el front matter debe terminar con tres guiones.
- **Indentación incorrecta en YAML**: los subniveles deben ir indentados con 2 espacios.
- **Viewer no muestra el botón "Edit"**: ocurre al usar `quarto preview` en vez de renderizar un post individual.
- **Token de GitHub no funciona**: si se olvida ejecutar `use_git_config()` antes de `usethis::use_github()`.

## 8. Contexto comunitario

El taller fue organizado por el grupo de usuarios de R de Santiago, Chile, con reuniones mensuales y un enfoque en generar comunidad además de enseñar contenidos técnicos.
