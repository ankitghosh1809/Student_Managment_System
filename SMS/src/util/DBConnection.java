package com.sms.util;
import java.sql.*;
import java.util.Properties;

public class DBConnection {
    private static final String JDBC_URL;
    private static final String DB_USER;
    private static final String DB_PASS;

    static {
        String raw = System.getenv("DATABASE_URL");
        System.out.println("[DBConnection] DATABASE_URL set: " + (raw != null));
        if (raw == null) throw new RuntimeException("DATABASE_URL env var is missing");

        String user = null, pass = null, url = raw;

        if (raw.startsWith("postgres://") || raw.startsWith("postgresql://")) {
            String noScheme = raw.startsWith("postgres://")
                ? raw.substring("postgres://".length())
                : raw.substring("postgresql://".length());
            int atIdx = noScheme.lastIndexOf('@');
            if (atIdx >= 0) {
                String userInfo = noScheme.substring(0, atIdx);
                String hostRest = noScheme.substring(atIdx + 1);
                int colonIdx = userInfo.indexOf(':');
                if (colonIdx >= 0) {
                    user = userInfo.substring(0, colonIdx);
                    pass = userInfo.substring(colonIdx + 1);
                } else {
                    user = userInfo;
                }
                url = "jdbc:postgresql://" + hostRest;
            } else {
                url = "jdbc:postgresql://" + noScheme;
            }
        } else if (!raw.startsWith("jdbc:")) {
            url = "jdbc:" + raw;
        }

        JDBC_URL = url;
        DB_USER = user;
        DB_PASS = pass;
        System.out.println("[DBConnection] URL prefix: " + JDBC_URL.substring(0, Math.min(50, JDBC_URL.length())));
        try { Class.forName("org.postgresql.Driver"); }
        catch (ClassNotFoundException e) { throw new RuntimeException("PostgreSQL driver not found", e); }
    }

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        Properties p = new Properties();
        if (DB_USER != null) p.setProperty("user", DB_USER);
        if (DB_PASS != null) p.setProperty("password", DB_PASS);
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
