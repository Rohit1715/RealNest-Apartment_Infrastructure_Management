package com.apartment.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//DAOs are now separated for clarity
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
        
        // Fetch all owners for display and for the dropdown
        List<User> ownerList = userDAO.getAllOwners(); 
        
        // Fetch only the apartments that do not currently have an owner
        List<Apartment> unassignedApartments = apartmentDAO.getUnassignedApartments();

        // Set attributes for the JSP page
        request.setAttribute("ownerList", ownerList);
        request.setAttribute("unassignedApartments", unassignedApartments);

        RequestDispatcher dispatcher = request.getRequestDispatcher("manage-owners.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String redirectUrl = "owners?assign=error";
        try {
            int ownerId = Integer.parseInt(request.getParameter("ownerId"));
            int apartmentId = Integer.parseInt(request.getParameter("apartmentId"));
            
            apartmentDAO.assignOwnerToApartment(ownerId, apartmentId);
            redirectUrl = "owners?assign=success";
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(redirectUrl);
    }
}

