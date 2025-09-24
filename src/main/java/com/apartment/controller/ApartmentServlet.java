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
import com.apartment.model.Apartment;

@WebServlet("/apartments")
public class ApartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ApartmentDAO apartmentDAO;

    public void init() {
        apartmentDAO = new ApartmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        int pageSize = 10; // Number of apartments per page

        List<Apartment> apartmentList = apartmentDAO.searchAndPaginateApartments(searchTerm, filterBy, currentPage, pageSize);
        int totalApartments = apartmentDAO.getApartmentCount(searchTerm, filterBy);
        int totalPages = (int) Math.ceil((double) totalApartments / pageSize);

        request.setAttribute("apartmentList", apartmentList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("search", searchTerm);
        request.setAttribute("filter", filterBy);

        RequestDispatcher dispatcher = request.getRequestDispatcher("manage-apartments.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String blockName = request.getParameter("blockName");
        String flatNumber = request.getParameter("flatNumber");
        int floor = 0;
        try {
        	floor = Integer.parseInt(request.getParameter("floor"));
        } catch (NumberFormatException e) {
        	// Handle error if floor is not a valid number
        	response.sendRedirect("apartments?add=error");
        	return;
        }
        
        String houseType = request.getParameter("houseType");
        String otherDetails = request.getParameter("otherDetails");

        Apartment newApartment = new Apartment();
        newApartment.setBlockName(blockName);
        newApartment.setFlatNumber(flatNumber);
        newApartment.setFloor(floor);
        newApartment.setHouseType(houseType);
        newApartment.setOtherDetails(otherDetails);

        try {
            apartmentDAO.addApartment(newApartment);
            // THIS IS THE KEY FIX: Redirect after a successful POST
            // This forces the browser to make a new GET request, refreshing the data.
            response.sendRedirect("apartments?add=success"); 
        } catch (SQLException e) {
            e.printStackTrace();
            // In a real app, you'd handle this more gracefully
            response.sendRedirect("apartments?add=error");
        }
    }
}

