package com.apartment.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.ComplaintDAO;
import com.apartment.model.Complaint;
import com.apartment.model.User;

@WebServlet("/owner-complaints")
public class OwnerComplaintsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ComplaintDAO complaintDAO;

    public void init() {
        complaintDAO = new ComplaintDAO();
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
            response.sendRedirect("dashboard.jsp");
            return;
        }
        
        int ownerId = owner.getUserId();

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

        int pageSize = 10; // Number of complaints per page

        // Fetch the paginated list of complaints for the owner
        List<Complaint> complaintList = complaintDAO.searchAndPaginateOwnerComplaints(ownerId, searchTerm, filterBy, currentPage, pageSize);
        int totalComplaints = complaintDAO.getOwnerComplaintCount(ownerId, searchTerm, filterBy);
        int totalPages = (int) Math.ceil((double) totalComplaints / pageSize);
        
        // Set attributes for the JSP page
        request.setAttribute("complaintList", complaintList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("search", searchTerm);
        request.setAttribute("filter", filterBy);
        
        request.getRequestDispatcher("owner-complaints.jsp").forward(request, response);
    }
}
