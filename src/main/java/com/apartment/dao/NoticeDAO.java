package com.apartment.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.apartment.model.Notice;
import com.apartment.util.DatabaseUtil;

public class NoticeDAO {

    public void addNotice(Notice notice) throws SQLException {
        String SQL = "INSERT INTO notices (title, description, created_by, valid_till) VALUES (?, ?, ?, ?)";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            
            preparedStatement.setString(1, notice.getTitle());
            preparedStatement.setString(2, notice.getDescription());
            preparedStatement.setInt(3, notice.getCreatedBy());
            preparedStatement.setDate(4, notice.getValidTill());
            
            preparedStatement.executeUpdate();
        }
    }

    public List<Notice> getAllNotices() {
        List<Notice> notices = new ArrayList<>();
        String SQL = "SELECT n.*, u.first_name, u.last_name FROM notices n " +
                     "JOIN users u ON n.created_by = u.user_id " +
                     "ORDER BY n.created_at DESC";
        
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                Notice notice = new Notice();
                notice.setNoticeId(rs.getInt("notice_id"));
                notice.setTitle(rs.getString("title"));
                notice.setDescription(rs.getString("description"));
                notice.setCreatedAt(rs.getTimestamp("created_at"));
                notice.setValidTill(rs.getDate("valid_till"));
                notice.setCreatedByName(rs.getString("first_name") + " " + rs.getString("last_name"));
                
                notices.add(notice);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notices;
    }

    public void deleteNotice(int noticeId) throws SQLException {
        String SQL = "DELETE FROM notices WHERE notice_id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            
            preparedStatement.setInt(1, noticeId);
            preparedStatement.executeUpdate();
        }
    }
    
    // This is the single, correct version of the method required for the dashboard
    public int getRecentNoticeCount() {
        int count = 0;
        String SQL = "SELECT COUNT(*) FROM notices WHERE valid_till >= CURDATE()";
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
}

