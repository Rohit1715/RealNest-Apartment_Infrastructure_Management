package com.apartment.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.OtpDAO;
import com.apartment.dao.UserDAO;
import com.apartment.model.User;

@WebServlet("/verifyOtp")
public class VerifyOtpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private OtpDAO otpDAO;

    public void init() {
        userDAO = new UserDAO();
        otpDAO = new OtpDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get the email from the hidden form field
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");

        // Validate that the email is present.
        if (email == null || email.isEmpty()) {
            request.setAttribute("errorMessage", "Your session has expired. Please try logging in again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Find the user by their email
        User user = userDAO.getUserByEmail(email);
        
        // This case should rarely happen, but it's a good safeguard
        if (user == null) {
            request.setAttribute("errorMessage", "An error occurred. User not found.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Verify the OTP
        boolean isOtpValid = otpDAO.verifyOtp(user.getUserId(), otp);
        
        if (isOtpValid) {
            // OTP is correct, create the session and log the user in
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Redirect based on role
            String userRole = user.getRole();
            if ("SECURITY".equals(userRole)) {
                response.sendRedirect("visitor-log");
            } else {
                response.sendRedirect("dashboard");
            }
        } else {
            // OTP is incorrect, send back to the verification page with an error
            request.setAttribute("errorMessage", "Invalid or expired OTP. Please try again.");
            request.setAttribute("email", email); // Pass the email back to the page
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
        }
    }
}

