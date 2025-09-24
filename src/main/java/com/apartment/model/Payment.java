package com.apartment.model;

import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private int userId;
    private int apartmentId; // NEW: Added to link payment to a specific apartment
    private double amount;
    private String paymentType;
    private String status;
    private Timestamp paymentDate; // NEW: Changed to Timestamp for time accuracy
    private String transactionId;
    
    // Additional fields for displaying in owner's view
    private String tenantName;
    private String apartmentDetails;

    // Getters and Setters for all fields
    
    public int getPaymentId() {
        return paymentId;
    }
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    // NEW: Getter and setter for apartmentId
    public int getApartmentId() {
        return apartmentId;
    }
    public void setApartmentId(int apartmentId) {
        this.apartmentId = apartmentId;
    }
    
    public double getAmount() {
        return amount;
    }
    public void setAmount(double amount) {
        this.amount = amount;
    }
    public String getPaymentType() {
        return paymentType;
    }
    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    
    // NEW: Getter and setter now use Timestamp
    public Timestamp getPaymentDate() {
        return paymentDate;
    }
    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }
    
    public String getTransactionId() {
        return transactionId;
    }
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    
    // Getters and Setters for the new fields
    
    public String getTenantName() {
        return tenantName;
    }
    public void setTenantName(String tenantName) {
        this.tenantName = tenantName;
    }
    public String getApartmentDetails() {
        return apartmentDetails;
    }
    public void setApartmentDetails(String apartmentDetails) {
        this.apartmentDetails = apartmentDetails;
    }
}

