<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Notifications</title>
<%-- DEFINITIVE FIX: Added the two missing stylesheet links --%>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css"> 
<style>
    .notifications-container {
        max-width: 800px;
        margin: 2rem auto;
        padding: 2rem;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    .notifications-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #eee;
        padding-bottom: 1rem;
        margin-bottom: 1rem;
    }
    .notification-item {
        display: flex;
        align-items: flex-start;
        padding: 1rem 0;
        border-bottom: 1px solid #eee;
        text-decoration: none;
        color: inherit;
        transition: background-color 0.2s;
    }
    .notification-item:last-child {
        border-bottom: none;
    }
    .notification-item:hover {
    	background-color: #f9f9f9;
    }
    .notification-item.unread {
        background-color: #f0f8ff; 
    }
    .notification-icon {
        margin-right: 1.5rem;
        color: var(--primary-color);
        flex-shrink: 0;
    }
    .notification-content {
        flex-grow: 1;
    }
    .notification-message {
        font-size: 1rem;
        color: #333;
    }
    .notification-time {
        font-size: 0.8rem;
        color: #888;
        margin-top: 4px;
    }
    .no-notifications {
    	text-align: center;
    	padding: 3rem;
    	color: #777;
    }
</style>
</head>
<body>
    <jsp:include page="common/header.jsp" />
    
    <div class="main-content">
        <div class="notifications-container">
            <div class="notifications-header">
                <h2>Notifications</h2>
            </div>
            
            <c:choose>
                <c:when test="${not empty notificationList}">
                    <c:forEach var="n" items="${notificationList}">
                        <a href="${pageContext.request.contextPath}/${n.link}" class="notification-item <c:if test='${!n.read}'>unread</c:if>">
                            <div class="notification-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                    <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                                </svg>
                            </div>
                            <div class="notification-content">
                                <p class="notification-message"><c:out value="${n.message}" /></p>
                                <p class="notification-time">${n.getTimeAgo()}</p>
                            </div>
                        </a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-notifications">
                        <p>You have no notifications at the moment.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>

