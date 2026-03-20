package com.sms.servlet;
import com.sms.dao.AttendanceDAO;
import com.sms.dao.MarksDAO;
import com.sms.dao.SubjectDAO;
import com.sms.model.Attendance;
import com.sms.model.Student;
import com.sms.model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
@WebServlet("/StudentDashboardServlet")
public class StudentDashboardServlet extends HttpServlet {
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final SubjectDAO    subjectDAO    = new SubjectDAO();
    private final MarksDAO      marksDAO      = new MarksDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("student") == null) {
            res.sendRedirect("StudentLoginServlet"); return;
        }
        Student student = (Student) session.getAttribute("student");
        // Attendance
        List<Attendance> records = attendanceDAO.getByStudent(student.getId());
        StringBuilder aJson = new StringBuilder("[");
        for (int i = 0; i < records.size(); i++) {
            Attendance a = records.get(i);
            if (i > 0) aJson.append(",");
            aJson.append("{\"subjectName\":\"").append(esc(a.getSubjectName())).append("\",")
                 .append("\"subjectCode\":\"").append(esc(a.getSubjectCode())).append("\",")
                 .append("\"date\":\"").append(a.getDate()).append("\",")
                 .append("\"status\":\"").append(esc(a.getStatus())).append("\"}");
        }
        aJson.append("]");
        // Attendance stats
        List<Map<String, Object>> allStats = attendanceDAO.getPercentages();
        StringBuilder statsJson = new StringBuilder("[");
        boolean first = true;
        for (Map<String, Object> row : allStats) {
            Object idObj = row.get("id");
            if (idObj != null && ((Number)idObj).intValue() == student.getId()) {
                if (!first) statsJson.append(",");
                statsJson.append("{\"total\":").append(row.get("total"))
                         .append(",\"present\":").append(row.get("present"))
                         .append(",\"pct\":").append(row.get("pct")).append("}");
                first = false;
            }
        }
        statsJson.append("]");
        // Subjects
        List<Subject> subjects = subjectDAO.getAll();
        StringBuilder subJson = new StringBuilder("[");
        for (int i = 0; i < subjects.size(); i++) {
            Subject s = subjects.get(i);
            if (i > 0) subJson.append(",");
            subJson.append("{\"name\":\"").append(esc(s.getName())).append("\",")
                   .append("\"code\":\"").append(esc(s.getCode())).append("\",")
                   .append("\"credits\":").append(s.getCredits()).append("}");
        }
        subJson.append("]");
        // Marks
        List<Map<String,Object>> marksList = marksDAO.getMarksByStudent(student.getId());
        StringBuilder mJson = new StringBuilder("[");
        for (int i = 0; i < marksList.size(); i++) {
            Map<String,Object> m = marksList.get(i);
            if (i > 0) mJson.append(",");
            mJson.append("{")
                 .append("\"subjectName\":\"").append(esc(m.get("subjectName"))).append("\",")
                 .append("\"subjectCode\":\"").append(esc(m.get("subjectCode"))).append("\",")
                 .append("\"marks\":").append(m.get("marks")).append(",")
                 .append("\"maxMarks\":").append(m.get("maxMarks")).append(",")
                 .append("\"grade\":\"").append(esc(m.get("grade"))).append("\",")
                 .append("\"percentage\":").append(m.get("percentage"))
                 .append("}");
        }
        mJson.append("]");
        req.setAttribute("student", student);
        req.setAttribute("attendanceJson", aJson.toString());
        req.setAttribute("statsJson", statsJson.toString());
        req.setAttribute("subjectsJson", subJson.toString());
        req.setAttribute("marksJson", mJson.toString());
        req.getRequestDispatcher("student-dashboard.jsp").forward(req, res);
    }
    private String esc(Object v) {
        if (v == null) return "";
        return v.toString().replace("\\","\\\\").replace("\"","\\\"");
    }
}
