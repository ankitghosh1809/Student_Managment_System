package com.sms.util;
import java.io.*;
import java.sql.*;
import java.util.Properties;
public class DBConnection {
    private static final String URL;
    private static final String USER;
    private static final String PASS;
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Properties p = new Properties();
            String cfgPath = System.getenv("SMS_DB_CONFIG");
            if (cfgPath == null) cfgPath = System.getProperty("user.home") + "/sms-config/db.properties";
            try (InputStream in = new FileInputStream(cfgPath)) { p.load(in); }
            URL  = p.getProperty("db.url");
            USER = p.getProperty("db.user");
            PASS = p.getProperty("db.password");
        } catch (Exception e) {
            throw new RuntimeException("DB config error: " + e.getMessage());
        }
    }
    private DBConnection() {}
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
    public static void close(Connection conn) {
        if (conn != null) try { conn.close(); }
        catch (SQLException e) { System.err.println(e.getMessage()); }
    }
}
