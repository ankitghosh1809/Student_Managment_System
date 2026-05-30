package com.sms.util;
import java.sql.*;
import java.util.Properties;

public class DBConnection {
    private static final String URL;

    static {
        try {
            Class.forName("org.postgresql.Driver");
            String dbUrl = System.getenv("DATABASE_URL");
            System.out.println("[DBConnection] DATABASE_URL present: " + (dbUrl != null));
            if (dbUrl == null) throw new RuntimeException("DATABASE_URL is not set");
            if (dbUrl.startsWith("postgresql://") || dbUrl.startsWith("postgres://")) {
                dbUrl = "jdbc:" + dbUrl;
            }
            URL = dbUrl;
            System.out.println("[DBConnection] JDBC URL prefix: " + URL.substring(0, Math.min(40, URL.length())));
        } catch (Exception e) {
            System.out.println("[DBConnection] INIT FAILED: " + e.getMessage());
            throw new RuntimeException("DBConnection init failed", e);
        }
    }

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        Properties props = new Properties();
        props.setProperty("ssl", "true");
        props.setProperty("sslmode", "require");
        try {
            return DriverManager.getConnection(URL, props);
        } catch (SQLException e) {
            System.out.println("[DBConnection] getConnection FAILED: " + e.getMessage());
            throw e;
        }
    }

    public static void close(Connection conn) {
        if (conn != null) try { conn.close(); }
        catch (SQLException e) { System.out.println("[DBConnection] close error: " + e.getMessage()); }
    }
}
