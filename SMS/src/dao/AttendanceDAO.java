package com.sms.dao;
import com.sms.model.Attendance;
import com.sms.util.DBConnection;
import java.sql.*;
import java.util.*;
public class AttendanceDAO implements GenericDAO<Attendance> {
    @FunctionalInterface
    interface ParamSetter { void set(PreparedStatement ps) throws SQLException; }
    private static final String JOIN =
        "SELECT a.*,s.name sn,sub.name subn,sub.code subc " +
        "FROM attendance a JOIN student s ON a.studentId=s.id " +
        "JOIN subject sub ON a.subjectId=sub.id ";
    @Override
    public List<Attendance> getAll() {
        return query(JOIN + "ORDER BY a.date DESC", null);
    }
    public List<Attendance> getByDate(java.sql.Date date) {
        return query(JOIN + "WHERE a.date=? ORDER BY s.name",
                     ps -> ps.setDate(1, date));
    }
    public List<Attendance> getByStudent(int studentId) {
        return query(JOIN + "WHERE a.studentId=? ORDER BY a.date DESC",
                     ps -> ps.setInt(1, studentId));
    }
    public boolean mark(Attendance a) {
        String sql = "INSERT INTO attendance (studentId,subjectId,date,status) VALUES (?,?,?,?) " +
                     "ON DUPLICATE KEY UPDATE status=VALUES(status)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, a.getStudentId()); ps.setInt(2, a.getSubjectId());
            ps.setDate(3, a.getDate()); ps.setString(4, a.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { System.err.println("AttendanceDAO.mark: " + e.getMessage()); }
        return false;
    }
    public List<Map<String,Object>> getPercentages() {
        List<Map<String,Object>> result = new ArrayList<>();
        String sql = "SELECT s.id,s.name,COUNT(a.id) total," +
                     "SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) present " +
                     "FROM student s LEFT JOIN attendance a ON s.id=a.studentId " +
                     "GROUP BY s.id,s.name ORDER BY s.name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int total = rs.getInt("total"); int present = rs.getInt("present");
                double pct = total > 0 ? Math.round(present * 1000.0 / total) / 10.0 : 0.0;
                Map<String,Object> row = new LinkedHashMap<>();
                row.put("id", rs.getInt("id")); row.put("name", rs.getString("name"));
                row.put("total", total); row.put("present", present); row.put("pct", pct);
                result.add(row);
            }
        } catch (SQLException e) { System.err.println("AttendanceDAO.getPercentages: " + e.getMessage()); }
        return result;
    }
    public int countTodayPresent() {
        String sql = "SELECT COUNT(*) FROM attendance WHERE date=CURDATE() AND status='Present'";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { System.err.println("AttendanceDAO.countTodayPresent: " + e.getMessage()); }
        return 0;
    }
    @Override public Attendance getById(int id)      { return null; }
    @Override public boolean insert(Attendance a)    { return mark(a); }
    @Override public boolean update(Attendance a)    { return mark(a); }
    @Override public boolean delete(int id)          { return false; }
    @Override public int count()                     { return 0; }
    private List<Attendance> query(String sql, ParamSetter setter) {
        List<Attendance> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (setter != null) setter.set(ps);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapFull(rs));
            }
        } catch (SQLException e) { System.err.println("AttendanceDAO.query: " + e.getMessage()); }
        return list;
    }
    private Attendance mapFull(ResultSet rs) throws SQLException {
        Attendance a = new Attendance();
        a.setId(rs.getInt("id")); a.setStudentId(rs.getInt("studentId"));
        a.setSubjectId(rs.getInt("subjectId")); a.setDate(rs.getDate("date"));
        a.setStatus(rs.getString("status")); a.setStudentName(rs.getString("sn"));
        a.setSubjectName(rs.getString("subn")); a.setSubjectCode(rs.getString("subc"));
        return a;
    }
}
