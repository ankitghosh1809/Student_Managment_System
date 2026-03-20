package com.sms.servlet;
import com.sms.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private final StudentDAO    studentDAO    = new StudentDAO();
    private final SubjectDAO    subjectDAO    = new SubjectDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!isLoggedIn(req)) { res.sendRedirect("login.jsp"); return; }
        req.setAttribute("totalStudents", studentDAO.count());
        req.setAttribute("totalSubjects", subjectDAO.count());
        req.setAttribute("todayPresent",  attendanceDAO.countTodayPresent());
        // Convert attendance stats to JSON
        List<Map<String, Object>> stats = attendanceDAO.getPercentages();
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < stats.size(); i++) {
            Map<String, Object> row = stats.get(i);
            if (i > 0) json.append(",");
            json.append("{")
                .append("\"id\":").append(row.get("id")).append(",")
                .append("\"name\":\"").append(esc(row.get("name"))).append("\",")
                .append("\"total\":").append(row.get("total")).append(",")
                .append("\"present\":").append(row.get("present")).append(",")
                .append("\"pct\":").append(row.get("pct"))
                .append("}");
        }
        json.append("]");
        req.setAttribute("attendanceStatsJson", json.toString());

        req.getRequestDispatcher("dashboard.jsp").forward(req, res);
    }
    static boolean isLoggedIn(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("admin") != null;
    }
    private String esc(Object v) {
        if (v == null) return "";
        return v.toString().replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
