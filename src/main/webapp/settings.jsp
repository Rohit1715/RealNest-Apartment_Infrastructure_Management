<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Settings</title>
<link rel="stylesheet" href="css/style.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    .settings-container {
        max-width: 700px;
        margin: 2rem auto;
        padding: 2.5rem;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    }
    .settings-header {
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 1px solid #eee;
    }
    .settings-header h1 {
        font-size: 1.8rem;
        margin: 0;
    }
    .form-group {
        margin-bottom: 1.5rem;
    }
    .form-group label {
        display: block;
        font-weight: 500;
        margin-bottom: 0.5rem;
        color: #555;
    }
    .form-control {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-family: 'Poppins', sans-serif;
        font-size: 1rem;
        box-sizing: border-box; /* Important for consistent sizing */
    }
    .form-control:read-only {
        background-color: #f5f5f5;
        cursor: not-allowed;
    }
    .btn-submit {
        display: inline-block;
        padding: 12px 30px;
        border: none;
        background-color: var(--primary-color);
        color: white;
        border-radius: 6px;
        font-size: 1rem;
        font-weight: 500;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .btn-submit:hover {
        background-color: #5847d8;
    }
    .message {
        padding: 1rem;
        border-radius: 6px;
        margin-bottom: 1.5rem;
        font-weight: 500;
    }
    .success-message {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }
    .error-message {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
</style>
</head>
<body>
    <jsp:include page="common/header.jsp" />
    
    <div class="main-content">
        <div class="settings-container">
            <div class="settings-header">
                <h1>Account Settings</h1>
            </div>

            <!-- Display success or error messages -->
            <c:if test="${not empty successMessage}">
                <div class="message success-message">
                    ${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="message error-message">
                    ${errorMessage}
                </div>
            </c:if>

            <form action="settings" method="post">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" class="form-control" value="<c:out value='${sessionScope.user.username}'/>" readonly>
                </div>
                <div class="form-group">
                    <label>Role</label>
                    <input type="text" class="form-control" value="<c:out value='${sessionScope.user.role}'/>" readonly>
                </div>
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" class="form-control" id="firstName" name="firstName" value="<c:out value='${sessionScope.user.firstName}'/>" required>
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" class="form-control" id="lastName" name="lastName" value="<c:out value='${sessionScope.user.lastName}'/>" required>
                </div>
                <div class="form-group">
                    <label for="mobile">Mobile Number</label>
                    <input type="text" class="form-control" id="mobile" name="mobile" value="<c:out value='${sessionScope.user.mobile}'/>" required>
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" class="form-control" id="email" name="email" value="<c:out value='${sessionScope.user.email}'/>" required>
                </div>
                
                <button type="submit" class="btn-submit">Save Changes</button>
            </form>
        </div>
    </div>
</body>
</html>
