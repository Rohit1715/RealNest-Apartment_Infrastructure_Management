<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Verify Your Identity</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-color: #6a5af9;
        --background-color: #f4f7fc;
        --card-bg-color: #ffffff;
        --text-color: #333;
        --label-color: #666;
        --input-border-color: #ddd;
        --error-color: #e74c3c;
    }
    body, html {
        height: 100%;
        margin: 0;
        font-family: 'Poppins', sans-serif;
        background-color: var(--background-color);
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .card {
        background-color: var(--card-bg-color);
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 8px
 30px rgba(0,0,0,0.1);
        width: 100%;
        max-width: 420px;
        text-align: center;
    }
    h1 {
        font-size: 1.8rem;
        font-weight: 600;
        margin-bottom: 10px;
        color: var(--text-color);
    }
    .subtitle {
        color: var(--label-color);
        margin-bottom: 30px;
    }
    .form-control {
        width: 100%;
        padding: 14px;
        border: 1px solid var(--input-border-color);
        border-radius: 8px;
        box-sizing: border-box;
        font-size: 1.2rem;
        text-align: center;
        letter-spacing: 5px;
    }
    .form-control:focus {
        outline: none;
        border-color: var(--primary-color);
    }
    .btn-submit {
        width: 100%;
        padding: 15px;
        border: none;
        background-color: var(--primary-color);
        color: white;
        border-radius: 8px;
        font-size: 1rem;
        font-weight: 500;
        cursor: pointer;
        margin-top: 20px;
    }
    .error-message {
        color: var(--error-color);
        margin-top: 15px;
        font-weight: 500;
    }
</style>
</head>
<body>
    <div class="card">
        <h1>Two-Step Verification</h1>
        <p class="subtitle">A verification code has been sent to your registered email address. Please enter the code below.</p>
        
        <form action="verifyOtp" method="post">
            <!-- CRITICAL FIX: Hidden field to carry the user's email -->
            <input type="hidden" name="email" value="${email}">
            
            <div class="form-group">
                <input type="text" class="form-control" name="otp" placeholder="Enter 6-digit OTP" required maxlength="6">
            </div>
            
            <button type="submit" class="btn-submit">Verify & Login</button>
            
            <c:if test="${not empty errorMessage}">
                <p class="error-message">${errorMessage}</p>
            </c:if>
        </form>
    </div>
</body>
</html>

