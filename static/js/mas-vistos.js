// quita el degradado del borde derecho de las filas con scroll horizontal
// (.mas-vistos-contenedor) cuando el scroll llega al final
document.querySelectorAll('.mas-vistos-contenedor').forEach(function (contenedor) {
  var fila = contenedor.querySelector('.mas-vistos-fila');

  function actualizar() {
    var al_final = fila.scrollLeft + fila.clientWidth >= fila.scrollWidth - 4;
    contenedor.classList.toggle('al-final', al_final);
  }

  fila.addEventListener('scroll', actualizar, { passive: true });
  window.addEventListener('resize', actualizar);
  actualizar();
});
