<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Marks — Student MS</title>
  <link rel="stylesheet" href="/SMS/css/style.css">
</head>
<body>
<div class="app-layout">
  <%@ include file="navbar.jsp" %>
  <input type="hidden" id="smsAdminName" value="${adminName}">
  <main class="main-content">
    <button class="hamburger" onclick="openSidebar()">Menu</button>
    <div class="topbar">
      <div class="page-title"><h1>Marks & Grades</h1><p>Manage student marks and view grades</p></div>
    </div>
    <div id="alertBox" style="display:none"></div>

    <!-- Student Summary Cards -->
    <div class="card">
      <div class="card-header"><h3>Student Grade Summary</h3></div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr><th>Roll No</th><th>Student</th><th>Course</th><th>Subjects</th><th>Total Marks</th><th>Avg %</th><th>Overall Grade</th></tr>
          </thead>
          <tbody id="summaryBody"></tbody>
        </table>
      </div>
    </div>

    <div class="split-layout">
      <!-- Add Marks Form -->
      <div class="card">
        <div class="card-header"><h3>Add / Update Marks</h3></div>
        <div class="card-body">
          <form id="marksForm" action="MarksServlet" method="POST" novalidate>
            <div class="form-group">
              <label class="form-label">Student <span class="required">*</span></label>
              <select id="studentId" name="studentId" class="form-control">
                <option value="">Select Student</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Subject <span class="required">*</span></label>
              <select id="subjectId" name="subjectId" class="form-control">
                <option value="">Select Subject</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Marks Obtained <span class="required">*</span></label>
              <input type="number" name="marks" class="form-control"
                     min="0" max="100" placeholder="e.g. 85">
            </div>
            <div class="form-group">
              <label class="form-label">Maximum Marks</label>
              <input type="number" name="maxMarks" class="form-control"
                     value="100" min="1">
            </div>
            <div class="form-group">
              <label class="form-label">Exam Type</label>
              <select name="examType" class="form-control">
                <option value="Internal">Internal</option>
                <option value="Midterm">Midterm</option>
                <option value="Final">Final</option>
                <option value="Practical">Practical</option>
              </select>
            </div>
            <button type="submit" class="btn btn-primary btn-full">Save Marks</button>
          </form>
        </div>
      </div>

      <!-- Detailed Marks Table -->
      <div class="card">
        <div class="card-header"><h3>All Marks Records</h3></div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr><th>Student</th><th>Subject</th><th>Marks</th><th>Grade</th></tr>
            </thead>
            <tbody id="marksBody"></tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>
<script src="/SMS/js/app.js"></script>
<script>
var rawMarks    = '<%= request.getAttribute("marksJson")   != null ? request.getAttribute("marksJson")   : "[]" %>';
var rawSummary  = '<%= request.getAttribute("summaryJson") != null ? request.getAttribute("summaryJson") : "[]" %>';
var rawStudents = '<%= request.getAttribute("studentsJson")!= null ? request.getAttribute("studentsJson"): "[]" %>';
var rawSubjects = '<%= request.getAttribute("subjectsJson")!= null ? request.getAttribute("subjectsJson"): "[]" %>';

var marks = [], summary = [], students = [], subjects = [];
try { marks    = JSON.parse(rawMarks);    } catch(e) {}
try { summary  = JSON.parse(rawSummary);  } catch(e) {}
try { students = JSON.parse(rawStudents); } catch(e) {}
try { subjects = JSON.parse(rawSubjects); } catch(e) {}

// Populate dropdowns
var sSel = document.getElementById('studentId');
students.forEach(function(s) {
  var o = document.createElement('option');
  o.value = s.id;
  o.textContent = s.rollNumber + ' - ' + s.name;
  sSel.appendChild(o);
});

var subSel = document.getElementById('subjectId');
subjects.forEach(function(s) {
  var o = document.createElement('option');
  o.value = s.id;
  o.textContent = s.name + ' (' + s.code + ')';
  subSel.appendChild(o);
});

// Grade badge color
function gradeBadge(g) {
  var cls = g === 'A+' || g === 'A' ? 'badge-success' :
            g === 'B' ? 'badge-info' :
            g === 'C' ? 'badge-warn' :
            g === 'D' ? 'badge-warn' : 'badge-danger';
  return '<span class="badge ' + cls + '">' + g + '</span>';
}

// Summary table
var sb = document.getElementById('summaryBody');
if (!summary.length) {
  sb.innerHTML = '<tr class="empty-row"><td colspan="7">No marks data yet.</td></tr>';
} else {
  var html = '';
  summary.forEach(function(s) {
    var pct = s.avgPct || 0;
    var barClass = pct >= 75 ? 'fill-good' : pct >= 50 ? 'fill-warn' : 'fill-bad';
    html += '<tr>';
    html += '<td><span class="badge badge-navy">' + (s.rollNumber || '-') + '</span></td>';
    html += '<td><div class="cell-name">' + s.name + '</div></td>';
    html += '<td class="text-muted">' + s.course + '</td>';
    html += '<td>' + s.totalSubjects + '</td>';
    html += '<td>' + s.totalMarks + ' / ' + s.totalMaxMarks + '</td>';
    html += '<td><div class="pct-bar-wrap"><div class="pct-bar-track"><div class="pct-bar-fill ' + barClass + '" style="width:' + pct + '%"></div></div><span class="pct-label">' + pct + '%</span></div></td>';
    html += '<td>' + gradeBadge(s.overallGrade) + '</td>';
    html += '</tr>';
  });
  sb.innerHTML = html;
}

// Marks detail table
var mb = document.getElementById('marksBody');
if (!marks.length) {
  mb.innerHTML = '<tr class="empty-row"><td colspan="4">No marks records yet.</td></tr>';
} else {
  var html = '';
  marks.forEach(function(m) {
    html += '<tr>';
    html += '<td><div class="cell-name">' + m.studentName + '</div><div class="cell-sub">' + m.rollNumber + '</div></td>';
    html += '<td><div class="cell-name">' + m.subjectName + '</div><div class="cell-sub">' + m.subjectCode + '</div></td>';
    html += '<td><strong>' + m.marks + '</strong> / ' + m.maxMarks + '</td>';
    html += '<td>' + gradeBadge(m.grade) + '</td>';
    html += '</tr>';
  });
  mb.innerHTML = html;
}
</script>
</body>
</html>
