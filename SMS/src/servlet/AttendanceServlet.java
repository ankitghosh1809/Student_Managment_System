package com.sms.servlet;
import com.sms.dao.*;
import com.sms.model.Attendance;
import com.sms.model.Student;
import com.sms.model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;
@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {
    private final AttendanceDAO dao        = new AttendanceDAO();
    private final StudentDAO    studentDAO = new StudentDAO();
    private final SubjectDAO    subjectDAO = new SubjectDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!DashboardServlet.isLoggedIn(req)) { res.sendRedirect("login.jsp"); return; }
        String dateParam = req.getParameter("date");
        String sidParam  = req.getParameter("studentId");
        List<Attendance> records;
        if (dateParam != null && !dateParam.isBlank()) {
            try {
                records = dao.getByDate(Date.valueOf(dateParam));
                req.setAttribute("filterDate", dateParam);
            } catch (Exception e) { records = dao.getAll(); }
        } else if (sidParam != null && !sidParam.isBlank()) {
            records = dao.getByStudent(Integer.parseInt(sidParam));
        } else {
            records = dao.getAll();
        }
        // Attendance records JSON
        StringBuilder aJson = new StringBuilder("[");
        for (int i = 0; i < records.size(); i++) {
            Attendance a = records.get(i);
            if (i > 0) aJson.append(",");
            aJson.append("{")
                 .append("\"id\":").append(a.getId()).append(",")
                 .append("\"studentName\":\"").append(esc(a.getStudentName())).append("\",")
                 .append("\"subjectName\":\"").append(esc(a.getSubjectName())).append("\",")
                 .append("\"subjectCode\":\"").append(esc(a.getSubjectCode())).append("\",")
                 .append("\"date\":\"").append(a.getDate()).append("\",")
                 .append("\"status\":\"").append(esc(a.getStatus())).append("\"")
                 .append("}");
        }
        aJson.append("]");
        req.setAttribute("attendanceJson", aJson.toString());
        // Students JSON for dropdown
        List<Student> students = studentDAO.getAll();
        StringBuilder sJson = new StringBuilder("[");
        for (int i = 0; i < students.size(); i++) {
            Student s = students.get(i);
            if (i > 0) sJson.append(",");
            sJson.append("{\"id\":").append(s.getId())
                 .append(",\"name\":\"").append(esc(s.getName())).append("\"")
                 .append(",\"course\":\"").append(esc(s.getCourse())).append("\"}");
        }
        sJson.append("]");
        req.setAttribute("studentsJson", sJson.toString());
        // Subjects JSON for dropdown
        List<Subject> subjects = subjectDAO.getAll();
        StringBuilder subJson = new StringBuilder("[");
        for (int i = 0; i < subjects.size(); i++) {
            Subject s = subjects.get(i);
            if (i > 0) subJson.append(",");
            subJson.append("{\"id\":").append(s.getId())
                   .append(",\"name\":\"").append(esc(s.getName())).append("\"")
                   .append(",\"code\":\"").append(esc(s.getCode())).append("\"}");
        }
        subJson.append("]");
        req.setAttribute("subjectsJson", subJson.toString());
        // Stats JSON
        List<Map<String, Object>> stats = dao.getPercentages();
        StringBuilder stJson = new StringBuilder("[");
        for (int i = 0; i < stats.size(); i++) {
            Map<String, Object> row = stats.get(i);
            if (i > 0) stJson.append(",");
            stJson.append("{")
                  .append("\"id\":").append(row.get("id")).append(",")
                  .append("\"name\":\"").append(esc(row.get("name"))).append("\",")
                  .append("\"total\":").append(row.get("total")).append(",")
                  .append("\"present\":").append(row.get("present")).append(",")
                  .append("\"pct\":").append(row.get("pct"))
                  .append("}");
        }
        stJson.append("]");
        req.setAttribute("attendanceStatsJson", stJson.toString());
        req.getRequestDispatcher("attendance.jsp").forward(req, res);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!DashboardServlet.isLoggedIn(req)) { res.sendRedirect("login.jsp"); return; }
        try {
            Attendance a = new Attendance();
            a.setStudentId(Integer.parseInt(req.getParameter("studentId")));
            a.setSubjectId(Integer.parseInt(req.getParameter("subjectId")));
            a.setDate(Date.valueOf(req.getParameter("date")));
            a.setStatus(req.getParameter("status"));
            boolean ok = dao.mark(a);
            res.sendRedirect("AttendanceServlet?" + (ok ? "success=Attendance+marked" : "error=Failed"));
        } catch (Exception e) {
            res.sendRedirect("AttendanceServlet?error=Invalid+data");
        }
    }
    private String esc(Object v) {
        if (v == null) return "";
        return v.toString().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
    }
}
