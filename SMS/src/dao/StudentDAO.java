package com.sms.dao;
import com.sms.model.Student;
import com.sms.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.*;
public class StudentDAO implements GenericDAO<Student> {
    @Override
    public List<Student> getAll() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student ORDER BY name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { System.out.println("StudentDAO.getAll: " + e.getMessage()); }
        return list;
    }
    public List<Student> search(String q) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student WHERE name ILIKE ? OR email ILIKE ? OR course ILIKE ? OR rollnumber ILIKE ? ORDER BY name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            String w = "%" + q + "%";
            ps.setString(1, w); ps.setString(2, w); ps.setString(3, w); ps.setString(4, w);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(map(rs)); }
        } catch (SQLException e) { System.out.println("StudentDAO.search: " + e.getMessage()); }
        return list;
    }
    @Override
    public Student getById(int id) {
        String sql = "SELECT * FROM student WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return map(rs); }
        } catch (SQLException e) { System.out.println("StudentDAO.getById: " + e.getMessage()); }
        return null;
    }
    public Student loginStudent(String rollNumber, String password) {
        String sql = "SELECT * FROM student WHERE rollnumber=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, rollNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && BCrypt.checkpw(password, rs.getString("password")))
                    return map(rs);
            }
        } catch (SQLException e) { System.out.println("StudentDAO.loginStudent: " + e.getMessage()); }
        return null;
    }
    @Override
    public boolean insert(Student s) {
        String sql = "INSERT INTO student (name,email,course,phone,address,password) VALUES (?,?,?,?,?,?) RETURNING id";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName()); ps.setString(2, s.getEmail());
            ps.setString(3, s.getCourse()); ps.setString(4, s.getPhone());
            ps.setString(5, s.getAddress());
            String raw = s.getPassword() != null ? s.getPassword() : "student123";
            ps.setString(6, BCrypt.hashpw(raw, BCrypt.gensalt(12)));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int newId = rs.getInt(1);
                    String roll = "CS" + String.format("%03d", newId);
                    try (PreparedStatement ups = c.prepareStatement("UPDATE student SET rollnumber=? WHERE id=?")) {
                        ups.setString(1, roll); ups.setInt(2, newId); ups.executeUpdate();
                    }
                    return true;
                }
            }
        } catch (SQLException e) { System.out.println("StudentDAO.insert: " + e.getMessage()); }
        return false;
    }
    @Override
    public boolean update(Student s) {
        String sql = "UPDATE student SET name=?,email=?,course=?,phone=?,address=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName()); ps.setString(2, s.getEmail());
            ps.setString(3, s.getCourse()); ps.setString(4, s.getPhone());
            ps.setString(5, s.getAddress()); ps.setInt(6, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { System.out.println("StudentDAO.update: " + e.getMessage()); }
        return false;
    }
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM student WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id); return ps.executeUpdate() > 0;
        } catch (SQLException e) { System.out.println("StudentDAO.delete: " + e.getMessage()); }
        return false;
    }
    @Override
    public int count() {
        String sql = "SELECT COUNT(*) FROM student";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { System.out.println("StudentDAO.count: " + e.getMessage()); }
        return 0;
    }
    private Student map(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setCourse(rs.getString("course"));
        s.setPhone(rs.getString("phone"));
        s.setAddress(rs.getString("address"));
        s.setEnrollmentDate(rs.getDate("enrollmentdate"));
        s.setRollNumber(rs.getString("rollnumber"));
        return s;
    }
}
