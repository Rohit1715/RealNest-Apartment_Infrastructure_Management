package com.apartment.model;

import java.sql.Timestamp;

public class VisitorLog {

    private int visitorLogId;
    private String visitorName;
    private String visitorPhone;
    private String purpose;
    private int apartmentIdToVisit;
    private Timestamp entryTime;
    private Timestamp exitTime;
    private int securityGuardId;

    // Additional fields for display purposes
    private String blockName;
    private String flatNumber;

    // Getters and Setters
    public int getVisitorLogId() { return visitorLogId; }
    public void setVisitorLogId(int visitorLogId) { this.visitorLogId = visitorLogId; }
    public String getVisitorName() { return visitorName; }
    public void setVisitorName(String visitorName) { this.visitorName = visitorName; }
    public String getVisitorPhone() { return visitorPhone; }
    public void setVisitorPhone(String visitorPhone) { this.visitorPhone = visitorPhone; }
    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }
    public int getApartmentIdToVisit() { return apartmentIdToVisit; }
    public void setApartmentIdToVisit(int apartmentIdToVisit) { this.apartmentIdToVisit = apartmentIdToVisit; }
    public Timestamp getEntryTime() { return entryTime; }
    public void setEntryTime(Timestamp entryTime) { this.entryTime = entryTime; }
    public Timestamp getExitTime() { return exitTime; }
    public void setExitTime(Timestamp exitTime) { this.exitTime = exitTime; }
    public int getSecurityGuardId() { return securityGuardId; }
    public void setSecurityGuardId(int securityGuardId) { this.securityGuardId = securityGuardId; }
    public String getBlockName() { return blockName; }
    public void setBlockName(String blockName) { this.blockName = blockName; }
    public String getFlatNumber() { return flatNumber; }
    public void setFlatNumber(String flatNumber) { this.flatNumber = flatNumber; }
}
