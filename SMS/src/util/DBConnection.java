package com.sms.util;

import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Resolves DB credentials in priority order:
 *   1. DB_URL + DB_USER + DB_PASS  (explicit, works on any cloud)
 *   2. MYSQLHOST + MYSQLPORT + MYSQLDATABASE + MYSQLUSER + MYSQLPASSWORD
 *      (auto-injected by Railway's MySQL plugin)
 *   3. Properties file at $SMS_DB_CONFIG or ~/sms-config/db.properties
 *      (local development fallback)
 */
public class DBConnection {

    private static final String URL;
    private static final String USER;
    private static final String PASS;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // ── Option 1: explicit env vars ──────────────────────────────────
            String dbUrl  = System.getenv("DB_URL");
            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASS");

            if (dbUrl != null) {
                URL  = dbUrl;
                USER = dbUser != null ? dbUser : "";
                PASS = dbPass != null ? dbPass : "";

            // ── Option 2: Railway MySQL plugin vars ──────────────────────────
            } else if (System.getenv("MYSQLHOST") != null) {
                String host = System.getenv("MYSQLHOST");
                String port = System.getenv("MYSQLPORT");
                String db   = System.getenv("MYSQLDATABASE");
                URL  = "jdbc:mysql://" + host + ":" + port + "/" + db
                     + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                USER = System.getenv("MYSQLUSER");
                PASS = System.getenv("MYSQLPASSWORD");

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
        return DriverManager.getConnection(URL, USER, PASS);
    }

    public static void close(Connection conn) {
        if (conn != null) try { conn.close(); }
        catch (SQLException e) { System.err.println("DBConnection.close: " + e.getMessage()); }
    }
}
