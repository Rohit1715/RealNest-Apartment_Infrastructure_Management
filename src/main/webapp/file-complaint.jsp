<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>File a Complaint | RealNest</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
    /* Page-specific styles for the centered card layout */
    .form-container-card {
        max-width: 800px;
        margin: 2rem auto;
        background-color: #fff;
        padding: 30px 40px;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
    }
    .form-container-card .content-header {
        justify-content: center;
        margin-bottom: 10px;
    }
    .form-container-card p.subtitle {
        color: #6c757d;
        margin-bottom: 30px;
        text-align: center;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        font-weight: 500;
        margin-bottom: 8px;
        color: #495057;
    }
    .form-group select,
    .form-group textarea {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ced4da;
        border-radius: 8px;
        font-family: 'Poppins', sans-serif;
        font-size: 1rem;
        transition: border-color 0.3s, box-shadow 0.3s;
        box-sizing: border-box;
    }
    .form-group select:focus,
    .form-group textarea:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(106, 90, 249, 0.2);
    }
    .btn-full {
        width: 100%;
        padding: 15px;
        font-size: 1.1rem;
        margin-top: 10px;
    }
    /* DEFINITIVE FIX: Styles for the new success message and corrected button color */
    .form-message {
        text-align: left;
        font-weight: 500;
        margin-bottom: 20px;
    }
    .form-message.success {
        color: #28a745; /* A pleasant green color */
    }
    .form-message.error {
        color: #dc3545; /* A clear red color */
    }
    .btn.btn-primary {
        background-color: var(--primary-color) !important; /* Ensures the correct purple is used */
        color: #fff !important;
    }
    .btn.btn-primary:hover {
        background-color: #5847e0 !important;
    }
</style>
</head>
<body>
    <div class="dashboard-wrapper">
        <jsp:include page="common/header.jsp" />

        <main class="main-content">
            <div class="form-container-card">
                <header class="content-header">
                    <h1>File a Complaint</h1>
                </header>
                <p class="subtitle">Please provide details about the issue you are facing. Our team will review it shortly.</p>
                
                <form action="complaints" method="post">
                    
                    <%-- DEFINITIVE FIX: New location and style for success/error messages --%>
                    <c:if test="${not empty successMessage}">
                        <p class="form-message success">${successMessage}</p>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <p class="form-message error">${errorMessage}</p>
                    </c:if>

                    <div class="form-group">
                        <label for="issueType">Type of Issue</label>
                        <select id="issueType" name="issueType" class="form-control" required>
                            <option value="">-- Select an Issue Type --</option>
                            <option value="Maintenance">Maintenance (e.g., plumbing, electrical)</option>
                            <option value="Security">Security Concern</option>
                            <option value="Noise">Noise Complaint</option>
                            <option value="Common Area">Common Area Issue (e.g., lobby, parking)</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="5" placeholder="Please describe the issue in detail..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary btn-full">Submit Complaint</button>
                </form>
            </div>
        </main>
    </div>
</body>
</html>

