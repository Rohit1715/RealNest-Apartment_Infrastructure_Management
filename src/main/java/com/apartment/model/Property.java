package com.apartment.model;

public class Property {
    private String block;
    private String flatNumber;
    private String type;
    private String status;
    private String tenantName;
    private String tenantContact;
    private double monthlyRent;

    // Getters and Setters
    public String getBlock() {
        return block;
    }
    public void setBlock(String block) {
        this.block = block;
    }
    public String getFlatNumber() {
        return flatNumber;
    }
    public void setFlatNumber(String flatNumber) {
        this.flatNumber = flatNumber;
    }
    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public String getTenantName() {
        return tenantName;
    }
    public void setTenantName(String tenantName) {
        this.tenantName = tenantName;
    }
    public String getTenantContact() {
        return tenantContact;
    }
    public void setTenantContact(String tenantContact) {
        this.tenantContact = tenantContact;
    }
    public double getMonthlyRent() {
        return monthlyRent;
    }
    public void setMonthlyRent(double monthlyRent) {
        this.monthlyRent = monthlyRent;
    }
}

