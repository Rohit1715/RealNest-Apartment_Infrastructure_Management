package com.apartment.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.NoticeDAO;
import com.apartment.dao.NotificationDAO;
import com.apartment.dao.UserDAO;
import com.apartment.model.Notice;
import com.apartment.model.User;

@WebServlet("/notices")
public class NoticeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NoticeDAO noticeDAO;
    private NotificationDAO notificationDAO;
    private UserDAO userDAO;

    public void init() {
        noticeDAO = new NoticeDAO();
        notificationDAO = new NotificationDAO();
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("addNotice".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                Date validTill = Date.valueOf(request.getParameter("validTill"));

                Notice newNotice = new Notice();
                newNotice.setTitle(title);
                newNotice.setDescription(description);
                newNotice.setCreatedBy(user.getUserId());
                newNotice.setValidTill(validTill);
                
                noticeDAO.addNotice(newNotice);
                
                String message = "New notice '" + title + "' has been posted by Admin.";
                List<Integer> userIdsToNotify = userDAO.getAllTenantAndOwnerIds();
                notificationDAO.createNotificationsForMultipleUsers(userIdsToNotify, message, "notices");

            } else if ("deleteNotice".equals(action)) {
                int noticeId = Integer.parseInt(request.getParameter("noticeId"));
                noticeDAO.deleteNotice(noticeId);
            }
        } catch (SQLException | IllegalArgumentException e) {
            e.printStackTrace();
        }
        
        response.sendRedirect("notices");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // FINAL FIX: Always set request attributes for the header view
        request.setAttribute("unreadCount", notificationDAO.getUnreadNotificationCount(user.getUserId()));
        request.setAttribute("pageName", "notices");
        
        List<Notice> noticeList = noticeDAO.getAllNotices();
        request.setAttribute("noticeList", noticeList);
        
        if ("ADMIN".equals(user.getRole())) {
            request.getRequestDispatcher("manage-notices.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("view-notices.jsp").forward(request, response);
        }
    }
}

