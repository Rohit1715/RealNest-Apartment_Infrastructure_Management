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
<title>Visitor Log | Security Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
    .table-card {
        grid-column: 1 / -1; /* Make table span both columns */
    }
    .visitor-table {
        width: 100%;
        border-collapse: collapse;
    }
    .visitor-table th, .visitor-table td {
        padding: 15px;
        text-align: left;
        border-bottom: 1px solid var(--border-color);
        vertical-align: middle;
    }
    .visitor-table th {
        font-weight: 600;
        color: var(--label-color);
    }
    .exit-btn {
        background-color: var(--red);
        color: #fff;
        border: none;
        padding: 8px 15px;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 500;
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
                <div class="logo">RealNest Security</div>
            </div>
            <div class="nav-right">
                <div class="profile-section" id="profileSection">
                    <div class="profile-info">
                        <div class="avatar"><c:out value="${sessionScope.user.firstName.substring(0, 1)}" /></div>
                        <div class="user-details">
                            <div class="username"><c:out value="${sessionScope.user.firstName} ${sessionScope.user.lastName}" /></div>
                            <div class="role"><c:out value="${sessionScope.user.role}" /></div>
                        </div>
                    </div>
                    <div class="profile-dropdown" id="profileDropdown">
                        <a href="logout" class="logout">Logout</a>
                    </div>
                </div>
            </div>
        </nav>

        <main class="main-content">
            <header class="content-header">
                <h1>Visitor Management</h1>
            </header>
            
            <div class="content-body">
                <div class="form-card">
                    <h2>Log New Visitor</h2>
                    <form action="visitor-log" method="post">
                        <input type="hidden" name="action" value="addVisitor">
                        <div class="form-group">
                            <label for="visitorName">Visitor Name</label>
                            <input type="text" id="visitorName" name="visitorName" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="visitorPhone">Visitor Phone</label>
                            <input type="tel" id="visitorPhone" name="visitorPhone" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="apartmentId">Apartment to Visit</label>
                            <select id="apartmentId" name="apartmentId" class="form-control" required>
                                <option value="">-- Select Apartment --</option>
                                <c:forEach var="apt" items="${apartmentList}">
                                    <option value="${apt.apartmentId}">Block: ${apt.blockName}, Flat: ${apt.flatNumber}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="purpose">Purpose of Visit</label>
                            <textarea id="purpose" name="purpose" class="form-control" rows="3" required></textarea>
                        </div>
                        <button type="submit" class="action-btn">Log Entry</button>
                    </form>
                </div>

                <div class="table-card">
                    <h2>Visitor Log</h2>
                    <table class="visitor-table">
                        <thead>
                            <tr>
                                <th>Visitor Name</th>
                                <th>Phone</th>
                                <th>Visiting</th>
                                <th>Entry Time</th>
                                <th>Exit Time</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="visitor" items="${visitorList}">
                                <tr>
                                    <td><c:out value="${visitor.visitorName}" /></td>
                                    <td><c:out value="${visitor.visitorPhone}" /></td>
                                    <td>Block ${visitor.blockName}, Flat ${visitor.flatNumber}</td>
                                    <td><fmt:formatDate value="${visitor.entryTime}" pattern="MMM d, yyyy, hh:mm a"/></td>
                                    <td>
                                        <c:if test="${not empty visitor.exitTime}">
                                            <fmt:formatDate value="${visitor.exitTime}" pattern="MMM d, yyyy, hh:mm a"/>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${empty visitor.exitTime}">
                                            <form action="visitor-log" method="post">
                                                <input type="hidden" name="action" value="markExit">
                                                <input type="hidden" name="visitorLogId" value="${visitor.visitorLogId}">
                                                <button type="submit" class="exit-btn">Mark Exit</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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
