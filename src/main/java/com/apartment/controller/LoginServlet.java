package com.apartment.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.UserDAO;
import com.apartment.model.User;

// NOTE: OTP-related imports are removed for the temporary fix.

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    // private OtpDAO otpDAO; // Temporarily commented out

    public void init() {
        userDAO = new UserDAO();
        // otpDAO = new OtpDAO(); // Temporarily commented out
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String loginIdentifier = request.getParameter("loginIdentifier");
        String password = request.getParameter("password");
        
        System.out.println("--- Login Attempt ---");
        System.out.println("Attempting login for identifier: " + loginIdentifier);
        
        User user = userDAO.validateUser(loginIdentifier, password);

        if (user != null) {
            System.out.println("User validation SUCCESSFUL for: " + user.getUsername());
            
            // TEMPORARY FIX: Log in all users directly to bypass OTP email issue on Render.
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect("dashboard"); // Redirect all successful logins to the dashboard
            
        } else {
            System.out.println("User validation FAILED for identifier: " + loginIdentifier);
            
            request.setAttribute("errorMessage", "Invalid username/email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}

