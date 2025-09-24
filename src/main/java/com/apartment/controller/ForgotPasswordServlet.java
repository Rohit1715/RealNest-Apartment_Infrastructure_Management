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
import com.apartment.util.EmailTemplateUtil;
import com.apartment.util.EmailUtil;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
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
        String role = request.getParameter("role"); // NEW: Get the selected role

        // NEW: Use the secure method to find a user by both email and role
        User user = userDAO.getUserByEmailAndRole(email, role);

        if (user == null) {
            // If no user is found, show an error message
            request.setAttribute("errorMessage", "No account found with this email and role combination.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            // Generate and send the OTP
            String otp = otpDAO.generateAndSaveOtp(user.getUserId());
            String emailBody = EmailTemplateUtil.getOtpEmailBody(user.getFirstName(), otp);
            EmailUtil.sendEmail(email, "Your Password Reset Code", emailBody);

            // Forward to the reset password page with the email and role
            request.setAttribute("email", email);
            request.setAttribute("role", role); // NEW: Forward the role
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Could not send OTP. Please try again later.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
}

