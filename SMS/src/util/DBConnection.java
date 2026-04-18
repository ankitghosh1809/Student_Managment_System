package com.sms.util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public class DBConnection {
    private static final String URL  = "jdbc:mysql://localhost:3306/sms_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "your_password_here";
    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL driver not found: " + e.getMessage());
        }
    }
    private DBConnection() {}
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); }
            catch (SQLException e) { System.err.println(e.getMessage()); }
        }
    }
}
