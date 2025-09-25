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
        
        // Get all tenants (users with role TENANT)
        List<User> tenantList = userDAO.getAllTenants();
        
        // Get all apartments that do not have a tenant
        List<Apartment> availableApartments = apartmentDAO.getApartmentsWithoutTenant();
        
        // Set attributes for the JSP
        request.setAttribute("tenantList", tenantList);
        request.setAttribute("availableApartments", availableApartments);
        
        request.getRequestDispatcher("manage-tenants.jsp").forward(request, response);
    }
}

