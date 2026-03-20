package com.sms.servlet;
import com.sms.dao.StudentDAO;
import com.sms.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private final StudentDAO dao = new StudentDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!DashboardServlet.isLoggedIn(req)) { res.sendRedirect("login.jsp"); return; }
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "edit" -> {
                Student s = dao.getById(parse(req.getParameter("id")));
                if (s == null) { res.sendRedirect("StudentServlet"); return; }
                req.setAttribute("student", s);
                req.getRequestDispatcher("edit-student.jsp").forward(req, res);
            }
            case "delete" -> {
                dao.delete(parse(req.getParameter("id")));
                res.sendRedirect("StudentServlet?success=Student+deleted");
            }
            default -> {
                String q = req.getParameter("search");
                List<Student> students = (q != null && !q.isBlank())
                    ? dao.search(q.trim()) : dao.getAll();
                // Convert to JSON string
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < students.size(); i++) {
                    Student s = students.get(i);
                    if (i > 0) json.append(",");
                    json.append("{")
                        .append("\"id\":").append(s.getId()).append(",")
                        .append("\"name\":\"").append(esc(s.getName())).append("\",")
                        .append("\"email\":\"").append(esc(s.getEmail())).append("\",")
                        .append("\"course\":\"").append(esc(s.getCourse())).append("\",")
                        .append("\"phone\":\"").append(esc(s.getPhone())).append("\",")
                        .append("\"address\":\"").append(esc(s.getAddress())).append("\",")
                        .append("\"enrollmentDate\":\"").append(s.getEnrollmentDate() != null ? s.getEnrollmentDate().toString() : "").append("\"")
                        .append("}");
                }
                json.append("]");
                req.setAttribute("studentsJson", json.toString());
                req.setAttribute("searchQuery", q != null ? q : "");
                req.getRequestDispatcher("students.jsp").forward(req, res);
            }
        }
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!DashboardServlet.isLoggedIn(req)) { res.sendRedirect("login.jsp"); return; }
        String action = req.getParameter("action");
        String name   = trim(req.getParameter("name"));
        String email  = trim(req.getParameter("email"));
        String course = trim(req.getParameter("course"));
        String phone  = trim(req.getParameter("phone"));
        String addr   = trim(req.getParameter("address"));
        if (name.isEmpty() || email.isEmpty() || course.isEmpty()) {
            req.setAttribute("error", "Name, email and course are required.");
            req.getRequestDispatcher("add-student.jsp").forward(req, res); return;
        }
        Student s = new Student();
        s.setName(name); s.setEmail(email); s.setCourse(course);
        s.setPhone(phone); s.setAddress(addr);
        if ("edit".equals(action)) {
            s.setId(parse(req.getParameter("id")));
            boolean ok = dao.update(s);
            res.sendRedirect("StudentServlet?" + (ok ? "success=Student+updated" : "error=Update+failed"));
        } else {
            boolean ok = dao.insert(s);
            res.sendRedirect("StudentServlet?" + (ok ? "success=Student+added" : "error=Email+already+exists"));
        }
    }
    private String esc(String v) {
        if (v == null) return "";
        return v.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
    }
    private int    parse(String v) { try { return Integer.parseInt(v); } catch (Exception e) { return 0; } }
    private String trim(String v)  { return v != null ? v.trim() : ""; }
}
