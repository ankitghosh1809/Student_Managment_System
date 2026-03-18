<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Dashboard — Student MS</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="app-layout">
  <%@ include file="navbar.html" %>
  <input type="hidden" id="smsAdminName" value="${adminName}">
  <main class="main-content">
    <button class="hamburger" onclick="openSidebar()">☰</button>
    <div class="topbar">
      <div class="page-title">
        <h1>Dashboard</h1>
        <p>Welcome back, <strong>${adminName}</strong></p>
      </div>
    </div>
    <div class="stats-row">
      <div class="stat-card stat-navy">
        <div class="stat-icon-wrap">👨‍🎓</div>
        <div class="stat-info"><div class="num">${totalStudents}</div><div class="lbl">Total Students</div></div>
      </div>
      <div class="stat-card stat-gold">
        <div class="stat-icon-wrap">📚</div>
        <div class="stat-info"><div class="num">${totalSubjects}</div><div class="lbl">Subjects</div></div>
      </div>
      <div class="stat-card stat-green">
        <div class="stat-icon-wrap">✅</div>
        <div class="stat-info"><div class="num">${todayPresent}</div><div class="lbl">Present Today</div></div>
      </div>
      <div class="stat-card stat-slate">
        <div class="stat-icon-wrap">📊</div>
        <div class="stat-info"><div class="num" id="trackedCount">0</div><div class="lbl">Tracked Students</div></div>
      </div>
    </div>
    <div class="card">
      <div class="card-header"><h3>Quick Actions</h3></div>
      <div class="quick-grid">
        <a href="StudentServlet?action=add" class="quick-card">
          <span class="quick-emoji">➕</span><span class="quick-title">Add Student</span><span class="quick-label">Enrol new student</span>
        </a>
        <a href="StudentServlet" class="quick-card">
          <span class="quick-emoji">👥</span><span class="quick-title">View Students</span><span class="quick-label">Browse all records</span>
        </a>
        <a href="SubjectServlet" class="quick-card">
          <span class="quick-emoji">📖</span><span class="quick-title">Subjects</span><span class="quick-label">Add or edit subjects</span>
        </a>
        <a href="AttendanceServlet" class="quick-card">
          <span class="quick-emoji">📋</span><span class="quick-title">Attendance</span><span class="quick-label">Mark and review</span>
        </a>
      </div>
    </div>
    <div class="card">
      <div class="card-header">
        <h3>Attendance Summary</h3>
        <a href="AttendanceServlet" class="btn btn-outline btn-sm">View All →</a>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr><th>#</th><th>Student</th><th>Total</th><th>Present</th><th>Attendance %</th><th>Status</th></tr>
          </thead>
          <tbody id="statsBody"></tbody>
        </table>
      </div>
    </div>
  </main>
</div>
<script id="statsData" type="application/json">${attendanceStatsJson}</script>
<script src="js/app.js"></script>
<script>
  let stats = [];
  try { stats = JSON.parse(document.getElementById('statsData').textContent || '[]'); } catch(e) {}
  document.getElementById('trackedCount').textContent = stats.length;
  const tbody = document.getElementById('statsBody');
  if (!stats.length) {
    tbody.innerHTML = '<tr class="empty-row"><td colspan="6">No attendance data yet.</td></tr>';
  } else {
    tbody.innerHTML = stats.map((s, i) => {
      const pct = s.pct || 0;
      const fc  = pct >= 75 ? 'fill-good' : pct >= 50 ? 'fill-warn' : 'fill-bad';
      const badge = pct >= 75
        ? '<span class="badge badge-success">Good</span>'
        : pct >= 50
        ? '<span class="badge badge-warn">At Risk</span>'
        : '<span class="badge badge-danger">Critical</span>';
      return `<tr>
        <td class="text-muted">${i+1}</td>
        <td><div class="avatar-cell">
          <div class="avatar">${s.name.charAt(0)}</div>
          <span class="fw-600 color-navy">${s.name}</span>
        </div></td>
        <td>${s.total}</td><td>${s.present}</td>
        <td><div class="pct-bar-wrap">
          <div class="pct-bar-track">
            <div class="pct-bar-fill ${fc}" style="width:${pct}%"></div>
          </div>
          <span class="pct-label">${pct}%</span>
        </div></td>
        <td>${badge}</td>
      </tr>`;
    }).join('');
  }
</script>
</body>
</html>
