package com.sms.servlet;
import com.sms.dao.StudentDAO;
import com.sms.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
@WebServlet("/StudentLoginServlet")
public class StudentLoginServlet extends HttpServlet {
    private final StudentDAO dao = new StudentDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute("student") != null) {
            res.sendRedirect("StudentDashboardServlet"); return;
        }
        req.getRequestDispatcher("student-login.jsp").forward(req, res);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String rollNumber = req.getParameter("rollNumber") != null ? req.getParameter("rollNumber").trim() : "";
        String password   = req.getParameter("password")   != null ? req.getParameter("password").trim()   : "";
        if (rollNumber.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Roll number and password are required.");
            req.getRequestDispatcher("student-login.jsp").forward(req, res); return;
        }
        Student student = dao.loginStudent(rollNumber, password);
        if (student != null) {
            HttpSession session = req.getSession();
            session.setAttribute("student", student);
            session.setAttribute("studentName", student.getName());
            session.setMaxInactiveInterval(1800);
            res.sendRedirect("StudentDashboardServlet");
        } else {
            req.setAttribute("error", "Invalid roll number or password.");
            req.getRequestDispatcher("student-login.jsp").forward(req, res);
        }
    }
}
