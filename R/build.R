# An optional custom script to run before Hugo builds your site.
# You can delete it if you do not need it.

# Corrige los enlaces internos que Quarto reescribe de "/seccion/" a
# "./seccion/" al renderizar los .qmd, para que Hugo no los resuelva como
# rutas relativas a la página (evita 404). Debe correr ANTES de Hugo.
source("R/funciones.R")
corregir_enlaces_qmd()

# Agrega loading="lazy" a las figuras de chunks (<img> crudo que escribe
# Quarto en los index.md), para que se descarguen al acercarse a la pantalla.
# También debe correr ANTES de Hugo, porque el HTML crudo no pasa por hooks.
agregar_lazy_figuras()
