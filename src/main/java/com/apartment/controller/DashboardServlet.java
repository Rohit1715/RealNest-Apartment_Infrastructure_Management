package com.apartment.controller;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.ApartmentDAO;
import com.apartment.dao.ComplaintDAO;
import com.apartment.dao.NoticeDAO;
import com.apartment.dao.NotificationDAO;
import com.apartment.dao.PaymentDAO;
import com.apartment.dao.UserDAO;
import com.apartment.model.User;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO;
    private ComplaintDAO complaintDAO;
    private NoticeDAO noticeDAO;
    private ApartmentDAO apartmentDAO;
    private UserDAO userDAO;
    private NotificationDAO notificationDAO;

    public void init() {
        paymentDAO = new PaymentDAO();
        complaintDAO = new ComplaintDAO();
        noticeDAO = new NoticeDAO();
        apartmentDAO = new ApartmentDAO();
        userDAO = new UserDAO();
        notificationDAO = new NotificationDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = user.getRole();

        // Prepare data for the header view
        request.setAttribute("unreadCount", notificationDAO.getUnreadNotificationCount(user.getUserId()));
        request.setAttribute("pageName", "dashboard");

        try {
            // --- FINAL FIX: Add .trim() to the role check for robustness ---
            if ("TENANT".equals(role.trim())) {
                session.setAttribute("rentDues", paymentDAO.getTenantOutstandingBalance(user.getUserId()));
                session.setAttribute("openComplaints", complaintDAO.getOpenComplaintCountForTenant(user.getUserId()));
                session.setAttribute("recentNotices", noticeDAO.getRecentNoticeCount());

            } else if ("OWNER".equals(role.trim())) {
                session.setAttribute("totalTenants", userDAO.getTotalTenantsByOwner(user.getUserId()));
                session.setAttribute("unpaidRents", paymentDAO.getUnpaidRentCountForOwner(user.getUserId()));
                session.setAttribute("openComplaints", complaintDAO.getOpenComplaintCountForOwner(user.getUserId()));

            } else if ("ADMIN".equals(role.trim())) {
                session.setAttribute("totalProperties", apartmentDAO.getTotalApartmentCount());
                session.setAttribute("pendingComplaints", complaintDAO.getOpenComplaintCount());
                session.setAttribute("monthlyRevenue", paymentDAO.getTotalRevenueThisMonth());
                
                Map<String, Double> revenueData = paymentDAO.getMonthlyRevenueLast6Months();
                session.setAttribute("revenueChartLabels", toJson(revenueData.keySet()));
                session.setAttribute("revenueChartData", toJson(revenueData.values()));

                Map<String, Integer> complaintStatusData = complaintDAO.getComplaintCountByStatus();
                session.setAttribute("complaintChartLabels", toJson(complaintStatusData.keySet()));
                session.setAttribute("complaintChartData", toJson(complaintStatusData.values()));
                
                request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
                return; // Exit after forwarding for admin
                
            } else if ("SECURITY".equals(role.trim())) {
                // The security dashboard is the visitor log page.
                request.getRequestDispatcher("visitor-log.jsp").forward(request, response);
                return; // Exit after forwarding for security
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Could not load dashboard data.");
        }
        
        // Forward to the general dashboard for Tenant and Owner
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
    
    private String toJson(java.util.Collection<?> data) {
        StringBuilder json = new StringBuilder("[");
        boolean first = true;
        for (Object item : data) {
            if (!first) {
                json.append(",");
            }
            if (item instanceof String) {
                json.append("\"").append(item.toString().replace("\"", "\\\"")).append("\"");
            } else {
                json.append(item);
            }
            first = false;
        }
        json.append("]");
        return json.toString();
    }
}

