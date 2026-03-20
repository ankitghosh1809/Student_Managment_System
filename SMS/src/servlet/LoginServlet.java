package com.sms.servlet;
import com.sms.dao.AdminDAO;
import com.sms.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute("admin") != null) {
            res.sendRedirect("DashboardServlet"); return;
        }
        req.getRequestDispatcher("login.jsp").forward(req, res);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("login.jsp").forward(req, res); return;
        }
        Admin admin = adminDAO.login(username.trim(), password.trim());
        if (admin != null) {
            HttpSession session = req.getSession();
            session.setAttribute("admin", admin);
            session.setAttribute("adminName", admin.getFullName());
            session.setMaxInactiveInterval(1800);
            res.sendRedirect("DashboardServlet");
        } else {
            req.setAttribute("error", "Invalid username or password.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
        }
    }
}
