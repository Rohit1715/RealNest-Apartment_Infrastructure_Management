package com.apartment.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.apartment.model.Payment;
import com.apartment.model.Tenant;
import com.apartment.util.DatabaseUtil;

public class PaymentDAO {

    // --- Methods for Tenant's Payment Actions ---

    // NEW: SQL query updated to include apartment_id
    public int addPayment(Payment payment) throws SQLException {
        String SQL = "INSERT INTO payments (user_id, apartment_id, amount, payment_type, status, transaction_id, payment_date) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        int generatedPaymentId = 0;
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {
            
            preparedStatement.setInt(1, payment.getUserId());
            preparedStatement.setInt(2, payment.getApartmentId()); // NEW: Set the apartment ID
            preparedStatement.setDouble(3, payment.getAmount());
            preparedStatement.setString(4, payment.getPaymentType());
            preparedStatement.setString(5, payment.getStatus());
            preparedStatement.setString(6, UUID.randomUUID().toString().substring(0, 13).toUpperCase());
            
            int affectedRows = preparedStatement.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = preparedStatement.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedPaymentId = rs.getInt(1);
                    }
                }
            }
        }
        return generatedPaymentId;
    }

    public List<Payment> getPaymentHistory(int userId) {
        List<Payment> paymentHistory = new ArrayList<>();
        // NEW: Join with apartments to show which apartment the payment was for
        String SQL = "SELECT p.*, a.block_name, a.flat_number FROM payments p " +
                     "LEFT JOIN apartments a ON p.apartment_id = a.apartment_id " +
                     "WHERE p.user_id = ? ORDER BY p.payment_date DESC";
        
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            
            preparedStatement.setInt(1, userId);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setUserId(rs.getInt("user_id"));
                payment.setApartmentId(rs.getInt("apartment_id"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentType(rs.getString("payment_type"));
                payment.setStatus(rs.getString("status"));
                payment.setPaymentDate(rs.getTimestamp("payment_date"));
                payment.setTransactionId(rs.getString("transaction_id"));
                // NEW: Set apartment details for display in the history
                payment.setApartmentDetails(rs.getString("block_name") + " - " + rs.getString("flat_number"));
                paymentHistory.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return paymentHistory;
    }
    
    // NEW: Logic completely rewritten to be tenancy-aware
    public double getTenantOutstandingBalance(int userId) {
        TenantDAO tenantDAO = new TenantDAO();
        Tenant currentTenancy = tenantDAO.getCurrentTenantDetails(userId);

        // If the user is not currently a tenant in any apartment, they have no balance.
        if (currentTenancy == null) {
            return 0.0;
        }

        double monthlyRent = currentTenancy.getMonthlyRent();
        int currentApartmentId = currentTenancy.getApartmentId();
        boolean hasPaidThisMonth = false;

        // NEW: This query now checks for a payment for the specific, current apartment
        String PAYMENT_SQL = "SELECT COUNT(*) FROM payments WHERE user_id = ? AND apartment_id = ? AND status = 'Paid' AND MONTH(payment_date) = MONTH(CURRENT_DATE()) AND YEAR(payment_date) = YEAR(CURRENT_DATE())";
         try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement paymentStatement = connection.prepareStatement(PAYMENT_SQL)) {
            paymentStatement.setInt(1, userId);
            paymentStatement.setInt(2, currentApartmentId);
            ResultSet rs = paymentStatement.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                hasPaidThisMonth = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return hasPaidThisMonth ? 0.0 : monthlyRent;
    }
    
    // --- Methods for Owner Panel (No changes needed here, but kept for completeness) ---

    public List<Payment> searchAndPaginateOwnerPayments(int ownerId, String searchTerm, String filterBy, int currentPage, int pageSize) {
        List<Payment> paymentList = new ArrayList<>();
        StringBuilder SQL = new StringBuilder(
            "SELECT p.*, u.first_name, u.last_name, a.block_name, a.flat_number " +
            "FROM payments p " +
            "JOIN users u ON p.user_id = u.user_id " +
            "JOIN tenants t ON u.user_id = t.tenant_user_id " +
            "JOIN apartments a ON t.apartment_id = a.apartment_id " +
            "WHERE a.owner_id = ?"
        );
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            SQL.append(" AND (u.first_name LIKE ? OR u.last_name LIKE ?)");
        }
        if (filterBy != null && !"all".equalsIgnoreCase(filterBy)) {
            SQL.append(" AND p.status = ?");
        }
        
        SQL.append(" ORDER BY p.payment_date DESC LIMIT ? OFFSET ?");
        
        int offset = (currentPage - 1) * pageSize;

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL.toString())) {
            
            int paramIndex = 1;
            preparedStatement.setInt(paramIndex++, ownerId);

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchPattern = "%" + searchTerm.trim() + "%";
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
            }
             if (filterBy != null && !"all".equalsIgnoreCase(filterBy)) {
                preparedStatement.setString(paramIndex++, filterBy);
            }

            preparedStatement.setInt(paramIndex++, pageSize);
            preparedStatement.setInt(paramIndex++, offset);
            
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentType(rs.getString("payment_type"));
                payment.setStatus(rs.getString("status"));
                payment.setPaymentDate(rs.getTimestamp("payment_date"));
                payment.setTransactionId(rs.getString("transaction_id"));
                payment.setTenantName(rs.getString("first_name") + " " + rs.getString("last_name"));
                payment.setApartmentDetails(rs.getString("block_name") + " - " + rs.getString("flat_number"));
                paymentList.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return paymentList;
    }

    public int getOwnerPaymentCount(int ownerId, String searchTerm, String filterBy) {
        int count = 0;
        StringBuilder SQL = new StringBuilder(
            "SELECT COUNT(*) FROM payments p " +
            "JOIN users u ON p.user_id = u.user_id " +
            "JOIN tenants t ON u.user_id = t.tenant_user_id " +
            "JOIN apartments a ON t.apartment_id = a.apartment_id " +
            "WHERE a.owner_id = ?"
        );

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            SQL.append(" AND (u.first_name LIKE ? OR u.last_name LIKE ?)");
        }
        if (filterBy != null && !"all".equalsIgnoreCase(filterBy)) {
            SQL.append(" AND p.status = ?");
        }

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL.toString())) {
            
            int paramIndex = 1;
            preparedStatement.setInt(paramIndex++, ownerId);

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchPattern = "%" + searchTerm.trim() + "%";
                preparedStatement.setString(paramIndex++, searchPattern);
                preparedStatement.setString(paramIndex++, searchPattern);
            }
            if (filterBy != null && !"all".equalsIgnoreCase(filterBy)) {
                preparedStatement.setString(paramIndex++, filterBy);
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
    
    public int getUnpaidRentCountForOwner(int ownerId) {
        int count = 0;
        // NEW: This logic is now tenancy-aware
        String SQL = "SELECT COUNT(DISTINCT t.tenant_user_id) FROM tenants t " +
                     "JOIN apartments a ON t.apartment_id = a.apartment_id " +
                     "WHERE a.owner_id = ? AND NOT EXISTS (" +
                     "  SELECT 1 FROM payments p WHERE p.user_id = t.tenant_user_id AND p.apartment_id = t.apartment_id AND MONTH(p.payment_date) = MONTH(CURRENT_DATE()) AND YEAR(p.payment_date) = YEAR(CURRENT_DATE())" +
                     ")";
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

    public double getTotalRevenueThisMonth() {
        double total = 0.0;
        String SQL = "SELECT SUM(amount) FROM payments WHERE status = 'Paid' AND MONTH(payment_date) = MONTH(CURRENT_DATE()) AND YEAR(payment_date) = YEAR(CURRENT_DATE())";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                total = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }
    
    public Map<String, Double> getMonthlyRevenueLast6Months() {
        Map<String, Double> revenueData = new LinkedHashMap<>();
        YearMonth currentMonth = YearMonth.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM yyyy");

        for (int i = 5; i >= 0; i--) {
            revenueData.put(currentMonth.minusMonths(i).format(formatter), 0.0);
        }

        String sql = "SELECT DATE_FORMAT(payment_date, '%b %Y') as month_year, SUM(amount) as total " +
                     "FROM payments " +
                     "WHERE status = 'Paid' AND payment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
                     "GROUP BY DATE_FORMAT(payment_date, '%b %Y') " +
                     "ORDER BY MIN(payment_date)";
        
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                revenueData.put(rs.getString("month_year"), rs.getDouble("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenueData;
    }
    
    public Map<String, Object> getPaymentDetailsForReceipt(int paymentId) {
        Map<String, Object> details = new HashMap<>();
        String SQL = "SELECT p.amount, p.payment_date, p.transaction_id, p.payment_type, " +
                     "t_user.first_name as tenant_first_name, t_user.last_name as tenant_last_name, t_user.email as tenant_email, " +
                     "o_user.first_name as owner_first_name, o_user.last_name as owner_last_name, o_user.email as owner_email, " +
                     "a.block_name, a.flat_number " +
                     "FROM payments p " +
                     "JOIN users t_user ON p.user_id = t_user.user_id " +
                     "JOIN apartments a ON p.apartment_id = a.apartment_id " + // Join on the new column
                     "JOIN users o_user ON a.owner_id = o_user.user_id " +
                     "WHERE p.payment_id = ?";
        
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            preparedStatement.setInt(1, paymentId);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                details.put("tenantName", rs.getString("tenant_first_name") + " " + rs.getString("tenant_last_name"));
                details.put("tenantEmail", rs.getString("tenant_email"));
                details.put("ownerName", rs.getString("owner_first_name") + " " + rs.getString("owner_last_name"));
                details.put("ownerEmail", rs.getString("owner_email"));
                details.put("amount", rs.getDouble("amount"));
                details.put("paymentDate", rs.getTimestamp("payment_date"));
                details.put("transactionId", rs.getString("transaction_id"));
                details.put("apartmentDetails", rs.getString("block_name") + " - " + rs.getString("flat_number"));
                details.put("paymentMethod", rs.getString("payment_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }
}

