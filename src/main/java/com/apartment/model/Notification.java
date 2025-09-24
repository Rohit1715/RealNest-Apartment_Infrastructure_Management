package com.apartment.model;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import com.google.gson.annotations.Expose; // NEW: Import the Expose annotation

public class Notification {

    @Expose // NEW: Tell Gson to include this field in JSON serialization
    private int notificationId;
    @Expose // NEW
    private int userId;
    @Expose // NEW
    private String message;
    @Expose // NEW
    private String link;
    @Expose // NEW
    private boolean isRead;
    @Expose // NEW
    private Timestamp createdAt;

    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getTimeAgo() {
        if (createdAt == null) {
            return "Just now";
        }

        Instant now = Instant.now();
        Instant then = createdAt.toInstant();
        
        if (then.isAfter(now)) {
            return "Just now";
        }

        Duration duration = Duration.between(then, now);
        long seconds = duration.getSeconds();

        if (seconds < 5) {
            return "Just now";
        }
        if (seconds < 60) {
            return seconds + " seconds ago";
        }
        if (seconds < 3600) {
            long minutes = seconds / 60;
            return minutes + (minutes == 1 ? " minute ago" : " minutes ago");
        }
        if (seconds < 86400) {
            long hours = seconds / 3600;
            return hours + (hours == 1 ? " hour ago" : " hours ago");
        }
        
        LocalDate today = LocalDate.now(ZoneId.systemDefault());
        LocalDate notificationDate = then.atZone(ZoneId.systemDefault()).toLocalDate();
        
        if (notificationDate.isEqual(today.minusDays(1))) {
             return "Yesterday";
        }
        
        LocalDateTime localDateTime = then.atZone(ZoneId.systemDefault()).toLocalDateTime();
        return localDateTime.format(DateTimeFormatter.ofPattern("MMM dd 'at' hh:mm a"));
    }
}

