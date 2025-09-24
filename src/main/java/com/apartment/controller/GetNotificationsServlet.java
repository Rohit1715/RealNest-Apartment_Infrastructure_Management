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
import com.google.gson.Gson;

@WebServlet("/getNotifications")
public class GetNotificationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NotificationDAO notificationDAO;
    private Gson gson;

    public void init() {
        notificationDAO = new NotificationDAO();
        // Using a simple, standard Gson instance is the most reliable method.
        gson = new Gson();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        List<Notification> notifications = notificationDAO.getRecentNotifications(user.getUserId(), 5);
        
        // Convert the list to a JSON string. Gson will serialize the Timestamp to milliseconds.
        String jsonResponse = gson.toJson(notifications);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse);
        
        // Mark notifications as read after they have been sent to the user.
        notificationDAO.markAllAsRead(user.getUserId());
    }
}

