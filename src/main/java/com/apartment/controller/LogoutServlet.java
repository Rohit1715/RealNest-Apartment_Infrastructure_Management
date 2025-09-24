package com.apartment.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get the current session
        HttpSession session = request.getSession(false); // false means do not create a new session if one doesn't exist
        
        if (session != null) {
            // 2. Invalidate the session - this removes all session attributes
            session.invalidate();
        }
        
        // 3. Redirect the user to the login page
        response.sendRedirect("login.jsp");
    }
}
