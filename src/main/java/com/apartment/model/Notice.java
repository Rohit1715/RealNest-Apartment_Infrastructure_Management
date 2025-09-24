package com.apartment.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Notice {

    private int noticeId;
    private String title;
    private String description;
    private int createdBy;
    private Timestamp createdAt;
    private Date validTill;
    
    // For display purposes
    private String createdByName;

    // Getters and Setters
    public int getNoticeId() { return noticeId; }
    public void setNoticeId(int noticeId) { this.noticeId = noticeId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Date getValidTill() { return validTill; }
    public void setValidTill(Date validTill) { this.validTill = validTill; }
    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }
}
