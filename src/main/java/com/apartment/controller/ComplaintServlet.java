package com.apartment.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.ComplaintDAO;
import com.apartment.dao.NotificationDAO;
import com.apartment.dao.UserDAO;
import com.apartment.model.Complaint;
import com.apartment.model.User;
// NEW: Import the email utility classes
import com.apartment.util.EmailTemplateUtil;
import com.apartment.util.EmailUtil;

@WebServlet("/complaints")
public class ComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ComplaintDAO complaintDAO;
    private NotificationDAO notificationDAO;
    private UserDAO userDAO;

    public void init() {
        complaintDAO = new ComplaintDAO();
        notificationDAO = new NotificationDAO();
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String issueType = request.getParameter("issueType");
        String description = request.getParameter("description");

        Complaint newComplaint = new Complaint();
        newComplaint.setResidentId(user.getUserId());
        newComplaint.setIssueType(issueType);
        newComplaint.setDescription(description);

        try {
            int newComplaintId = complaintDAO.addComplaint(newComplaint);
            
            if (newComplaintId > 0) {
                 // --- In-App Notification Logic ---
                 Map<String, Integer> ids = complaintDAO.getTenantAndOwnerIdsForComplaint(newComplaintId);
                 Integer ownerId = ids.get("ownerId");
                 if (ownerId != null) {
                     String ownerMessage = "New complaint '" + issueType + "' filed for your property.";
                     notificationDAO.createNotification(ownerId, ownerMessage, "owner-complaints");
                 }
                 
                 List<Integer> adminIds = userDAO.getAdminUserIds();
                 if (adminIds != null && !adminIds.isEmpty()) {
                     String adminMessage = "New complaint '" + issueType + "' filed by " + user.getFirstName() + ".";
                     notificationDAO.createNotificationsForMultipleUsers(adminIds, adminMessage, "complaints");
                 }
                 
                 // --- Email Notification Logic ---
                 Map<String, String> emailDetails = complaintDAO.getComplaintEmailDetails(newComplaintId);
                 String tenantName = emailDetails.get("tenantName");
                 String apartmentInfo = emailDetails.get("apartmentInfo");
                 String ownerEmail = emailDetails.get("ownerEmail");
                 
                 if (tenantName != null && apartmentInfo != null) { 
                     String subject = "New Complaint Alert: " + issueType + " for " + apartmentInfo;
                     String body = EmailTemplateUtil.getNewComplaintAlertBody(tenantName, issueType, description, apartmentInfo);
                     
                     if (ownerEmail != null && !ownerEmail.isEmpty()) {
                         EmailUtil.sendEmail(ownerEmail, subject, body);
                     }
                     
                     List<String> adminEmails = userDAO.getAdminEmails();
                     for (String adminEmail : adminEmails) {
                         EmailUtil.sendEmail(adminEmail, subject, body);
                     }
                 }
            }
            
            // The redirect now includes a status parameter
            response.sendRedirect("complaints?status=success");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("complaints?status=error");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = user.getRole();

        // Prepare data for the header on every GET request
        request.setAttribute("unreadCount", notificationDAO.getUnreadNotificationCount(user.getUserId()));

        if ("ADMIN".equals(role)) {
            request.setAttribute("pageName", "complaints");
            String searchTerm = request.getParameter("search");
            String filterBy = request.getParameter("filter");
            String pageStr = request.getParameter("page");

            if (filterBy == null || filterBy.isEmpty()) {
                filterBy = "all";
            }

            int currentPage = 1;
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int pageSize = 10;

            List<Complaint> complaintList = complaintDAO.searchAndPaginateComplaints(searchTerm, filterBy, currentPage, pageSize);
            int totalComplaints = complaintDAO.getComplaintCount(searchTerm, filterBy);
            int totalPages = (int) Math.ceil((double) totalComplaints / pageSize);

            request.setAttribute("complaintList", complaintList);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("search", searchTerm);
            request.setAttribute("filter", filterBy);

            request.getRequestDispatcher("manage-complaints.jsp").forward(request, response);
        } else {
            // This logic is for Tenants
            request.setAttribute("pageName", "complaints");

            // NEW: Check for status from the redirect and set the appropriate message
            String status = request.getParameter("status");
            if ("success".equals(status)) {
                request.setAttribute("successMessage", "Complaint submitted successfully!");
            } else if ("error".equals(status)) {
                request.setAttribute("errorMessage", "There was an error submitting your complaint. Please try again.");
            }
            
            request.getRequestDispatcher("file-complaint.jsp").forward(request, response);
        }
    }
}

