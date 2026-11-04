---
title: Trivia de comunas, provincias y regiones de Chile
subtitle: "Juego interactivo de preguntas hecho con R y `{territorial}`"
author: Bastián Olea Herrera
date: '2026-11-04'
slug: []
categories: []
tags:
  - Chile
  - curiosidades
  - paquetes
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
excerpt: "Mi paquete para limpiar, complementar y validar comunas y regiones de Chile, [`{territorial}`](https://bastianolea.github.io/territorial/), ahora incluye la función `trivia()` que inicia un juego de preguntas interactivo para probar tus conocimientos sobre los territorios del país. También probarlo en esta publicación sin necesidad de tener R ni instalar nada!"
links:
  - icon: dice
    icon_pack: fas
    name: Jugar
    url: https://bastianolea.github.io/territorial/articles/trivia.html
---

¡Pon a prueba tus conocimientos de comunas, regiones y provincias de Chile con este juego de preguntas! 🎉

[El paquete de R `{territorial}`](https://bastianolea.github.io/territorial/) te ayuda a [limpiar](https://bastianolea.github.io/territorial/reference/limpiar_comunas.html) y [validar](https://bastianolea.github.io/territorial/reference/validar_comunas.html) datos de comunas y regiones de Chile, y ahora le agregué un **juego de trivia interactivo**!

[Instala el paquete](https://bastianolea.github.io/territorial/articles/territorial.html#instalación) en R y ejecuta `territorial::trivia()` para iniciar una trivia interactiva sobre comunas y regiones de Chile!

Son 5 tipos de preguntas distintos, y las alternativas se crean al azar con respuestas que buscan engañarte. [Programé las preguntas](https://github.com/bastianolea/territorial/blob/main/R/pregunta_comuna.R) usando puras funciones de `{territorial}`, lo que también me sirvió para probar el paquete en aspectos que no había considerado, dando a luz [nuevas funciones](https://bastianolea.github.io/territorial/news/index.html).

También puedes **jugar en tu navegador** [aquí](https://bastianolea.github.io/territorial/articles/trivia.html) o en la consola que saldrá a continuación:

<!-- consola webR con territorial::trivia(). menu() necesita cross-origin isolation, y
     coi-serviceworker.js (en este mismo bundle) agrega los headers COOP/COEP solo en esta página.
     ojo: no dejar líneas en blanco dentro del div, o markdown corta el bloque html -->
<div class="consola">
<script>window.coi = { scope: "./" };</script>
<script src="coi-serviceworker.js"></script>
<p id="trivia-aviso" class="consola-aviso" hidden></p>
<pre id="trivia-out" class="consola-salida" aria-live="polite">Cargando R en tu navegador (puede tardar unos segundos)…
</pre>
<form id="trivia-form" class="consola-entrada" autocomplete="off">
  <input id="trivia-input" placeholder="Escribe tu respuesta y presiona Enter" aria-label="Respuesta" disabled>
  <button type="submit" id="trivia-send" disabled>Enviar</button>
  <button type="button" id="trivia-again" class="secundario" disabled>Reiniciar</button>
</form>
<script type="module">
  import { Console } from "https://webr.r-wasm.org/latest/webr.mjs";
  const out = document.getElementById("trivia-out");
  const input = document.getElementById("trivia-input");
  const send = document.getElementById("trivia-send");
  const again = document.getElementById("trivia-again");
  const ansi = /\x1b\[[0-?]*[ -\/]*[@-~]/g;
  let started = false;
  let ready = false;
  const write = (text, cls) => {
    const span = document.createElement("span");
    if (cls) span.className = cls;
    span.textContent = text.replace(ansi, "");
    out.append(span);
    out.scrollTop = out.scrollHeight;
  };
  if (window.crossOriginIsolated) {
    sessionStorage.removeItem("trivia-recargada");
  } else {
    // en la primera visita coi-serviceworker recarga la página para activar el
    // aislamiento: esperar antes de avisar o de iniciar webR
    await new Promise((resolve) => setTimeout(resolve, 4000));
    // si la recarga ocurrió antes de que el service worker tomara control, recargar una vez más
    const reg = await navigator.serviceWorker?.getRegistration("./");
    if (reg?.active && !sessionStorage.getItem("trivia-recargada")) {
      sessionStorage.setItem("trivia-recargada", "1");
      location.reload();
      await new Promise(() => {});
    }
    const aviso = document.getElementById("trivia-aviso");
    aviso.textContent = "Aviso: la página no está aislada (cross-origin isolation), " +
      "así que las preguntas podrían no aceptar respuestas. Prueba recargando la página " +
      "o usando otro navegador (no funciona en ventanas privadas de algunos navegadores).";
    aviso.hidden = false;
  }
  const con = new Console({
    stdout: (line) => {
      // ocultar el mensaje de bienvenida de R hasta que el paquete esté cargado
      if (!ready) {
        // señal de que webR ya cargó y comienza la instalación del paquete
        if (line === "__TRIVIA_INSTALANDO__") out.textContent = "Instalando el paquete {territorial}…\n";
        if (line === "__TRIVIA_LISTA__") { ready = true; out.textContent = ""; }
        return;
      }
      write(line + "\n");
    },
    stderr: (line) => write(line + "\n", "err"),
    prompt: (p) => {
      const rPrompt = p === "> " || p === "+ ";
      if (rPrompt) {
        // R volvió al prompt normal: la trivia terminó (o aún está cargando)
        input.disabled = send.disabled = true;
        again.disabled = !started;
      } else {
        // prompt de menu() ("Selection: "): esperar la respuesta
        started = true;
        write(p);
        input.disabled = send.disabled = false;
        again.disabled = true;
        input.focus({ preventScroll: true });
      }
    },
  });
  con.run();
  const sendLine = (text, echo = true) => {
    if (echo) write(text + "\n");
    con.stdin(text);
  };
  document.getElementById("trivia-form").addEventListener("submit", (e) => {
    e.preventDefault();
    sendLine(input.value);
    input.value = "";
  });
  again.addEventListener("click", () => {
    out.textContent = "";
    again.disabled = true;
    sendLine("territorial::trivia()", false);
  });
  sendLine(
    'invisible({' +
    'options(cli.num_colors = 1); ' +
    'cat("__TRIVIA_INSTALANDO__\\n"); ' +
    'webr::install("territorial", repos = c("https://bastianolea.r-universe.dev", "https://repo.r-wasm.org"), quiet = TRUE); ' +
    'suppressPackageStartupMessages(library(territorial)); ' +
    'cat("__TRIVIA_LISTA__\\n"); ' +
    'trivia()' +
    '})',
    false
  );
</script>
</div>


¡A ver si logras sacar el puntaje máximo! 🤓

{{< info "La consola de R que ves arriba es interactiva: al cargar la página se carga R y se ejecuta `territorial::trivia()` automáticamente para que empiece el cuestionario. Responde cada pregunta con el número de la alternativa y presiona _enter_. R funciona directamente en tu navegador gracias a [webR](https://docs.r-wasm.org/webr/latest/)!" >}}

Si tienes R instalado, también puedes jugar localmente en tu consola:

```r
# instalar {territorial}
install.packages("territorial", repos = "https://bastianolea.r-universe.dev")

# iniciar preguntas
library(territorial)
trivia()
```

Lee más sobre `{territorial}` en su documentación oficial:

{{< paquete "Paquete `{territorial}`"
  "https://bastianolea.github.io/territorial/articles/territorial.html"
  "/blog/territorial/hex-featured.png"
  "Herramientas para facilitar el procesamiento de datos de comunas y regiones de Chile con R, ofreciendo funciones para validación de comunas, limpiar nombres de comunas, ordenar regiones, y más." >}}