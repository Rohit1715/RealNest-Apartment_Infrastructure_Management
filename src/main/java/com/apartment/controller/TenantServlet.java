package com.apartment.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.apartment.dao.ApartmentDAO;
import com.apartment.dao.TenantDAO;
import com.apartment.dao.UserDAO;
import com.apartment.model.Apartment;
import com.apartment.model.Tenant;
import com.apartment.model.User;

@WebServlet("/tenants")
public class TenantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private ApartmentDAO apartmentDAO;
    private TenantDAO tenantDAO;

    public void init() {
        userDAO = new UserDAO();
        apartmentDAO = new ApartmentDAO();
        tenantDAO = new TenantDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String redirectUrl = "tenants?assign=error";
        try {
            int tenantUserId = Integer.parseInt(request.getParameter("tenantId"));
            int apartmentId = Integer.parseInt(request.getParameter("apartmentId"));
            Date moveInDate = Date.valueOf(request.getParameter("moveInDate"));
            double monthlyRent = Double.parseDouble(request.getParameter("monthlyRent"));

            Tenant newTenant = new Tenant();
            newTenant.setTenantUserId(tenantUserId);
            newTenant.setApartmentId(apartmentId);
            newTenant.setMoveInDate(moveInDate);
            newTenant.setMonthlyRent(monthlyRent);
            
            tenantDAO.assignTenantToApartment(newTenant);
            redirectUrl = "tenants?assign=success";
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(redirectUrl);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // --- New Search and Pagination Logic ---
        String searchTerm = request.getParameter("search");
        String pageStr = request.getParameter("page");
        
        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int pageSize = 10; // Number of tenants per page

        // Fetch paginated list of tenants for the main display
        List<User> tenantList = tenantDAO.searchAndPaginateTenants(searchTerm, currentPage, pageSize);
        int totalTenants = tenantDAO.getTenantCount(searchTerm);
        int totalPages = (int) Math.ceil((double) totalTenants / pageSize);

        // --- Data for the dropdowns in the form ---
        List<User> allTenants = userDAO.getAllTenants();
        List<Apartment> availableApartments = apartmentDAO.getApartmentsWithoutTenant();
        
        // Set all attributes for the JSP page
        request.setAttribute("tenantList", tenantList); // The paginated list for display
        request.setAttribute("allTenants", allTenants); // The complete list for the form
        request.setAttribute("availableApartments", availableApartments);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("search", searchTerm);
        
        request.getRequestDispatcher("manage-tenants.jsp").forward(request, response);
    }
}

