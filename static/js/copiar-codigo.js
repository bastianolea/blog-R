// agrega un botón para copiar el código en la esquina superior derecha
// de cada bloque de código con lenguaje (div.highlight generado por hugo/chroma)
(function () {
  const texto_inicial = "Copiar código";
  const duracion_aviso = 1500;

  function agregar_boton(bloque) {
    const boton = document.createElement("button");
    boton.type = "button";
    boton.className = "boton-copiar-codigo";
    boton.innerHTML =
      '<i class="fas fa-clone" aria-hidden="true"></i>' +
      '<span class="texto-copiar-codigo">' + texto_inicial + "</span>";

    const icono = boton.querySelector("i");
    const texto = boton.querySelector("span");
    let temporizador;

    function mostrar_estado(clase_icono, mensaje, clase_estado) {
      icono.className = "fas " + clase_icono;
      texto.textContent = mensaje;
      boton.classList.add(clase_estado);

      // reiniciar el aviso si se hace clic varias veces seguidas
      clearTimeout(temporizador);
      temporizador = setTimeout(function () {
        icono.className = "fas fa-clone";
        texto.textContent = texto_inicial;
        boton.classList.remove("copiado", "error");
      }, duracion_aviso);
    }

    boton.addEventListener("click", function () {
      const codigo = bloque.querySelector("code").textContent.replace(/\n$/, "");

      navigator.clipboard
        .writeText(codigo)
        .then(function () {
          mostrar_estado("fa-check", "¡Copiado!", "copiado");
        })
        .catch(function () {
          mostrar_estado("fa-xmark", "No se pudo copiar", "error");
        });
    });

    bloque.appendChild(boton);
  }

  // el script se carga con defer, así que el documento ya está listo
  document.querySelectorAll("div.highlight").forEach(agregar_boton);
})();
