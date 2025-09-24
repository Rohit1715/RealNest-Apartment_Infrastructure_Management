package com.apartment.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Random;

import com.apartment.util.DatabaseUtil;

public class OtpDAO {

    private static final int OTP_EXPIRATION_MINUTES = 10;

    /**
     * Generates a random 6-digit OTP, saves it to the database for a specific user,
     * and returns the OTP.
     * @param userId The ID of the user for whom the OTP is generated.
     * @return The 6-digit OTP string, or null if there was a database error.
     */
    public String generateAndSaveOtp(int userId) {
        Random random = new Random();
        int otpNumber = 100000 + random.nextInt(900000);
        String otpCode = String.valueOf(otpNumber);

        Instant now = Instant.now();
        Timestamp expiresAt = Timestamp.from(now.plus(OTP_EXPIRATION_MINUTES, ChronoUnit.MINUTES));

        String SQL = "INSERT INTO user_otps (user_id, otp_code, expires_at) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            
            ps.setInt(1, userId);
            ps.setString(2, otpCode);
            ps.setTimestamp(3, expiresAt);
            ps.executeUpdate();
            
            return otpCode;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Verifies the provided OTP for a user. It checks if the OTP is correct,
     * not expired (using the application's clock), and has not been used before.
     * If verification is successful, it marks the OTP as used.
     * @param userId The user's ID.
     * @param otpCode The OTP code entered by the user.
     * @return true if the OTP is valid, false otherwise.
     */
    public boolean verifyOtp(int userId, String otpCode) {
        // NEW: The query now takes the current time from Java to avoid timezone issues.
        String SELECT_SQL = "SELECT otp_id FROM user_otps " +
                            "WHERE user_id = ? AND otp_code = ? AND expires_at > ? AND is_used = FALSE " +
                            "ORDER BY created_at DESC LIMIT 1";
        
        String UPDATE_SQL = "UPDATE user_otps SET is_used = TRUE WHERE otp_id = ?";

        try (Connection conn = DatabaseUtil.getConnection()) {
            try (PreparedStatement selectPs = conn.prepareStatement(SELECT_SQL)) {
                selectPs.setInt(1, userId);
                selectPs.setString(2, otpCode);
                // NEW: Pass the current timestamp from the application.
                selectPs.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                
                ResultSet rs = selectPs.executeQuery();

                if (rs.next()) {
                    int otpId = rs.getInt("otp_id");
                    
                    try (PreparedStatement updatePs = conn.prepareStatement(UPDATE_SQL)) {
                        updatePs.setInt(1, otpId);
                        updatePs.executeUpdate();
                    }
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

