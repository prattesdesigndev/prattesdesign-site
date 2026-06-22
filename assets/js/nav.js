/* Menu mobile — mantém aria-expanded em sincronia + fecha no clique do link / Esc.
   Acessibilidade. (A home tem essa lógica inline; aqui é a versão compartilhada
   das demais páginas.) */
(function () {
  var toggle = document.getElementById('pd-nav-toggle');
  if (!toggle) return;
  var hamb = document.querySelector('.pd-hamburger');
  var menu = document.querySelector('.nav-menu');
  function sync() {
    if (!hamb) return;
    hamb.setAttribute('aria-expanded', toggle.checked ? 'true' : 'false');
    hamb.setAttribute('aria-label', toggle.checked ? 'Fechar menu' : 'Abrir menu');
  }
  function close() { toggle.checked = false; sync(); }
  toggle.addEventListener('change', sync);
  if (menu) menu.querySelectorAll('a').forEach(function (a) { a.addEventListener('click', close); });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') close(); });
  sync();
})();
