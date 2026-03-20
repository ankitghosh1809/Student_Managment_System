package com.sms.servlet;

import com.sms.dao.MarksDAO;
import com.sms.dao.StudentDAO;
import com.sms.dao.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/MarksServlet")
public class MarksServlet extends HttpServlet {
    private final MarksDAO   marksDAO   = new MarksDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!DashboardServlet.isLoggedIn(req)) {
            res.sendRedirect("login.jsp"); return;
        }

        // All marks
        List<Map<String,Object>> allMarks = marksDAO.getAllMarks();
        StringBuilder mJson = new StringBuilder("[");
        for (int i = 0; i < allMarks.size(); i++) {
            Map<String,Object> m = allMarks.get(i);
            if (i > 0) mJson.append(",");
            mJson.append("{")
                 .append("\"id\":").append(m.get("id")).append(",")
                 .append("\"studentId\":").append(m.get("studentId")).append(",")
                 .append("\"studentName\":\"").append(esc(m.get("studentName"))).append("\",")
                 .append("\"rollNumber\":\"").append(esc(m.get("rollNumber"))).append("\",")
                 .append("\"subjectName\":\"").append(esc(m.get("subjectName"))).append("\",")
                 .append("\"subjectCode\":\"").append(esc(m.get("subjectCode"))).append("\",")
                 .append("\"marks\":").append(m.get("marks")).append(",")
                 .append("\"maxMarks\":").append(m.get("maxMarks")).append(",")
                 .append("\"examType\":\"").append(esc(m.get("examType"))).append("\",")
                 .append("\"grade\":\"").append(esc(m.get("grade"))).append("\"")
                 .append("}");
        }
        mJson.append("]");

        // Student summary
        List<Map<String,Object>> summary = marksDAO.getStudentSummary();
        StringBuilder sJson = new StringBuilder("[");
        for (int i = 0; i < summary.size(); i++) {
            Map<String,Object> s = summary.get(i);
            if (i > 0) sJson.append(",");
            sJson.append("{")
                 .append("\"id\":").append(s.get("id")).append(",")
                 .append("\"name\":\"").append(esc(s.get("name"))).append("\",")
                 .append("\"rollNumber\":\"").append(esc(s.get("rollNumber"))).append("\",")
                 .append("\"course\":\"").append(esc(s.get("course"))).append("\",")
                 .append("\"totalSubjects\":").append(s.get("totalSubjects")).append(",")
                 .append("\"totalMarks\":").append(s.get("totalMarks")).append(",")
                 .append("\"totalMaxMarks\":").append(s.get("totalMaxMarks")).append(",")
                 .append("\"avgPct\":").append(s.get("avgPct")).append(",")
                 .append("\"overallGrade\":\"").append(esc(s.get("overallGrade"))).append("\"")
                 .append("}");
        }
        sJson.append("]");

        // Students and subjects for add marks form
        req.setAttribute("marksJson",   mJson.toString());
        req.setAttribute("summaryJson", sJson.toString());
        req.setAttribute("studentsJson", toStudentJson(studentDAO));
        req.setAttribute("subjectsJson", toSubjectJson(subjectDAO));

        req.getRequestDispatcher("marks.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!DashboardServlet.isLoggedIn(req)) {
            res.sendRedirect("login.jsp"); return;
        }
        try {
            int studentId = Integer.parseInt(req.getParameter("studentId"));
            int subjectId = Integer.parseInt(req.getParameter("subjectId"));
            int marks     = Integer.parseInt(req.getParameter("marks"));
            int maxMarks  = Integer.parseInt(req.getParameter("maxMarks"));
            String exam   = req.getParameter("examType");
            boolean ok    = marksDAO.saveMarks(studentId, subjectId, marks, maxMarks, exam);
            res.sendRedirect("MarksServlet?" + (ok ? "success=Marks+saved" : "error=Save+failed"));
        } catch (Exception e) {
            res.sendRedirect("MarksServlet?error=Invalid+data");
        }
    }

    private String toStudentJson(StudentDAO dao) {
        StringBuilder sb = new StringBuilder("[");
        var list = dao.getAll();
        for (int i = 0; i < list.size(); i++) {
            var s = list.get(i);
            if (i > 0) sb.append(",");
            sb.append("{\"id\":").append(s.getId())
              .append(",\"name\":\"").append(esc(s.getName())).append("\"")
              .append(",\"rollNumber\":\"").append(esc(s.getRollNumber())).append("\"}");
        }
        return sb.append("]").toString();
    }

    private String toSubjectJson(SubjectDAO dao) {
        StringBuilder sb = new StringBuilder("[");
        var list = dao.getAll();
        for (int i = 0; i < list.size(); i++) {
            var s = list.get(i);
            if (i > 0) sb.append(",");
            sb.append("{\"id\":").append(s.getId())
              .append(",\"name\":\"").append(esc(s.getName())).append("\"")
              .append(",\"code\":\"").append(esc(s.getCode())).append("\"}");
        }
        return sb.append("]").toString();
    }

    private String esc(Object v) {
        if (v == null) return "";
        return v.toString().replace("\\","\\\\").replace("\"","\\\"");
    }
}
