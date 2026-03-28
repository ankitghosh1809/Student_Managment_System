<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Dashboard — Student MS</title>
  <link rel="stylesheet" href="/SMS/css/style.css">
</head>
<body>
<div class="app-layout">
  <%@ include file="navbar.jsp" %>
  <input type="hidden" id="smsAdminName" value="${adminName}">
  <main class="main-content">
    <button class="hamburger" onclick="openSidebar()">Menu</button>
    <div class="topbar">
      <div class="page-title">
        <h1>Dashboard</h1>
        <p>Welcome back, <strong>${adminName}</strong></p>
      </div>
    </div>
    <div class="stats-row">
      <div class="stat-card stat-navy">
        <div class="stat-icon-wrap">&#128106;</div>
        <div class="stat-info"><div class="num">${totalStudents}</div><div class="lbl">Total Students</div></div>
      </div>
      <div class="stat-card stat-gold">
        <div class="stat-icon-wrap">&#128218;</div>
        <div class="stat-info"><div class="num">${totalSubjects}</div><div class="lbl">Subjects</div></div>
      </div>
      <div class="stat-card stat-green">
        <div class="stat-icon-wrap">&#10003;</div>
        <div class="stat-info"><div class="num">${todayPresent}</div><div class="lbl">Present Today</div></div>
      </div>
      <div class="stat-card stat-slate">
        <div class="stat-icon-wrap">&#128202;</div>
        <div class="stat-info"><div class="num" id="trackedCount">0</div><div class="lbl">Tracked Students</div></div>
      </div>
    </div>
    <div class="card">
      <div class="card-header"><h3>Quick Actions</h3></div>
      <div class="quick-grid">
        <a href="StudentServlet" class="quick-card">
          <div style="font-size:26px;margin-bottom:4px;">+</div>
          <span class="quick-title">Add Student</span>
          <span class="quick-label">Enrol new student</span>
        </a>
        <a href="StudentServlet" class="quick-card">
          <div style="font-size:26px;margin-bottom:4px;">&#128100;</div>
          <span class="quick-title">View Students</span>
          <span class="quick-label">Browse all records</span>
        </a>
        <a href="SubjectServlet" class="quick-card">
          <div style="font-size:26px;margin-bottom:4px;">&#128218;</div>
          <span class="quick-title">Subjects</span>
          <span class="quick-label">Add or edit subjects</span>
        </a>
        <a href="AttendanceServlet" class="quick-card">
          <div style="font-size:26px;margin-bottom:4px;">&#128203;</div>
          <span class="quick-title">Attendance</span>
          <span class="quick-label">Mark and review</span>
        </a>
      </div>
    </div>
    <div class="card">
      <div class="card-header">
        <h3>Attendance Summary</h3>
        <a href="AttendanceServlet" class="btn btn-outline btn-sm">View All</a>
      </div>
      <div class="table-wrap">
        <table>
          <thead><tr><th>#</th><th>Student</th><th>Total</th><th>Present</th><th>Attendance %</th><th>Status</th></tr></thead>
          <tbody id="statsBody"></tbody>
        </table>
      </div>
    </div>
  </main>
</div>
<script src="/SMS/js/app.js"></script>
<script>
var rawStats = '<%= request.getAttribute("attendanceStatsJson") != null ? request.getAttribute("attendanceStatsJson") : "[]" %>';
var stats = [];
try { stats = JSON.parse(rawStats); } catch(e) { stats = []; }
document.getElementById('trackedCount').textContent = stats.length;
var tbody = document.getElementById('statsBody');
if (!stats.length) {
  tbody.innerHTML = '<tr class="empty-row"><td colspan="6">No attendance data yet.</td></tr>';
} else {
  var html = '';
  for (var i = 0; i < stats.length; i++) {
    var s = stats[i];
    var pct = s.pct || 0;
    var fc = pct >= 75 ? 'fill-good' : pct >= 50 ? 'fill-warn' : 'fill-bad';
    var badge = pct >= 75
      ? '<span class="badge badge-success">Good</span>'
      : pct >= 50
      ? '<span class="badge badge-warn">At Risk</span>'
      : '<span class="badge badge-danger">Critical</span>';
    html += '<tr>';
    html += '<td class="text-muted">' + (i+1) + '</td>';
    html += '<td><div class="avatar-cell"><div class="avatar">' + s.name.charAt(0) + '</div><span class="fw-600 color-navy">' + s.name + '</span></div></td>';
    html += '<td>' + s.total + '</td>';
    html += '<td>' + s.present + '</td>';
    html += '<td><div class="pct-bar-wrap"><div class="pct-bar-track"><div class="pct-bar-fill ' + fc + '" style="width:' + pct + '%"></div></div><span class="pct-label">' + pct + '%</span></div></td>';
    html += '<td>' + badge + '</td>';
    html += '</tr>';
  }
  tbody.innerHTML = html;
}
</script>
</body>
</html>
