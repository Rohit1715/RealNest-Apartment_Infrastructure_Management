package com.apartment.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.UserDAO;
import com.apartment.model.User;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // Set pageName for active nav link highlighting
        request.setAttribute("pageName", "settings");
        request.getRequestDispatcher("settings.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        // Get the updated details from the form
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String mobile = request.getParameter("mobile");
        String email = request.getParameter("email");
        
        // Create a temporary user object with the new details to pass to the DAO
        User updatedUser = new User();
        updatedUser.setUserId(currentUser.getUserId());
        updatedUser.setFirstName(firstName);
        updatedUser.setLastName(lastName);
        updatedUser.setMobile(mobile);
        updatedUser.setEmail(email);

        try {
            boolean isSuccess = userDAO.updateUserProfile(updatedUser);

            if (isSuccess) {
                // IMPORTANT: Update the user object in the session to reflect changes immediately
                currentUser.setFirstName(firstName);
                currentUser.setLastName(lastName);
                currentUser.setMobile(mobile);
                currentUser.setEmail(email);
                session.setAttribute("user", currentUser); // Put the updated object back in the session
                
                request.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                // This means the email was already in use
                request.setAttribute("errorMessage", "Email is already in use by another account. Please choose a different one.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred. Please try again later.");
        }

        // Forward back to the settings page to display the message
        doGet(request, response);
    }
}
