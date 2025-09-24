package com.apartment.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.PaymentDAO;
import com.apartment.dao.TenantDAO; // NEW: Import TenantDAO
import com.apartment.model.Payment;
import com.apartment.model.Tenant;    // NEW: Import Tenant model
import com.apartment.model.User;
import com.apartment.util.EmailTemplateUtil;
import com.apartment.util.EmailUtil;

@WebServlet("/payments")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO;
    private TenantDAO tenantDAO; // NEW: Declare TenantDAO

    public void init() {
        paymentDAO = new PaymentDAO();
        tenantDAO = new TenantDAO(); // NEW: Initialize TenantDAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"TENANT".equals(user.getRole())) {
            // Redirect non-tenants to their respective dashboard
            response.sendRedirect("dashboard");
            return;
        }

        try {
            List<Payment> paymentHistory = paymentDAO.getPaymentHistory(user.getUserId());
            double outstandingBalance = paymentDAO.getTenantOutstandingBalance(user.getUserId());
            double lastPaymentAmount = 0.0;

            if (!paymentHistory.isEmpty()) {
                // To avoid errors if the first payment was for a now-vacated apartment
                Payment latestPayment = paymentHistory.get(0);
                if (latestPayment != null) {
                    lastPaymentAmount = latestPayment.getAmount();
                }
            }

            Calendar c = Calendar.getInstance();
            c.add(Calendar.MONTH, 1);
            c.set(Calendar.DAY_OF_MONTH, 1);
            String nextDueDate = new SimpleDateFormat("MMMM d, yyyy").format(c.getTime());

            request.setAttribute("paymentHistory", paymentHistory);
            request.setAttribute("outstandingBalance", outstandingBalance);
            request.setAttribute("lastPaymentAmount", lastPaymentAmount);
            request.setAttribute("nextDueDate", nextDueDate);
            
            request.getRequestDispatcher("my-payments.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Could not load payment information.");
            request.setAttribute("paymentHistory", Collections.emptyList());
            request.getRequestDispatcher("my-payments.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // NEW: Get the tenant's current apartment ID
            Tenant currentTenancy = tenantDAO.getCurrentTenantDetails(user.getUserId());
            if (currentTenancy == null) {
                // This is a safeguard. A tenant making a payment must be in an apartment.
                response.sendRedirect("payments?error=not_assigned");
                return;
            }
            int apartmentId = currentTenancy.getApartmentId();

            double amount = Double.parseDouble(request.getParameter("amount"));
            String paymentMethod = request.getParameter("paymentMethod");

            Payment newPayment = new Payment();
            newPayment.setUserId(user.getUserId());
            newPayment.setApartmentId(apartmentId); // NEW: Set the apartment ID on the payment
            newPayment.setAmount(amount);
            newPayment.setPaymentType(paymentMethod);
            newPayment.setStatus("Paid");

            int newPaymentId = paymentDAO.addPayment(newPayment);

            // Email logic remains the same but will now work correctly
            if (newPaymentId > 0) {
                Map<String, Object> receiptData = paymentDAO.getPaymentDetailsForReceipt(newPaymentId);
                
                if (receiptData != null && !receiptData.isEmpty()) {
                    Timestamp paymentTimestamp = (Timestamp) receiptData.get("paymentDate");
                    String formattedDate = new SimpleDateFormat("MMMM d, yyyy 'at' h:mm a").format(paymentTimestamp);

                    String tenantEmail = (String) receiptData.get("tenantEmail");
                    String tenantName = (String) receiptData.get("tenantName");
                    double paidAmount = (double) receiptData.get("amount");
                    String transactionId = (String) receiptData.get("transactionId");
                    String apartmentDetails = (String) receiptData.get("apartmentDetails");
                    String paidWithMethod = (String) receiptData.get("paymentMethod");
                    
                    String tenantSubject = "Your Payment Receipt from RealNest";
                    String tenantBody = EmailTemplateUtil.getPaymentReceiptBody(tenantName, paidAmount, formattedDate, transactionId, apartmentDetails, paidWithMethod);
                    EmailUtil.sendEmail(tenantEmail, tenantSubject, tenantBody);
                    
                    String ownerEmail = (String) receiptData.get("ownerEmail");
                    String ownerName = (String) receiptData.get("ownerName");
                    
                    if (ownerEmail != null && !ownerEmail.isEmpty()) {
                        String ownerSubject = "Payment Received for Your Property: " + apartmentDetails;
                        String ownerBody = EmailTemplateUtil.getOwnerPaymentNotificationBody(ownerName, tenantName, paidAmount, apartmentDetails, formattedDate);
                        EmailUtil.sendEmail(ownerEmail, ownerSubject, ownerBody);
                    }
                }
            }

            response.sendRedirect("payments?status=success");

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("make-payment?error=true");
        }
    }
}

