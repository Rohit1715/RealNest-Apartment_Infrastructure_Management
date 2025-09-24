<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Confirm Payment | RealNest</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-color: #5E54D8;
        --background-color: #f1f5f9;
        --text-color: #333;
        --border-color: #e2e8f0;
    }
    body {
        margin: 0;
        font-family: 'Poppins', sans-serif;
        background-color: var(--background-color);
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }
    .gateway-container {
        background: #fff;
        padding: 40px;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        text-align: center;
        width: 100%;
        max-width: 400px;
    }
    .gateway-header .logo {
        font-size: 1.8rem;
        font-weight: 700;
        color: var(--primary-color);
        margin-bottom: 20px;
    }
    .amount-display {
        margin: 20px 0;
    }
    .amount-display .amount {
        font-size: 3rem;
        font-weight: 700;
        color: var(--text-color);
    }
    .amount-display .label {
        color: #777;
    }
    .recipient-info {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 30px;
    }
    .btn {
        display: inline-block; font-weight: 500; text-align: center;
        vertical-align: middle; cursor: pointer; user-select: none; background-color: transparent;
        border: 1px solid transparent; padding: 0.8rem 1.5rem; font-size: 1rem;
        line-height: 1.5; border-radius: 0.5rem; text-decoration: none;
        transition: all 0.15s ease-in-out;
        width: 100%;
    }
    .btn-primary {
        color: #fff;
        background-color: var(--primary-color);
        border-color: var(--primary-color);
    }
    .btn-primary:hover {
        opacity: 0.9;
    }
    .btn-primary:disabled {
        background-color: #ccc;
        border-color: #ccc;
        cursor: not-allowed;
    }
</style>
</head>
<body>
    <div class="gateway-container">
        <div class="gateway-header">
            <div class="logo">RealNest Secure Pay</div>
        </div>
        
        <div class="amount-display">
            <div class="label">You are paying</div>
            <div class="amount">
                <fmt:setLocale value="en_IN" />
                <fmt:formatNumber value="${param.amount}" type="currency" currencySymbol="₹"/>
            </div>
        </div>
        
        <div class="recipient-info">
            <p><strong>To:</strong> RealNest Properties</p>
            <p><strong>UPI ID:</strong> realnest@hdfcbank</p>
        </div>

        <c:set var="paymentAmount" value="${param.amount}" />
        <c:choose>
            <c:when test="${paymentAmount > 0.0}">
                <form action="payments" method="post">
                    <input type="hidden" name="amount" value="${param.amount}">
                    <input type="hidden" name="paymentMethod" value="UPI">
                    <button type="submit" class="btn btn-primary">Confirm & Pay</button>
                </form>
            </c:when>
            <c:otherwise>
                <p style="color: #c62828; font-weight: 500;">Invalid payment amount. Cannot proceed.</p>
                <button class="btn btn-primary" disabled>Confirm & Pay</button>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>

