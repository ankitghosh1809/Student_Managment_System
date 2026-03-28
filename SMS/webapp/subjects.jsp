<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Subjects — Student MS</title>
  <link rel="stylesheet" href="/SMS/css/style.css">
</head>
<body>
<div class="app-layout">
  <%@ include file="navbar.jsp" %>
  <input type="hidden" id="smsAdminName" value="${adminName}">
  <main class="main-content">
    <button class="hamburger" onclick="openSidebar()">Menu</button>
    <div class="topbar">
      <div class="page-title"><h1>Subjects</h1><p>Manage course subjects</p></div>
    </div>
    <div id="alertBox" style="display:none"></div>
    <div class="split-layout">
      <div class="card">
        <div class="card-header"><h3 id="formTitle">Add Subject</h3></div>
        <div class="card-body">
          <form id="subjectForm" action="SubjectServlet" method="POST" novalidate>
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="id" id="editId" value="">
            <div class="form-group">
              <label class="form-label">Subject Name <span class="required">*</span></label>
              <input type="text" id="subName" name="name" class="form-control" placeholder="e.g. Data Structures">
              <span class="field-error" id="nameErr">Name is required.</span>
            </div>
            <div class="form-group">
              <label class="form-label">Subject Code <span class="required">*</span></label>
              <input type="text" id="subCode" name="code" class="form-control" placeholder="e.g. CS101">
              <span class="field-error" id="codeErr">Code is required.</span>
            </div>
            <div class="form-group">
              <label class="form-label">Credits</label>
              <input type="number" id="subCredits" name="credits" class="form-control" min="1" max="6" value="3">
            </div>
            <div class="form-group">
              <label class="form-label">Description</label>
              <textarea id="subDesc" name="description" class="form-control" rows="3" placeholder="Brief description"></textarea>
            </div>
            <div class="d-flex gap-2">
              <button type="submit" class="btn btn-primary" id="submitBtn">Add Subject</button>
              <button type="button" class="btn btn-outline" id="cancelEdit" onclick="resetForm()" style="display:none">Cancel</button>
            </div>
          </form>
        </div>
      </div>
      <div class="card">
        <div class="card-header"><h3 id="tableHeading">All Subjects</h3></div>
        <div class="table-wrap">
          <table>
            <thead><tr><th>Code</th><th>Name</th><th>Credits</th><th>Actions</th></tr></thead>
            <tbody id="subjectBody"></tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>
<div class="modal-bg" id="deleteModal">
  <div class="modal-box">
    <div class="modal-icon">!</div>
    <h3>Delete Subject?</h3>
    <p>Delete <strong id="deleteSubjectName"></strong>?</p>
    <div class="modal-btns">
      <button class="btn btn-outline" onclick="document.getElementById('deleteModal').classList.remove('open')">Cancel</button>
      <a id="deleteConfirmLink" href="#" class="btn btn-danger">Yes, Delete</a>
    </div>
  </div>
</div>
<script src="/SMS/js/app.js"></script>
<script>
var rawSubjects = '<%= request.getAttribute("subjectsJson") != null ? request.getAttribute("subjectsJson") : "[]" %>';
var rawEdit     = '<%= request.getAttribute("editSubjectJson") != null ? request.getAttribute("editSubjectJson") : "null" %>';

var subjects = [];
try { subjects = JSON.parse(rawSubjects); } catch(e) { subjects = []; }

function renderTable(list) {
  document.getElementById('tableHeading').textContent = 'All Subjects (' + list.length + ')';
  var tbody = document.getElementById('subjectBody');
  if (!list.length) {
    tbody.innerHTML = '<tr class="empty-row"><td colspan="4">No subjects yet.</td></tr>';
    return;
  }
  var html = '';
  for (var i = 0; i < list.length; i++) {
    var s = list[i];
    var desc = s.description ? (s.description.length > 55 ? s.description.substring(0,55) + '...' : s.description) : '';
    var safeName = s.name.replace(/\\/g,'\\\\').replace(/'/g,"\\'");
    var safeCode = s.code.replace(/\\/g,'\\\\').replace(/'/g,"\\'");
    var safeDesc = (s.description||'').replace(/\\/g,'\\\\').replace(/'/g,"\\'");
    html += '<tr>';
    html += '<td><span class="badge badge-info">' + s.code + '</span></td>';
    html += '<td><div class="cell-name">' + s.name + '</div>';
    if (desc) html += '<div class="cell-sub">' + desc + '</div>';
    html += '</td>';
    html += '<td><span class="badge badge-navy">' + s.credits + ' cr</span></td>';
    html += '<td><div class="d-flex gap-2">';
    html += '<button onclick="editSubject(' + s.id + ',\'' + safeName + '\',\'' + safeCode + '\',' + s.credits + ',\'' + safeDesc + '\')" class="btn btn-warn btn-sm">Edit</button>';
    html += '<button onclick="confirmDelete(' + s.id + ',\'' + safeName + '\')" class="btn btn-danger btn-sm">Delete</button>';
    html += '</div></td>';
    html += '</tr>';
  }
  tbody.innerHTML = html;
}
renderTable(subjects);

var editSubj = null;
try { editSubj = JSON.parse(rawEdit); } catch(e) {}
if (editSubj && editSubj.id) {
  editSubject(editSubj.id, editSubj.name, editSubj.code, editSubj.credits, editSubj.description || '');
}

function editSubject(id, name, code, credits, desc) {
  document.getElementById('formTitle').textContent = 'Edit Subject';
  document.getElementById('formAction').value = 'edit';
  document.getElementById('editId').value = id;
  document.getElementById('subName').value = name;
  document.getElementById('subCode').value = code;
  document.getElementById('subCredits').value = credits;
  document.getElementById('subDesc').value = desc;
  document.getElementById('submitBtn').textContent = 'Update Subject';
  document.getElementById('cancelEdit').style.display = 'inline-flex';
  document.getElementById('subjectForm').scrollIntoView({behavior:'smooth'});
}
function resetForm() {
  document.getElementById('subjectForm').reset();
  document.getElementById('formTitle').textContent = 'Add Subject';
  document.getElementById('formAction').value = 'add';
  document.getElementById('editId').value = '';
  document.getElementById('submitBtn').textContent = 'Add Subject';
  document.getElementById('cancelEdit').style.display = 'none';
  document.getElementById('subCredits').value = 3;
}
document.getElementById('subjectForm').addEventListener('submit', function(e) {
  var ok = true;
  var checks = [['subName','nameErr'],['subCode','codeErr']];
  for (var i = 0; i < checks.length; i++) {
    var el = document.getElementById(checks[i][0]);
    var err = document.getElementById(checks[i][1]);
    err.classList.remove('show'); el.style.borderColor = '';
    if (!el.value.trim()) { err.classList.add('show'); el.style.borderColor = 'var(--danger)'; ok = false; }
  }
  if (!ok) e.preventDefault();
});
function confirmDelete(id, name) {
  document.getElementById('deleteSubjectName').textContent = name;
  document.getElementById('deleteConfirmLink').href = 'SubjectServlet?action=delete&id=' + id;
  document.getElementById('deleteModal').classList.add('open');
}
</script>
</body>
</html>
