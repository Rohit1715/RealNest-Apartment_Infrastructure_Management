package com.apartment.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.apartment.dao.OtpDAO;
import com.apartment.dao.UserDAO;
import com.apartment.model.User;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private OtpDAO otpDAO;

    public void init() {
        userDAO = new UserDAO();
        otpDAO = new OtpDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        
        // CORRECTED: Using the standardized method name
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("errorMessage", "An unexpected error occurred. Please start over.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        boolean isOtpValid = otpDAO.verifyOtp(user.getUserId(), otp);

        if (isOtpValid) {
            try {
                userDAO.updatePassword(email, newPassword);
                response.sendRedirect("login.jsp?reset=success");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("email", email);
                request.setAttribute("errorMessage", "Failed to update password. Please try again.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("email", email);
            request.setAttribute("errorMessage", "Invalid or expired OTP. Please try again.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }
}

