package com.apartment.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.apartment.dao.ApartmentDAO;
import com.apartment.dao.UserDAO;
import com.apartment.model.Apartment;
import com.apartment.model.User;

@WebServlet("/owners")
public class OwnerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private ApartmentDAO apartmentDAO;

    public void init() {
        userDAO = new UserDAO();
        apartmentDAO = new ApartmentDAO();
    }

    @Override
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

        int pageSize = 10; // Number of owners per page

        // Fetch paginated list of owners for display
        List<User> ownerList = userDAO.searchAndPaginateOwners(searchTerm, currentPage, pageSize);
        int totalOwners = userDAO.getOwnerCount(searchTerm);
        int totalPages = (int) Math.ceil((double) totalOwners / pageSize);
        
        // --- Data for the dropdowns in the form ---
        List<User> allOwners = userDAO.getAllOwners(); // For the "Select Owner" dropdown
        List<Apartment> unassignedApartments = apartmentDAO.getUnassignedApartments();

        // Set all attributes for the JSP page
        request.setAttribute("ownerList", ownerList); // The paginated list for display
        request.setAttribute("allOwners", allOwners); // The complete list for the form
        request.setAttribute("unassignedApartments", unassignedApartments);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("search", searchTerm);

        RequestDispatcher dispatcher = request.getRequestDispatcher("manage-owners.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String redirectUrl = "owners?assign=error"; // Default to error
        try {
            int ownerId = Integer.parseInt(request.getParameter("ownerId"));
            int apartmentId = Integer.parseInt(request.getParameter("apartmentId"));
            
            apartmentDAO.assignOwnerToApartment(ownerId, apartmentId);
            redirectUrl = "owners?assign=success"; // Change to success if no exception
            
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(redirectUrl);
    }
}