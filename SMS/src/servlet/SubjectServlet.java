package com.sms.servlet;

import com.sms.dao.SubjectDAO;
import com.sms.model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/SubjectServlet")
public class SubjectServlet extends HttpServlet {
    private final SubjectDAO dao = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!DashboardServlet.isLoggedIn(req)) { res.sendRedirect("login.jsp"); return; }

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            dao.delete(parse(req.getParameter("id")));
            res.sendRedirect("SubjectServlet?success=Subject+deleted"); return;
        }

        // Build subjects JSON
        List<Subject> subjects = dao.getAll();
        req.setAttribute("subjectsJson", toJson(subjects));

        // Edit mode — pass subject as JSON too
        if ("edit".equals(action)) {
            Subject es = dao.getById(parse(req.getParameter("id")));
            if (es != null) {
                String ej = "{\"id\":" + es.getId()
                    + ",\"name\":\"" + esc(es.getName()) + "\""
                    + ",\"code\":\"" + esc(es.getCode()) + "\""
                    + ",\"credits\":" + es.getCredits()
                    + ",\"description\":\"" + esc(es.getDescription()) + "\"}";
                req.setAttribute("editSubjectJson", ej);
            }
        }
        if (req.getAttribute("editSubjectJson") == null) {
            req.setAttribute("editSubjectJson", "null");
        }

        req.getRequestDispatcher("subjects.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!DashboardServlet.isLoggedIn(req)) { res.sendRedirect("login.jsp"); return; }

        Subject s = new Subject();
        s.setName(trim(req.getParameter("name")));
        s.setCode(trim(req.getParameter("code")));
        s.setCredits(parse(req.getParameter("credits")));
        s.setDescription(trim(req.getParameter("description")));

        boolean isEdit = "edit".equals(req.getParameter("action"));
        if (isEdit) {
            s.setId(parse(req.getParameter("id")));
            boolean ok = dao.update(s);
            res.sendRedirect("SubjectServlet?" + (ok ? "success=Subject+updated" : "error=Update+failed"));
        } else {
            boolean ok = dao.insert(s);
            res.sendRedirect("SubjectServlet?" + (ok ? "success=Subject+added" : "error=Code+exists"));
        }
    }

    private String toJson(List<Subject> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            Subject s = list.get(i);
            if (i > 0) sb.append(",");
            sb.append("{")
              .append("\"id\":").append(s.getId()).append(",")
              .append("\"name\":\"").append(esc(s.getName())).append("\",")
              .append("\"code\":\"").append(esc(s.getCode())).append("\",")
              .append("\"credits\":").append(s.getCredits()).append(",")
              .append("\"description\":\"").append(esc(s.getDescription())).append("\"")
              .append("}");
        }
        return sb.append("]").toString();
    }

    private String esc(String v) {
        if (v == null) return "";
        return v.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
    }
    private int    parse(String v) { try { return Integer.parseInt(v); } catch (Exception e) { return 3; } }
    private String trim(String v)  { return v != null ? v.trim() : ""; }
}
