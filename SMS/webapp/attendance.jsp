<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Attendance — Student MS</title>
  <link rel="stylesheet" href="/SMS/css/style.css">
</head>
<body>
<div class="app-layout">
  <%@ include file="navbar.jsp" %>
  <input type="hidden" id="smsAdminName" value="${adminName}">
  <main class="main-content">
    <button class="hamburger" onclick="openSidebar()">Menu</button>
    <div class="topbar">
      <div class="page-title"><h1>Attendance</h1><p>Track and manage student attendance</p></div>
    </div>
    <div id="alertBox" style="display:none"></div>
    <div class="split-layout">
      <div class="card">
        <div class="card-header"><h3>Mark Attendance</h3></div>
        <div class="card-body">
          <form id="attForm" action="AttendanceServlet" method="POST" novalidate>
            <div class="form-group">
              <label class="form-label">Student <span class="required">*</span></label>
              <select id="studentId" name="studentId" class="form-control">
                <option value="">Select Student</option>
              </select>
              <span class="field-error" id="studentErr">Please select a student.</span>
            </div>
            <div class="form-group">
              <label class="form-label">Subject <span class="required">*</span></label>
              <select id="subjectId" name="subjectId" class="form-control">
                <option value="">Select Subject</option>
              </select>
              <span class="field-error" id="subjectErr">Please select a subject.</span>
            </div>
            <div class="form-group">
              <label class="form-label">Date <span class="required">*</span></label>
              <input type="date" id="attDate" name="date" class="form-control">
            </div>
            <div class="form-group">
              <label class="form-label">Status</label>
              <div class="radio-row">
                <label class="radio-opt opt-present"><input type="radio" name="status" value="Present" checked> Present</label>
                <label class="radio-opt opt-absent"><input type="radio" name="status" value="Absent"> Absent</label>
                <label class="radio-opt opt-late"><input type="radio" name="status" value="Late"> Late</label>
              </div>
            </div>
            <button type="submit" class="btn btn-primary btn-full">Mark Attendance</button>
          </form>
        </div>
      </div>
      <div class="card">
        <div class="card-header"><h3>Attendance Statistics</h3></div>
        <div class="table-wrap">
          <table>
            <thead><tr><th>Student</th><th>Present</th><th>Total</th><th>%</th></tr></thead>
            <tbody id="statsBody"></tbody>
          </table>
        </div>
      </div>
    </div>
    <div class="card">
      <div class="card-header">
        <h3>Attendance Records</h3>
        <form action="AttendanceServlet" method="GET" class="search-bar">
          <label style="font-size:13px;color:var(--text-3)">Filter by date:</label>
          <input type="date" name="date" class="form-control" style="width:auto" value="${filterDate}">
          <button type="submit" class="btn btn-outline btn-sm">Filter</button>
          <a href="AttendanceServlet" class="btn btn-outline btn-sm">Clear</a>
        </form>
      </div>
      <div class="table-wrap">
        <table>
          <thead><tr><th>Student</th><th>Subject</th><th>Date</th><th>Status</th></tr></thead>
          <tbody id="recordsBody"></tbody>
        </table>
      </div>
    </div>
  </main>
</div>
<script src="/SMS/js/app.js"></script>
<script>
document.getElementById('attDate').value = new Date().toISOString().split('T')[0];

var rawStudents = '<%= request.getAttribute("studentsJson") != null ? request.getAttribute("studentsJson") : "[]" %>';
var rawSubjects = '<%= request.getAttribute("subjectsJson") != null ? request.getAttribute("subjectsJson") : "[]" %>';
var rawStats    = '<%= request.getAttribute("attendanceStatsJson") != null ? request.getAttribute("attendanceStatsJson") : "[]" %>';
var rawRecords  = '<%= request.getAttribute("attendanceJson") != null ? request.getAttribute("attendanceJson") : "[]" %>';

var students = [], subjects = [], stats = [], records = [];
try { students = JSON.parse(rawStudents); } catch(e) {}
try { subjects = JSON.parse(rawSubjects); } catch(e) {}
try { stats    = JSON.parse(rawStats);    } catch(e) {}
try { records  = JSON.parse(rawRecords);  } catch(e) {}

// Populate student dropdown
var sSel = document.getElementById('studentId');
for (var i = 0; i < students.length; i++) {
  var opt = document.createElement('option');
  opt.value = students[i].id;
  opt.textContent = students[i].name + ' - ' + students[i].course;
  sSel.appendChild(opt);
}

// Populate subject dropdown
var subSel = document.getElementById('subjectId');
for (var i = 0; i < subjects.length; i++) {
  var opt = document.createElement('option');
  opt.value = subjects[i].id;
  opt.textContent = subjects[i].name + ' (' + subjects[i].code + ')';
  subSel.appendChild(opt);
}

// Render stats
var sb = document.getElementById('statsBody');
if (!stats.length) {
  sb.innerHTML = '<tr class="empty-row"><td colspan="4">No records yet.</td></tr>';
} else {
  var html = '';
  for (var i = 0; i < stats.length; i++) {
    var s = stats[i];
    var pct = s.pct || 0;
    var fc = pct >= 75 ? 'fill-good' : pct >= 50 ? 'fill-warn' : 'fill-bad';
    html += '<tr>';
    html += '<td><div class="cell-name">' + s.name + '</div></td>';
    html += '<td>' + s.present + '</td>';
    html += '<td>' + s.total + '</td>';
    html += '<td><div class="pct-bar-wrap"><div class="pct-bar-track"><div class="pct-bar-fill ' + fc + '" style="width:' + pct + '%"></div></div><span class="pct-label">' + pct + '%</span></div></td>';
    html += '</tr>';
  }
  sb.innerHTML = html;
}

// Render records
var rb = document.getElementById('recordsBody');
if (!records.length) {
  rb.innerHTML = '<tr class="empty-row"><td colspan="4">No attendance records found.</td></tr>';
} else {
  var html = '';
  for (var i = 0; i < records.length; i++) {
    var r = records[i];
    var bc = r.status === 'Present' ? 'badge-success' : r.status === 'Absent' ? 'badge-danger' : 'badge-warn';
    html += '<tr>';
    html += '<td><div class="avatar-cell"><div class="avatar">' + r.studentName.charAt(0) + '</div><span class="fw-600 color-navy">' + r.studentName + '</span></div></td>';
    html += '<td><div class="cell-name">' + r.subjectName + '</div><div class="cell-sub">' + r.subjectCode + '</div></td>';
    html += '<td class="text-muted">' + r.date + '</td>';
    html += '<td><span class="badge ' + bc + '">' + r.status + '</span></td>';
    html += '</tr>';
  }
  rb.innerHTML = html;
}

// Form validation
document.getElementById('attForm').addEventListener('submit', function(e) {
  var ok = true;
  var checks = [['studentId','studentErr'],['subjectId','subjectErr']];
  for (var i = 0; i < checks.length; i++) {
    var el = document.getElementById(checks[i][0]);
    var err = document.getElementById(checks[i][1]);
    err.classList.remove('show'); el.style.borderColor = '';
    if (!el.value) { err.classList.add('show'); el.style.borderColor = 'var(--danger)'; ok = false; }
  }
  if (!ok) e.preventDefault();
});
</script>
</body>
</html>
