<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
String ctx = request.getContextPath();
%>
<aside class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <div class="brand-icon" style="display:flex;align-items:center;justify-content:center;">
      <svg width="20" height="20" fill="none" stroke="#0D1B2A" stroke-width="2" viewBox="0 0 24 24">
        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
      </svg>
    </div>
    <div class="brand-text">Student MS <span>Management System</span></div>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-section-label">Main</div>
    <a href="<%= ctx %>/DashboardServlet" class="nav-item">
      <span class="nav-icon">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
          <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
        </svg>
      </span>Dashboard
    </a>
    <a href="<%= ctx %>/StudentServlet" class="nav-item">
      <span class="nav-icon">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
          <circle cx="9" cy="7" r="4"/>
          <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
          <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
        </svg>
      </span>Students
    </a>
    <a href="<%= ctx %>/SubjectServlet" class="nav-item">
      <span class="nav-icon">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
          <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
        </svg>
      </span>Subjects
    </a>
    <a href="<%= ctx %>/AttendanceServlet" class="nav-item">
      <span class="nav-icon">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
          <polyline points="14 2 14 8 20 8"/>
          <line x1="16" y1="13" x2="8" y2="13"/>
          <line x1="16" y1="17" x2="8" y2="17"/>
        </svg>
      </span>Attendance
    </a>
    <a href="<%= ctx %>/MarksServlet" class="nav-item">
      <span class="nav-icon">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
          <polyline points="14 2 14 8 20 8"/>
          <line x1="9" y1="13" x2="15" y2="13"/>
          <line x1="9" y1="17" x2="12" y2="17"/>
        </svg>
      </span>Marks & Grades
    </a>
  </nav>
  <div class="sidebar-footer">
    <div class="admin-info">
      <div class="admin-avatar" id="adminInitial">A</div>
      <div>
        <div class="admin-name" id="adminNameDisplay">Administrator</div>
        <div class="admin-role">Admin</div>
      </div>
    </div>
    <a href="<%= ctx %>/LogoutServlet" class="btn-logout">
      <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
        <polyline points="16 17 21 12 16 7"/>
        <line x1="21" y1="12" x2="9" y2="12"/>
      </svg>
      Logout
    </a>
  </div>
</aside>
<div id="sidebarOverlay" onclick="closeSidebar()"
     style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.4);z-index:199;"></div>
