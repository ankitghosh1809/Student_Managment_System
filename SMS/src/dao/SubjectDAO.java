package com.sms.dao;
import com.sms.model.Subject;
import com.sms.util.DBConnection;
import java.sql.*;
import java.util.*;
public class SubjectDAO implements GenericDAO<Subject> {
    @Override
    public List<Subject> getAll() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject ORDER BY name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { System.err.println("SubjectDAO.getAll: " + e.getMessage()); }
        return list;
    }
    @Override
    public Subject getById(int id) {
        String sql = "SELECT * FROM subject WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { System.err.println("SubjectDAO.getById: " + e.getMessage()); }
        return null;
    }
    @Override
    public boolean insert(Subject s) {
        String sql = "INSERT INTO subject (name,code,credits,description) VALUES (?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName()); ps.setString(2, s.getCode().toUpperCase());
            ps.setInt(3, s.getCredits()); ps.setString(4, s.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { System.err.println("SubjectDAO.insert: " + e.getMessage()); }
        return false;
    }
    @Override
    public boolean update(Subject s) {
        String sql = "UPDATE subject SET name=?,code=?,credits=?,description=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName()); ps.setString(2, s.getCode().toUpperCase());
            ps.setInt(3, s.getCredits()); ps.setString(4, s.getDescription());
            ps.setInt(5, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { System.err.println("SubjectDAO.update: " + e.getMessage()); }
        return false;
    }
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM subject WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { System.err.println("SubjectDAO.delete: " + e.getMessage()); }
        return false;
    }
    @Override
    public int count() {
        String sql = "SELECT COUNT(*) FROM subject";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { System.err.println("SubjectDAO.count: " + e.getMessage()); }
        return 0;
    }
    private Subject map(ResultSet rs) throws SQLException {
        Subject s = new Subject();
        s.setId(rs.getInt("id")); s.setName(rs.getString("name"));
        s.setCode(rs.getString("code")); s.setCredits(rs.getInt("credits"));
        s.setDescription(rs.getString("description"));
        return s;
    }
}
