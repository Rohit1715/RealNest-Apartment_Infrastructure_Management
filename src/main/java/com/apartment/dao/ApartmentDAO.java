package com.apartment.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.apartment.model.Apartment;
import com.apartment.model.Property;
import com.apartment.util.DatabaseUtil;

public class ApartmentDAO {

    // --- METHODS FOR ADMIN APARTMENT MANAGEMENT ---

    public List<Apartment> searchAndPaginateApartments(String searchTerm, String filterBy, int page, int pageSize) {
        List<Apartment> apartments = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("SELECT * FROM apartments WHERE 1=1");
        appendSearchAndFilterConditions(SQL, searchTerm, filterBy);
        int offset = (page - 1) * pageSize;
        SQL.append(" ORDER BY block_name, flat_number LIMIT ? OFFSET ?");

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL.toString())) {
            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.isEmpty()) {
                preparedStatement.setString(paramIndex++, "%" + searchTerm + "%");
                preparedStatement.setString(paramIndex++, "%" + searchTerm + "%");
            }
            preparedStatement.setInt(paramIndex++, pageSize);
            preparedStatement.setInt(paramIndex, offset);

            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                apartments.add(mapResultSetToApartment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apartments;
    }

    public int getApartmentCount(String searchTerm, String filterBy) {
        StringBuilder SQL = new StringBuilder("SELECT COUNT(*) FROM apartments WHERE 1=1");
        appendSearchAndFilterConditions(SQL, searchTerm, filterBy);
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL.toString())) {
            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.isEmpty()) {
                preparedStatement.setString(paramIndex++, "%" + searchTerm + "%");
                preparedStatement.setString(paramIndex++, "%" + searchTerm + "%");
            }
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void appendSearchAndFilterConditions(StringBuilder sql, String searchTerm, String filterBy) {
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (block_name LIKE ? OR flat_number LIKE ?)");
        }
        if (filterBy != null && !filterBy.equals("all")) {
            if (filterBy.equals("assigned")) {
                sql.append(" AND owner_id IS NOT NULL AND owner_id != 0");
            } else if (filterBy.equals("unassigned")) {
                sql.append(" AND (owner_id IS NULL OR owner_id = 0)");
            }
        }
    }
    
    public void addApartment(Apartment apartment) throws SQLException {
        String INSERT_SQL = "INSERT INTO apartments (block_name, flat_number, floor, house_type, other_details) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_SQL)) {
            preparedStatement.setString(1, apartment.getBlockName());
            preparedStatement.setString(2, apartment.getFlatNumber());
            preparedStatement.setInt(3, apartment.getFloor());
            preparedStatement.setString(4, apartment.getHouseType());
            preparedStatement.setString(5, apartment.getOtherDetails());
            preparedStatement.executeUpdate();
        }
    }

    public void assignOwnerToApartment(int ownerId, int apartmentId) throws SQLException {
        String SQL = "UPDATE apartments SET owner_id = ? WHERE apartment_id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            preparedStatement.setInt(1, ownerId);
            preparedStatement.setInt(2, apartmentId);
            preparedStatement.executeUpdate();
        }
    }

    // --- METHODS FOR OWNER PROPERTY MANAGEMENT ---
    
    public List<Property> searchAndPaginateOwnerProperties(int ownerId, String searchTerm, String filterBy, int currentPage, int pageSize) {
        List<Property> properties = new ArrayList<>();
        StringBuilder SQL = new StringBuilder(
            "SELECT a.block_name, a.flat_number, a.house_type, " +
            "u.first_name, u.last_name, u.mobile, ten.monthly_rent " +
            "FROM apartments a " +
            "LEFT JOIN tenants ten ON a.apartment_id = ten.apartment_id " +
            "LEFT JOIN users u ON ten.tenant_user_id = u.user_id " +
            "WHERE a.owner_id = ?"
        );
        
        appendOwnerPropertyConditions(SQL, searchTerm, filterBy);
        SQL.append(" ORDER BY a.block_name, a.flat_number LIMIT ? OFFSET ?");
        
        int offset = (currentPage - 1) * pageSize;

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL.toString())) {
            
            int paramIndex = 1;
            preparedStatement.setInt(paramIndex++, ownerId);
            paramIndex = setOwnerPropertyParameters(preparedStatement, paramIndex, searchTerm, filterBy);

            preparedStatement.setInt(paramIndex++, pageSize);
            preparedStatement.setInt(paramIndex++, offset);
            
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                properties.add(mapResultSetToProperty(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return properties;
    }

    public int getOwnerPropertyCount(int ownerId, String searchTerm, String filterBy) {
        int count = 0;
        StringBuilder SQL = new StringBuilder("SELECT COUNT(*) FROM apartments a WHERE a.owner_id = ?");

        // Note: Searching tenants requires a more complex count query
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
             SQL = new StringBuilder(
                "SELECT COUNT(*) FROM apartments a " +
                "LEFT JOIN tenants ten ON a.apartment_id = ten.apartment_id " +
                "LEFT JOIN users u ON ten.tenant_user_id = u.user_id " +
                "WHERE a.owner_id = ?"
            );
        }
        
        appendOwnerPropertyConditions(SQL, searchTerm, filterBy);

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL.toString())) {
            
            int paramIndex = 1;
            preparedStatement.setInt(paramIndex++, ownerId);
            setOwnerPropertyParameters(preparedStatement, paramIndex, searchTerm, filterBy);
            
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    private void appendOwnerPropertyConditions(StringBuilder sql, String searchTerm, String filterBy) {
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (CONCAT(u.first_name, ' ', u.last_name) LIKE ? OR a.block_name LIKE ? OR a.flat_number LIKE ?)");
        }
        if (filterBy != null && !"all".equalsIgnoreCase(filterBy)) {
            if ("occupied".equalsIgnoreCase(filterBy)) {
                sql.append(" AND a.tenant_id IS NOT NULL");
            } else if ("vacant".equalsIgnoreCase(filterBy)) {
                sql.append(" AND a.tenant_id IS NULL");
            }
        }
    }

    private int setOwnerPropertyParameters(PreparedStatement ps, int startIndex, String searchTerm, String filterBy) throws SQLException {
        int paramIndex = startIndex;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchPattern = "%" + searchTerm.trim() + "%";
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
        }
        return paramIndex;
    }

    // --- UTILITY & GENERAL USE METHODS ---
    
    /**
     * THIS IS THE METHOD THAT WAS MISSING.
     * It is required by the VisitorLogServlet to populate the dropdown.
     */
    public List<Apartment> getAllApartments() {
        List<Apartment> apartments = new ArrayList<>();
        String SQL = "SELECT * FROM apartments ORDER BY block_name, flat_number";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                apartments.add(mapResultSetToApartment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apartments;
    }
    
    public List<Apartment> getUnassignedApartments() {
        List<Apartment> apartments = new ArrayList<>();
        String SQL = "SELECT * FROM apartments WHERE owner_id IS NULL OR owner_id = 0 ORDER BY block_name, flat_number";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                apartments.add(mapResultSetToApartment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apartments;
    }
    
    public List<Apartment> getApartmentsWithoutTenant() {
        List<Apartment> apartments = new ArrayList<>();
        String SQL = "SELECT * FROM apartments WHERE owner_id IS NOT NULL AND tenant_id IS NULL ORDER BY block_name, flat_number";
         try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                apartments.add(mapResultSetToApartment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apartments;
    }
    // --- NEW METHOD FOR DASHBOARD ---
    public int getTotalApartmentCount() {
        int count = 0;
        String SQL = "SELECT COUNT(*) FROM apartments";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    private Apartment mapResultSetToApartment(ResultSet rs) throws SQLException {
        Apartment apartment = new Apartment();
        apartment.setApartmentId(rs.getInt("apartment_id"));
        apartment.setBlockName(rs.getString("block_name"));
        apartment.setFlatNumber(rs.getString("flat_number"));
        apartment.setFloor(rs.getInt("floor"));
        apartment.setHouseType(rs.getString("house_type"));
        apartment.setOtherDetails(rs.getString("other_details"));
        apartment.setOwnerId(rs.getInt("owner_id"));
        apartment.setTenantId(rs.getInt("tenant_id"));
        return apartment;
    }

    private Property mapResultSetToProperty(ResultSet rs) throws SQLException {
        Property prop = new Property();
        prop.setBlock(rs.getString("block_name"));
        prop.setFlatNumber(rs.getString("flat_number"));
        prop.setType(rs.getString("house_type"));
        
        String tenantFirstName = rs.getString("first_name");
        if (tenantFirstName != null) {
            prop.setStatus("Occupied");
            prop.setTenantName(tenantFirstName + " " + rs.getString("last_name"));
            prop.setTenantContact(rs.getString("mobile"));
            prop.setMonthlyRent(rs.getDouble("monthly_rent"));
        } else {
            prop.setStatus("Vacant");
            prop.setTenantName("N/A");
            prop.setTenantContact("N/A");
            prop.setMonthlyRent(0.0);
        }
        return prop;
    }
}

