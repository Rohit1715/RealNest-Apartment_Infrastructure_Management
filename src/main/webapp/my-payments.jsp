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
<title>My Payments | Apartment MS</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
    /* Page-specific styles for payments dashboard */
    .card-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 25px;
    }
    .card {
        background-color: #ffffff;
        padding: 25px;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
    }
    .card .value {
        font-size: 2rem;
        font-weight: 700;
        margin-bottom: 5px;
    }
    .card .value.red { color: #c62828; }
    .card .description { font-size: 0.9rem; color: var(--label-color); }

    .transaction-history {
        margin-top: 40px;
    }
    .timeline {
        list-style: none;
        padding: 0;
    }
    .timeline-item {
        display: flex;
        align-items: center;
        padding: 20px;
        border-bottom: 1px solid var(--border-color);
    }
    .timeline-item:last-child {
        border-bottom: none;
    }
    .timeline-icon {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #e8f5e9;
        color: #43a047;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 20px;
    }
    .timeline-content {
        flex-grow: 1;
    }
    .timeline-content .title {
        font-weight: 600;
        margin-bottom: 3px;
    }
    .timeline-content .details {
        font-size: 0.9rem;
        color: var(--label-color);
    }
    .timeline-amount {
        font-weight: 600;
        font-size: 1.1rem;
    }
    
    /* Modal styles */
    .modal-backdrop {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.6);
        z-index: 1000;
        justify-content: center;
        align-items: center;
    }
    .modal-content {
        background-color: #fff;
        padding: 40px;
        border-radius: 20px;
        text-align: center;
        max-width: 400px;
        width: 90%;
        box-shadow: 0 5px 25px rgba(0,0,0,0.1);
        transform: scale(0.9);
        opacity: 0;
        transition: transform 0.3s ease, opacity 0.3s ease;
    }
    .modal-icon {
        width: 80px;
        height: 80px;
        margin: 0 auto 20px;
        background-color: #4CAF50;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
    }
    .modal-icon svg {
        width: 40px;
        height: 40px;
    }
    .modal-content h2 {
        font-size: 1.8rem;
        margin-bottom: 10px;
        color: #333;
    }
    .modal-content p {
        color: #666;
        margin-bottom: 30px;
    }
    
    /* FINAL FIX: Added button styles */
    .btn {
        display: inline-block; font-weight: 500; text-align: center;
        vertical-align: middle; cursor: pointer; user-select: none; background-color: transparent;
        border: 1px solid transparent; padding: 0.6rem 1rem; font-size: 0.95rem;
        line-height: 1.5; border-radius: 0.3rem; text-decoration: none;
        transition: all 0.15s ease-in-out;
    }
    .btn-primary {
        color: #fff;
        background-color: #5E54D8;
        border-color: #5E54D8;
    }
    .btn-primary:hover {
        background-color: #4D45B4;
        border-color: #4D45B4;
    }
</style>
</head>
<body>
    <div class="dashboard-wrapper">
        <c:set var="pageName" value="payments" scope="request" />
        <%@ include file="/common/header.jsp" %>

        <main class="main-content">
            <header class="content-header">
                <h1>Payments</h1>
                <a href="make-payment" class="btn btn-primary">Make a Payment</a>
            </header>
            
            <div class="card-grid">
                <div class="card">
                    <div class="value red">
                        <fmt:formatNumber value="${outstandingBalance}" type="currency" currencySymbol="₹"/>
                    </div>
                    <div class="description">Outstanding Balance</div>
                </div>
                <div class="card">
                    <div class="value">
                        <fmt:formatNumber value="${lastPaymentAmount}" type="currency" currencySymbol="₹"/>
                    </div>
                    <div class="description">Last Payment Made</div>
                </div>
                 <div class="card">
                    <div class="value">${nextDueDate}</div>
                    <div class="description">Next Rent Due</div>
                </div>
            </div>

            <div class="table-card transaction-history">
                <h2>Transaction History</h2>
                <ul class="timeline">
                     <c:if test="${empty paymentHistory}">
                        <p style="text-align:center; color: #888; padding: 40px 0;">No payment history found.</p>
                    </c:if>
                    <c:forEach var="payment" items="${paymentHistory}">
                        <li class="timeline-item">
                            <div class="timeline-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-check2-circle" viewBox="0 0 16 16"><path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/><path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/></svg>
                            </div>
                            <div class="timeline-content">
                                <div class="title">Rent Payment - ${payment.paymentType}</div>
                                <div class="details">
                                    <fmt:formatDate value="${payment.paymentDate}" pattern="MMMM d, yyyy"/> | Transaction ID: ${payment.transactionId}
                                </div>
                            </div>
                            <div class="timeline-amount">
                                <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₹"/>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </main>
    </div>
    
    <!-- Payment Success Modal -->
    <div class="modal-backdrop" id="successModal">
        <div class="modal-content">
            <div class="modal-icon">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            </div>
            <h2>Payment Successful!</h2>
            <p>Your transaction has been completed. You will be redirected shortly.</p>
        </div>
    </div>

    <script src="js/script.js"></script>
    <script>
        // JS for success modal
        document.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('status') === 'success') {
                const modal = document.getElementById('successModal');
                modal.style.display = 'flex';
                setTimeout(() => {
                    modal.querySelector('.modal-content').style.transform = 'scale(1)';
                    modal.querySelector('.modal-content').style.opacity = '1';
                }, 10);

                setTimeout(() => {
                    window.location.href = 'payments';
                }, 4000);
            }
        });
    </script>
</body>
</html>

