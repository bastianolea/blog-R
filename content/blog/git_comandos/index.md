---
title: Comandos comunes de Git
author: Bastián Olea Herrera
date: '2025-10-27'
slug: []
draft: false
categories: []
tags:
  - git
  - GitHub
  - consejos
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "Colección de comandos de `git` para realizar acciones comunes y resolver problemas frecuentes. `git` es una herramienta para el control de versiones de código, respaldo de código, y colaboración."
---

`git` es una herramienta para el control de versiones de código, respaldo de código, y colaboración. En otro post hice un tutorial para [aprender a usar `git` y GitHub con R y RStudio](/blog/r_introduccion/tutorial_github/). En este post voy a mantener una lista[^1] de los comandos que más uso en `git`, así como los comandos que necesito para resolver los **problemas más frecuentes.**

[^1]: Hago esto porque tengo una nota en el computador con todos los comandos y siempre vuelvo a buscarla para copiarlos, así que mejor dejo todo eso acá 😋

{{< relacionada "/blog/r_introduccion/tutorial_github/" >}}

Otro recurso mucho más completo es [ohshitgit.com](https://ohshitgit.com/es), que como su nombre indica, está enfocado en resolver problemas comunes con `git`.


{{< aviso "Este post está _en construcción_, y a medida que me encuentro con problemas o voy aprendiendo iré agregando y desarrollando." >}}

{{< aviso "Ten mucho cuidado al ejecutar estos u otros comandos de `git`, ya que pueden afectar tus archivos. Recuerda siempre tener **respaldos**!" >}}


## Comandos git básicos


### Crear repositorio git en proyecto de RStudio

**Recomendado:** crearlo con la ayuda del paquete `{usethis}`:

```r
usethis::use_git()
```

Crearlo manualmente por la terminal, verificando que esté apuntando a la carpeta de tu proyecto de R:

```
git init
```

Para más información sobre la integración de R con `git`, [revisa este post](/blog/r_introduccion/tutorial_github/). También existe el libro [Happy Git with R](https://happygitwithr.com), que detalla todos los pasos necesarios para poder usar `git` con R, incluyendo soluciones a problemas comunes.


### Ver estado del repositorio
Para ver qué archivos han sido modificados, cuáles están en el área de preparación, y cuáles no:

```
git status
```


### Agregar archivos al área de preparación (_staging area_)
Cuando creaste o modificaste archivos, y quieres registrarlos para ser agregados a la nueva versión del proyecto:

```
git add archivo.R
```

Para agregar todos los archivos cambiados desde el último _commit_:

```
git add .
```

Esto hará que los archivos pasen al área de _staging_ o preparación, para que estén listos para hacer el _commit_ y guardar una nueva versión del código.


### Guardar los cambios preparados en una versión (_commit_)
Un _commit_ es la operación en la que tomas los archivos del área de preparación (agregados con `git add`) y los guardas como una nueva versión del proyecto.

Recomiendo primero confirmar el estado de los archivos con `git status`, así sabemos qué cosas están modificadas y no _staged_ (no se agregan a la versión), cuáles están _staged_ (sí se agregan a la versión), y otros temas.

Luego creamos el _commit_, agregando un mensaje que describa los cambios de esta versión:

```
git commit -m "procesamiento de datos actualizado"
```


### Cambiar un mensaje de _commit_
Por si te equivocaste en el mensaje del _commit_ anterior, te permite cambiar el mensaje, siempre que lo ejecutes antes de haber hecho _push_

```
git commit --amend -m "nuevo mensaje de commit"
```


### Ver todos los _commits_ que has hecho
Te entrega una lista con las versiones de tu repositorio, con sus mensajes respectivos y el índice de cada uno de ellos (un código único que identifica cada cambio)

```
git log
```

También está el comando `git reflog`, que muestra un historial de todos los movimientos en el repositorio, incluyendo _commits_, cambios de ramas, y otras operaciones.
```
git reflog
```


### Subir los cambios guardados al repositorio remoto

Asumiendo que tu proyecto de RStudio tiene un repositorio `git`, que has hecho `commit` de tus cambios, y que [ya conectaste el repositorio local con un repositorio remoto](/blog/r_introduccion/tutorial_github/#crear-un-repositorio-remoto-en-github-para-tu-proyecto-de-r) en GitHub o GitLab:

```
git push
```

Si no has creado una versión remota de tu repositorio aún, puedes usar el comando `use_github()` para crear una rápidamente.

```r
usethis::use_github()
```



----

## Ramas

Crear rama

```
git branch ramita
```

Cambiarse de rama
```
git switch ramita
```
----


## Evitar problemas


### _Vacunar_ tu proyecto de R

Agregar archivos generalmente indeseables de R a tu `.gitignore` para prevenir problemas.

```
usethis::git_vaccinate()
```

----

## Solucionar problemas

### Deshacer `git add archivo.R`
Por si la embarraste y agregaste un archivo incorrecto a la zona de preparación:

```
git rm archivo.R
```

### Deshacer `git add .`
```
git reset
```

### Modificar el _commit_ anterior

Hacer el cambio, luego `git add {cambio}`:

```
commit --amend --no-edit
```


### Deshacer _commit_

Si guardaste una versión del código pero ésta tenía archivos equivocados, puedes deshacer el _commit_ pero **sin perder los cambios** que hiciste. Con esto, tu repositorio volverá a la versión antes del commit, pero el código y archivos nuevos no se perderán, y estarán disponibles para volver a agregarlos con `git add` y rehacer la versión con `git commit`.

```
git reset --soft HEAD~1
```


### Deshacer _commit_ con violencia

```
git reset HEAD~ --hard
```


### Eliminar archivos agregados con `git add` después del commit
Para cuando agregaste archivos al _commit_ pero luego te das cuenta que no debías haberlo hecho. Por ejemplo, si agregaste un archivo muy grande por error:

```
git rm --cached "archivo"
git commit -m "mensaje"
git push -u origin branch
```

### Cambiar mensaje del último _commit_

```
git commit --amend -m 'nuevo mensaje del ultimo commit'
```

----





## Recuperar cambios


### Deshacer un _commit_

Buscar el _hash_ del commit problemático:

```r
git log
```

Y cuando identifiquemos el commit que queremos revertir:

```
git revert 7104ab4eadb6a69fcff94e3b41945e91a55f7294
```


### Revertir un archivo a una versión anterior

Identificar el _hash_ del _commit_ que cambió el archivo con `git log``

```
git restore archivo.R --source=89f46bd5f0a7ccee8c94eb11061e7f9c5dc7d6d2
```

Y el archivo volverá a su versión anterior. Luego también puedes volver a hacerlo para ir saltando entre versiones.


### Volver al último commit

Borra el último commit, **perdiendo tus cambios locales.**
```
git reset --hard HEAD
```


### Volver a una versión anterior de tu código

Busca el índice de la versión a la cual quieres volver, y usa `git reset` para regresar a esa versión:

```
git reflog
git reset HEAD@{index}
```

----




## Forzar cambios

### Forzar push

Por si no te deja subir los cambios, pero estás segurx de que quieres sobreescribir el repositorio remoto con tu versión local:

```
git push origin main --force
```


### Forzar pull

Cuando la versión del código que te importa es la remota (en GitHub o equivalente) y deseas descartar los cambios locales, por ejemplo, si hiciste cambios locales pero no puedes subirlos porque olvidaste ahcer `pull` antes):

```
git fetch --all
git branch backup-main
git reset --hard origin/main
```


### Ramas

Aprende a [hacer ramas online aquí](https://learngitbranching.js.org/)


## Configuraciones

### Revisar si la configuración de git y GitHub son correctas

```r
usethis::git_sitrep()
```

### Cambiar el editor de texto por defecto

Por si detestas Vim y quieres usar un editor más simple como Nano:

```
git config --global core.editor "nano"
```

Así cuando necesitas introducir texto al usar git, se abre un editor más amigable para escribir mensajes de _commit_ y otros. Puedes revisar esta configuración con `saperlipopette::exo_check_editor(".")`


### Cambiar nombre por defecto de las ramas 

Si te pasa como a mi y las ramas de tus proyectos usan el nombre antiguo, _master_, usa este comando para que en los siguientes proyectos pasen a llamarse _main_:

```
git config --global init.defaultBranch main
```

{{< relacionada "/blog/r_introduccion/tutorial_github/" >}}


### Actualizar _token_ vencido

Si se vence el token que usas en tu computador (que se usa para darle permiso a tu computador para acceder a tu cuenta), genera uno nuevo en GitHub, cópialo, y en R ejecuta:

```r
gitcreds::gitcreds_set()
```

Podrás pegar el nuevo token en la consola, y tu computador quedará autorizado para volver a hacer _pull_ a tus repositorios.


----


## Recursos

Recursos para aprender a usar `git` con R:

- [Tutorial: crear un repositorio Git para tu proyecto de R y comparte tu código en GitHub](/blog/r_introduccion/tutorial_github/)
- [Libro _Happy Git with R_](https://happygitwithr.com)
- [ohshitgit.com](https://ohshitgit.com/es)