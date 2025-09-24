<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.apartment.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Notices | Apartment MS</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
    .notice-item {
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        border-left: 5px solid var(--primary-color);
    }
    .notice-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }
    .notice-title {
        font-size: 1.2rem;
        font-weight: 600;
    }
    .notice-meta {
        font-size: 0.85rem;
        color: var(--label-color);
    }
    .notice-body {
        color: #444;
    }
    .delete-btn {
        background-color: var(--red);
        color: #fff;
        border: none;
        padding: 5px 10px;
        border-radius: 5px;
        cursor: pointer;
    }
</style>
</head>
<body>
    <%
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>
    <div class="dashboard-wrapper">
        <nav class="top-nav">
            <div class="nav-left">
                <div class="logo">RealNest</div>
                <div class="nav-links">
                    <ul>
                        <li><a href="dashboard">Dashboard</a></li>
                        <li><a href="apartments">Apartments</a></li>
                        <li><a href="owners">Owners</a></li>
                        <li><a href="tenants">Tenants</a></li>
                        <li><a href="complaints">Complaints</a></li>
                        <li><a href="notices" class="active">Notices</a></li>
                    </ul>
                </div>
            </div>
            <div class="nav-right">
                <div class="notification-bell">
                    <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="currentColor" class="bi bi-bell-fill" viewBox="0 0 16 16"><path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zm.995-14.901a1 1 0 1 0-1.99 0A5.002 5.002 0 0 0 3 6c0 1.098-.5 6-2 7h14c-1.5-1-2-5.902-2-7 0-2.42-1.72-4.44-4.005-4.901z"/></svg>
                </div>
                <div class="profile-section" id="profileSection">
                    <div class="profile-info">
                        <div class="avatar"><c:out value="${sessionScope.user.firstName.substring(0, 1)}" /></div>
                        <div class="user-details">
                            <div class="username"><c:out value="${sessionScope.user.firstName} ${sessionScope.user.lastName}" /></div>
                            <div class="role"><c:out value="${sessionScope.user.role}" /></div>
                        </div>
                    </div>
                    <div class="profile-dropdown" id="profileDropdown">
                        <a href="#">Settings</a>
                        <a href="logout" class="logout">Logout</a>
                    </div>
                </div>
            </div>
        </nav>

        <main class="main-content">
            <header class="content-header">
                <h1>Manage Notices</h1>
            </header>
            
            <div class="content-body">
                <div class="form-card">
                    <h2>Post a New Notice</h2>
                    <form action="notices" method="post">
                        <input type="hidden" name="action" value="addNotice">
                        <div class="form-group">
                            <label for="title">Title</label>
                            <input type="text" id="title" name="title" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="4" required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="validTill">Valid Until</label>
                            <input type="date" id="validTill" name="validTill" class="form-control" required>
                        </div>
                        <button type="submit" class="action-btn">Post Notice</button>
                    </form>
                </div>

                <div class="table-card">
                    <h2>Posted Notices</h2>
                    <c:forEach var="notice" items="${noticeList}">
                        <div class="notice-item">
                            <div class="notice-header">
                                <span class="notice-title"><c:out value="${notice.title}" /></span>
                                <form action="notices" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="deleteNotice">
                                    <input type="hidden" name="noticeId" value="${notice.noticeId}">
                                    <button type="submit" class="delete-btn">Delete</button>
                                </form>
                            </div>
                            <div class="notice-body">
                                <p><c:out value="${notice.description}" /></p>
                            </div>
                            <div class="notice-meta">
                                Posted by ${notice.createdByName} on <fmt:formatDate value="${notice.createdAt}" pattern="MMM d, yyyy"/> | 
                                Valid until <fmt:formatDate value="${notice.validTill}" pattern="MMM d, yyyy"/>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty noticeList}"><p>No notices have been posted yet.</p></c:if>
                </div>
            </div>
        </main>
    </div>

    <script>
        const profileSection = document.getElementById('profileSection');
        const profileDropdown = document.getElementById('profileDropdown');
        profileSection.addEventListener('click', (event) => {
            profileDropdown.style.display = profileDropdown.style.display === 'block' ? 'none' : 'block';
            event.stopPropagation();
        });
        window.addEventListener('click', (event) => {
            if (!profileSection.contains(event.target)) {
                profileDropdown.style.display = 'none';
            }
        });
    </script>
</body>
</html>
