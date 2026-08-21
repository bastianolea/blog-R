// Precarga en segundo plano la app Shiny del buscador para "calentar" el
// proceso R en shinyapps.io, de modo que /buscar/ cargue más rápido.
// No se ejecuta en la propia página /buscar/, que ya carga su iframe visible.
(function () {
  if (window.location.pathname.indexOf('/buscar') === 0) return

  var conexion = navigator.connection || navigator.mozConnection || navigator.webkitConnection
  if (conexion) {
    if (conexion.saveData) return
    if (conexion.effectiveType && /2g/.test(conexion.effectiveType)) return
  }

  function precargarBuscador() {
    var iframe = document.createElement('iframe')
    iframe.src = 'https://bastianoleah.shinyapps.io/buscador/'
    iframe.style.cssText = 'position:absolute; width:1px; height:1px; opacity:0; pointer-events:none; border:none;'
    iframe.setAttribute('aria-hidden', 'true')
    iframe.setAttribute('tabindex', '-1')
    iframe.title = 'Precarga del buscador'
    document.body.appendChild(iframe)
  }

  window.addEventListener('load', function () {
    if ('requestIdleCallback' in window) {
      requestIdleCallback(precargarBuscador, { timeout: 3000 })
    } else {
      setTimeout(precargarBuscador, 1500)
    }
  })
})()
