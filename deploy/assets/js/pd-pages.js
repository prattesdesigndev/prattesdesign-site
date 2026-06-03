/* ============================================================
   PRATTES DESIGN — JS compartilhado das páginas de portfólio/case
   Header scroll · Menu mobile · Reveal on scroll · Lightbox · Proteção de imagem
   ============================================================ */
(function () {
  'use strict';

  // --- Header encolhe ao rolar ---
  var header = document.getElementById('header');
  if (header) {
    window.addEventListener('scroll', function () {
      header.classList.toggle('scrolled', window.scrollY > 30);
    }, { passive: true });
  }

  // --- Menu mobile: fecha ao clicar em link ou ESC ---
  var toggle = document.getElementById('pd-nav-toggle');
  if (toggle) {
    document.querySelectorAll('.nav-menu a').forEach(function (a) {
      a.addEventListener('click', function () { toggle.checked = false; });
    });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') toggle.checked = false; });
  }

  // --- Reveal on scroll ---
  var revealEls = document.querySelectorAll('.reveal');
  if (revealEls.length && 'IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); }
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
    revealEls.forEach(function (el) { io.observe(el); });
  } else {
    revealEls.forEach(function (el) { el.classList.add('in'); });
  }

  // --- Lightbox da galeria do case ---
  var lightbox = document.getElementById('pdLightbox');
  if (lightbox) {
    var lbImg = lightbox.querySelector('.pd-lightbox-img');
    var closeBtn = lightbox.querySelector('.pd-lightbox-close');
    var prevBtn = lightbox.querySelector('.pd-lightbox-prev');
    var nextBtn = lightbox.querySelector('.pd-lightbox-next');
    var figure = lightbox.querySelector('.pd-lightbox-figure');
    var shots = Array.prototype.slice.call(document.querySelectorAll('.case-shot img, .case-feature-img'));
    var current = -1, lastFocused = null;

    shots.forEach(function (img, i) {
      img.style.cursor = 'zoom-in';
      img.tabIndex = 0;
      img.setAttribute('role', 'button');
      img.setAttribute('aria-label', 'Ampliar: ' + (img.alt || 'imagem'));
      img.addEventListener('click', function () { open(i, img); });
      img.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); open(i, img); }
      });
    });

    function open(i, src) {
      if (i < 0 || i >= shots.length) return;
      current = i; lastFocused = src || shots[i];
      lbImg.src = shots[i].src;
      lbImg.alt = shots[i].alt || '';
      lightbox.setAttribute('aria-label', shots[i].alt || 'Imagem ampliada');
      if (!lightbox.open) { lightbox.showModal(); document.body.style.overflow = 'hidden'; setTimeout(function () { closeBtn.focus(); }, 50); }
    }
    function close() { lightbox.close(); document.body.style.overflow = ''; if (lastFocused && lastFocused.focus) lastFocused.focus(); }
    function nav(d) { var n = current + d; if (n < 0) n = shots.length - 1; if (n >= shots.length) n = 0; open(n); }

    if (closeBtn) closeBtn.addEventListener('click', close);
    if (prevBtn) prevBtn.addEventListener('click', function () { nav(-1); });
    if (nextBtn) nextBtn.addEventListener('click', function () { nav(1); });
    lightbox.addEventListener('click', function (e) { if (e.target === lightbox || e.target === figure) close(); });
    lightbox.addEventListener('close', function () { document.body.style.overflow = ''; });
    document.addEventListener('keydown', function (e) {
      if (!lightbox.open) return;
      if (e.key === 'ArrowLeft') { e.preventDefault(); nav(-1); }
      if (e.key === 'ArrowRight') { e.preventDefault(); nav(1); }
    });
  }

  // --- Proteção leve de imagens (portfólio) ---
  document.addEventListener('contextmenu', function (e) {
    var t = e.target.tagName;
    if (t === 'INPUT' || t === 'TEXTAREA') return;
    e.preventDefault();
  }, false);
  document.addEventListener('dragstart', function (e) {
    if (e.target.tagName === 'IMG') e.preventDefault();
  }, false);
})();
