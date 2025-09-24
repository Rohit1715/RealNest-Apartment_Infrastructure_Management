package com.apartment.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.PaymentDAO;
import com.apartment.model.User;

@WebServlet("/make-payment")
public class MakePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO;

    public void init() {
        paymentDAO = new PaymentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"TENANT".equals(user.getRole())) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        try {
            // Fetch the tenant's rent details to show the amount due
            double outstandingBalance = paymentDAO.getTenantOutstandingBalance(user.getUserId());
            request.setAttribute("outstandingBalance", outstandingBalance);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("outstandingBalance", 0.0); // Default on error
        }

        request.getRequestDispatcher("make-payment.jsp").forward(request, response);
    }
}

