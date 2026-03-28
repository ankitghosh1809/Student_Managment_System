<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Student Login — Student MS</title>
  <link rel="stylesheet" href="/SMS/css/style.css">
  <style>
    .portal-switch {
      display: flex; gap: 0; margin-bottom: 28px;
      border: 1.5px solid var(--border); border-radius: var(--radius);
      overflow: hidden;
    }
    .portal-btn {
      flex: 1; padding: 10px; text-align: center;
      font-size: 13px; font-weight: 600; cursor: pointer;
      text-decoration: none; color: var(--text-3);
      transition: all var(--transition);
    }
    .portal-btn.active {
      background: var(--navy); color: var(--white);
    }
    .portal-btn:hover:not(.active) { background: var(--cream); }
  </style>
</head>
<body class="login-page">
<div class="login-bg-pattern"></div>
<div class="login-card">
  <div class="login-logo">
    <div class="login-logo-icon">
      <svg width="32" height="32" fill="none" stroke="white" stroke-width="2" viewBox="0 0 24 24">
        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
      </svg>
    </div>
    <h1>Student MS</h1>
    <p>Student Portal</p>
  </div>

  <!-- Portal Switch -->
  <div class="portal-switch">
    <a href="login.jsp" class="portal-btn">Admin Login</a>
    <a href="StudentLoginServlet" class="portal-btn active">Student Login</a>
  </div>

  <div id="serverAlert" style="display:none"></div>
  <%
    String errAttr = (String) request.getAttribute("error");
    if (errAttr != null && !errAttr.isEmpty()) {
  %>
  <div class="alert alert-danger">
    <span class="alert-icon">!</span> <%= errAttr %>
  </div>
  <% } %>

  <form id="loginForm" action="StudentLoginServlet" method="POST" novalidate>
    <div class="form-group">
      <label class="form-label">Roll Number</label>
      <div class="input-icon-wrap">
        <span class="ico">
          <svg width="15" height="15" fill="none" stroke="#7A8A9A" stroke-width="2" viewBox="0 0 24 24">
            <rect x="2" y="7" width="20" height="14" rx="2"/>
            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
          </svg>
        </span>
        <input type="text" id="rollNumber" name="rollNumber" class="form-control"
               placeholder="e.g. CS001" autocomplete="username">
      </div>
      <span class="field-error" id="rollErr">Roll number is required.</span>
    </div>
    <div class="form-group">
      <label class="form-label">Password</label>
      <div class="input-icon-wrap">
        <span class="ico">
          <svg width="15" height="15" fill="none" stroke="#7A8A9A" stroke-width="2" viewBox="0 0 24 24">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
          </svg>
        </span>
        <input type="password" id="password" name="password" class="form-control"
               placeholder="Enter password" autocomplete="current-password">
      </div>
      <span class="field-error" id="passErr">Password is required.</span>
    </div>
    <button type="submit" class="btn btn-primary btn-full" style="padding:12px;">
      Sign In
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <line x1="5" y1="12" x2="19" y2="12"/>
        <polyline points="12 5 19 12 12 19"/>
      </svg>
    </button>
  </form>

  <div class="login-hint">
    Default password: <strong>student123</strong><br>
    Roll number format: <strong>CS001, CS002...</strong>
  </div>
</div>
<script>
  document.getElementById('loginForm').addEventListener('submit', function(ev) {
    var ok = true;
    var r = document.getElementById('rollNumber');
    var p = document.getElementById('password');
    var rE = document.getElementById('rollErr');
    var pE = document.getElementById('passErr');
    rE.classList.remove('show'); pE.classList.remove('show');
    r.style.borderColor = ''; p.style.borderColor = '';
    if (!r.value.trim()) { rE.classList.add('show'); r.style.borderColor='var(--danger)'; ok=false; }
    if (!p.value.trim()) { pE.classList.add('show'); p.style.borderColor='var(--danger)'; ok=false; }
    if (!ok) ev.preventDefault();
  });
</script>
</body>
</html>
