package com.sms.util;

import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Resolves DB credentials in priority order:
 *   1. DATABASE_URL  (full JDBC URL — recommended for Neon/Koyeb)
 *   2. DB_URL + DB_USER + DB_PASS  (explicit separate vars)
 *   3. Properties file at $SMS_DB_CONFIG or ~/sms-config/db.properties
 *      (local development fallback)
 */
public class DBConnection {

    private static final String URL;
    private static final String USER;
    private static final String PASS;

    static {
        try {
            Class.forName("org.postgresql.Driver");

            // ── Option 1: full Neon connection string (DATABASE_URL) ─────────
            String databaseUrl = System.getenv("DATABASE_URL");
            if (databaseUrl != null) {
                // Neon provides: postgresql://user:pass@host/db?sslmode=require
                // Convert to JDBC format if needed
                if (databaseUrl.startsWith("postgresql://")) {
                    databaseUrl = "jdbc:" + databaseUrl;
                }
                URL  = databaseUrl;
                USER = "";
                PASS = "";

            // ── Option 2: explicit env vars ──────────────────────────────────
            } else if (System.getenv("DB_URL") != null) {
                URL  = System.getenv("DB_URL");
                USER = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "";
                PASS = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "";

            // ── Option 3: local properties file (dev) ────────────────────────
            } else {
                Properties p   = new Properties();
                String cfgPath = System.getenv("SMS_DB_CONFIG");
                if (cfgPath == null)
                    cfgPath = System.getProperty("user.home") + "/sms-config/db.properties";
                try (InputStream in = new FileInputStream(cfgPath)) { p.load(in); }
                URL  = p.getProperty("db.url");
                USER = p.getProperty("db.user");
                PASS = p.getProperty("db.password");
            }

        } catch (Exception e) {
            throw new RuntimeException("DBConnection init failed: " + e.getMessage(), e);
        }
    }

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        if (USER == null || USER.isEmpty()) {
            // DATABASE_URL already contains credentials
            return DriverManager.getConnection(URL);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }

    public static void close(Connection conn) {
        if (conn != null) try { conn.close(); }
        catch (SQLException e) { System.err.println("DBConnection.close: " + e.getMessage()); }
    }
}
