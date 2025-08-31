// ===== Настройки API / Auth =====
const API_BASE = ''; // если фронт и API на одном домене, оставь пустым
const AUTH_LOGIN_URL = '/auth/jwt/login'; // подставь свой эндпоинт логина (fastapi-users)

// Глобальное состояние
const state = {
  view: 'categories',
  token: localStorage.getItem('adm_token') || null,
  userEmail: localStorage.getItem('adm_user') || null,
  uploadedUrl: null,

  // ↓↓↓ добавь это ↓↓↓
  productsFilter: '',    // выбранная категория ('' = все)
  _filterDocHandler: null, // чтоб не навешивать документ-клик много раз
};

// Обертка над fetch с токеном
async function apiFetch(url, opts={}) {
  opts.headers = opts.headers || {};
  if (state.token) opts.headers.Authorization = 'Bearer ' + state.token;
  const res = await fetch(url, opts);
  if (res.status === 401) {
    logout(); switchView('login');
    throw new Error('Unauthorized');
  }
  return res;
}

// ====== Навигация (табы) ======
async function switchView(view) {
  const mustLogin = !state.token && view !== 'login';
  if (mustLogin) view = 'login';

  state.view = view;
  document.querySelector('header h1').textContent = ({
    categories: 'Категории',
    products:   'Продукты',
    users:      'Пользователи',
    workers:  'Сотрудники'
  })[view] || 'Админка';

  for (const b of document.querySelectorAll('.tab')) {
    b.classList.toggle('active', b.dataset.view === view);
  }
  for (const s of document.querySelectorAll('section[data-view]')) {
    s.classList.toggle('active', s.getAttribute('data-view') === view);
  }
  
  if (view === 'login') initLoginView();
  if (view === 'categories') loadCategories();
  if (view === 'products') {
    wireFilterDropdown();          // включаем выпадашку
    await loadProductCategories(); // построить меню категорий и селект создания
    await loadProducts();          // загрузить список с учётом фильтра
  }
  if (view === 'users') loadUsersPlaceholder();
  if (view === 'workers') loadWorkersPlaceholder();

  location.hash = '#' + view;
}

// ====== Auth UI ======
function showAuthPanel(show) {
  document.getElementById('authPanel').classList.toggle('open', !!show);
}
function reflectAuth() {
  const btn = document.getElementById('loginBtn');
  const msg = document.getElementById('authMsg');
  if (state.token) {
    btn.textContent = state.userEmail ? `👤 ${state.userEmail}` : 'Аккаунт';
    msg.textContent = 'Вы вошли';
  } else {
    btn.textContent = 'Войти';
    msg.textContent = '';
  }
}

async function doLogin() {
  const email = document.getElementById('loginEmail').value.trim();
  const pass = document.getElementById('loginPassword').value.trim();
  const msg = document.getElementById('authMsg');
  msg.textContent = '';
  if (!email || !pass) { msg.textContent = 'Заполните email и пароль'; return; }

  const body = new URLSearchParams();
  body.set('username', email);
  body.set('password', pass);

  try {
    const r = await fetch(API_BASE + AUTH_LOGIN_URL, {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body
    });
    if (!r.ok) { msg.textContent = 'Ошибка входа: HTTP ' + r.status; return; }
    let data = {};
    try { data = await r.json(); } catch {}
    const token = data.access_token || data.token || null;
    if (!token) { msg.textContent = 'Не получил токен. Проверь формат ответа.'; return; }

    state.token = token;
    state.userEmail = email;
    localStorage.setItem('adm_token', token);
    localStorage.setItem('adm_user', email);
    reflectAuth();
    showAuthPanel(false);
  } catch(e) { msg.textContent = 'Ошибка сети: ' + e.message; }
}

function doLogout() {
  state.token = null;
  state.userEmail = null;
  localStorage.removeItem('adm_token');
  localStorage.removeItem('adm_user');
  reflectAuth();
}

// ====== Категории ======
async function loadCategories(){
  const list = document.getElementById('list');
  list.innerHTML = 'Загрузка...';
  try{
    const r = await apiFetch('/manage/categories');
    if(!r.ok) throw new Error('HTTP '+r.status);
    const data = await r.json();
    if(data.length === 0){
      list.innerHTML = '<div class="muted">Пока нет категорий</div>';
      return;
    }
    list.innerHTML = '';
    for(const c of data){
      const card = document.createElement('div');
      card.className = 'card';
      card.innerHTML = `
        <div class="title">
          <img class="img" src="${c.image_url}" alt="">
          <div>
            <div>${escapeHtml(c.name)}</div>
            <div class="muted" style="font-size:12px">${c.id}</div>
          </div>
        </div>
        <div style="margin-top:10px" class="row">
          <button class="danger" onclick="delCategory('${c.id}')">Удалить</button>
        </div>`;
      list.appendChild(card);
    }
  }catch(e){
    list.innerHTML = '<div class="muted">Ошибка загрузки: '+e.message+'</div>';
  }
}

async function createCategory(){
  const name = document.getElementById('name').value.trim();
  const msg = document.getElementById('msg');
  msg.textContent = '';
  if(!name){ msg.textContent = 'Название обязательно'; return; }
  if(!state.uploadedUrl){ msg.textContent = 'Сначала загрузите картинку'; return; }

  try{
    const r = await apiFetch('/manage/categories', {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({name, image_url: state.uploadedUrl})
    });
    if(r.status === 201){
      document.getElementById('name').value='';
      document.getElementById('file').value='';
      const preview = document.getElementById('preview');
      preview.style.display='none'; preview.src='';
      state.uploadedUrl = null;
      await loadCategories();
      msg.textContent = 'Категория создана.';
    }else{
      msg.textContent = 'Ошибка: '+(await r.text());
    }
  }catch(e){
    msg.textContent = 'Ошибка сети: '+e.message;
  }
}

async function delCategory(id){
  if(!confirm('Удалить категорию?')) return;
  const msg = document.getElementById('msg');
  msg.textContent = '';
  try{
    const r = await apiFetch('/manage/categories/'+id, { method:'DELETE' });
    if(r.ok){
      await loadCategories();
      msg.textContent = 'Удалено.';
    }else{
      msg.textContent = 'Ошибка удаления: '+(await r.text());
    }
  }catch(e){
    msg.textContent = 'Ошибка сети: '+e.message;
  }
}

async function uploadCategoryImage(){
  const f = document.getElementById('file').files[0];
  const name = document.getElementById('name').value.trim();
  const msg = document.getElementById('msg');   // элемент для сообщений
  msg.textContent = '';

  if(!name){ msg.textContent = "Введите название категории"; return; }
  if(!f){ msg.textContent = "Выберите файл."; return; }

  const fd = new FormData();
  fd.append("file", f);
  fd.append("category_name", name);

  try {
    const r = await fetch('/files/categories/upload', {method: 'POST', body: fd});
    if(!r.ok){
      msg.textContent = 'Ошибка загрузки: HTTP ' + r.status + ' ' + (await r.text());
      return;
    }
    const data = await r.json();
    state.uploadedUrl = data.url;

    // превью картинки
    const preview = document.getElementById('preview');
    preview.src = data.url;
    preview.style.display = 'inline-block';

    msg.textContent = 'Картинка загружена.';
  } catch(e){
    msg.textContent = 'Ошибка сети: ' + e.message;
  }
}

// ===== Заглушки остальных разделов =====
function loadProductsPlaceholder(){
  document.getElementById('productsList').innerHTML =
    '<div class="card"><div class="muted">Здесь будет список продуктов с выбором категории.</div></div>';
}
function loadUsersPlaceholder(){
  document.getElementById('usersList').innerHTML =
    '<div class="card"><div class="muted">Здесь будет управление пользователями.</div></div>';
}
function loadWorkersPlaceholder(){
  document.getElementById('workersList').innerHTML =
    '<div class="card"><div class="muted">Здесь будет управление сотрудниками.</div></div>';
}

// ===== Утилиты =====
function escapeHtml(s){ return s.replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m])); }

// ===== Инициализация =====
function initUI(){
  document.getElementById('tabs').addEventListener('click', (e)=>{
    const btn = e.target.closest('.tab'); if(!btn) return;
    switchView(btn.dataset.view);
  });
  // auth
  document.getElementById('loginBtn').addEventListener('click', ()=> showAuthPanel(!document.getElementById('authPanel').classList.contains('open')));
  document.getElementById('doLogin').addEventListener('click', doLogin);
  document.getElementById('doLogout').addEventListener('click', ()=>{ doLogout(); showAuthPanel(false); });
  reflectAuth();

  // категории: кнопки
//   document.getElementById('btnUpload').addEventListener('click', uploadCategoryImage);
//   document.getElementById('btnCreate').addEventListener('click', createCategory);
//   document.getElementById('btnReload').addEventListener('click', loadCategories);


    document.getElementById('btnUpload').addEventListener('click', ()=>{ console.log('upload click'); uploadCategoryImage(); });
  document.getElementById('btnCreate').addEventListener('click', ()=>{ console.log('create click'); createCategory(); });
  document.getElementById('btnReload').addEventListener('click', ()=>{ console.log('reload click'); loadCategories(); });
}

window.addEventListener('DOMContentLoaded', ()=>{
  initUI();
  initRouting();
});

document.getElementById('pToggleCreate')?.addEventListener('click', () => {
  const panel = document.getElementById('pCreatePanel');
  if (!panel) return;
  panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
  if (panel.style.display === 'block') panel.open = true; // раскрываем details
});
document.getElementById('pBtnCancel')?.addEventListener('click', () => {
  resetProductForm();
});
document.getElementById('nutriAdd')?.addEventListener('click', addNutriRow);
document.getElementById('pBtnUpload')?.addEventListener('click', uploadProductImage);
document.getElementById('pBtnCreate')?.addEventListener('click', createProduct);
document.getElementById('pBtnReload')?.addEventListener('click', loadProducts);


async function loadProductCategories() {
  const sel = document.getElementById('pCategory');
  sel.innerHTML = '<option>Загрузка...</option>';
  try {
    const r = await apiFetch('/manage/categories');
    if (!r.ok) throw new Error('HTTP ' + r.status);
    const cats = await r.json();
    sel.innerHTML = cats.map(c => `<option value="${c.id}">${escapeHtml(c.name)}</option>`).join('');
  } catch(e) {
    sel.innerHTML = '<option>Ошибка: '+e.message+'</option>';
  }
}

async function uploadProductImage(){
  const f = document.getElementById('pFile').files[0];
  const name = document.getElementById('pName').value.trim();
  const msg = document.getElementById('pMsg');
  msg.textContent = '';

  if(!name){ msg.textContent = "Введите название продукта"; return; }
  if(!f){ msg.textContent = "Выберите файл."; return; }

  const fd = new FormData();
  fd.append("file", f);
  fd.append("name", name);

  try {
    const r = await apiFetch('/files/products/upload', { method:'POST', body: fd });
    if(!r.ok){
      msg.textContent = 'Ошибка загрузки: HTTP ' + r.status + ' ' + (await r.text());
      return;
    }
    const data = await r.json();
    state.uploadedUrl = data.url;

    const preview = document.getElementById('pPreview');
    preview.src = data.url;
    preview.style.display = 'inline-block';

    msg.textContent = 'Картинка загружена.';
  } catch(e){
    msg.textContent = 'Ошибка сети: ' + e.message;
  }
}

async function createProduct(){
  const msg = document.getElementById('pMsg');
  msg.textContent = '';

  const name        = document.getElementById('pName').value.trim();
  const category_id = document.getElementById('pCategory').value;
  const image_url   = state.uploadedUrl;

  if(!name){ msg.textContent = 'Название обязательно'; return; }
  if(!category_id){ msg.textContent = 'Выберите категорию'; return; }
  if(!image_url){ msg.textContent = 'Сначала загрузите картинку'; return; }

  // собираем остальные поля
  const price          = toDecOrNull( document.getElementById('pPrice').value );
  const discount_price = toDecOrNull( document.getElementById('pDiscountPrice').value );
  const weight         = toFloatOrNull( document.getElementById('pWeight').value );
  const calories       = toIntOrNull( document.getElementById('pCalories').value );
  const country        = toNullIfEmpty( document.getElementById('pCountry').value );
  const pkg            = toNullIfEmpty( document.getElementById('pPackage').value );
  const description    = toNullIfEmpty( document.getElementById('pDesc').value );
  const composition    = toNullIfEmpty( document.getElementById('pComposition').value );
  const nutritional    = buildNutritional();

  // !!! ВАЖНО: твой бэк (сейчас) требует id — сгенерим на фронте
  const id = (crypto && crypto.randomUUID) ? crypto.randomUUID() : String(Date.now());

  const payload = {
    id,                 // если бэк перестанет требовать — можно убрать
    category_id,
    name,
    description,
    image_url,
    price: price ?? 0,  // у тебя price NOT NULL; ставим 0 если пусто
    discount_price,     // nullable
    stock: 0,           // NOT NULL в БД — подстрахуемся
    rating: null,       // nullable
    composition,
    nutritional,        // list[dict] | null
    package: pkg,
    calories,
    weight,
    country
  };

  try{
    const r = await apiFetch('/manage/products', {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify(payload)
    });
    if(r.status === 201 || r.status === 200){
      resetProductForm();
      await loadProducts(); // обновим список с учётом текущего фильтра
      msg.textContent = 'Товар создан.';
    }else{
      msg.textContent = 'Ошибка: '+(await r.text());
    }
  }catch(e){
    msg.textContent = 'Ошибка сети: '+e.message;
  }
}

async function loadProductCategories() {
  const createSel = document.getElementById('pCategory'); // селект для создания
  const menu = document.getElementById('pFilterMenu');    // меню фильтра
  const btn  = document.getElementById('pFilterBtn');     // большая кнопка

  if (createSel) createSel.innerHTML = '<option>Загрузка...</option>';
  if (menu) menu.innerHTML = '<div class="muted" style="padding:6px 10px">Загрузка...</div>';

  try {
    const r = await apiFetch('/manage/categories');
    if (!r.ok) throw new Error('HTTP ' + r.status);
    const cats = await r.json();

    // селект для создания товара
    if (createSel) {
      createSel.innerHTML = cats.map(c =>
        `<option value="${c.id}">${escapeHtml(c.name)}</option>`
      ).join('');
    }

    // пункты меню фильтра
    if (menu) {
      const html = [
        `<button type="button" data-id="" data-name="Все категории">Все категории</button>`,
        ...cats.map(c => `<button type="button" data-id="${c.id}" data-name="${escapeHtml(c.name)}">${escapeHtml(c.name)}</button>`)
      ].join('');
      menu.innerHTML = html;

      // ВАЖНО: без {once:true}; переопределяем обработчик, чтобы не плодить дубликаты
      menu.onclick = (e) => {
        const b = e.target.closest('button[data-id]');
        if (!b) return;
        setProductsFilter(b.dataset.id, b.dataset.name);
      };
    }

    // подпись на кнопке
    if (btn) {
      btn.textContent = (state.productsFilter
        ? (cats.find(c => c.id === state.productsFilter)?.name || 'Категория')
        : 'Все категории') + ' ▾';
    }

  } catch (e) {
    if (menu) menu.innerHTML = `<div class="muted" style="padding:6px 10px">Ошибка: ${e.message}</div>`;
    if (createSel) createSel.innerHTML = '<option>Ошибка</option>';
  }
}


function renderProductsList(data) {
  const box = document.getElementById('productsList');
  if (!Array.isArray(data) || data.length === 0) {
    box.innerHTML = '<div class="muted">Товары не найдены</div>';
    return;
  }
  box.innerHTML = '';
  for (const p of data) {
    const div = document.createElement('div');
    div.className = 'card';
    div.innerHTML = `
      <div class="title">
        <img class="img" src="${p.image_url || ''}" alt="">
        <div>
          <div>${escapeHtml(p.name)}</div>
          <div class="muted" style="font-size:12px">${p.id}</div>
        </div>
      </div>
      <div class="row" style="margin-top:10px">
        <button class="danger" onclick="delProduct('${p.id}')">Удалить</button>
      </div>`;
    box.appendChild(div);
  }
}


async function delProduct(id){
  if (!confirm('Удалить продукт?')) return;
  const msg = document.getElementById('pMsg');
  msg.textContent = '';
  try{
    const r = await apiFetch('/manage/products/' + encodeURIComponent(id), { method: 'DELETE' });
    if (r.ok){
      await loadProducts();        // перечитываем с учетом текущего state.productsFilter
      msg.textContent = 'Удалено.';
    } else {
      msg.textContent = 'Ошибка удаления: ' + (await r.text());
    }
  } catch(e){
    msg.textContent = 'Ошибка сети: ' + e.message;
  }
}


async function loadProducts() {
  const box = document.getElementById('productsList');
  const filterId = state.productsFilter || '';
  box.innerHTML = 'Загрузка...';

  try {
    const url = filterId
      ? `/manage/products?category_id=${encodeURIComponent(filterId)}`
      : '/manage/products';

    let r = await apiFetch(url);
    if (!r.ok) throw new Error('HTTP ' + r.status);

    const all = await r.json();
    // 👉 Всегда фильтруем на клиенте, если filterId задан
    const data = filterId
      ? all.filter(p => String(p.category_id ?? p.category?.id ?? '') === String(filterId))
      : all;

    renderProductsList(data);
  } catch (e) {
    box.innerHTML = '<div class="muted">Ошибка: ' + e.message + '</div>';
  }

  document.getElementById('pBtnUpload')?.addEventListener('click', uploadProductImage);
  document.getElementById('pBtnCreate')?.addEventListener('click', createProduct);
  document.getElementById('pBtnReload')?.addEventListener('click', loadProducts);
}


function wireFilterDropdown(){
  const box  = document.getElementById('pFilterBox');
  const btn  = document.getElementById('pFilterBtn');
  const menu = document.getElementById('pFilterMenu');
  if (!box || !btn || !menu) return;

  btn.onclick = () => menu.classList.toggle('open');

  // навешиваем «клик-вне» один раз за сессию
  if (!state._filterDocHandler) {
    state._filterDocHandler = (e) => {
      if (!box.contains(e.target)) menu.classList.remove('open');
    };
    document.addEventListener('click', state._filterDocHandler);
  }
}

function setProductsFilter(id, name){
  state.productsFilter = id || '';
  const btn  = document.getElementById('pFilterBtn');
  const menu = document.getElementById('pFilterMenu');
  if (btn)  btn.textContent  = `${name || 'Все категории'} ▾`;
  if (menu) menu.classList.remove('open');
  loadProducts();
}

function addNutriRow(name = '', value = '') {
  const list = document.getElementById('nutriList');
  const row = document.createElement('div');
  row.className = 'row';
  row.innerHTML = `
    <input class="nutri-name" placeholder="показатель (напр., белки, г/100г)" style="flex:1" value="${escapeHtml(name)}" />
    <input class="nutri-value" placeholder="значение (напр., 1.2)" style="width:200px" value="${escapeHtml(value)}" />
    <button type="button" class="ghost nutri-del">×</button>
  `;
  row.querySelector('.nutri-del').onclick = () => row.remove();
  list.appendChild(row);
}

function readNutriList() {
  const items = [];
  document.querySelectorAll('#nutriList .row').forEach(r => {
    const n = r.querySelector('.nutri-name')?.value.trim();
    const v = r.querySelector('.nutri-value')?.value.trim();
    if (n && v) items.push({ name: n, value: v });
  });
  return items.length ? items : null;
}

function resetProductForm() {
  const panel = document.getElementById('pCreatePanel');
  if (panel) { panel.open = false; panel.style.display = 'none'; }

  state.uploadedUrl = null;

  const ids = [
    'pName','pPrice','pDiscountPrice','pWeight','pCalories',
    'pCountry','pPackage','pDesc','pComposition','pProt','pFat','pCarb'
  ];
  ids.forEach(id => {
    const el = document.getElementById(id);
    if (el) el.value = '';
  });

  const f = document.getElementById('pFile');
  if (f) f.value = '';

  const preview = document.getElementById('pPreview');
  if (preview) {
    preview.src = '';
    preview.style.display = 'none';
  }

  // если хочешь — синхронизируй селект категории с текущим фильтром
  const sel = document.getElementById('pCategory');
  if (sel && state.productsFilter) sel.value = state.productsFilter;
}

function toNullIfEmpty(s){ const v = (s ?? '').toString().trim(); return v === '' ? null : v; }
function toDecOrNull(s){ const v = toNullIfEmpty(s); return v===null ? null : Number(v); }
function toIntOrNull(s){ const v = toNullIfEmpty(s); return v===null ? null : parseInt(v,10); }
function toFloatOrNull(s){ const v = toNullIfEmpty(s); return v===null ? null : parseFloat(v); }

function _toNumOrNull(s){
  const t = (s ?? '').toString().trim();
  if (!t) return null;
  const n = Number(t.replace(',', '.'));
  return Number.isFinite(n) ? n : null;
}

function _toNumOrNull(s){
  const t = (s ?? '').toString().trim();
  if (!t) return null;
  const n = Number(t.replace(',', '.'));
  return Number.isFinite(n) ? n : null;
}

function buildNutritional(){
  const p = _toNumOrNull(document.getElementById('pProt')?.value);
  const f = _toNumOrNull(document.getElementById('pFat')?.value);
  const c = _toNumOrNull(document.getElementById('pCarb')?.value);

  // Бэку нужен список объектов; кладём один объект с тремя полями.
  return [{
    proteins:       p ?? 0,
    fats:           f ?? 0,
    carbohydrates:  c ?? 0,
  }];
}