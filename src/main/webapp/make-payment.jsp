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
<title>Make a Payment | Apartment MS</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
    .payment-container {
        display: flex;
        max-width: 900px;
        margin: 40px auto;
        background: #fff;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.07);
        overflow: hidden;
    }
    .payment-card-preview {
        flex-basis: 40%;
        background: linear-gradient(135deg, #6a5af9, #d66bff);
        padding: 40px;
        color: white;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    .card-graphic {
        background: rgba(255,255,255,0.1);
        border-radius: 15px;
        padding: 20px;
        backdrop-filter: blur(10px);
    }
    .card-graphic .chip {
        width: 50px;
        height: 40px;
        background: #ffc46a;
        border-radius: 6px;
        margin-bottom: 20px;
    }
    .card-number-display {
        font-family: 'Courier New', Courier, monospace;
        font-size: 1.5rem;
        letter-spacing: 3px;
        margin-bottom: 20px;
        height: 30px;
    }
    .card-holder-info { display: flex; justify-content: space-between; align-items: center; }
    .card-holder-name { font-size: 0.9rem; height: 20px; }
    .card-logo { font-size: 2rem; }
    .payment-form-section {
        flex-basis: 60%;
        padding: 40px;
    }
    .payment-form-section h2 { margin-top: 0; }
    .payment-methods { display: flex; gap: 10px; margin-bottom: 20px; border-bottom: 1px solid var(--border-color); }
    .payment-methods button {
        padding: 10px 15px;
        border: none;
        background: none;
        cursor: pointer;
        font-weight: 500;
        color: var(--label-color);
        border-bottom: 3px solid transparent;
        transition: color 0.2s, border-color 0.2s;
    }
    .payment-methods button.active {
        color: var(--primary-color);
        border-bottom-color: var(--primary-color);
    }
    .payment-form-content { display: none; }
    .payment-form-content.active { display: block; }
    .card-details-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
    .upi-details { text-align: center; }
    .upi-details img { max-width: 150px; margin-bottom: 15px; border-radius: 8px; }

    /* Confirmation Overlay */
    .confirmation-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(255, 255, 255, 0.9);
        z-index: 2000;
        justify-content: center;
        align-items: center;
        text-align: center;
        flex-direction: column;
    }
    .spinner {
        border: 4px solid rgba(0,0,0,0.1);
        width: 50px;
        height: 50px;
        border-radius: 50%;
        border-left-color: var(--primary-color);
        animation: spin 1s ease infinite;
    }
    .confirmation-overlay p { font-size: 1.2rem; font-weight: 500; margin-top: 20px; }
    @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

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
    .btn-secondary {
        color: #5E54D8;
        background-color: transparent;
        border: 1px solid #5E54D8;
    }
    .btn-secondary:hover {
        color: #fff;
        background-color: #5E54D8;
    }
    .btn-full {
        width: 100%;
        display: block;
    }
    
    @media (max-width: 992px) {
        .payment-container {
            flex-direction: column;
        }
        .payment-card-preview, .payment-form-section {
            flex-basis: auto;
        }
    }
</style>
</head>
<body>
    <div class="dashboard-wrapper">
        <c:set var="pageName" value="payments" scope="request" />
        <%@ include file="/common/header.jsp" %>

        <main class="main-content">
            <header class="content-header">
                <h1>Make a Payment</h1>
                <a href="payments" class="btn btn-secondary">Back to Payment History</a>
            </header>

            <div class="payment-container">
                <div class="payment-card-preview">
                    <div class="card-graphic">
                        <div class="chip"></div>
                        <div class="card-number-display" id="cardNumberDisplay">#### #### #### ####</div>
                        <div class="card-holder-info">
                            <div>
                                <small>Card Holder</small>
                                <div class="card-holder-name" id="cardHolderDisplay">FULL NAME</div>
                            </div>
                            <div class="card-logo">VISA</div>
                        </div>
                    </div>
                    <p style="font-size: 0.8rem; text-align: center; opacity: 0.7;">Your payment is secure and encrypted.</p>
                </div>

                <div class="payment-form-section">
                    <h2>Secure Payment</h2>
                    <div class="payment-methods">
                        <button class="payment-method-btn active" data-method="credit-card">Credit Card</button>
                        <button class="payment-method-btn" data-method="upi">UPI</button>
                        <button class="payment-method-btn" data-method="net-banking">Net Banking</button>
                    </div>

                    <form id="paymentForm" action="payments" method="post">
                        <input type="hidden" id="paymentMethod" name="paymentMethod" value="Credit Card">
                        <div class="form-group">
                            <label for="amount">Payment Amount (INR)</label>
                            <input type="number" step="0.01" id="amount" name="amount" class="form-control" value="${outstandingBalance}" required>
                        </div>

                        <!-- Credit Card Form -->
                        <div id="credit-card" class="payment-form-content active">
                            <div class="form-group">
                                <label for="cardName">Name on Card</label>
                                <input type="text" id="cardName" name="cardName" class="form-control" placeholder="John M. Doe">
                            </div>
                            <div class="form-group">
                                <label for="cardNumber">Card Number</label>
                                <input type="text" id="cardNumber" name="cardNumber" class="form-control" placeholder="1111-2222-3333-4444">
                            </div>
                            <div class="card-details-grid">
                                <div class="form-group">
                                    <label for="expiryDate">Expiry Date</label>
                                    <input type="text" id="expiryDate" name="expiryDate" class="form-control" placeholder="MM/YY">
                                </div>
                                <div class="form-group">
                                    <label for="cvc">CVC</label>
                                    <input type="text" id="cvc" name="cvc" class="form-control" placeholder="123">
                                </div>
                            </div>
                        </div>

                        <!-- UPI Form -->
                        <div id="upi" class="payment-form-content">
                             <div class="upi-details">
                                <%-- 
                                    NOTE FOR MOBILE TESTING:
                                    1. Your computer and phone MUST be on the same WiFi network.
                                    2. Find your computer's Local IP Address (e.g., 192.168.1.5).
                                       - On Windows, open Command Prompt and type: ipconfig
                                       - On Mac, open Terminal and type: ifconfig
                                    3. Replace "localhost" in the generated URL with your actual IP address.
                                       This is required for your phone to connect to your local server.
                                --%>
                                <c:url var="dummyUrl" value="dummy-payment.jsp">
                                    <c:param name="amount" value="${outstandingBalance}" />
                                </c:url>
                                <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/${dummyUrl}" alt="UPI QR Code">
                                
                                <p>Scan the code to confirm payment</p>
                                <strong>OR</strong>
                                <div class="form-group" style="margin-top: 15px;">
                                    <label for="upiId">Enter Your UPI ID</label>
                                    <input type="text" id="upiId" name="upiId" class="form-control" placeholder="yourname@bank">
                                </div>
                             </div>
                        </div>
                        
                        <!-- Net Banking Form -->
                        <div id="net-banking" class="payment-form-content">
                            <div class="form-group">
                                <label for="bank">Select Your Bank</label>
                                <select id="bank" name="bank" class="form-control">
                                    <option>State Bank of India</option>
                                    <option>HDFC Bank</option>
                                    <option>ICICI Bank</option>
                                    <option>Axis Bank</option>
                                    <option>Kotak Mahindra Bank</option>
                                    <option>Punjab National Bank</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="netBankingUser">User ID</label>
                                <input type="text" id="netBankingUser" name="netBankingUser" class="form-control">
                            </div>
                             <div class="form-group">
                                <label for="netBankingPass">Password</label>
                                <input type="password" id="netBankingPass" name="netBankingPass" class="form-control">
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-full" ${outstandingBalance <= 0 ? 'disabled' : ''}>
                            ${outstandingBalance <= 0 ? 'No Outstanding Balance' : 'Pay Now'}
                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <div class="confirmation-overlay" id="confirmationOverlay">
        <div class="spinner" id="spinner"></div>
        <p id="confirmationText">Processing your payment...</p>
    </div>

    <script>
        const paymentMethodInput = document.getElementById('paymentMethod');
        const methodBtns = document.querySelectorAll('.payment-method-btn');
        const formContents = document.querySelectorAll('.payment-form-content');
        
        methodBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const method = btn.dataset.method;
                paymentMethodInput.value = btn.textContent;
                
                methodBtns.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                
                formContents.forEach(content => {
                    content.classList.remove('active');
                    if (content.id === method) {
                        content.classList.add('active');
                    }
                });
            });
        });

        const cardNameInput = document.getElementById('cardName');
        const cardNumberInput = document.getElementById('cardNumber');
        const cardHolderDisplay = document.getElementById('cardHolderDisplay');
        const cardNumberDisplay = document.getElementById('cardNumberDisplay');

        cardNameInput.addEventListener('input', () => {
            cardHolderDisplay.textContent = cardNameInput.value.toUpperCase() || 'FULL NAME';
        });
        cardNumberInput.addEventListener('input', () => {
            let val = cardNumberInput.value.replace(/\D/g, '');
            let formatted = val.replace(/(\d{4})/g, '$1 ').trim();
            cardNumberDisplay.textContent = formatted || '#### #### #### ####';
        });
        
        const paymentForm = document.getElementById('paymentForm');
        const overlay = document.getElementById('confirmationOverlay');
        const amountInput = document.getElementById('amount');

        paymentForm.addEventListener('submit', function(e) {
            e.preventDefault();

            // Logic to prevent submitting zero or negative payment amounts
            const amount = parseFloat(amountInput.value);
            if (isNaN(amount) || amount <= 0) {
                alert('Please enter a valid payment amount greater than zero.');
                return;
            }

            overlay.style.display = 'flex';
            setTimeout(() => {
                paymentForm.submit();
            }, 2000);
        });
    </script>
</body>
</html>

