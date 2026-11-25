// controla los degradados de las filas con scroll horizontal (.mas-vistos-contenedor):
// el derecho se oculta al llegar al final (.al-final); el izquierdo solo aparece con scroll (.con-scroll)
document.querySelectorAll('.mas-vistos-contenedor').forEach(function (contenedor) {
  var fila = contenedor.querySelector('.mas-vistos-fila');

  function actualizar() {
    var al_final = fila.scrollLeft + fila.clientWidth >= fila.scrollWidth - 4;
    contenedor.classList.toggle('al-final', al_final);
    contenedor.classList.toggle('con-scroll', fila.scrollLeft > 4);
  }

  fila.addEventListener('scroll', actualizar, { passive: true });
  window.addEventListener('resize', actualizar);
  actualizar();
});
