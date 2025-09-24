package com.apartment.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.apartment.model.VisitorLog;
import com.apartment.util.DatabaseUtil;

public class VisitorLogDAO {

    // Method to add a new visitor entry
    public void addVisitor(VisitorLog visitor) throws SQLException {
        String SQL = "INSERT INTO visitor_logs (visitor_name, visitor_phone, purpose, apartment_id_to_visit, security_guard_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            
            preparedStatement.setString(1, visitor.getVisitorName());
            preparedStatement.setString(2, visitor.getVisitorPhone());
            preparedStatement.setString(3, visitor.getPurpose());
            preparedStatement.setInt(4, visitor.getApartmentIdToVisit());
            preparedStatement.setInt(5, visitor.getSecurityGuardId());
            
            preparedStatement.executeUpdate();
        }
    }

    // Method to get a list of all visitors (for the log)
    public List<VisitorLog> getAllVisitors() {
        List<VisitorLog> visitors = new ArrayList<>();
        // This query joins visitor_logs with apartments to get the flat number
        String SQL = "SELECT v.*, a.block_name, a.flat_number FROM visitor_logs v " +
                     "JOIN apartments a ON v.apartment_id_to_visit = a.apartment_id " +
                     "ORDER BY v.entry_time DESC";
        
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                VisitorLog visitor = new VisitorLog();
                visitor.setVisitorLogId(rs.getInt("visitor_log_id"));
                visitor.setVisitorName(rs.getString("visitor_name"));
                visitor.setVisitorPhone(rs.getString("visitor_phone"));
                visitor.setPurpose(rs.getString("purpose"));
                visitor.setEntryTime(rs.getTimestamp("entry_time"));
                visitor.setExitTime(rs.getTimestamp("exit_time"));
                visitor.setBlockName(rs.getString("block_name"));
                visitor.setFlatNumber(rs.getString("flat_number"));
                
                visitors.add(visitor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return visitors;
    }

    // Method to update a visitor's exit time
    public void markVisitorExit(int visitorLogId) throws SQLException {
        String SQL = "UPDATE visitor_logs SET exit_time = ? WHERE visitor_log_id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            
            preparedStatement.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            preparedStatement.setInt(2, visitorLogId);
            
            preparedStatement.executeUpdate();
        }
    }
}
