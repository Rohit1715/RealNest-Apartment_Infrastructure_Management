package com.apartment.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.apartment.model.Notification;
import com.apartment.util.DatabaseUtil;

public class NotificationDAO {

    // Method to create a single notification
    public void createNotification(int userId, String message, String link) {
        String SQL = "INSERT INTO notifications (user_id, message, link) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.setString(3, link);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Method to create notifications for a list of users (for broadcasting)
    public void createNotificationsForMultipleUsers(List<Integer> userIds, String message, String link) {
        String SQL = "INSERT INTO notifications (user_id, message, link) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            
            for (Integer userId : userIds) {
                ps.setInt(1, userId);
                ps.setString(2, message);
                ps.setString(3, link);
                ps.addBatch();
            }
            ps.executeBatch();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all notifications for a specific user, newest first
    public List<Notification> getNotificationsForUser(int userId) {
        List<Notification> notifications = new ArrayList<>();
        String SQL = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                notifications.add(mapRowToNotification(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    // NEW: This method now gets the 5 most RECENT notifications, regardless of read status
    public List<Notification> getRecentNotifications(int userId, int limit) {
        List<Notification> notifications = new ArrayList<>();
        // REMOVED "AND is_read = FALSE" to always show the latest notifications
        String SQL = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                notifications.add(mapRowToNotification(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    // Get the count of unread notifications for the bell icon
    public int getUnreadNotificationCount(int userId) {
        int count = 0;
        String SQL = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // Mark a specific notification as read
    public void markAsRead(int notificationId, int userId) {
        String SQL = "UPDATE notifications SET is_read = TRUE WHERE notification_id = ? AND user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Mark all notifications for a user as read
    public void markAllAsRead(int userId) {
        // We only mark unread notifications as read to be more efficient
        String SQL = "UPDATE notifications SET is_read = TRUE WHERE user_id = ? AND is_read = FALSE";
         try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Notification mapRowToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setNotificationId(rs.getInt("notification_id"));
        notification.setUserId(rs.getInt("user_id"));
        notification.setMessage(rs.getString("message"));
        notification.setLink(rs.getString("link"));
        notification.setRead(rs.getBoolean("is_read"));
        notification.setCreatedAt(rs.getTimestamp("created_at"));
        return notification;
    }
}

