document.addEventListener('DOMContentLoaded', function () {
  // Set admin name in sidebar
  const nameInput = document.getElementById('smsAdminName');
  if (nameInput && nameInput.value) {
    const nameEl = document.getElementById('adminNameDisplay');
    const initEl = document.getElementById('adminInitial');
    if (nameEl) nameEl.textContent = nameInput.value;
    if (initEl) initEl.textContent = nameInput.value.charAt(0).toUpperCase();
  }
  // Auto-dismiss alerts after 5s
  document.querySelectorAll('.alert').forEach(function (el) {
    setTimeout(function () {
      el.style.transition = 'opacity .4s ease';
      el.style.opacity = '0';
      setTimeout(function () { el.remove(); }, 400);
    }, 5000);
  });
  // Show success/error from URL query params
  const params  = new URLSearchParams(window.location.search);
  const success = params.get('success');
  const error   = params.get('error');
  const box     = document.getElementById('alertBox');
  if (box) {
    if (success) {
      box.style.display = 'flex';
      box.className = 'alert alert-success';
      box.innerHTML = '<span class="alert-icon">✅</span>' +
                      decodeURIComponent(success.replace(/\+/g,' '));
      setTimeout(() => {
        box.style.opacity = '0';
        setTimeout(() => box.remove(), 400);
      }, 5000);
    } else if (error) {
      box.style.display = 'flex';
      box.className = 'alert alert-danger';
      box.innerHTML = '<span class="alert-icon">⚠️</span>' +
                      decodeURIComponent(error.replace(/\+/g,' '));
    }
  }
  // Highlight active nav item
  const path = window.location.pathname + window.location.search;
  document.querySelectorAll('.nav-item').forEach(function (item) {
    const href = item.getAttribute('href') || '';
    if (href && path.includes(href.split('?')[0].replace('/',''))) {
      item.classList.add('active');
    }
  });
});
function openSidebar() {
  document.getElementById('sidebar').classList.add('open');
  document.getElementById('sidebarOverlay').style.display = 'block';
}
function closeSidebar() {
  document.getElementById('sidebar').classList.remove('open');
  document.getElementById('sidebarOverlay').style.display = 'none';
}
function showToast(message, type) {
  const t = document.createElement('div');
  t.className = 'alert ' + (type === 'error' ? 'alert-danger' : 'alert-success');
  t.style.cssText = 'position:fixed;bottom:24px;right:24px;z-index:9999;min-width:260px;box-shadow:var(--shadow-lg);';
  t.innerHTML = '<span class="alert-icon">' + (type==='error'?'⚠️':'✅') + '</span>' + message;
  document.body.appendChild(t);
  setTimeout(() => { t.style.opacity='0'; setTimeout(()=>t.remove(),400); }, 4000);
}
