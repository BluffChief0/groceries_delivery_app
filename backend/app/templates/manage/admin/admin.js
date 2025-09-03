// ===== Настройки API / Auth =====
const API_BASE = '';                 // если фронт и API на одном домене, оставь пустым
const AUTH_LOGIN_URL = '/auth/jwt/login'; // эндпоинт логина fastapi-users

// ===== Глобальное состояние =====
const state = {
  view: 'categories',
  token: localStorage.getItem('adm_token') || null,
  userEmail: localStorage.getItem('adm_user') || null,
  uploadedUrl: null,                 // последний загруженный image_url (категории/продукты)
  productsFilter: '',                // фильтр по id категории; '' = все
  _filterDocHandler: null
};

// ===== Утилиты =====
const qs = (sel, root=document) => root.querySelector(sel);
const qsa = (sel, root=document) => Array.from(root.querySelectorAll(sel));
const escapeHtml = s => (s ?? '').toString().replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));

function showAuthPanel(open) {
  const panel = qs('#authPanel');
  if (!panel) return;
  if (open === undefined) {
    // toggle
    panel.classList.toggle('open');
  } else {
    panel.classList.toggle('open', !!open);
  }
}

function reflectAuth() {
  const btn = qs('#loginBtn');
  const msg = qs('#authMsg');
  if (state.token) {
    if (btn) btn.textContent = state.userEmail ? `👤 ${state.userEmail}` : 'Аккаунт';
    if (msg) msg.textContent = 'Вы вошли';
  } else {
    if (btn) btn.textContent = 'Войти';
    if (msg) msg.textContent = '';
  }
}

// Обёртка над fetch с токеном и обработкой 401
async function apiFetch(url, opts = {}) {
  opts.headers = opts.headers || {};
  if (state.token) opts.headers.Authorization = 'Bearer ' + state.token;
  const res = await fetch(url, opts);
  if (res.status === 401) {
    doLogout();                      // <— правильная функция
    switchView('login');
    throw new Error('Unauthorized');
  }
  return res;
}

// ====== Навигация (табы) ======
async function switchView(view) {
  const mustLogin = !state.token && view !== 'login';
  if (mustLogin) view = 'login';

  state.view = view;
  const title = ({
    categories: 'Категории',
    products:   'Продукты',
    users:      'Пользователи',
    workers:    'Сотрудники',
    login:      'Вход'
  })[view] || 'Админка';
  const h1 = qs('header h1'); if (h1) h1.textContent = title;

  // подсветка табов
  qsa('.tab').forEach(b => b.classList.toggle('active', b.dataset.view === view));
  // показ нужного section
  qsa('section[data-view]').forEach(s => s.classList.toggle('active', s.getAttribute('data-view') === view));

  if (view === 'categories') {
    await loadCategories();
  } else if (view === 'products') {
    await loadProductCategories();   // подтянем категории, нужен селект и фильтр
    await loadProducts();
  } else if (view === 'users') {
    loadUsersPlaceholder();
  } else if (view === 'workers') {
    loadWorkersPlaceholder();
  } else if (view === 'login') {
    // ничего
  }
}

// ====== Аутентификация ======
async function doLogin() {
  const email = qs('#loginEmail')?.value.trim();
  const pass  = qs('#loginPassword')?.value.trim();
  const msg   = qs('#authMsg');
  if (msg) msg.textContent = '';
  if (!email || !pass) { if (msg) msg.textContent = 'Заполните email и пароль'; return; }

  const body = new URLSearchParams();
  body.set('username', email);
  body.set('password', pass);

  try {
    const r = await fetch(API_BASE + AUTH_LOGIN_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body
    });
    if (!r.ok) {
      const txt = await r.text();
      throw new Error(`Ошибка входа: ${txt}`);
    }
    const data = await r.json();     // fastapi-users вернёт {access_token, token_type, ...}
    state.token = data.access_token;
    state.userEmail = email;
    localStorage.setItem('adm_token', state.token);
    localStorage.setItem('adm_user', email);
    reflectAuth();
    showAuthPanel(false);
    switchView('categories');
  } catch (e) {
    if (msg) msg.textContent = e.message;
  }
}

function doLogout() {
  state.token = null;
  state.userEmail = null;
  localStorage.removeItem('adm_token');
  localStorage.removeItem('adm_user');
  reflectAuth();
}

// ====== Категории ======
async function uploadCategoryImage() {
  const f = qs('#file');
  const name = qs('#name')?.value.trim() || '';
  const msg = qs('#msg');
  if (!f || !f.files || !f.files[0]) { if (msg) msg.textContent = 'Выберите файл'; return; }
  if (!name) { if (msg) msg.textContent = 'Сначала введите название категории (нужно для имени файла)'; return; }
  if (msg) msg.textContent = '';

  const fd = new FormData();
  fd.append('file', f.files[0]);
  fd.append('category_name', name);

  try {
    const r = await apiFetch('/categories/upload', { method: 'POST', body: fd });
    if (!r.ok) throw new Error(await r.text());
    const data = await r.json();     // ожидаем {image_url: '/categories/images/.../img.png'}
    state.uploadedUrl = data.image_url;
    const prev = qs('#preview');
    if (prev) { prev.src = data.image_url; prev.style.display = 'block'; }
    if (msg) msg.textContent = 'Картинка загружена.';
  } catch (e) {
    if (msg) msg.textContent = 'Ошибка загрузки: ' + e.message;
  }
}

async function createCategory() {
  const name = qs('#name')?.value.trim();
  const msg = qs('#msg');
  if (msg) msg.textContent = '';
  if (!name) { if (msg) msg.textContent = 'Название обязательно'; return; }
  if (!state.uploadedUrl) { if (msg) msg.textContent = 'Сначала загрузите картинку'; return; }

  try {
    const r = await apiFetch('/manage/categories', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, image_url: state.uploadedUrl })
    });
    if (r.status === 201 || r.ok) {
      if (qs('#name')) qs('#name').value = '';
      if (qs('#file')) qs('#file').value = '';
      const prev = qs('#preview'); if (prev) { prev.style.display = 'none'; prev.src = ''; }
      state.uploadedUrl = null;
      if (msg) msg.textContent = 'Готово!';
      await loadCategories();
    } else {
      throw new Error(await r.text());
    }
  } catch (e) {
    if (msg) msg.textContent = 'Ошибка: ' + e.message;
  }
}

async function delCategory(id) {
  if (!confirm('Удалить категорию?')) return;
  const msg = qs('#msg');
  if (msg) msg.textContent = '';
  try {
    const r = await apiFetch('/manage/categories/' + encodeURIComponent(id), { method: 'DELETE' });
    if (!r.ok) throw new Error(await r.text());
    if (msg) msg.textContent = 'Удалено.';
    await loadCategories();
  } catch (e) {
    if (msg) msg.textContent = 'Ошибка удаления: ' + e.message;
  }
}

async function loadCategories() {
  const list = qs('#list');
  if (!list) return;
  list.innerHTML = 'Загрузка...';
  try {
    const r = await apiFetch('/manage/categories');
    if (!r.ok) throw new Error(await r.text());
    const data = await r.json();
    list.innerHTML = '';
    if (!Array.isArray(data) || data.length === 0) {
      list.innerHTML = '<div class="muted">Пока пусто</div>';
      return;
    }
    for (const c of data) {
      const card = document.createElement('div');
      card.className = 'card';
      card.innerHTML = `
        <div class="row">
          <img src="${escapeHtml(c.image_url || '')}" alt="" width="48" height="48" style="border-radius:8px;object-fit:cover;margin-right:10px">
          <div>
            <div class="name">${escapeHtml(c.name || '')}</div>
            <div class="muted" style="font-size:12px">${escapeHtml(c.id || '')}</div>
          </div>
        </div>
        <div class="row" style="margin-top:10px">
          <button class="danger" onclick="delCategory('${c.id}')">Удалить</button>
        </div>`;
      list.appendChild(card);
    }
  } catch (e) {
    list.innerHTML = '<div class="muted">Ошибка загрузки: ' + escapeHtml(e.message) + '</div>';
  }
}

// ====== Продукты ======
function toNullIfEmpty(s) { const v = (s ?? '').toString().trim(); return v === '' ? null : v; }
function toDecOrNull(s)  { const v = toNullIfEmpty(s); return v === null ? null : Number(v); }
function toIntOrNull(s)  { const v = toNullIfEmpty(s); return v === null ? null : parseInt(v,10); }
function toFloatOrNull(s){ const v = toNullIfEmpty(s); return v === null ? null : parseFloat(v); }

function addNutriRow() {
  const ul = qs('#nutriList'); if (!ul) return;
  const li = document.createElement('li');
  li.className = 'nutri-row';
  li.innerHTML = `
    <input type="text" class="nutri-name"  placeholder="Показатель">
    <input type="number" step="0.01" class="nutri-amount" placeholder="Значение">
    <input type="text" class="nutri-unit"  placeholder="Ед.изм">
    <button type="button" class="muted small nutri-del">✕</button>`;
  ul.appendChild(li);
  li.querySelector('.nutri-del').addEventListener('click', () => li.remove());
}

function buildNutritional() {
  const ul = qs('#nutriList'); if (!ul) return null;
  const rows = qsa('li.nutri-row', ul);
  const out = {};
  for (const r of rows) {
    const name = toNullIfEmpty(qs('.nutri-name', r)?.value);
    const amount = toFloatOrNull(qs('.nutri-amount', r)?.value);
    const unit = toNullIfEmpty(qs('.nutri-unit', r)?.value);
    if (name && amount !== null) {
      out[name] = unit ? `${amount} ${unit}` : amount;
    }
  }
  return Object.keys(out).length ? out : null;
}

async function uploadProductImage() {
  const f = qs('#pFile');
  const name = qs('#pName')?.value.trim() || '';
  const msg = qs('#pMsg');
  if (!f || !f.files || !f.files[0]) { if (msg) msg.textContent = 'Выберите файл'; return; }
  if (!name) { if (msg) msg.textContent = 'Введите название товара (для имени файла)'; return; }
  if (msg) msg.textContent = '';

  const fd = new FormData();
  fd.append('file', f.files[0]);
  fd.append('product_name', name);

  try {
    const r = await apiFetch('/products/upload', { method: 'POST', body: fd });
    if (!r.ok) throw new Error(await r.text());
    const data = await r.json();     // {image_url: '/products/images/...png'}
    state.uploadedUrl = data.image_url;
    const prev = qs('#pPreview');
    if (prev) { prev.src = data.image_url; prev.style.display = 'block'; }
    if (msg) msg.textContent = 'Картинка загружена.';
  } catch (e) {
    if (msg) msg.textContent = 'Ошибка загрузки: ' + e.message;
  }
}

async function createProduct() {
  const msg = qs('#pMsg'); if (msg) msg.textContent = '';
  const category_id = qs('#pCategory')?.value || '';
  const name  = qs('#pName')?.value.trim() || '';
  const image_url = state.uploadedUrl;
  if (!name) { if (msg) msg.textContent = 'Название обязательно'; return; }
  if (!category_id) { if (msg) msg.textContent = 'Выберите категорию'; return; }
  if (!image_url) { if (msg) msg.textContent = 'Сначала загрузите картинку'; return; }

  const price          = toDecOrNull(qs('#pPrice')?.value);
  const discount_price = toDecOrNull(qs('#pDiscountPrice')?.value);
  const weight         = toFloatOrNull(qs('#pWeight')?.value);
  const calories       = toIntOrNull(qs('#pCalories')?.value);
  const country        = toNullIfEmpty(qs('#pCountry')?.value);
  const pkg            = toNullIfEmpty(qs('#pPackage')?.value);
  const description    = toNullIfEmpty(qs('#pDesc')?.value);
  const composition    = toNullIfEmpty(qs('#pComposition')?.value);
  const nutritional    = buildNutritional();

  // На случай, если бек сейчас требует id
  const id = (crypto && crypto.randomUUID) ? crypto.randomUUID() : String(Date.now());

  const payload = {
    id,
    category_id,
    name,
    description,
    image_url,
    price: price ?? 0,
    discount_price,
    stock: 0,
    rating: null,
    composition,
    weight,
    calories,
    country,
    package: pkg,
    nutritional_value: nutritional,
  };

  try {
    const r = await apiFetch('/manage/products', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    if (!r.ok) throw new Error(await r.text());
    if (msg) msg.textContent = 'Товар создан';
    await loadProducts();
    resetProductForm();
  } catch (e) {
    if (msg) msg.textContent = 'Ошибка создания: ' + e.message;
  }
}

async function delProduct(id) {
  if (!confirm('Удалить продукт?')) return;
  const msg = qs('#pMsg'); if (msg) msg.textContent = '';
  try {
    const r = await apiFetch('/manage/products/' + encodeURIComponent(id), { method: 'DELETE' });
    if (!r.ok) throw new Error(await r.text());
    if (msg) msg.textContent = 'Удалено.';
    await loadProducts();
  } catch (e) {
    if (msg) msg.textContent = 'Ошибка удаления: ' + e.message;
  }
}

async function loadProductCategories() {
  const sel  = qs('#pCategory');      // селект в форме создания товара
  const btn  = qs('#pFilterBtn');     // кнопка "Все категории ▾"
  const menu = qs('#pFilterMenu');    // выпадающее меню
  const label = qs('#pFilterLabel');  // опциональная подпись

  // 1) тянем публичные категории (НЕ /manage/categories)
  const resp = await apiFetch('/categories');
  if (!resp.ok) throw new Error(await resp.text());
  const cats = await resp.json();

  // 2) селект в форме создания
  if (sel) {
    sel.innerHTML = '<option value="">— категория —</option>';
    for (const c of cats) {
      const o = document.createElement('option');
      o.value = c.id;
      o.textContent = c.name;
      sel.appendChild(o);
    }
    if (state.productsFilter) sel.value = state.productsFilter;
  }

  // 3) выпадающее меню фильтра
  if (btn && menu) {
    // кнопки вместо div (лучше ловят клик и фокус)
    menu.innerHTML = `
      <button type="button" class="menu-item" data-id="" data-name="Все категории">Все категории</button>
      ${cats.map(c => `<button type="button" class="menu-item" data-id="${c.id}" data-name="${c.name}">${c.name}</button>`).join('')}
    `;

    // подпись на кнопке и (если есть) в label
    const current = state.productsFilter
      ? (cats.find(c => c.id === state.productsFilter)?.name || 'Все категории')
      : 'Все категории';
    btn.textContent = current + ' ▾';
    if (label) label.textContent = 'Фильтр: ' + current;

    // чтобы текст не выделялся при клике/drag
    menu.addEventListener('mousedown', (e) => e.preventDefault());

    // делегированный клик по любому пункту
    menu.onclick = (e) => {
      const item = e.target.closest('.menu-item');
      if (!item) return;
      state.productsFilter = item.dataset.id || '';
      const name = item.dataset.name || 'Все категории';
      btn.textContent = name + ' ▾';
      if (label) label.textContent = 'Фильтр: ' + name;
      menu.classList.remove('open');
      loadProducts();
    };

    // открыть/закрыть меню
    btn.onclick = (e) => { e.stopPropagation(); menu.classList.toggle('open'); };
    document.addEventListener('click', (e) => {
      if (!menu.contains(e.target) && e.target !== btn) menu.classList.remove('open');
    });
  }
}

async function loadProducts() {
  const box = qs('#productsList'); if (!box) return;
  box.innerHTML = 'Загрузка...';
  try {
    const url = state.productsFilter
      ? `/manage/products?category_id=${encodeURIComponent(state.productsFilter)}`
      : '/manage/products';
    const r = await apiFetch(url);
    if (!r.ok) { box.innerHTML = 'Ошибка: ' + escapeHtml(await r.text()); return; }
    const data = await r.json();

    box.innerHTML = '';
    if (!Array.isArray(data) || data.length === 0) {
      box.innerHTML = '<div class="muted">Пока пусто</div>';
      return;
    }

    for (const p of data) {
      const div = document.createElement('div');
      div.className = 'card';
      div.innerHTML = `
        <div class="row">
          <img src="${escapeHtml(p.image_url || '')}" alt="" width="48" height="48" style="border-radius:8px;object-fit:cover;margin-right:10px">
          <div>
            <div class="name">${escapeHtml(p.name || '')}</div>
            <div class="muted" style="font-size:12px">${escapeHtml(p.id || '')}</div>
          </div>
        </div>
        <div class="row" style="margin-top:10px">
          <button class="danger" onclick="delProduct('${p.id}')">Удалить</button>
        </div>`;
      box.appendChild(div);
    }
  } catch (e) {
    box.innerHTML = '<div class="muted">Ошибка загрузки: ' + escapeHtml(e.message) + '</div>';
  }
}

function resetProductForm() {
  // спрятать превью
  const prev = qs('#pPreview'); if (prev) { prev.src = ''; prev.style.display = 'none'; }
  state.uploadedUrl = null;
  ['pName','pPrice','pDiscountPrice','pWeight','pCalories','pCountry','pPackage','pDesc','pComposition','pProt','pFat','pCarb'].forEach(id => { const el = qs('#'+id); if (el) el.value=''; });
  const f = qs('#pFile'); if (f) f.value = '';
  // синхронизировать селект с текущим фильтром
  const sel = qs('#pCategory'); if (sel && state.productsFilter) sel.value = state.productsFilter;
}

// ====== Заглушки ======
function loadUsersPlaceholder(){
  const el = qs('#usersList');
  if (el) el.innerHTML = '<div class="card"><div class="muted">Здесь будет управление пользователями.</div></div>';
}
function loadWorkersPlaceholder(){
  const el = qs('#workersList');
  if (el) el.innerHTML = '<div class="card"><div class="muted">Здесь будет управление сотрудниками.</div></div>';
}

// ====== Инициализация ======
function initUI() {
  // табы
  qs('#tabs')?.addEventListener('click', (e) => {
    const btn = e.target.closest('.tab'); if (!btn) return;
    switchView(btn.dataset.view);
  });

  // auth
  qs('#loginBtn')?.addEventListener('click', () => showAuthPanel());
  qs('#doLogin')?.addEventListener('click', doLogin);
  qs('#doLogout')?.addEventListener('click', () => { doLogout(); showAuthPanel(false); });
  reflectAuth();

  // категории
  qs('#btnUpload')?.addEventListener('click', uploadCategoryImage);
  qs('#btnCreate')?.addEventListener('click', createCategory);
  qs('#btnReload')?.addEventListener('click', loadCategories);

  // продукты
  qs('#pToggleCreate')?.addEventListener('click', () => {
    const panel = qs('#pCreatePanel');
    if (!panel) return;
    panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
  });
  qs('#pBtnUpload')?.addEventListener('click', uploadProductImage);
  qs('#pBtnCreate')?.addEventListener('click', createProduct);
  qs('#pBtnReload')?.addEventListener('click', loadProducts);
  qs('#nutriAdd')?.addEventListener('click', addNutriRow);
}

window.addEventListener('DOMContentLoaded', () => {
  initUI();
  const startView = (location.hash || '#categories').slice(1);
  switchView(startView);
});

// Сделаем часть функций глобальными для onclick в разметке
window.delCategory = delCategory;
window.delProduct = delProduct;
