document.addEventListener('DOMContentLoaded', function () {

  // Set admin name in sidebar
  var nameInput = document.getElementById('smsAdminName');
  if (nameInput && nameInput.value) {
    var nameEl = document.getElementById('adminNameDisplay');
    var initEl = document.getElementById('adminInitial');
    if (nameEl) nameEl.textContent = nameInput.value;
    if (initEl) initEl.textContent = nameInput.value.charAt(0).toUpperCase();
  }

  // Auto-dismiss alerts after 5s
  document.querySelectorAll('.alert').forEach(function (el) {
    setTimeout(function () {
      el.style.transition = 'opacity .4s ease';
      el.style.opacity = '0';
      setTimeout(function () { if(el.parentNode) el.remove(); }, 400);
    }, 5000);
  });

  // Show success/error from URL query params
  var params  = new URLSearchParams(window.location.search);
  var success = params.get('success');
  var error   = params.get('error');
  var box     = document.getElementById('alertBox');
  if (box) {
    if (success) {
      box.style.display = 'flex';
      box.className = 'alert alert-success';
      box.innerHTML = '<span class="alert-icon">&#10003;</span> ' +
                      decodeURIComponent(success.replace(/\+/g,' '));
      setTimeout(function() {
        box.style.opacity = '0';
        setTimeout(function() { if(box.parentNode) box.remove(); }, 400);
      }, 5000);
    } else if (error) {
      box.style.display = 'flex';
      box.className = 'alert alert-danger';
      box.innerHTML = '<span class="alert-icon">!</span> ' +
                      decodeURIComponent(error.replace(/\+/g,' '));
    }
  }

  // Highlight active nav item
  var path = window.location.pathname;
  document.querySelectorAll('.nav-item').forEach(function (item) {
    var href = item.getAttribute('href') || '';
    var servletName = href.replace('/SMS/','').replace('.jsp','');
    if (servletName && path.indexOf(servletName) > -1) {
      item.classList.add('active');
    }
  });

  // Fix SVG rendering in sidebar
  document.querySelectorAll('.nav-icon svg').forEach(function(svg) {
    svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
  });

});

function openSidebar() {
  var s = document.getElementById('sidebar');
  var o = document.getElementById('sidebarOverlay');
  if (s) s.classList.add('open');
  if (o) o.style.display = 'block';
}

function closeSidebar() {
  var s = document.getElementById('sidebar');
  var o = document.getElementById('sidebarOverlay');
  if (s) s.classList.remove('open');
  if (o) o.style.display = 'none';
}

function showToast(message, type) {
  var t = document.createElement('div');
  t.className = 'alert ' + (type === 'error' ? 'alert-danger' : 'alert-success');
  t.style.cssText = 'position:fixed;bottom:24px;right:24px;z-index:9999;min-width:260px;box-shadow:var(--shadow-lg);';
  t.innerHTML = '<span class="alert-icon">' + (type==='error'?'!':'&#10003;') + '</span> ' + message;
  document.body.appendChild(t);
  setTimeout(function() {
    t.style.opacity = '0';
    setTimeout(function() { if(t.parentNode) t.remove(); }, 400);
  }, 4000);
}
