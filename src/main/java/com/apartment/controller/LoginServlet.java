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
import com.apartment.util.EmailTemplateUtil;
import com.apartment.util.EmailUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private OtpDAO otpDAO;

    public void init() {
        userDAO = new UserDAO();
        otpDAO = new OtpDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String loginIdentifier = request.getParameter("loginIdentifier");
        String password = request.getParameter("password");
        User user = userDAO.validateUser(loginIdentifier, password);

        if (user != null) {
            // If user is ADMIN, bypass OTP and log in directly
            if ("ADMIN".equals(user.getRole())) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect("dashboard");
                return;
            }

            // For all other users, proceed with OTP generation
            try {
                String otp = otpDAO.generateAndSaveOtp(user.getUserId());
                String emailBody = EmailTemplateUtil.getOtpEmailBody(user.getFirstName(), otp);
                EmailUtil.sendEmail(user.getEmail(), "Your One-Time Password (OTP)", emailBody);

                // Redirect to the OTP verification page, passing the user's email
                request.setAttribute("email", user.getEmail());
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Could not send OTP. Please try again later.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } else {
            request.setAttribute("errorMessage", "Invalid username/email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}

