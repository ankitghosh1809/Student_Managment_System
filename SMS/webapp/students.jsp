<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Students — Student MS</title>
  <link rel="stylesheet" href="/SMS/css/style.css">
</head>
<body>
<div class="app-layout">
  <%@ include file="navbar.jsp" %>
  <input type="hidden" id="smsAdminName" value="${adminName}">
  <main class="main-content">
    <button class="hamburger" onclick="openSidebar()">Menu</button>
    <div class="topbar">
      <div class="page-title"><h1>Students</h1><p>Manage all enrolled students</p></div>
      <a href="add-student.jsp" class="btn btn-primary">+ Add Student</a>
    </div>
    <div id="alertBox" style="display:none"></div>
    <div class="card">
      <div class="card-header">
        <h3 id="tableHeading">All Students</h3>
        <form action="StudentServlet" method="GET" class="search-bar">
          <input type="hidden" name="action" value="list">
          <input type="text" name="search" class="search-input"
                 placeholder="Search name, email, course..." value="${searchQuery}">
          <button type="submit" class="btn btn-outline btn-sm">Search</button>
          <a href="StudentServlet" class="btn btn-outline btn-sm">Clear</a>
        </form>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr><th>#</th><th>Student</th><th>Email</th><th>Course</th><th>Phone</th><th>Enrolled</th><th>Actions</th></tr>
          </thead>
          <tbody id="studentBody"></tbody>
        </table>
      </div>
    </div>
  </main>
</div>
<div class="modal-bg" id="deleteModal">
  <div class="modal-box">
    <div class="modal-icon">!</div>
    <h3>Delete Student?</h3>
    <p>Delete <strong id="deleteStudentName"></strong>? All attendance records will also be removed.</p>
    <div class="modal-btns">
      <button class="btn btn-outline" onclick="document.getElementById('deleteModal').classList.remove('open')">Cancel</button>
      <a id="deleteConfirmLink" href="#" class="btn btn-danger">Yes, Delete</a>
    </div>
  </div>
</div>
<script src="/SMS/js/app.js"></script>
<script>
var rawStudents = '<%= request.getAttribute("studentsJson") != null ? request.getAttribute("studentsJson") : "[]" %>';
var sq = '<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>';
var students = [];
try { students = JSON.parse(rawStudents); } catch(e) { students = []; }

document.getElementById('tableHeading').textContent =
  sq ? 'Results for "' + sq + '" (' + students.length + ')' : 'All Students (' + students.length + ')';

var tbody = document.getElementById('studentBody');
if (!students.length) {
  tbody.innerHTML = '<tr class="empty-row"><td colspan="7">' +
    (sq ? 'No results. <a href="StudentServlet">View all</a>.' : 'No students yet. <a href="add-student.jsp">Add first student</a>.') +
    '</td></tr>';
} else {
  var html = '';
  for (var i = 0; i < students.length; i++) {
    var s = students[i];
    var safeName = s.name.replace(/'/g,"\\'");
    html += '<tr>';
    html += '<td class="text-muted">' + (i+1) + '</td>';
    html += '<td><div class="avatar-cell"><div class="avatar">' + s.name.charAt(0).toUpperCase() + '</div><div class="cell-name">' + s.name + '</div></div></td>';
    html += '<td class="text-muted">' + s.email + '</td>';
    html += '<td><span class="badge badge-navy">' + s.course + '</span></td>';
    html += '<td class="text-muted">' + (s.phone || '-') + '</td>';
    html += '<td class="text-muted">' + (s.enrollmentDate || '-') + '</td>';
    html += '<td><div class="d-flex gap-2">';
    html += '<a href="StudentServlet?action=edit&id=' + s.id + '" class="btn btn-warn btn-sm">Edit</a>';
    html += '<a href="AttendanceServlet?studentId=' + s.id + '" class="btn btn-outline btn-sm">Attendance</a>';
    html += '<button onclick="confirmDelete(' + s.id + ',\'' + safeName + '\')" class="btn btn-danger btn-sm">Delete</button>';
    html += '</div></td>';
    html += '</tr>';
  }
  tbody.innerHTML = html;
}
function confirmDelete(id, name) {
  document.getElementById('deleteStudentName').textContent = name;
  document.getElementById('deleteConfirmLink').href = 'StudentServlet?action=delete&id=' + id;
  document.getElementById('deleteModal').classList.add('open');
}
</script>
</body>
</html>
