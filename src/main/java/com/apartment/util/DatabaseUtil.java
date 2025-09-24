    package com.apartment.util;

    import java.sql.Connection;
    import java.sql.DriverManager;
    import java.sql.SQLException;

    /**
     * This utility class handles the database connection.
     * It ensures we don't have to write the connection logic in every DAO class.
     */
    public class DatabaseUtil {

        // --- IMPORTANT: UPDATE THESE VALUES ---
        private static final String JDBC_URL = "jdbc:mysql://localhost:3306/apartment_db?useSSL=false&serverTimezone=UTC";
        private static final String JDBC_USERNAME = "root"; // Your MySQL username
        private static final String JDBC_PASSWORD = ""; // Your MySQL password

        public static Connection getConnection() {
            Connection connection = null;
            try {
                // Register the MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                // Attempt to get a connection
                connection = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
            } catch (ClassNotFoundException e) {
                System.err.println("MySQL JDBC Driver not found.");
                e.printStackTrace();
            } catch (SQLException e) {
                System.err.println("Connection Failed! Check output console");
                e.printStackTrace();
            }
            return connection;
        }
    }
    