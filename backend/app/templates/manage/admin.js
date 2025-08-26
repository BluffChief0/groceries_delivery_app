// ===== Настройки API / Auth =====
const API_BASE = ''; // если фронт и API на одном домене, оставь пустым
const AUTH_LOGIN_URL = '/auth/jwt/login'; // подставь свой эндпоинт логина (fastapi-users)

// Глобальное состояние
const state = {
  view: 'categories',
  token: localStorage.getItem('adm_token') || null,
  userEmail: localStorage.getItem('adm_user') || null,
  uploadedUrl: null, // сюда кладём URL картинки после загрузки
};

// Обертка над fetch с токеном
async function apiFetch(path, opts = {}) {
  const headers = opts.headers ? {...opts.headers} : {};
  if (state.token) headers['Authorization'] = `Bearer ${state.token}`;
  const resp = await fetch(API_BASE + path, {...opts, headers});
  if (resp.status === 401) {
    showAuthPanel(true);
    throw new Error('Требуется вход');
  }
  return resp;
}

// ====== Навигация (табы) ======
function switchView(view) {
  state.view = view;
  document.querySelector('header h1').textContent = ({
    categories: 'Категории',
    products: 'Продукты',
    users: 'Пользователи',
    employees: 'Сотрудники'
  })[view] || 'Админка';

  for (const b of document.querySelectorAll('.tab')) {
    b.classList.toggle('active', b.dataset.view === view);
  }
  for (const s of document.querySelectorAll('section[data-view]')) {
    s.classList.toggle('active', s.getAttribute('data-view') === view);
  }

  if (view === 'categories') loadCategories();
  if (view === 'products') loadProducts();
  if (view === 'users') loadUsersPlaceholder();
  if (view === 'employees') loadEmployeesPlaceholder();

  location.hash = '#' + view;
}

function initRouting() {
  const initial = location.hash?.slice(1) || 'categories';
  switchView(initial);
  window.addEventListener('hashchange', () => {
    const v = location.hash?.slice(1) || 'categories';
    switchView(v);
  });
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
function loadEmployeesPlaceholder(){
  document.getElementById('employeesList').innerHTML =
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


async function loadProducts(){
  const box = document.getElementById('productsList');
  box.innerHTML = 'Загрузка...';
  try{
    const r = await apiFetch('/manage/products');   // ← дергаем бэкенд
    if(!r.ok) throw new Error('HTTP '+r.status);
    const data = await r.json();
    if(data.length === 0){
      box.innerHTML = '<div class="muted">Пока нет продуктов</div>';
      return;
    }
    box.innerHTML = '';
    for (const p of data){
      const div = document.createElement('div');
      div.className = 'card';
      div.innerHTML = `
        <div class="title">
          <img class="img" src="${p.image_url || ''}" alt="">
          <div>
            <div>${escapeHtml(p.name)}</div>
            <div class="muted" style="font-size:12px">${p.id}</div>
          </div>
        </div>`;
      box.appendChild(div);
    }
  } catch(e){
    box.innerHTML = '<div class="muted">Ошибка: '+e.message+'</div>';
  }
  document.getElementById('pBtnUpload')?.addEventListener('click', uploadProductImage);
  document.getElementById('pBtnCreate')?.addEventListener('click', createProduct);
  document.getElementById('pBtnReload')?.addEventListener('click', loadProducts);
}