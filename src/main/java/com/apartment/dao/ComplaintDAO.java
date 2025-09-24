package com.apartment.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.apartment.model.Complaint;
import com.apartment.util.DatabaseUtil;

public class ComplaintDAO {

    public int addComplaint(Complaint complaint) throws SQLException {
        String SQL = "INSERT INTO complaints (resident_id, issue_type, description, status) VALUES (?, ?, ?, 'Open')";
        int generatedComplaintId = 0;
        
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {
            
            preparedStatement.setInt(1, complaint.getResidentId());
            preparedStatement.setString(2, complaint.getIssueType());
            preparedStatement.setString(3, complaint.getDescription());
            
            int affectedRows = preparedStatement.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = preparedStatement.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedComplaintId = rs.getInt(1);
                    }
                }
            }
        }
        return generatedComplaintId;
    }
    
    // NEW: Method to get all details required for the new complaint email alert
    public Map<String, String> getComplaintEmailDetails(int complaintId) {
        Map<String, String> details = new HashMap<>();
        String SQL = "SELECT " +
                     "  CONCAT(tenant.first_name, ' ', tenant.last_name) AS tenant_name, " +
                     "  CONCAT(a.block_name, ', Flat ', a.flat_number) AS apartment_info, " +
                     "  owner.email AS owner_email " +
                     "FROM complaints c " +
                     "JOIN users tenant ON c.resident_id = tenant.user_id " +
                     "JOIN tenants t ON tenant.user_id = t.tenant_user_id " +
                     "JOIN apartments a ON t.apartment_id = a.apartment_id " +
                     "JOIN users owner ON a.owner_id = owner.user_id " +
                     "WHERE c.complaint_id = ?";

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {
            ps.setInt(1, complaintId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                details.put("tenantName", rs.getString("tenant_name"));
                details.put("apartmentInfo", rs.getString("apartment_info"));
                details.put("ownerEmail", rs.getString("owner_email"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }
    
    public Complaint getComplaintById(int complaintId) {
        Complaint complaint = null;
        String SQL = "SELECT c.*, u.first_name, u.last_name, a.block_name, a.flat_number " +
                     "FROM complaints c " +
                     "JOIN users u ON c.resident_id = u.user_id " +
                     "LEFT JOIN tenants t ON u.user_id = t.tenant_user_id " +
                     "LEFT JOIN apartments a ON t.apartment_id = a.apartment_id " +
                     "WHERE c.complaint_id = ?";
                     
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {
            ps.setInt(1, complaintId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                complaint = mapResultSetToComplaint(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaint;
    }
    
    public Map<String, Integer> getTenantAndOwnerIdsForComplaint(int complaintId) {
        Map<String, Integer> ids = new HashMap<>();
        String SQL = "SELECT c.resident_id, a.owner_id " +
                     "FROM complaints c " +
                     "JOIN tenants t ON c.resident_id = t.tenant_user_id " +
                     "JOIN apartments a ON t.apartment_id = a.apartment_id " +
                     "WHERE c.complaint_id = ?";
                     
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {
            ps.setInt(1, complaintId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ids.put("tenantId", rs.getInt("resident_id"));
                ids.put("ownerId", rs.getInt("owner_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }


    public void updateComplaintStatus(int complaintId, String newStatus) throws SQLException {
        String SQL = "UPDATE complaints SET status = ? WHERE complaint_id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            
            preparedStatement.setString(1, newStatus);
            preparedStatement.setInt(2, complaintId);
            
            preparedStatement.executeUpdate();
        }
    }

    public List<Complaint> getAllComplaints() {
        return searchAndPaginateComplaints(null, "all", 1, Integer.MAX_VALUE);
    }
    
    public int getComplaintCount(String searchTerm, String filterBy) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT c.complaint_id) FROM complaints c " +
                                              "JOIN users u ON c.resident_id = u.user_id " +
                                              "LEFT JOIN tenants t ON u.user_id = t.tenant_user_id " +
                                              "LEFT JOIN apartments a ON t.apartment_id = a.apartment_id WHERE 1=1");
        
        appendAdminComplaintConditions(sql, searchTerm, filterBy);

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            setAdminComplaintParameters(preparedStatement, 1, searchTerm, filterBy);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Complaint> searchAndPaginateComplaints(String searchTerm, String filterBy, int currentPage, int pageSize) {
        List<Complaint> complaints = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT c.*, u.first_name, u.last_name, a.block_name, a.flat_number " +
                                              "FROM complaints c " +
                                              "JOIN users u ON c.resident_id = u.user_id " +
                                              "LEFT JOIN tenants t ON u.user_id = t.tenant_user_id " +
                                              "LEFT JOIN apartments a ON t.apartment_id = a.apartment_id WHERE 1=1");
        
        appendAdminComplaintConditions(sql, searchTerm, filterBy);
        sql.append(" ORDER BY c.created_at DESC LIMIT ? OFFSET ?");
        
        int offset = (currentPage - 1) * pageSize;

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            int paramIndex = setAdminComplaintParameters(preparedStatement, 1, searchTerm, filterBy);
            preparedStatement.setInt(paramIndex++, pageSize);
            preparedStatement.setInt(paramIndex, offset);

            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                complaints.add(mapResultSetToComplaint(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    private void appendAdminComplaintConditions(StringBuilder sql, String searchTerm, String filterBy) {
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (CONCAT(u.first_name, ' ', u.last_name) LIKE ? OR a.block_name LIKE ? OR a.flat_number LIKE ?)");
        }
        if (filterBy != null && !filterBy.equalsIgnoreCase("all")) {
            sql.append(" AND c.status = ?");
        }
    }

    private int setAdminComplaintParameters(PreparedStatement ps, int startIndex, String searchTerm, String filterBy) throws SQLException {
        int paramIndex = startIndex;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchPattern = "%" + searchTerm.trim() + "%";
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
        }
        if (filterBy != null && !filterBy.equalsIgnoreCase("all")) {
            ps.setString(paramIndex++, filterBy);
        }
        return paramIndex;
    }
    
    public List<Complaint> getComplaintsByOwner(int ownerId) {
        return searchAndPaginateOwnerComplaints(ownerId, null, "all", 1, Integer.MAX_VALUE);
    }

    public int getOwnerComplaintCount(int ownerId, String searchTerm, String filterBy) {
        int count = 0;
        StringBuilder SQL = new StringBuilder(
            "SELECT COUNT(DISTINCT c.complaint_id) FROM complaints c " +
            "JOIN users u ON c.resident_id = u.user_id " +
            "JOIN tenants t ON u.user_id = t.tenant_user_id " +
            "JOIN apartments a ON t.apartment_id = a.apartment_id " +
            "WHERE a.owner_id = ?"
        );

        appendOwnerComplaintConditions(SQL, searchTerm, filterBy);

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL.toString())) {
            
            int paramIndex = 1;
            preparedStatement.setInt(paramIndex++, ownerId);
            setOwnerComplaintParameters(preparedStatement, paramIndex, searchTerm, filterBy);

            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Complaint> searchAndPaginateOwnerComplaints(int ownerId, String searchTerm, String filterBy, int currentPage, int pageSize) {
        List<Complaint> complaints = new ArrayList<>();
        StringBuilder SQL = new StringBuilder(
            "SELECT c.*, u.first_name, u.last_name, a.block_name, a.flat_number " +
            "FROM complaints c " +
            "JOIN users u ON c.resident_id = u.user_id " +
            "JOIN tenants t ON u.user_id = t.tenant_user_id " +
            "JOIN apartments a ON t.apartment_id = a.apartment_id " +
            "WHERE a.owner_id = ?"
        );
        
        appendOwnerComplaintConditions(SQL, searchTerm, filterBy);
        SQL.append(" ORDER BY c.created_at DESC LIMIT ? OFFSET ?");
        
        int offset = (currentPage - 1) * pageSize;

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL.toString())) {
            
            int paramIndex = 1;
            preparedStatement.setInt(paramIndex++, ownerId);
            paramIndex = setOwnerComplaintParameters(preparedStatement, paramIndex, searchTerm, filterBy);

            preparedStatement.setInt(paramIndex++, pageSize);
            preparedStatement.setInt(paramIndex++, offset);
            
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                complaints.add(mapResultSetToComplaint(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    private void appendOwnerComplaintConditions(StringBuilder sql, String searchTerm, String filterBy) {
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (CONCAT(u.first_name, ' ', u.last_name) LIKE ? OR a.block_name LIKE ? OR a.flat_number LIKE ?)");
        }
        if (filterBy != null && !filterBy.equalsIgnoreCase("all")) {
            sql.append(" AND c.status = ?");
        }
    }

    private int setOwnerComplaintParameters(PreparedStatement ps, int startIndex, String searchTerm, String filterBy) throws SQLException {
        int paramIndex = startIndex;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchPattern = "%" + searchTerm.trim() + "%";
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
        }
        if (filterBy != null && !filterBy.equalsIgnoreCase("all")) {
            ps.setString(paramIndex++, filterBy);
        }
        return paramIndex;
    }

    public int getOpenComplaintCountForTenant(int tenantId) {
        int count = 0;
        String SQL = "SELECT COUNT(*) FROM complaints WHERE resident_id = ? AND status IN ('Open', 'In Progress')";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            preparedStatement.setInt(1, tenantId);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int getOpenComplaintCountForOwner(int ownerId) {
        int count = 0;
        String SQL = "SELECT COUNT(c.complaint_id) FROM complaints c " +
                     "JOIN tenants t ON c.resident_id = t.tenant_user_id " +
                     "JOIN apartments a ON t.apartment_id = a.apartment_id " +
                     "WHERE a.owner_id = ? AND c.status IN ('Open', 'In Progress')";
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

    public int getOpenComplaintCount() {
        int count = 0;
        String SQL = "SELECT COUNT(*) FROM complaints WHERE status IN ('Open', 'In Progress')";
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
    
    public Map<String, Integer> getComplaintCountByStatus() {
        Map<String, Integer> statusCounts = new HashMap<>();
        String sql = "SELECT status, COUNT(*) as count FROM complaints GROUP BY status";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                statusCounts.put(rs.getString("status"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return statusCounts;
    }
    
    private Complaint mapResultSetToComplaint(ResultSet rs) throws SQLException {
        Complaint complaint = new Complaint();
        complaint.setComplaintId(rs.getInt("complaint_id"));
        complaint.setResidentId(rs.getInt("resident_id"));
        complaint.setIssueType(rs.getString("issue_type"));
        complaint.setDescription(rs.getString("description"));
        complaint.setStatus(rs.getString("status"));
        complaint.setCreatedAt(rs.getTimestamp("created_at"));
        complaint.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        if (hasColumn(rs, "first_name")) {
            complaint.setResidentName(rs.getString("first_name") + " " + rs.getString("last_name"));
        }
        if (hasColumn(rs, "block_name")) {
             complaint.setBlockName(rs.getString("block_name"));
        }
        if (hasColumn(rs, "flat_number")) {
            complaint.setFlatNumber(rs.getString("flat_number"));
        }
        
        return complaint;
    }
    
    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }
}

