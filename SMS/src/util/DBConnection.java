package com.sms.util;
import java.sql.*;
import java.util.Properties;

public class DBConnection {
    private static final String JDBC_URL;

    static {
        String raw = System.getenv("DATABASE_URL");
        System.out.println("[DBConnection] DATABASE_URL set: " + (raw != null));
        if (raw == null) throw new RuntimeException("DATABASE_URL env var is missing");
        if (!raw.startsWith("jdbc:")) raw = "jdbc:" + raw;
        JDBC_URL = raw;
        System.out.println("[DBConnection] URL prefix: " + JDBC_URL.substring(0, Math.min(45, JDBC_URL.length())));
        try { Class.forName("org.postgresql.Driver"); }
        catch (ClassNotFoundException e) { throw new RuntimeException("PostgreSQL driver not found", e); }
    }

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        Properties p = new Properties();
        p.setProperty("ssl", "true");
        p.setProperty("sslmode", "require");
        try {
            Connection c = DriverManager.getConnection(JDBC_URL, p);
            System.out.println("[DBConnection] Connection OK");
            return c;
        } catch (SQLException e) {
            System.out.println("[DBConnection] FAILED: " + e.getMessage());
            throw e;
        }
    }

    public static void close(Connection c) {
        if (c != null) try { c.close(); } catch (SQLException ignored) {}
    }
}
