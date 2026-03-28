<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Edit Student — Student MS</title>
  <link rel="stylesheet" href="/SMS/css/style.css">
</head>
<body>
<div class="app-layout">
  <%@ include file="navbar.html" %>
  <input type="hidden" id="smsAdminName" value="${adminName}">
  <main class="main-content">
    <button class="hamburger" onclick="openSidebar()">☰</button>
    <div class="topbar">
      <div class="page-title">
        <h1>Edit Student</h1>
        <p>Updating record for <strong>${student.name}</strong></p>
      </div>
      <a href="StudentServlet" class="btn btn-outline">← Back</a>
    </div>
    <div id="serverAlert" style="display:none"></div>
    <div class="card" style="max-width:760px;">
      <div class="card-header"><h3>Edit Student Information</h3></div>
      <div class="card-body">
        <form id="editForm" action="StudentServlet" method="POST" novalidate>
          <input type="hidden" name="action" value="edit">
          <input type="hidden" name="id"     value="${student.id}">
          <div class="form-grid-2">
            <div class="form-group">
              <label class="form-label">Full Name <span class="required">*</span></label>
              <input type="text" id="name" name="name" class="form-control" value="${student.name}">
              <span class="field-error" id="nameErr">Full name is required.</span>
            </div>
            <div class="form-group">
              <label class="form-label">Email <span class="required">*</span></label>
              <input type="email" id="email" name="email" class="form-control" value="${student.email}">
              <span class="field-error" id="emailErr">Valid email is required.</span>
            </div>
            <div class="form-group">
              <label class="form-label">Course <span class="required">*</span></label>
              <input type="text" id="course" name="course" class="form-control" value="${student.course}">
              <span class="field-error" id="courseErr">Course is required.</span>
            </div>
            <div class="form-group">
              <label class="form-label">Phone</label>
              <input type="tel" name="phone" class="form-control" value="${student.phone}">
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Address</label>
            <textarea name="address" class="form-control" rows="3">${student.address}</textarea>
          </div>
          <div class="d-flex gap-2 mt-4">
            <button type="submit" class="btn btn-primary">💾 Save Changes</button>
            <a href="StudentServlet" class="btn btn-outline">Cancel</a>
          </div>
        </form>
      </div>
    </div>
  </main>
</div>
<script src="/SMS/js/app.js"></script>
<script>
  const errMsg = '${error}';
  if (errMsg) {
    const b = document.getElementById('serverAlert');
    b.style.display = 'flex'; b.className = 'alert alert-danger';
    b.innerHTML = '<span class="alert-icon">⚠️</span>' + errMsg;
  }
  document.getElementById('editForm').addEventListener('submit', function(e) {
    let ok = true;
    [['name','nameErr'],['email','emailErr'],['course','courseErr']].forEach(([id, eid]) => {
      const el = document.getElementById(id), err = document.getElementById(eid);
      err.classList.remove('show'); el.style.borderColor = '';
      if (!el.value.trim()) { err.classList.add('show'); el.style.borderColor='var(--danger)'; ok=false; }
    });
    if (!ok) e.preventDefault();
  });
</script>
</body>
</html>
