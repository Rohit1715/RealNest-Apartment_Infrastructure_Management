package com.apartment.controller;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.apartment.dao.UserDAO;
import com.apartment.model.User;
// NEW: Import the email utility classes
import com.apartment.util.EmailTemplateUtil;
import com.apartment.util.EmailUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String mobile = request.getParameter("mobile");
        String role = request.getParameter("role");

        if (userDAO.checkUserExists(username, email)) {
            request.setAttribute("errorMessage", "A user with this username or email already exists.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setFirstName(firstName);
        newUser.setLastName(lastName);
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPassword(password);
        newUser.setMobile(mobile);
        newUser.setRole(role);

        try {
            userDAO.saveUser(newUser);
            System.out.println("User registered successfully!");

            // NEW: Send the welcome email after successful registration
            String subject = "Welcome to RealNest!";
            String body = EmailTemplateUtil.getWelcomeEmailBody(newUser.getFirstName());
            EmailUtil.sendEmail(newUser.getEmail(), subject, body);
            // NEW: Email logic ends here

            response.sendRedirect("login.jsp?registration=success");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
