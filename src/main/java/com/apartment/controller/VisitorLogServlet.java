package com.apartment.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.ApartmentDAO;
import com.apartment.dao.VisitorLogDAO;
import com.apartment.model.Apartment;
import com.apartment.model.User;
import com.apartment.model.VisitorLog;

@WebServlet("/visitor-log")
public class VisitorLogServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private VisitorLogDAO visitorLogDAO;
    private ApartmentDAO apartmentDAO;

    public void init() {
        visitorLogDAO = new VisitorLogDAO();
        apartmentDAO = new ApartmentDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User securityGuard = (User) session.getAttribute("user");
        
        String action = request.getParameter("action");

        try {
            if ("addVisitor".equals(action)) {
                String visitorName = request.getParameter("visitorName");
                String visitorPhone = request.getParameter("visitorPhone");
                String purpose = request.getParameter("purpose");
                int apartmentId = Integer.parseInt(request.getParameter("apartmentId"));

                VisitorLog newVisitor = new VisitorLog();
                newVisitor.setVisitorName(visitorName);
                newVisitor.setVisitorPhone(visitorPhone);
                newVisitor.setPurpose(purpose);
                newVisitor.setApartmentIdToVisit(apartmentId);
                newVisitor.setSecurityGuardId(securityGuard.getUserId());
                
                visitorLogDAO.addVisitor(newVisitor);

            } else if ("markExit".equals(action)) {
                int visitorLogId = Integer.parseInt(request.getParameter("visitorLogId"));
                visitorLogDAO.markVisitorExit(visitorLogId);
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        }
        
        response.sendRedirect("visitor-log");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<VisitorLog> visitorList = visitorLogDAO.getAllVisitors();
        // This line will now work correctly once you update your ApartmentDAO
        List<Apartment> apartmentList = apartmentDAO.getAllApartments();
        
        request.setAttribute("visitorList", visitorList);
        request.setAttribute("apartmentList", apartmentList);
        
        request.getRequestDispatcher("visitor-log.jsp").forward(request, response);
    }
}
