package com.apartment.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.apartment.dao.ComplaintDAO;
import com.apartment.dao.NotificationDAO;
import com.apartment.dao.UserDAO; // NEW: Import UserDAO
import com.apartment.model.Complaint;
import com.apartment.model.User; // NEW: Import User model
import com.apartment.util.EmailTemplateUtil; // NEW: Import EmailTemplateUtil
import com.apartment.util.EmailUtil; // NEW: Import EmailUtil

@WebServlet("/updateComplaintStatus")
public class UpdateComplaintStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ComplaintDAO complaintDAO;
    private NotificationDAO notificationDAO;
    private UserDAO userDAO; // NEW: Declare UserDAO

    public void init() {
        complaintDAO = new ComplaintDAO();
        notificationDAO = new NotificationDAO();
        userDAO = new UserDAO(); // NEW: Initialize UserDAO
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int complaintId = Integer.parseInt(request.getParameter("complaintId"));
            String newStatus = request.getParameter("newStatus");
            
            complaintDAO.updateComplaintStatus(complaintId, newStatus);
            
            Complaint complaint = complaintDAO.getComplaintById(complaintId);
            Map<String, Integer> ids = complaintDAO.getTenantAndOwnerIdsForComplaint(complaintId);
            Integer tenantId = ids.get("tenantId");
            Integer ownerId = ids.get("ownerId");
            
            String complaintIdentifier;
            if (complaint != null && complaint.getIssueType() != null) {
                complaintIdentifier = "your '" + complaint.getIssueType() + "' complaint";
            } else {
                complaintIdentifier = "complaint (ID: " + complaintId + ")";
            }
            
            // --- In-App Notification Logic ---
            if (tenantId != null) {
                String tenantMessage = "Admin updated the status of " + complaintIdentifier + " to '" + newStatus + "'.";
                notificationDAO.createNotification(tenantId, tenantMessage, "complaints");
            }
            if (ownerId != null) {
                String ownerMessage = "Status of a complaint for your property was updated to '" + newStatus + "'.";
                notificationDAO.createNotification(ownerId, ownerMessage, "owner-complaints");
            }
            
            // --- NEW: Email Notification Logic ---
            if (tenantId != null && complaint != null) {
                User tenant = userDAO.getUserById(tenantId);
                if (tenant != null) {
                    String subject = "Update on Your Complaint: '" + complaint.getIssueType() + "'";
                    String body = EmailTemplateUtil.getComplaintStatusUpdateBody(tenant.getFirstName(), complaint.getIssueType(), newStatus);
                    EmailUtil.sendEmail(tenant.getEmail(), subject, body);
                }
            }
            // --- Email Logic Ends ---
            
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
        }
        
        response.sendRedirect("complaints");
    }
}

