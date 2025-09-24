package com.apartment.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.apartment.model.Tenant;
import com.apartment.model.User;
import com.apartment.util.DatabaseUtil;

public class TenantDAO {

    // NEW: Helper method to get a tenant's current assigned apartment details
    public Tenant getCurrentTenantDetails(int tenantUserId) {
        Tenant tenant = null;
        String SQL = "SELECT apartment_id, monthly_rent FROM tenants WHERE tenant_user_id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            preparedStatement.setInt(1, tenantUserId);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                tenant = new Tenant();
                tenant.setTenantUserId(tenantUserId);
                tenant.setApartmentId(rs.getInt("apartment_id"));
                tenant.setMonthlyRent(rs.getDouble("monthly_rent"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tenant;
    }

    public void assignTenantToApartment(Tenant tenant) throws SQLException {
        Connection connection = null;
        PreparedStatement findOldApartmentStmt = null;
        PreparedStatement vacateOldApartmentStmt = null;
        PreparedStatement upsertTenantStmt = null;
        PreparedStatement updateNewApartmentStmt = null;
        ResultSet rs = null;
        
        String FIND_OLD_APARTMENT_SQL = "SELECT apartment_id FROM tenants WHERE tenant_user_id = ?";
        String VACATE_OLD_APARTMENT_SQL = "UPDATE apartments SET tenant_id = NULL WHERE apartment_id = ?";
        String UPSERT_TENANT_SQL = "INSERT INTO tenants (tenant_user_id, apartment_id, move_in_date, monthly_rent) VALUES (?, ?, ?, ?) " +
                                   "ON DUPLICATE KEY UPDATE apartment_id = VALUES(apartment_id), move_in_date = VALUES(move_in_date), monthly_rent = VALUES(monthly_rent)";
        String UPDATE_NEW_APARTMENT_SQL = "UPDATE apartments SET tenant_id = ? WHERE apartment_id = ?";

        try {
            connection = DatabaseUtil.getConnection();
            connection.setAutoCommit(false); 

            findOldApartmentStmt = connection.prepareStatement(FIND_OLD_APARTMENT_SQL);
            findOldApartmentStmt.setInt(1, tenant.getTenantUserId());
            rs = findOldApartmentStmt.executeQuery();

            if (rs.next()) {
                int oldApartmentId = rs.getInt("apartment_id");
                
                if (oldApartmentId != 0 && oldApartmentId != tenant.getApartmentId()) {
                    vacateOldApartmentStmt = connection.prepareStatement(VACATE_OLD_APARTMENT_SQL);
                    vacateOldApartmentStmt.setInt(1, oldApartmentId);
                    vacateOldApartmentStmt.executeUpdate();
                }
            }

            upsertTenantStmt = connection.prepareStatement(UPSERT_TENANT_SQL);
            upsertTenantStmt.setInt(1, tenant.getTenantUserId());
            upsertTenantStmt.setInt(2, tenant.getApartmentId());
            upsertTenantStmt.setDate(3, tenant.getMoveInDate());
            upsertTenantStmt.setDouble(4, tenant.getMonthlyRent());
            upsertTenantStmt.executeUpdate();

            updateNewApartmentStmt = connection.prepareStatement(UPDATE_NEW_APARTMENT_SQL);
            updateNewApartmentStmt.setInt(1, tenant.getTenantUserId());
            updateNewApartmentStmt.setInt(2, tenant.getApartmentId());
            updateNewApartmentStmt.executeUpdate();
            
            connection.commit();

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (findOldApartmentStmt != null) try { findOldApartmentStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (vacateOldApartmentStmt != null) try { vacateOldApartmentStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (upsertTenantStmt != null) try { upsertTenantStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (updateNewApartmentStmt != null) try { updateNewApartmentStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    public List<User> getTenantsByOwner(int ownerId, String searchTerm) {
        List<User> tenants = new ArrayList<>();
        StringBuilder SQL = new StringBuilder(
            "SELECT u.* FROM users u " +
            "JOIN tenants t ON u.user_id = t.tenant_user_id " +
            "JOIN apartments a ON t.apartment_id = a.apartment_id " +
            "WHERE a.owner_id = ?"
        );
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            SQL.append(" AND (u.first_name LIKE ? OR u.last_name LIKE ? OR u.email LIKE ? OR u.mobile LIKE ?)");
        }
        
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL.toString())) {
            
            int paramIndex = 1;
            preparedStatement.setInt(paramIndex++, ownerId);

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchPattern = "%" + searchTerm.trim() + "%";
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
            }
            
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                User tenant = new User();
                tenant.setUserId(rs.getInt("user_id"));
                tenant.setFirstName(rs.getString("first_name"));
                tenant.setLastName(rs.getString("last_name"));
                tenant.setEmail(rs.getString("email"));
                tenant.setMobile(rs.getString("mobile"));
                tenants.add(tenant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tenants;
    }
    
    public int getTenantCount(String searchTerm) {
        int count = 0;
        String baseQuery = "SELECT count(*) FROM users WHERE role='tenant'";
        String searchQuery = "";

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            searchQuery = " AND (first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR mobile LIKE ?)";
        }

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(baseQuery + searchQuery)) {

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchPattern = "%" + searchTerm.trim() + "%";
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

    public List<User> searchAndPaginateTenants(String searchTerm, int currentPage, int pageSize) {
        List<User> tenantList = new ArrayList<>();
        String baseQuery = "SELECT * FROM users WHERE role='tenant'";
        String searchQuery = "";
        String paginationQuery = " ORDER BY user_id LIMIT ? OFFSET ?";

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            searchQuery = " AND (first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR mobile LIKE ?)";
        }
        
        int offset = (currentPage - 1) * pageSize;

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(baseQuery + searchQuery + paginationQuery)) {
            
            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchPattern = "%" + searchTerm.trim() + "%";
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
            }
            preparedStatement.setInt(paramIndex++, pageSize);
            preparedStatement.setInt(paramIndex++, offset);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                User tenant = new User();
                tenant.setUserId(rs.getInt("user_id"));
                tenant.setFirstName(rs.getString("first_name"));
                tenant.setLastName(rs.getString("last_name"));
                tenant.setEmail(rs.getString("email"));
                tenant.setMobile(rs.getString("mobile"));
                tenant.setRole(rs.getString("role"));
                tenantList.add(tenant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tenantList;
    }
}

