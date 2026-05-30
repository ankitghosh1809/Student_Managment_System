package com.sms.dao;
import com.sms.model.Admin;
import com.sms.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.*;
public class AdminDAO implements GenericDAO<Admin> {
    public Admin login(String username, String password) {
        String sql = "SELECT * FROM admin WHERE username=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String stored = rs.getString("password");
                    System.out.println("[AdminDAO] User found: " + username);
                    boolean ok = BCrypt.checkpw(password, stored);
                    System.out.println("[AdminDAO] Password match: " + ok);
                    if (ok) return map(rs);
                } else {
                    System.out.println("[AdminDAO] No user found: " + username);
                }
            }
        } catch (Exception e) {
            System.out.println("[AdminDAO] ERROR: " + e.getClass().getName() + ": " + e.getMessage());
            e.printStackTrace(System.out);
        }
        return null;
    }
    @Override public List<Admin> getAll()    { return new ArrayList<>(); }
    @Override public Admin getById(int id)   { return null; }
    @Override public boolean insert(Admin a) { return false; }
    @Override public boolean update(Admin a) { return false; }
    @Override public boolean delete(int id)  { return false; }
    @Override public int count()             { return 0; }
    private Admin map(ResultSet rs) throws SQLException {
        Admin a = new Admin();
        a.setId(rs.getInt("id"));
        a.setUsername(rs.getString("username"));
        a.setFullName(rs.getString("fullname")); // PostgreSQL lowercases column names
        return a;
    }
}
