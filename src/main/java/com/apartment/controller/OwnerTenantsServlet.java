package com.apartment.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.TenantDAO;
import com.apartment.model.User;

@WebServlet("/owner-tenants")
public class OwnerTenantsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TenantDAO tenantDAO;

    public void init() {
        tenantDAO = new TenantDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User owner = (User) session.getAttribute("user");
        if (!"OWNER".equals(owner.getRole())) {
            // Redirect if the user is not an owner
            response.sendRedirect("dashboard.jsp"); 
            return;
        }
        
        // Get the search term from the request
        String searchTerm = request.getParameter("search");
        
        // Fetch the list of tenants for the logged-in owner, now with search functionality
        List<User> tenantList = tenantDAO.getTenantsByOwner(owner.getUserId(), searchTerm);
        
        // Pass the tenant list and the search term back to the JSP
        request.setAttribute("tenantList", tenantList);
        request.setAttribute("search", searchTerm);
        
        request.getRequestDispatcher("owner-tenants.jsp").forward(request, response);
    }
}

