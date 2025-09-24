package com.apartment.model;

import java.sql.Date;

public class Tenant {
    private int tenantUserId;
    private int apartmentId;
    private Date moveInDate;
    private Date moveOutDate;
    private String rentalAgreementUrl;
    private double monthlyRent;

    // Getters and Setters
    public int getTenantUserId() { return tenantUserId; }
    public void setTenantUserId(int tenantUserId) { this.tenantUserId = tenantUserId; }
    public int getApartmentId() { return apartmentId; }
    public void setApartmentId(int apartmentId) { this.apartmentId = apartmentId; }
    public Date getMoveInDate() { return moveInDate; }
    public void setMoveInDate(Date moveInDate) { this.moveInDate = moveInDate; }
    public Date getMoveOutDate() { return moveOutDate; }
    public void setMoveOutDate(Date moveOutDate) { this.moveOutDate = moveOutDate; }
    public String getRentalAgreementUrl() { return rentalAgreementUrl; }
    public void setRentalAgreementUrl(String rentalAgreementUrl) { this.rentalAgreementUrl = rentalAgreementUrl; }
    public double getMonthlyRent() { return monthlyRent; }
    public void setMonthlyRent(double monthlyRent) { this.monthlyRent = monthlyRent; }
}
