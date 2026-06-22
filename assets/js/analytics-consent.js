/* ============================================================
   Prattes Design — Google Analytics 4 + Consent Mode + aviso de cookies (LGPD)
   - GA4 carrega com consentimento "denied" por padrão (sem cookie até o aceite)
   - Banner pergunta; "Aceitar" libera analytics_storage; "Recusar" mantém negado
   - A escolha fica salva em localStorage (não pergunta de novo)
   ID de métricas: G-X3XYXKMXTH
   ============================================================ */
(function () {
  var GA_ID = 'G-X3XYXKMXTH';
  var STORAGE = 'pd-cookie-consent';

  // dataLayer + gtag
  window.dataLayer = window.dataLayer || [];
  function gtag() { dataLayer.push(arguments); }
  window.gtag = gtag;

  // Consent Mode v2 — tudo negado por padrão (antes de carregar o gtag.js)
  gtag('consent', 'default', {
    ad_storage: 'denied',
    ad_user_data: 'denied',
    ad_personalization: 'denied',
    analytics_storage: 'denied',
    wait_for_update: 500
  });
  gtag('js', new Date());
  gtag('config', GA_ID, { anonymize_ip: true });

  // carrega o gtag.js do Google
  var s = document.createElement('script');
  s.async = true;
  s.src = 'https://www.googletagmanager.com/gtag/js?id=' + GA_ID;
  document.head.appendChild(s);

  // escolha anterior?
  var choice = null;
  try { choice = localStorage.getItem(STORAGE); } catch (e) {}
  if (choice === 'granted') { gtag('consent', 'update', { analytics_storage: 'granted' }); return; }
  if (choice === 'denied') { return; }

  // ----- Banner (só aparece sem escolha registrada) -----
  function injectBanner() {
    var style = document.createElement('style');
    style.textContent =
      '.pd-cookie{position:fixed;left:16px;right:16px;bottom:16px;z-index:99990;max-width:560px;margin:0 auto;' +
      'background:#16161a;color:#eaeaea;border:1px solid #2a2a2a;border-radius:14px;padding:18px 20px;' +
      'box-shadow:0 16px 50px rgba(0,0,0,.45);font-family:Comfortaa,system-ui,sans-serif;font-size:13.5px;line-height:1.55;' +
      'animation:pdck .35s ease both}' +
      '@keyframes pdck{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:none}}' +
      '.pd-cookie a{color:#FFDA00;text-decoration:underline}' +
      '.pd-cookie-row{display:flex;gap:10px;margin-top:14px;flex-wrap:wrap}' +
      '.pd-cookie-btn{flex:1;min-width:120px;border:0;border-radius:999px;padding:11px 18px;font-weight:700;' +
      'font-size:13px;cursor:pointer;font-family:Sora,system-ui,sans-serif;letter-spacing:.02em}' +
      '.pd-cookie-accept{background:#FFDA00;color:#111}' +
      '.pd-cookie-deny{background:transparent;color:#eaeaea;border:1px solid #3a3a3a}' +
      '@media(prefers-reduced-motion:reduce){.pd-cookie{animation:none}}';
    document.head.appendChild(style);

    var box = document.createElement('div');
    box.className = 'pd-cookie';
    box.setAttribute('role', 'dialog');
    box.setAttribute('aria-label', 'Aviso de cookies');
    box.innerHTML =
      '<div>Usamos cookies para entender como você usa o site e melhorar sua experiência. ' +
      'Saiba mais na <a href="privacidade_11_1_2.html">Política de Privacidade</a>.</div>' +
      '<div class="pd-cookie-row">' +
      '<button class="pd-cookie-btn pd-cookie-accept" type="button">Aceitar</button>' +
      '<button class="pd-cookie-btn pd-cookie-deny" type="button">Recusar</button>' +
      '</div>';
    document.body.appendChild(box);

    // no mobile, levanta o botão flutuante do WhatsApp pra não colidir com o banner
    var fab = document.querySelector('.pd-whatsapp-fab');
    var narrow = window.matchMedia && window.matchMedia('(max-width: 700px)').matches;
    if (fab && narrow) {
      fab.style.transition = 'bottom .25s ease';
      fab.style.bottom = (box.getBoundingClientRect().height + 28) + 'px';
    }
    function resetFab() { if (fab && narrow) fab.style.bottom = ''; }

    box.querySelector('.pd-cookie-accept').addEventListener('click', function () {
      try { localStorage.setItem(STORAGE, 'granted'); } catch (e) {}
      gtag('consent', 'update', { analytics_storage: 'granted' });
      resetFab(); box.remove();
    });
    box.querySelector('.pd-cookie-deny').addEventListener('click', function () {
      try { localStorage.setItem(STORAGE, 'denied'); } catch (e) {}
      resetFab(); box.remove();
    });
  }

  if (document.body) injectBanner();
  else document.addEventListener('DOMContentLoaded', injectBanner);
})();
