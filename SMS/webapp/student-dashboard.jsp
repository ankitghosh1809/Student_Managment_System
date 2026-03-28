<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sms.model.Student" %>
<%
  if (session == null || session.getAttribute("student") == null) {
    response.sendRedirect("StudentLoginServlet"); return;
  }
  Student student = (Student) session.getAttribute("student");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>My Dashboard — Student MS</title>
  <link rel="stylesheet" href="/SMS/css/style.css">
  <style>
    .profile-card {
      background: var(--navy); border-radius: var(--radius-lg);
      padding: 32px; color: white;
      display: flex; align-items: center; gap: 24px; margin-bottom: 24px;
    }
    .profile-avatar {
      width: 80px; height: 80px; border-radius: 50%;
      background: var(--gold); display: flex; align-items: center;
      justify-content: center; font-size: 32px; font-weight: 800;
      color: var(--navy); flex-shrink: 0;
    }
    .profile-name { font-size: 24px; font-weight: 700; margin-bottom: 4px; }
    .profile-sub  { font-size: 14px; opacity: .7; margin-bottom: 2px; }
    .profile-roll {
      display: inline-block; background: var(--gold); color: var(--navy);
      padding: 3px 12px; border-radius: 999px;
      font-size: 12px; font-weight: 700; margin-top: 8px;
    }
    .detail-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px,1fr)); gap: 16px; margin-bottom: 24px; }
    .detail-item { background: var(--white); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px 20px; }
    .detail-label { font-size: 11px; text-transform: uppercase; letter-spacing:.07em; color: var(--text-3); margin-bottom: 4px; }
    .detail-value { font-size: 15px; font-weight: 600; color: var(--navy); }
    .tab-row { display: flex; gap: 0; margin-bottom: 20px; border-radius: var(--radius); overflow: hidden; border: 1.5px solid var(--border); }
    .tab-btn { flex: 1; padding: 11px; text-align: center; font-size: 13px; font-weight: 600; cursor: pointer; background: var(--white); color: var(--text-3); border: none; transition: all var(--transition); }
    .tab-btn.active { background: var(--navy); color: var(--white); }
    .tab-content { display: none; }
    .tab-content.active { display: block; }
    .grade-big { font-size: 48px; font-weight: 800; text-align: center; margin: 8px 0; }
    .grade-A\+ { color: #1A7F5A; } .grade-A { color: #1A7F5A; }
    .grade-B { color: #1457A8; } .grade-C { color: #A05C10; }
    .grade-D { color: #A05C10; } .grade-F { color: #B8261E; }
  </style>
</head>
<body>
<nav style="background:var(--navy);padding:0 24px;height:64px;display:flex;align-items:center;justify-content:space-between;position:fixed;top:0;left:0;right:0;z-index:200;">
  <div style="display:flex;align-items:center;gap:12px;">
    <div style="width:36px;height:36px;background:var(--gold);border-radius:10px;display:flex;align-items:center;justify-content:center;">
      <svg width="18" height="18" fill="none" stroke="#0D1B2A" stroke-width="2" viewBox="0 0 24 24">
        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/>
      </svg>
    </div>
    <span style="color:white;font-weight:700;font-size:16px;">Student MS</span>
  </div>
  <div style="display:flex;align-items:center;gap:16px;">
    <span style="color:rgba(255,255,255,.7);font-size:14px;">Welcome, <%= student.getName() %></span>
    <a href="StudentLogoutServlet" style="background:rgba(255,255,255,.1);color:white;padding:7px 16px;border-radius:8px;font-size:13px;text-decoration:none;">Logout</a>
  </div>
</nav>

<div style="margin-top:64px;padding:32px 28px;max-width:1200px;margin-left:auto;margin-right:auto;">

  <!-- Profile Card -->
  <div class="profile-card">
    <div class="profile-avatar"><%= student.getName().charAt(0) %></div>
    <div>
      <div class="profile-name"><%= student.getName() %></div>
      <div class="profile-sub"><%= student.getCourse() %></div>
      <div class="profile-sub"><%= student.getEmail() %></div>
      <div class="profile-roll">Roll No: <%= student.getRollNumber() %></div>
    </div>
  </div>

  <!-- Details -->
  <div class="detail-grid">
    <div class="detail-item"><div class="detail-label">Full Name</div><div class="detail-value"><%= student.getName() %></div></div>
    <div class="detail-item"><div class="detail-label">Roll Number</div><div class="detail-value"><%= student.getRollNumber() %></div></div>
    <div class="detail-item"><div class="detail-label">Course</div><div class="detail-value"><%= student.getCourse() %></div></div>
    <div class="detail-item"><div class="detail-label">Email</div><div class="detail-value"><%= student.getEmail() %></div></div>
    <div class="detail-item"><div class="detail-label">Phone</div><div class="detail-value"><%= student.getPhone() != null ? student.getPhone() : "-" %></div></div>
    <div class="detail-item"><div class="detail-label">Enrolled On</div><div class="detail-value"><%= student.getEnrollmentDate() != null ? student.getEnrollmentDate().toString() : "-" %></div></div>
    <div class="detail-item"><div class="detail-label">Attendance %</div><div class="detail-value" id="overallPct">-</div></div>
    <div class="detail-item"><div class="detail-label">Overall Grade</div><div class="detail-value" id="overallGrade">-</div></div>
  </div>

  <!-- Tabs -->
  <div class="tab-row">
    <button class="tab-btn active" onclick="showTab('attendance')">Attendance</button>
    <button class="tab-btn" onclick="showTab('marks')">Marks & Grades</button>
    <button class="tab-btn" onclick="showTab('subjects')">Subjects</button>
  </div>

  <!-- Attendance Tab -->
  <div class="tab-content active" id="tab-attendance">
    <div class="card">
      <div class="card-header">
        <h3>My Attendance Records</h3>
        <span id="attSummary" class="badge badge-info"></span>
      </div>
      <div class="table-wrap">
        <table>
          <thead><tr><th>Subject</th><th>Code</th><th>Date</th><th>Status</th></tr></thead>
          <tbody id="attendanceBody"></tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Marks Tab -->
  <div class="tab-content" id="tab-marks">
    <div class="card">
      <div class="card-header"><h3>My Marks & Grades</h3></div>
      <div class="table-wrap">
        <table>
          <thead><tr><th>Subject</th><th>Code</th><th>Marks</th><th>Max</th><th>Percentage</th><th>Grade</th></tr></thead>
          <tbody id="marksBody"></tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Subjects Tab -->
  <div class="tab-content" id="tab-subjects">
    <div class="card">
      <div class="card-header"><h3>My Subjects</h3></div>
      <div class="table-wrap">
        <table>
          <thead><tr><th>Subject Name</th><th>Code</th><th>Credits</th></tr></thead>
          <tbody id="subjectsBody"></tbody>
        </table>
      </div>
    </div>
  </div>

</div>

<script src="/SMS/js/app.js"></script>
<script>
var rawAtt      = '<%= request.getAttribute("attendanceJson") != null ? request.getAttribute("attendanceJson") : "[]" %>';
var rawStats    = '<%= request.getAttribute("statsJson")      != null ? request.getAttribute("statsJson")      : "[]" %>';
var rawSubjects = '<%= request.getAttribute("subjectsJson")   != null ? request.getAttribute("subjectsJson")   : "[]" %>';
var rawMarks    = '<%= request.getAttribute("marksJson")      != null ? request.getAttribute("marksJson")      : "[]" %>';

var attendance = [], stats = [], subjects = [], marks = [];
try { attendance = JSON.parse(rawAtt);      } catch(e) {}
try { stats      = JSON.parse(rawStats);    } catch(e) {}
try { subjects   = JSON.parse(rawSubjects); } catch(e) {}
try { marks      = JSON.parse(rawMarks);    } catch(e) {}

// Tab switching
function showTab(name) {
  document.querySelectorAll('.tab-content').forEach(function(t) { t.classList.remove('active'); });
  document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
  document.getElementById('tab-' + name).classList.add('active');
  event.target.classList.add('active');
}

// Attendance %
if (stats.length > 0) {
  var s = stats[0];
  var pct = s.pct || 0;
  var color = pct >= 75 ? 'var(--success)' : pct >= 50 ? 'var(--warn)' : 'var(--danger)';
  document.getElementById('overallPct').innerHTML =
    '<span style="color:' + color + '">' + pct + '%</span> (' + s.present + '/' + s.total + ')';
}

// Overall grade from marks
if (marks.length > 0) {
  var totalM = 0, totalMM = 0;
  marks.forEach(function(m) { totalM += m.marks; totalMM += m.maxMarks; });
  var avgPct = totalMM > 0 ? Math.round(totalM * 1000.0 / totalMM) / 10 : 0;
  var og = avgPct >= 90 ? 'A+' : avgPct >= 80 ? 'A' : avgPct >= 70 ? 'B' :
           avgPct >= 60 ? 'C' : avgPct >= 50 ? 'D' : 'F';
  var gradeColor = (og === 'A+' || og === 'A') ? 'var(--success)' :
                   og === 'B' ? 'var(--info)' :
                   (og === 'C' || og === 'D') ? 'var(--warn)' : 'var(--danger)';
  document.getElementById('overallGrade').innerHTML =
    '<span style="color:' + gradeColor + ';font-size:20px;font-weight:800;">' + og + '</span>' +
    '<span style="font-size:12px;color:var(--text-3);margin-left:6px;">(' + avgPct + '%)</span>';
}

// Attendance table
var ab = document.getElementById('attendanceBody');
document.getElementById('attSummary').textContent = attendance.length + ' records';
if (!attendance.length) {
  ab.innerHTML = '<tr class="empty-row"><td colspan="4">No attendance records yet.</td></tr>';
} else {
  var html = '';
  attendance.forEach(function(a) {
    var bc = a.status === 'Present' ? 'badge-success' : a.status === 'Absent' ? 'badge-danger' : 'badge-warn';
    html += '<tr><td class="cell-name">' + a.subjectName + '</td>' +
            '<td><span class="badge badge-info">' + a.subjectCode + '</span></td>' +
            '<td class="text-muted">' + a.date + '</td>' +
            '<td><span class="badge ' + bc + '">' + a.status + '</span></td></tr>';
  });
  ab.innerHTML = html;
}

// Marks table
function gradeBadge(g) {
  var cls = (g==='A+'||g==='A') ? 'badge-success' : g==='B' ? 'badge-info' :
            (g==='C'||g==='D') ? 'badge-warn' : 'badge-danger';
  return '<span class="badge ' + cls + '">' + g + '</span>';
}
var mb = document.getElementById('marksBody');
if (!marks.length) {
  mb.innerHTML = '<tr class="empty-row"><td colspan="6">No marks records yet.</td></tr>';
} else {
  var html = '';
  marks.forEach(function(m) {
    var pct = m.maxMarks > 0 ? Math.round(m.marks * 1000.0 / m.maxMarks) / 10 : 0;
    var barClass = pct >= 75 ? 'fill-good' : pct >= 50 ? 'fill-warn' : 'fill-bad';
    html += '<tr>' +
      '<td class="cell-name">' + m.subjectName + '</td>' +
      '<td><span class="badge badge-info">' + m.subjectCode + '</span></td>' +
      '<td><strong>' + m.marks + '</strong></td>' +
      '<td class="text-muted">' + m.maxMarks + '</td>' +
      '<td><div class="pct-bar-wrap"><div class="pct-bar-track"><div class="pct-bar-fill ' + barClass + '" style="width:' + pct + '%"></div></div><span class="pct-label">' + pct + '%</span></div></td>' +
      '<td>' + gradeBadge(m.grade) + '</td>' +
      '</tr>';
  });
  mb.innerHTML = html;
}

// Subjects table
var sub_b = document.getElementById('subjectsBody');
if (!subjects.length) {
  sub_b.innerHTML = '<tr class="empty-row"><td colspan="3">No subjects yet.</td></tr>';
} else {
  var html = '';
  subjects.forEach(function(s) {
    html += '<tr><td class="cell-name">' + s.name + '</td>' +
            '<td><span class="badge badge-info">' + s.code + '</span></td>' +
            '<td><span class="badge badge-navy">' + s.credits + ' cr</span></td></tr>';
  });
  sub_b.innerHTML = html;
}
</script>
</body>
</html>
