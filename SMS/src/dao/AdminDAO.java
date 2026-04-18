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
                if (rs.next() && BCrypt.checkpw(password, rs.getString("password")))
                    return map(rs);
            }
        } catch (SQLException e) { System.err.println("AdminDAO.login: " + e.getMessage()); }
        return null;
    }
    @Override public List<Admin> getAll()        { return new ArrayList<>(); }
    @Override public Admin getById(int id)        { return null; }
    @Override public boolean insert(Admin a)      { return false; }
    @Override public boolean update(Admin a)      { return false; }
    @Override public boolean delete(int id)       { return false; }
    @Override public int count()                  { return 0; }
    private Admin map(ResultSet rs) throws SQLException {
        Admin a = new Admin();
        a.setId(rs.getInt("id"));
        a.setUsername(rs.getString("username"));
        a.setFullName(rs.getString("fullName"));
        return a;
    }
}
