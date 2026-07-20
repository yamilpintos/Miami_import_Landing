// MIAMI_IMPORT — Stock Manager · Frontend

const API = '';  // mismo dominio
let PRODUCTS_CACHE = [];

// ============ Helpers ============
const $ = sel => document.querySelector(sel);
const $$ = sel => document.querySelectorAll(sel);

// Escapado obligatorio para TODO dato que venga de la API y se inserte con
// innerHTML. Los pedidos los crea cualquiera desde el checkout publico (nombre,
// email), asi que sin esto un `<img onerror=...>` en el nombre del comprador
// ejecuta JS con la sesion del admin apenas se abre la pestana Pedidos.
// Regla: si el valor no lo escribiste vos en este archivo, va con esc().
const esc = s => String(s ?? '').replace(/[&<>"']/g,
  c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

function toast(msg, type = '') {
  const t = $('#toast');
  t.textContent = msg;
  t.className = 'toast ' + type;
  setTimeout(() => t.classList.add('hidden'), 3500);
  setTimeout(() => t.className = 'toast hidden', 3500);
}

function fmtMoney(n) {
  if (n === null || n === undefined) return '—';
  return '$ ' + Number(n).toLocaleString('es-AR', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
}

function fmtNum(n) {
  return Number(n).toLocaleString('es-AR');
}

async function api(path, opts = {}) {
  const r = await fetch(API + path, opts);
  if (r.status === 401 || r.status === 403) {
    window.location.href = '/login';
    throw new Error('Sesión expirada');
  }
  if (!r.ok) {
    const t = await r.text();
    throw new Error(t || r.statusText);
  }
  if (r.headers.get('content-type')?.includes('application/json')) {
    return r.json();
  }
  return r;
}

// ============ Tabs ============
$$('.nav-item').forEach(btn => {
  btn.addEventListener('click', () => {
    const tab = btn.dataset.tab;
    $$('.nav-item').forEach(b => b.classList.toggle('active', b.dataset.tab === tab));
    $$('.tab').forEach(s => s.classList.toggle('active', s.dataset.tab === tab));
    if (tab === 'productos' && PRODUCTS_CACHE.length === 0) loadProducts();
    if (tab === 'pedidos') loadOrders();
    if (tab === 'estadisticas') loadStatsDetail();
    if (tab === 'precios-usd') loadUsdPrices();
    if (tab === 'whatsapp') loadWaTemplates();
    if (tab === 'bot-mia') loadBotConfig();
    if (tab === 'legales') loadLegalPages();
  });
});

// ============ Dashboard ============
async function loadDashboard() {
  try {
    const s = await api('/api/stats');

    $('#kpi-publicados').textContent = fmtNum(s.productos.publicados);
    $('#kpi-publicados-sub').textContent = `de ${s.productos.total} totales`;
    $('#kpi-stock').textContent = fmtNum(s.productos.stock_total);
    $('#kpi-stock-sub').textContent = `en ${s.productos.variantes} variantes`;
    $('#kpi-sin-stock').textContent = fmtNum(s.productos.sin_stock);
    $('#kpi-facturado').textContent = fmtMoney(s.pedidos.facturado_total);
    $('#kpi-facturado-sub').textContent = `${s.pedidos.total} pedidos · ticket ${fmtMoney(s.pedidos.ticket_promedio)}`;

    // Top vendidos
    const topEl = $('#list-top-vendidos');
    if (s.top_vendidos && s.top_vendidos.length) {
      topEl.innerHTML = s.top_vendidos.map((t, i) => `
        <li>
          <span><b>${i + 1}.</b> ${esc(t.name || '—')}</span>
          <span class="qty">${t.vendidos} ${t.vendidos === 1 ? 'unidad' : 'unidades'}</span>
        </li>
      `).join('');
    } else {
      topEl.innerHTML = '<li class="loading-row">Sin ventas registradas todavía.</li>';
    }

    // Stock bajo
    const stockEl = $('#list-stock-bajo');
    if (s.stock_bajo && s.stock_bajo.length) {
      stockEl.innerHTML = s.stock_bajo.slice(0, 12).map(p => `
        <li>
          <span>${esc(p.name || '—')} <small style="color:var(--ink-mute)">· ${esc(p.brand || '')}</small></span>
          <span class="alert">${p.stock} unid.</span>
        </li>
      `).join('');
    } else {
      stockEl.innerHTML = '<li class="loading-row">¡Todo con stock OK!</li>';
    }
  } catch (e) {
    toast('Error cargando estadísticas: ' + e.message, 'error');
  }
}

$('#btn-refresh-stats').addEventListener('click', loadDashboard);

// ============ Productos ============
async function loadProducts() {
  const grid = $('#products-grid');
  grid.innerHTML = '<div class="loading">Cargando productos…</div>';
  try {
    const prods = await api('/api/products/all');
    PRODUCTS_CACHE = prods;
    renderProducts(prods);
  } catch (e) {
    grid.innerHTML = '<div class="loading">Error: ' + esc(e.message) + '</div>';
  }
}

function renderProducts(prods) {
  const grid = $('#products-grid');
  if (!prods.length) {
    grid.innerHTML = '<div class="loading">No se encontraron productos.</div>';
    return;
  }
  grid.innerHTML = prods.map(p => {
    const nm = (p.name && p.name.es) || p.name || '—';
    const brand = p.brand || '';
    const img = p.images && p.images[0] ? p.images[0].src : '';
    const stock = (p.variants || []).reduce((a, v) => a + (parseInt(v.stock) || 0), 0);
    const minPrice = Math.min(...(p.variants || []).map(v => parseFloat(v.price) || Infinity));
    let stockClass = '';
    if (stock === 0) stockClass = 'empty';
    else if (stock <= 2) stockClass = 'low';
    return `
      <div class="product-card" data-product-id="${Number(p.id)}">
        <div class="img">
          ${img ? `<img src="${esc(img)}" alt="${esc(nm)}" loading="lazy">` : '<div class="no-img">Sin imagen</div>'}
        </div>
        <div class="meta">
          <div class="brand">${esc(brand)}</div>
          <div class="name">${esc(nm)}</div>
          <div class="footline">
            <span class="price">${minPrice !== Infinity ? fmtMoney(minPrice) : '—'}</span>
            <span class="stock-pill ${stockClass}">${stock} ud.</span>
          </div>
        </div>
      </div>
    `;
  }).join('');
}

$('#search').addEventListener('input', e => {
  const q = e.target.value.trim().toLowerCase();
  if (!q) return renderProducts(PRODUCTS_CACHE);
  const filt = PRODUCTS_CACHE.filter(p => {
    const nm = ((p.name && p.name.es) || p.name || '').toLowerCase();
    const brand = (p.brand || '').toLowerCase();
    return nm.includes(q) || brand.includes(q);
  });
  renderProducts(filt);
});

// ============ Modal producto ============
async function openProduct(pid) {
  $('#modal').classList.remove('hidden');
  $('#modal-body').innerHTML = '<div class="loading">Cargando…</div>';
  try {
    const p = await api(`/api/products/${pid}`);
    renderProductModal(p);
  } catch (e) {
    $('#modal-body').innerHTML = 'Error: ' + esc(e.message);
  }
}

function renderProductModal(p) {
  const nm = (p.name && p.name.es) || p.name || '—';
  const img = p.images && p.images[0] ? p.images[0].src : '';
  const handle = (p.handle && p.handle.es) || p.handle || '';
  const url = `https://miamiimport4.mitiendanube.com/productos/${handle}/`;

  const variants = (p.variants || []).map(v => {
    const vals = v.values || [];
    const talle = vals[0]?.es || vals[0]?.value || 'Único';
    return `
      <div class="modal-row" data-vid="${Number(v.id)}">
        <span class="talle">${esc(talle)}</span>
        <span class="sku">${esc(v.sku || '')}</span>
        <span style="flex:1"></span>
        <button class="btn-stock" data-adjust="-1" data-pid="${Number(p.id)}" data-vid="${Number(v.id)}">−</button>
        <input class="stock-input" type="number" min="0" value="${Number(v.stock) || 0}" data-stock-input/>
        <button class="btn-stock" data-adjust="1" data-pid="${Number(p.id)}" data-vid="${Number(v.id)}">+</button>
        <span style="font-weight:600; min-width:80px; text-align:right">${fmtMoney(v.price)}</span>
      </div>
    `;
  }).join('');

  $('#modal-body').innerHTML = `
    <div class="modal-brand">${esc(p.brand || '—')}</div>
    <h2>${esc(nm)}</h2>
    <p style="color:var(--ink-mute); font-size:13px"><a href="${esc(url)}" target="_blank">${esc(url)} ↗</a></p>
    ${img ? `<img class="modal-img" src="${esc(img)}" alt="${esc(nm)}">` : ''}

    <h2 style="margin-top:20px; font-size:14px; letter-spacing:.08em; text-transform:uppercase; color:var(--ink-mute)">Variantes y stock</h2>
    ${variants}

    <div class="modal-actions">
      <button class="btn-primary" data-save-stock="${Number(p.id)}">Guardar cambios de stock</button>
      <button class="btn-ghost" data-open-url="${esc(url)}">Ver en tienda ↗</button>
      <button class="btn-danger" data-delete-product="${Number(p.id)}" style="margin-left:auto">Eliminar producto</button>
    </div>
  `;

  // La URL se abre desde un data-attribute: interpolarla dentro de un
  // onclick permitiria cerrar la string y ejecutar JS arbitrario.
  $('#modal-body').querySelector('[data-open-url]')
    ?.addEventListener('click', ev => window.open(ev.currentTarget.dataset.openUrl, '_blank'));
}

async function adjustStock(pid, vid, delta) {
  const row = document.querySelector(`.modal-row[data-vid="${vid}"]`);
  const input = row.querySelector('[data-stock-input]');
  const newVal = Math.max(0, (parseInt(input.value) || 0) + delta);
  input.value = newVal;
  // guardado optimista visual; el save real se hace con "Guardar cambios"
}

async function saveAllStock(pid) {
  const rows = document.querySelectorAll('.modal-row');
  let ok = 0, fail = 0;
  for (const row of rows) {
    const vid = row.dataset.vid;
    const newStock = parseInt(row.querySelector('[data-stock-input]').value) || 0;
    try {
      await api(`/api/variants/${pid}/${vid}/stock`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ stock: newStock }),
      });
      ok++;
    } catch (e) {
      fail++;
    }
  }
  if (fail === 0) {
    toast(`✓ Stock actualizado en ${ok} variantes`, 'success');
  } else {
    toast(`Actualizadas ${ok}, fallaron ${fail}`, 'error');
  }
  // refrescar el cache
  loadProducts();
}

async function deleteProduct(pid) {
  if (!confirm('¿Eliminar este producto? Esta acción NO se puede deshacer.')) return;
  try {
    await api(`/api/products/${pid}`, { method: 'DELETE' });
    toast('✓ Producto eliminado', 'success');
    $('#modal').classList.add('hidden');
    loadProducts();
  } catch (e) {
    toast('Error al eliminar: ' + e.message, 'error');
  }
}

$('#modal-close').addEventListener('click', () => $('#modal').classList.add('hidden'));
$('.modal-backdrop').addEventListener('click', () => $('#modal').classList.add('hidden'));

// ============ Alta producto ============
$('#form-nuevo').addEventListener('submit', async e => {
  e.preventDefault();
  const form = e.target;
  const status = $('#alta-status');
  const submitBtn = form.querySelector('button[type=submit]');
  const fd = new FormData(form);

  // checkboxes en FormData: si no están tildados no van, hay que normalizar
  if (!form.publicado.checked) fd.set('publicado', 'false');
  else fd.set('publicado', 'true');
  if (!form.convertir_a_ars.checked) fd.set('convertir_a_ars', 'false');
  else fd.set('convertir_a_ars', 'true');

  submitBtn.disabled = true;
  status.textContent = 'Creando producto + subiendo imágenes…';
  const result = $('#alta-result');
  result.classList.add('hidden');

  try {
    const r = await fetch(API + '/api/products', { method: 'POST', body: fd });
    const data = await r.json();
    if (!r.ok) throw new Error(data.detail || r.statusText);

    result.classList.remove('hidden');
    result.classList.remove('error');
    result.innerHTML = `
      <b>✓ Producto creado</b><br>
      ID interno: ${esc(data.product_id)}<br>
      Variantes creadas: ${esc(data.variantes_creadas)}<br>
      Imágenes subidas: ${esc(data.imagenes_subidas)}<br>
      <a href="${esc(data.url)}" target="_blank">Ver en la tienda ↗</a>
    `;
    status.textContent = '';
    form.reset();
    toast('✓ Producto creado', 'success');
    PRODUCTS_CACHE = []; // forzar recarga
  } catch (e) {
    result.classList.remove('hidden');
    result.classList.add('error');
    result.innerHTML = `<b>Error al crear:</b> ${esc(e.message)}`;
    status.textContent = '';
    toast('Error: ' + e.message, 'error');
  } finally {
    submitBtn.disabled = false;
  }
});

// ============ Pedidos ============
async function loadOrders() {
  const list = $('#orders-list');
  list.innerHTML = '<div class="loading">Cargando pedidos…</div>';
  try {
    const orders = await api('/api/orders?per_page=100');
    if (!orders.length) {
      list.innerHTML = '<div class="loading">Todavía no hay pedidos.</div>';
      return;
    }
    list.innerHTML = orders.map(o => {
      const customer = o.contact_name || '—';
      const email = o.contact_email || '';
      const fecha = o.created_at ? new Date(o.created_at).toLocaleDateString('es-AR') : '—';
      const status = o.payment_status || o.status || 'pending';
      const badge = status === 'paid' ? 'paid' : status === 'cancelled' ? 'cancelled' : 'pending';
      // Phone para WhatsApp link (puede venir en contact_phone o en shipping_address.phone)
      const phone = (o.contact_phone || (o.shipping_address && o.shipping_address.phone) || '').toString().replace(/[^0-9]/g, '');
      const orderNum = o.number || o.id;
      // Botón WhatsApp con template "coordinar_caba" pre-cargado
      const waBtn = phone
        ? `<button class="btn-ghost wa-btn" data-phone="${esc(phone)}" data-order="${esc(orderNum)}" data-name="${esc(customer)}" title="Abrir WhatsApp con plantilla">💬 WhatsApp</button>`
        : `<span style="color:#888;font-size:11px;">sin tel</span>`;
      return `
        <div class="order-row">
          <div class="num">#${esc(orderNum)}</div>
          <div class="customer">
            ${esc(customer)}
            <small>${esc(email)}</small>
          </div>
          <div>${esc(fecha)}</div>
          <div class="total">${fmtMoney(o.total)}</div>
          <div class="status"><span class="status-badge ${esc(badge)}">${esc(status)}</span></div>
          <div class="wa-cell">${waBtn}</div>
        </div>
      `;
    }).join('');

    // Wire WhatsApp buttons (event delegation seria mejor, pero ok asi)
    list.querySelectorAll('.wa-btn').forEach(btn => {
      btn.addEventListener('click', () => openWhatsappForOrder({
        phone: btn.dataset.phone,
        order: btn.dataset.order,
        name: btn.dataset.name,
      }));
    });
  } catch (e) {
    list.innerHTML = '<div class="loading">Error: ' + esc(e.message) + '</div>';
  }
}

$('#btn-refresh-orders').addEventListener('click', loadOrders);

// ============ WhatsApp helpers (usado desde Pedidos) ============
let WA_TEMPLATES_CACHE = null;
async function ensureTemplatesLoaded() {
  if (WA_TEMPLATES_CACHE) return WA_TEMPLATES_CACHE;
  try {
    WA_TEMPLATES_CACHE = await api('/api/whatsapp_templates');
  } catch (e) {
    WA_TEMPLATES_CACHE = {};
  }
  return WA_TEMPLATES_CACHE;
}

async function openWhatsappForOrder({ phone, order, name }) {
  const tpls = await ensureTemplatesLoaded();
  // Por defecto usamos "coordinar_caba". Si el usuario quiere elegir otra,
  // se puede agregar un menu desplegable, por ahora siempre coordinar.
  const tpl = tpls.coordinar_caba || 'Hola {name}, te aviso por tu pedido #{order}.';
  const txt = tpl.replace(/{name}/g, name || '').replace(/{order}/g, order || '');
  window.open(`https://wa.me/${phone}?text=${encodeURIComponent(txt)}`, '_blank');
}

// ============ Precios USD ============
async function loadUsdPrices() {
  try {
    const [data, products] = await Promise.all([
      api('/api/usd_prices'),
      PRODUCTS_CACHE.length ? Promise.resolve(PRODUCTS_CACHE) : api('/api/products/all'),
    ]);
    PRODUCTS_CACHE = products;
    const prices = data.prices || {};
    const rate = data.rate || 1410;
    $('#usd-rate-input').value = rate;
    $('#usd-rate-current').textContent = '$ ' + fmtNum(rate);

    const listEl = $('#usd-prices-list');
    if (!products.length) {
      listEl.innerHTML = '<div class="loading">Sin productos cargados.</div>';
      return;
    }
    listEl.innerHTML = `
      <table style="width:100%;border-collapse:collapse;">
        <thead>
          <tr style="border-bottom:1px solid #333;">
            <th style="text-align:left;padding:8px 4px;">Producto</th>
            <th style="text-align:left;padding:8px 4px;">Marca</th>
            <th style="text-align:right;padding:8px 4px;">USD</th>
            <th style="text-align:right;padding:8px 4px;">ARS calculado</th>
          </tr>
        </thead>
        <tbody>
          ${products.map(p => {
            const nm = typeof p.name === 'object' ? (p.name.es || '') : (p.name || '');
            const pid = String(p.id);
            const usd = prices[pid] || '';
            const arsCalc = usd ? fmtMoney(Number(usd) * rate) : '—';
            return `<tr style="border-bottom:1px solid #1f1f1f;">
              <td style="padding:8px 4px;">${esc(nm)}</td>
              <td style="padding:8px 4px;color:#888;font-size:13px;">${esc(p.brand || '—')}</td>
              <td style="padding:8px 4px;text-align:right;">
                <input type="number" step="0.01" data-pid="${esc(pid)}" value="${esc(usd)}" style="width:90px;text-align:right;" class="usd-input"/>
              </td>
              <td style="padding:8px 4px;text-align:right;color:#888;" data-ars="${esc(pid)}">${esc(arsCalc)}</td>
            </tr>`;
          }).join('')}
        </tbody>
      </table>
    `;

    // Live update ARS column al editar USD
    listEl.querySelectorAll('.usd-input').forEach(inp => {
      inp.addEventListener('input', () => {
        const pid = inp.dataset.pid;
        const usd = parseFloat(inp.value) || 0;
        const arsCell = listEl.querySelector(`[data-ars="${pid}"]`);
        if (arsCell) arsCell.textContent = usd ? fmtMoney(usd * rate) : '—';
      });
    });
  } catch (e) {
    $('#usd-prices-list').innerHTML = '<div class="loading">Error: ' + esc(e.message) + '</div>';
  }
}

$('#btn-refresh-usd')?.addEventListener('click', loadUsdPrices);

$('#btn-save-rate')?.addEventListener('click', async () => {
  const rate = parseFloat($('#usd-rate-input').value);
  if (!rate || rate <= 0) return toast('Cotización inválida', 'error');
  try {
    await api('/api/bot_config', {
      method: 'POST', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ usd_rate: rate }),
    });
    toast('Cotización guardada: $' + fmtNum(rate), 'success');
    loadUsdPrices();
  } catch (e) { toast('Error: ' + e.message, 'error'); }
});

$('#btn-seed-usd')?.addEventListener('click', async () => {
  if (!confirm('Esto va a leer todos los precios ARS actuales de Tiendanube y dividirlos por la cotización para guardar el USD equivalente. ¿Seguir?')) return;
  $('#usd-action-status').textContent = '⏳ Inicializando...';
  try {
    const r = await api('/api/usd_prices/from_current', { method: 'POST' });
    $('#usd-action-status').textContent = `✓ Listo. ${r.count} productos con USD asignado (cotización $${fmtNum(r.rate)}).`;
    toast('USD prices inicializados desde ARS actual', 'success');
    loadUsdPrices();
  } catch (e) {
    $('#usd-action-status').textContent = '✗ Error: ' + e.message;
    toast('Error: ' + e.message, 'error');
  }
});

$('#btn-sync-usd')?.addEventListener('click', async () => {
  // Primero guardar los cambios pendientes en la tabla
  const inputs = document.querySelectorAll('#usd-prices-list .usd-input');
  const prices = {};
  inputs.forEach(inp => {
    const v = parseFloat(inp.value);
    if (v > 0) prices[inp.dataset.pid] = v;
  });
  if (!Object.keys(prices).length) return toast('No hay USD prices para sincronizar', 'error');
  if (!confirm(`Esto va a SUBIR ${Object.keys(prices).length} precios ARS a Tiendanube (USD × cotización). ¿Confirmar?`)) return;

  $('#usd-action-status').textContent = '⏳ Guardando + subiendo...';
  try {
    await api('/api/usd_prices', {
      method: 'POST', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ prices }),
    });
    const r = await api('/api/usd_prices/sync_to_tiendanube', { method: 'POST' });
    $('#usd-action-status').textContent = `✓ ${r.updated_products} productos · ${r.updated_variants} variantes actualizadas (cotización $${fmtNum(r.rate)}).`;
    toast(`Precios sincronizados a Tiendanube`, 'success');
  } catch (e) {
    $('#usd-action-status').textContent = '✗ Error: ' + e.message;
    toast('Error: ' + e.message, 'error');
  }
});

// ============ WhatsApp Templates editor ============
const WA_LABELS = {
  coordinar_caba: '🚚 Coordinar entrega CABA / GBA',
  salida_camino: '🛵 Aviso "Salí en camino"',
  entregado: '✅ Confirmación de entrega',
  post_venta: '⭐ Follow-up post-venta',
  tracking_correo: '📦 Tracking del correo',
};

async function loadWaTemplates() {
  try {
    WA_TEMPLATES_CACHE = await api('/api/whatsapp_templates');
    const cnt = $('#wa-templates-container');
    cnt.innerHTML = Object.entries(WA_TEMPLATES_CACHE).map(([key, val]) => `
      <div class="form-card">
        <label>
          <b>${esc(WA_LABELS[key] || key)}</b>
          <textarea data-wa-key="${esc(key)}" rows="5">${esc(val)}</textarea>
        </label>
      </div>
    `).join('');
  } catch (e) {
    $('#wa-templates-container').innerHTML = '<div class="loading">Error: ' + esc(e.message) + '</div>';
  }
}

$('#btn-save-wa')?.addEventListener('click', async () => {
  const body = {};
  document.querySelectorAll('[data-wa-key]').forEach(t => { body[t.dataset.waKey] = t.value; });
  try {
    await api('/api/whatsapp_templates', {
      method: 'POST', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    WA_TEMPLATES_CACHE = body;
    toast('Plantillas guardadas', 'success');
  } catch (e) { toast('Error: ' + e.message, 'error'); }
});

// ============ Bot Mía config (SHIPPING_INFO etc) ============
async function loadBotConfig() {
  try {
    const cfg = await api('/api/bot_config');
    $('#cfg-shipping').value = cfg.shipping_info || '';
    $('#cfg-payment').value = cfg.payment_info || '';
    $('#cfg-exchange').value = cfg.exchange_info || '';
  } catch (e) { toast('Error: ' + e.message, 'error'); }
}

$('#btn-save-bot-cfg')?.addEventListener('click', async () => {
  const body = {
    shipping_info: $('#cfg-shipping').value,
    payment_info: $('#cfg-payment').value,
    exchange_info: $('#cfg-exchange').value,
  };
  try {
    await api('/api/bot_config', {
      method: 'POST', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    toast('Configuración del bot guardada', 'success');
  } catch (e) { toast('Error: ' + e.message, 'error'); }
});

// ============ Páginas legales ============
async function loadLegalPages() {
  try {
    const r = await api('/api/legal_pages');
    const cnt = $('#legal-pages-list');
    if (!r.available) {
      cnt.innerHTML = `<div class="panel" style="border-color:rgba(220,143,56,0.5);">
        <p><b>⚠️ No encuentro la carpeta de páginas legales.</b></p>
        <p>Esperaba: <code style="font-size:11px;">${esc(r.dir)}</code></p>
        <p>Setea la env var <code>LEGAL_PAGES_DIR</code> en el <code>.env</code> apuntando a tu carpeta <code>PEGAR_EN_ADMIN/6-paginas_legales/</code>.</p>
      </div>`;
      return;
    }
    if (!r.pages.length) {
      cnt.innerHTML = '<div class="loading">No hay HTMLs en ' + esc(r.dir) + '</div>';
      return;
    }
    cnt.innerHTML = r.pages.map(p => `
      <div class="form-card" style="display:flex;justify-content:space-between;align-items:center;">
        <div>
          <b>/${esc(p.name)}</b>
          <small style="display:block;color:#888;">${esc(p.filename)} · ${(Number(p.size)/1024).toFixed(1)} KB</small>
        </div>
        <button class="btn-secondary" data-legal-name="${esc(p.name)}">Ver y copiar</button>
      </div>
    `).join('');
    cnt.querySelectorAll('[data-legal-name]').forEach(btn => {
      btn.addEventListener('click', async () => {
        try {
          const r2 = await api(`/api/legal_pages/${btn.dataset.legalName}`);
          await navigator.clipboard.writeText(r2.html);
          toast('HTML copiado al portapapeles ✓ pegalo en admin Tiendanube → Mi tienda → Páginas', 'success');
        } catch (e) { toast('Error: ' + e.message, 'error'); }
      });
    });
  } catch (e) {
    $('#legal-pages-list').innerHTML = '<div class="loading">Error: ' + esc(e.message) + '</div>';
  }
}

// ============ Acciones ============
$('#btn-redeploy-bot')?.addEventListener('click', async () => {
  const status = $('#redeploy-status');
  status.textContent = '⏳ Disparando redeploy...';
  try {
    const r = await api('/api/actions/redeploy_bot', { method: 'POST' });
    if (r.ok) {
      status.textContent = `✓ Redeploy disparado (HTTP ${r.status}). Esperá ~3 min y verificá en Render dashboard.`;
      toast('Redeploy disparado', 'success');
    } else {
      status.textContent = '✗ ' + (r.error || 'unknown');
      toast('Error: ' + (r.error || 'unknown'), 'error');
    }
  } catch (e) {
    status.textContent = '✗ Error: ' + e.message;
    toast('Error: ' + e.message, 'error');
  }
});

// ============ Estadísticas detalle ============
async function loadStatsDetail() {
  try {
    const s = await api('/api/stats');
    const grid = $('#stats-grid');
    grid.innerHTML = `
      <div class="kpi-card">
        <div class="kpi-label">Total productos</div>
        <div class="kpi-value">${fmtNum(s.productos.total)}</div>
        <div class="kpi-sub">${s.productos.publicados} publicados</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-label">Total variantes</div>
        <div class="kpi-value">${fmtNum(s.productos.variantes)}</div>
        <div class="kpi-sub">talles + SKUs</div>
      </div>
      <div class="kpi-card kpi-success">
        <div class="kpi-label">Pedidos pagados</div>
        <div class="kpi-value">${fmtNum(s.pedidos.pagados)}</div>
        <div class="kpi-sub">de ${s.pedidos.total} totales</div>
      </div>
      <div class="kpi-card kpi-warn">
        <div class="kpi-label">Pedidos pendientes</div>
        <div class="kpi-value">${fmtNum(s.pedidos.pendientes)}</div>
        <div class="kpi-sub">a procesar</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-label">Ticket promedio</div>
        <div class="kpi-value">${fmtMoney(s.pedidos.ticket_promedio)}</div>
        <div class="kpi-sub">por pedido</div>
      </div>
      <div class="kpi-card">
        <div class="kpi-label">Stock total</div>
        <div class="kpi-value">${fmtNum(s.productos.stock_total)}</div>
        <div class="kpi-sub">unidades en catálogo</div>
      </div>
    `;
  } catch (e) {
    toast('Error: ' + e.message, 'error');
  }
}

$('#btn-refresh-stats2').addEventListener('click', loadStatsDetail);

// ============ Exportar Excel ============
$('#btn-export').addEventListener('click', () => {
  toast('Generando Excel… (puede tardar 10-30 seg)');
  window.location.href = '/api/export/excel';
});

$('#btn-logout')?.addEventListener('click', async () => {
  try { await fetch('/api/auth/logout', { method: 'POST' }); } catch (e) {}
  window.location.href = '/login';
});

// ============ Init ============
loadDashboard();

// ============ Delegacion de eventos ============
// Los handlers no van inline (onclick="...") porque eso obliga a permitir
// 'unsafe-inline' en script-src, lo que anula la CSP como defensa contra XSS.
// Se delega desde document: funciona igual para el HTML que se genera despues.
document.addEventListener('click', ev => {
  const card = ev.target.closest('[data-product-id]');
  if (card) return openProduct(Number(card.dataset.productId));

  const adj = ev.target.closest('[data-adjust]');
  if (adj) return adjustStock(Number(adj.dataset.pid), Number(adj.dataset.vid),
                              Number(adj.dataset.adjust));

  const save = ev.target.closest('[data-save-stock]');
  if (save) return saveAllStock(Number(save.dataset.saveStock));

  const del = ev.target.closest('[data-delete-product]');
  if (del) return deleteProduct(Number(del.dataset.deleteProduct));
});
