package com.apartment.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.ApartmentDAO;
import com.apartment.model.Property;
import com.apartment.model.User;

@WebServlet("/my-properties")
public class OwnerPropertiesServlet extends HttpServlet { 
    private static final long serialVersionUID = 1L;
    private ApartmentDAO apartmentDAO;

    public void init() {
        apartmentDAO = new ApartmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = null;

        if (session != null) {
            loggedInUser = (User) session.getAttribute("user");
        }

        if (loggedInUser == null || !"OWNER".equals(loggedInUser.getRole())) {
            response.sendRedirect("login.jsp");
            return; 
        }

        int ownerId = loggedInUser.getUserId();
        
        // --- UPGRADED Search, Filter, and Pagination Logic ---
        String searchTerm = request.getParameter("search");
        String filterBy = request.getParameter("filter");
        String pageStr = request.getParameter("page");
        
        if (filterBy == null || filterBy.isEmpty()) {
            filterBy = "all";
        }

        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int pageSize = 10; // Number of properties per page

        List<Property> propertyList = apartmentDAO.searchAndPaginateOwnerProperties(ownerId, searchTerm, filterBy, currentPage, pageSize);
        int totalProperties = apartmentDAO.getOwnerPropertyCount(ownerId, searchTerm, filterBy);
        int totalPages = (int) Math.ceil((double) totalProperties / pageSize);

        request.setAttribute("propertyList", propertyList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("search", searchTerm);
        request.setAttribute("filter", filterBy);

        RequestDispatcher dispatcher = request.getRequestDispatcher("my-properties.jsp");
        dispatcher.forward(request, response);
    }
}

