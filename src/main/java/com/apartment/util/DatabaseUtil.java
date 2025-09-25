package com.apartment.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {

    // --- Local Development Credentials ---
    private static final String LOCAL_JDBC_URL = "jdbc:mysql://localhost:3306/apartment_db";
    private static final String LOCAL_DB_USER = "root"; // <-- Update with your local username
    private static final String LOCAL_DB_PASSWORD = ""; // <-- Update with your local password

    public static Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // --- DEPLOYMENT LOGIC FOR RENDER ---
            String dbHost = System.getenv("DB_HOST");
            String dbPort = System.getenv("DB_PORT");
            String dbUser = System.getenv("DB_USER");
            String dbPassword = System.getenv("DB_PASS");
            String dbName = System.getenv("DB_NAME");

            if (dbHost != null && dbUser != null && dbPassword != null && dbName != null) {
                // If live credentials are found, construct the TiDB URL and use them.
                System.out.println("Connecting to live TiDB database with SSL...");
                
                // --- FINAL FIX: Use the secure connection string required by TiDB Cloud ---
                String jdbcUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?sslMode=VERIFY_IDENTITY&enabledTLSProtocols=TLSv1.2,TLSv1.3";
                
                connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            } else {
                // If not, fall back to the local credentials.
                System.out.println("Connecting to local database...");
                connection = DriverManager.getConnection(LOCAL_JDBC_URL, LOCAL_DB_USER, LOCAL_DB_PASSWORD);
            }
        } catch (ClassNotFoundException | SQLException e) {
            // Print the full stack trace to the server logs for detailed debugging
            e.printStackTrace();
            throw new SQLException("Failed to connect to the database.", e);
        }
        return connection;
    }
}

