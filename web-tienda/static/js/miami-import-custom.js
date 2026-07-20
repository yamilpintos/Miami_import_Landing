/* ===========================================================
   MIAMI_IMPORT — Custom JS
   - Carrusel arrastrable con momentum
   - Modales legales
   - Reveal on scroll
   - Marquee infinito (duplica items para loop)
   =========================================================== */
(function () {
  'use strict';

  /* -------- Drag carousel -------- */
  function initCarousel(carousel) {
    var track = carousel.querySelector('[data-mi-track]');
    if (!track) return;

    var isDown = false;
    var startX = 0;
    var startScroll = 0;
    var lastX = 0;
    var lastT = 0;
    var velocity = 0;
    var hasMoved = false;
    var DRAG_THRESHOLD = 6; // px before treating as drag (so click still works on small wiggle)

    function down(e) {
      isDown = true;
      hasMoved = false;
      startX = (e.touches ? e.touches[0].pageX : e.pageX);
      startScroll = track.scrollLeft;
      lastX = startX;
      lastT = Date.now();
      velocity = 0;
    }
    function move(e) {
      if (!isDown) return;
      var x = (e.touches ? e.touches[0].pageX : e.pageX);
      var dx = x - startX;
      if (Math.abs(dx) > DRAG_THRESHOLD) {
        if (!hasMoved) {
          hasMoved = true;
          track.classList.add('mi-grabbing');
        }
        // For touch we want native scroll to work too, so don't preventDefault
        if (!e.touches) e.preventDefault();
        track.scrollLeft = startScroll - dx * 1.4;
        var now = Date.now();
        var dt = now - lastT || 16;
        velocity = (x - lastX) / dt; // px/ms
        lastX = x; lastT = now;
      }
    }
    function up() {
      if (!isDown) return;
      isDown = false;
      if (!hasMoved) { track.classList.remove('mi-grabbing'); return; }
      // momentum
      var v = -velocity * 16; // scale to ~px per frame
      var maxFrames = 90;
      var f = 0;
      function step() {
        if (Math.abs(v) < 0.4 || f++ > maxFrames) {
          track.classList.remove('mi-grabbing');
          return;
        }
        track.scrollLeft += v;
        v *= 0.93;
        requestAnimationFrame(step);
      }
      requestAnimationFrame(step);
    }

    // Mouse
    track.addEventListener('mousedown', down);
    window.addEventListener('mousemove', move);
    window.addEventListener('mouseup', up);
    // Prevent stray click after drag
    track.addEventListener('click', function (e) {
      if (hasMoved) {
        e.preventDefault();
        e.stopPropagation();
        hasMoved = false;
      }
    }, true);
    // Touch
    track.addEventListener('touchstart', down, { passive: true });
    track.addEventListener('touchmove', move, { passive: true });
    track.addEventListener('touchend', up);
    track.addEventListener('touchcancel', up);

    // Arrow buttons
    var prev = carousel.querySelector('.mi-prev');
    var next = carousel.querySelector('.mi-next');
    if (prev) prev.addEventListener('click', function () {
      track.scrollBy({ left: -track.clientWidth * 0.85, behavior: 'smooth' });
    });
    if (next) next.addEventListener('click', function () {
      track.scrollBy({ left: track.clientWidth * 0.85, behavior: 'smooth' });
    });
  }

  function initAllCarousels() {
    document.querySelectorAll('[data-mi-carousel]').forEach(initCarousel);
  }

  /* -------- Modal opener (legales) -------- */
  function initModals() {
    document.addEventListener('click', function (e) {
      var t = e.target.closest('[data-mi-open]');
      if (t) {
        e.preventDefault();
        var id = t.getAttribute('data-mi-open');
        var modal = document.getElementById(id);
        if (modal) {
          modal.hidden = false;
          document.body.classList.add('mi-modal-open');
        }
        return;
      }
      if (e.target.matches('[data-mi-close]')) {
        var modal2 = e.target.closest('.mi-modal');
        if (modal2) { modal2.hidden = true; }
        if (!document.querySelector('.mi-modal:not([hidden])')) {
          document.body.classList.remove('mi-modal-open');
        }
      }
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') {
        document.querySelectorAll('.mi-modal:not([hidden])').forEach(function (m) { m.hidden = true; });
        document.body.classList.remove('mi-modal-open');
      }
    });
  }

  /* -------- Reveal on scroll -------- */
  function initReveal() {
    if (!('IntersectionObserver' in window)) {
      document.querySelectorAll('[data-mi-reveal]').forEach(function (el) { el.classList.add('mi-revealed'); });
      return;
    }
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('mi-revealed');
          io.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 });
    document.querySelectorAll('[data-mi-reveal]').forEach(function (el) { io.observe(el); });
  }

  /* -------- Duplicate marquee content for seamless loop -------- */
  function initMarquees() {
    document.querySelectorAll('[data-mi-marquee]').forEach(function (track) {
      track.innerHTML = track.innerHTML + track.innerHTML;
    });
  }

  /* -------- Boot -------- */
  function boot() {
    initAllCarousels();
    initModals();
    initReveal();
    initMarquees();
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else {
    boot();
  }
})();
