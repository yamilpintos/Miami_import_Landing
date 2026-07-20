/*!
 * Miami Import — Dual Price Display
 * Shows "USD XXX" above + "Precio final: $X ARS" below for every price.
 * Pure JS file: Tiendanube serves as static asset, no Twig parsing.
 *
 * CHANGE THE EXCHANGE RATE: edit USD_RATE constant below.
 */
(function () {
  'use strict';

  var USD_RATE = 1428;

  var PRICE_SELECTORS = [
    '.js-price-display',
    '.js-item-price',
    '.item-price',
    '.product-item-price',
    '.product-price',
    '.price'
  ];

  function formatARS(n) {
    n = Math.round(n);
    var s = n.toString();
    var out = '';
    while (s.length > 3) {
      out = '.' + s.slice(-3) + out;
      s = s.slice(0, -3);
    }
    return '$' + s + out;
  }

  function extractARSValue(text) {
    if (!text) return null;
    var clean = text.replace(/[^\d.,]/g, '');
    if (!clean) return null;
    if (clean.indexOf(',') !== -1) {
      clean = clean.replace(/\./g, '').replace(',', '.');
    } else {
      var parts = clean.split('.');
      if (parts.length > 2 || (parts.length === 2 && parts[1].length === 3)) {
        clean = parts.join('');
      }
    }
    var val = parseFloat(clean);
    return isNaN(val) ? null : val;
  }

  function processPriceElement(el) {
    if (!el || el.dataset.miamiPriceDone === '1') return;
    if (el.querySelector('.miami-price-usd')) {
      el.dataset.miamiPriceDone = '1';
      return;
    }
    var raw = el.textContent.trim();
    var ars = extractARSValue(raw);
    if (!ars || ars < 3000) return;
    var usd = Math.round(ars / USD_RATE);
    if (usd <= 0) return;
    el.classList.add('miami-price-dual');
    el.innerHTML =
      '<span class="miami-price-usd">USD ' + usd + '</span>' +
      '<span class="miami-price-ars-label">Precio final:</span>' +
      '<span class="miami-price-ars">' + formatARS(ars) + ' ARS</span>';
    el.dataset.miamiPriceDone = '1';
  }

  function processAll() {
    PRICE_SELECTORS.forEach(function (sel) {
      document.querySelectorAll(sel).forEach(processPriceElement);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', processAll);
  } else {
    processAll();
  }

  /* Re-process en cambios dinamicos */
  if (window.MutationObserver) {
    var observer = new MutationObserver(function () {
      if (window._miamiPriceTimeout) return;
      window._miamiPriceTimeout = setTimeout(function () {
        window._miamiPriceTimeout = null;
        PRICE_SELECTORS.forEach(function (sel) {
          document.querySelectorAll(sel).forEach(function (el) {
            if (el.dataset.miamiPriceDone === '1' && !el.querySelector('.miami-price-usd')) {
              el.dataset.miamiPriceDone = '';
            }
          });
        });
        processAll();
      }, 150);
    });
    observer.observe(document.body, { childList: true, subtree: true, characterData: true });
  }

  document.addEventListener('cart_change', processAll);
  document.addEventListener('variant_change', processAll);
})();
