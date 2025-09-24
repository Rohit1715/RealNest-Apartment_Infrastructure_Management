package com.apartment.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.apartment.dao.NotificationDAO;
import com.apartment.model.Notification;
import com.apartment.model.User;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NotificationDAO notificationDAO;

    public void init() {
        notificationDAO = new NotificationDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fetch all notifications for the user
        List<Notification> notificationList = notificationDAO.getNotificationsForUser(user.getUserId());
        request.setAttribute("notificationList", notificationList);
        
        // Mark all as read since the user is viewing them
        notificationDAO.markAllAsRead(user.getUserId());
        
        request.setAttribute("pageName", "notifications"); // For active nav link
        request.getRequestDispatcher("notifications.jsp").forward(request, response);
    }
}
