package com.sms.dao;
import com.sms.util.DBConnection;
import java.sql.*;
import java.util.*;
public class MarksDAO {
    // Get all marks for a specific student
    public List<Map<String,Object>> getMarksByStudent(int studentId) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT m.*, sub.name subjectName, sub.code subjectCode, sub.credits " +
                     "FROM marks m JOIN subject sub ON m.subjectId = sub.id " +
                     "WHERE m.studentId = ? ORDER BY sub.name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> row = new LinkedHashMap<>();
                    row.put("id",          rs.getInt("id"));
                    row.put("subjectId",   rs.getInt("subjectId"));
                    row.put("subjectName", rs.getString("subjectName"));
                    row.put("subjectCode", rs.getString("subjectCode"));
                    row.put("credits",     rs.getInt("credits"));
                    row.put("marks",       rs.getInt("marks"));
                    row.put("maxMarks",    rs.getInt("maxMarks"));
                    row.put("examType",    rs.getString("examType"));
                    row.put("grade",       rs.getString("grade"));
                    double pct = rs.getInt("maxMarks") > 0
                        ? Math.round(rs.getInt("marks") * 100.0 / rs.getInt("maxMarks") * 10) / 10.0
                        : 0;
                    row.put("percentage", pct);
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            System.err.println("MarksDAO.getMarksByStudent: " + e.getMessage());
        }
        return list;
    }
    // Get all marks for admin view (all students)
    public List<Map<String,Object>> getAllMarks() {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT m.*, s.name studentName, s.rollNumber, " +
                     "sub.name subjectName, sub.code subjectCode " +
                     "FROM marks m " +
                     "JOIN student s ON m.studentId = s.id " +
                     "JOIN subject sub ON m.subjectId = sub.id " +
                     "ORDER BY s.name, sub.name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> row = new LinkedHashMap<>();
                row.put("id",          rs.getInt("id"));
                row.put("studentId",   rs.getInt("studentId"));
                row.put("studentName", rs.getString("studentName"));
                row.put("rollNumber",  rs.getString("rollNumber"));
                row.put("subjectName", rs.getString("subjectName"));
                row.put("subjectCode", rs.getString("subjectCode"));
                row.put("marks",       rs.getInt("marks"));
                row.put("maxMarks",    rs.getInt("maxMarks"));
                row.put("examType",    rs.getString("examType"));
                row.put("grade",       rs.getString("grade"));
                list.add(row);
            }
        } catch (SQLException e) {
            System.err.println("MarksDAO.getAllMarks: " + e.getMessage());
        }
        return list;
    }
    // Get summary per student (total, avg, overall grade)
    public List<Map<String,Object>> getStudentSummary() {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT s.id, s.name, s.rollNumber, s.course, " +
                     "COUNT(m.id) totalSubjects, " +
                     "SUM(m.marks) totalMarks, " +
                     "SUM(m.maxMarks) totalMaxMarks, " +
                     "ROUND(AVG(m.marks * 100.0 / m.maxMarks), 1) avgPct " +
                     "FROM student s LEFT JOIN marks m ON s.id = m.studentId " +
                     "GROUP BY s.id, s.name, s.rollNumber, s.course ORDER BY s.name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> row = new LinkedHashMap<>();
                double avg = rs.getDouble("avgPct");
                String overallGrade = avg >= 90 ? "A+" : avg >= 80 ? "A" :
                                      avg >= 70 ? "B"  : avg >= 60 ? "C" :
                                      avg >= 50 ? "D"  : "F";
                row.put("id",            rs.getInt("id"));
                row.put("name",          rs.getString("name"));
                row.put("rollNumber",    rs.getString("rollNumber"));
                row.put("course",        rs.getString("course"));
                row.put("totalSubjects", rs.getInt("totalSubjects"));
                row.put("totalMarks",    rs.getInt("totalMarks"));
                row.put("totalMaxMarks", rs.getInt("totalMaxMarks"));
                row.put("avgPct",        avg);
                row.put("overallGrade",  overallGrade);
                list.add(row);
            }
        } catch (SQLException e) {
            System.err.println("MarksDAO.getStudentSummary: " + e.getMessage());
        }
        return list;
    }
    // Add or update marks
    public boolean saveMarks(int studentId, int subjectId,
                             int marks, int maxMarks, String examType) {
        String grade = calculateGrade(marks, maxMarks);
        String sql = "INSERT INTO marks (studentId,subjectId,marks,maxMarks,examType,grade) " +
                     "VALUES (?,?,?,?,?,?) " +
                     "ON DUPLICATE KEY UPDATE marks=VALUES(marks), " +
                     "maxMarks=VALUES(maxMarks), grade=VALUES(grade)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId); ps.setInt(2, subjectId);
            ps.setInt(3, marks);     ps.setInt(4, maxMarks);
            ps.setString(5, examType); ps.setString(6, grade);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("MarksDAO.saveMarks: " + e.getMessage());
        }
        return false;
    }
    // Grade calculation logic
    public static String calculateGrade(int marks, int maxMarks) {
        if (maxMarks == 0) return "F";
        double pct = marks * 100.0 / maxMarks;
        if (pct >= 90) return "A+";
        if (pct >= 80) return "A";
        if (pct >= 70) return "B";
        if (pct >= 60) return "C";
        if (pct >= 50) return "D";
        return "F";
    }
}
