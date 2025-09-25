package com.apartment.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.apartment.model.User;
import com.apartment.util.DatabaseUtil;

public class UserDAO {

    public boolean updateUserProfile(User user) throws SQLException {
        String CHECK_EMAIL_SQL = "SELECT user_id FROM users WHERE email = ? AND user_id != ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement checkStmt = connection.prepareStatement(CHECK_EMAIL_SQL)) {
            checkStmt.setString(1, user.getEmail());
            checkStmt.setInt(2, user.getUserId());
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    return false; 
                }
            }
        }

        String UPDATE_USER_SQL = "UPDATE users SET first_name = ?, last_name = ?, mobile = ?, email = ? WHERE user_id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement updateStmt = connection.prepareStatement(UPDATE_USER_SQL)) {
            updateStmt.setString(1, user.getFirstName());
            updateStmt.setString(2, user.getLastName());
            updateStmt.setString(3, user.getMobile());
            updateStmt.setString(4, user.getEmail());
            updateStmt.setInt(5, user.getUserId());
            updateStmt.executeUpdate();
        }
        return true;
    }

    public User getUserByEmailAndRole(String email, String role) {
        User user = null;
        String SQL = "SELECT * FROM users WHERE email = ? AND role = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, role);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
    
    public void updatePassword(String email, String newPassword) throws SQLException {
        String SQL = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            preparedStatement.setString(1, newPassword);
            preparedStatement.setString(2, email);
            preparedStatement.executeUpdate();
        }
    }

    public User getUserById(int userId) {
        User user = null;
        String SQL = "SELECT * FROM users WHERE user_id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            preparedStatement.setInt(1, userId);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public User getUserByEmail(String email) {
        User user = null;
        String SQL = "SELECT * FROM users WHERE email = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            preparedStatement.setString(1, email);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public List<String> getAdminEmails() {
        List<String> adminEmails = new ArrayList<>();
        String SQL = "SELECT email FROM users WHERE role = 'ADMIN'";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                adminEmails.add(rs.getString("email"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return adminEmails;
    }
	
	public List<Integer> getAdminUserIds() {
        List<Integer> adminIds = new ArrayList<>();
        String SQL = "SELECT user_id FROM users WHERE role = 'ADMIN'";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                adminIds.add(rs.getInt("user_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return adminIds;
    }
	
	public List<Integer> getAllTenantAndOwnerIds() {
        List<Integer> userIds = new ArrayList<>();
        String SQL = "SELECT user_id FROM users WHERE role IN ('TENANT', 'OWNER')";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                userIds.add(rs.getInt("user_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userIds;
    }

    public void saveUser(User user) throws SQLException {
        String INSERT_USERS_SQL = "INSERT INTO users (username, password, email, first_name, last_name, mobile, role) VALUES (?, ?, ?, ?, ?, ?, ?);";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USERS_SQL)) {
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getPassword());
            preparedStatement.setString(3, user.getEmail());
            preparedStatement.setString(4, user.getFirstName());
            preparedStatement.setString(5, user.getLastName());
            preparedStatement.setString(6, user.getMobile());
            preparedStatement.setString(7, user.getRole());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public User validateUser(String identifier, String password) {
        User user = null;
        // --- MODIFICATION: Added TRIM() to the SQL query to handle whitespace issues from the database. ---
        String SELECT_USER_SQL = "SELECT * FROM users WHERE (TRIM(username) = ? OR TRIM(email) = ?) AND password = ?";
        
        System.out.println("Executing UserDAO.validateUser...");
        
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_SQL)) {
            
            // --- MODIFICATION: Trim the user's input as well for a robust comparison. ---
            preparedStatement.setString(1, identifier.trim());
            preparedStatement.setString(2, identifier.trim());
            preparedStatement.setString(3, password);

            System.out.println("Executing query: " + preparedStatement.toString().split(": ")[1]);

            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                System.out.println("Query returned a result. User found.");
                user = mapResultSetToUser(rs);
            } else {
                System.out.println("Query returned NO result. User not found.");
            }
        } catch (SQLException e) {
            System.out.println("SQLException in validateUser: " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }
    
    public boolean checkUserExists(String username, String email) {
        boolean userExists = false;
        String CHECK_USER_SQL = "SELECT 1 FROM users WHERE username = ? OR email = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(CHECK_USER_SQL)) {
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, email);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                userExists = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userExists;
    }

    public List<User> getAllOwners() {
        List<User> owners = new ArrayList<>();
        String SQL = "SELECT * FROM users WHERE role = 'OWNER'";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                owners.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return owners;
    }
    
    public List<User> getAllTenants() {
        List<User> tenants = new ArrayList<>();
        String SQL = "SELECT * FROM users WHERE role = 'TENANT'";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                tenants.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tenants;
    }

    public int getOwnerCount(String searchTerm) {
        int count = 0;
        String baseQuery = "SELECT count(*) FROM users WHERE role='owner'";
        String searchQuery = "";

        if (searchTerm != null && !searchTerm.isEmpty()) {
            searchQuery = " AND (first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR mobile LIKE ?)";
        }

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(baseQuery + searchQuery)) {

            if (searchTerm != null && !searchTerm.isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                preparedStatement.setString(1, searchPattern);
                preparedStatement.setString(2, searchPattern);
                preparedStatement.setString(3, searchPattern);
                preparedStatement.setString(4, searchPattern);
            }

            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    public List<User> searchAndPaginateOwners(String searchTerm, int currentPage, int pageSize) {
        List<User> ownerList = new ArrayList<>();
        String baseQuery = "SELECT * FROM users WHERE role='owner'";
        String searchQuery = "";
        String paginationQuery = " ORDER BY user_id LIMIT ? OFFSET ?";

        if (searchTerm != null && !searchTerm.isEmpty()) {
            searchQuery = " AND (first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR mobile LIKE ?)";
        }
        
        int offset = (currentPage - 1) * pageSize;

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(baseQuery + searchQuery + paginationQuery)) {
            
            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
            }
            preparedStatement.setInt(paramIndex++, pageSize);
            preparedStatement.setInt(paramIndex++, offset);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                ownerList.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ownerList;
    }
    
    public int getTotalTenantsByOwner(int ownerId) {
        int count = 0;
        String SQL = "SELECT COUNT(DISTINCT t.tenant_user_id) FROM tenants t " +
                     "JOIN apartments a ON t.apartment_id = a.apartment_id " +
                     "WHERE a.owner_id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            preparedStatement.setInt(1, ownerId);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setEmail(rs.getString("email"));
        user.setMobile(rs.getString("mobile"));
        user.setRole(rs.getString("role"));
        return user;
    }
}

