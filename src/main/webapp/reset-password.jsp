<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reset Your Password</title>
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
        --success-color: #2ecc71;
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
        box-shadow: 0 8px 30px rgba(0,0,0,0.1);
        width: 100%;
        max-width: 420px;
        box-sizing: border-box;
    }
    h1 {
        font-size: 1.8rem;
        font-weight: 600;
        text-align: center;
        margin-bottom: 10px;
        color: var(--text-color);
    }
    .subtitle {
        text-align: center;
        color: var(--label-color);
        margin-bottom: 30px;
    }
    .form-group {
        margin-bottom: 20px;
        position: relative;
    }
    .form-control {
        width: 100%;
        padding: 14px 18px;
        border: 1px solid var(--input-border-color);
        border-radius: 8px;
        box-sizing: border-box;
        font-family: 'Poppins', sans-serif;
        font-size: 0.95rem;
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
        transition: background-color 0.3s, opacity 0.3s;
    }
    .btn-submit:hover {
        background-color: #5847d8;
    }
    .btn-submit:disabled {
        background-color: #ccc;
        cursor: not-allowed;
        opacity: 0.7;
    }
    .error-message {
        color: var(--error-color);
        text-align: center;
        margin-bottom: 15px;
    }
    .password-match-error {
        color: var(--error-color);
        font-size: 0.8rem;
        margin-top: 5px;
        height: 15px;
    }
    /* NEW: Styles for the password criteria checklist */
    .password-criteria {
        list-style: none;
        padding: 0;
        margin: 10px 0 0 0;
        font-size: 0.85rem;
    }
    .criterion {
        display: flex;
        align-items: center;
        margin-bottom: 5px;
        transition: color 0.3s;
    }
    .criterion.invalid {
        color: var(--error-color);
    }
    .criterion.valid {
        color: var(--success-color);
    }
    .criterion svg {
        margin-right: 8px;
        flex-shrink: 0;
    }
</style>
</head>
<body>
    <div class="card">
        <h1>Set New Password</h1>
        <p class="subtitle">Please enter your OTP and a new secure password.</p>

        <c:if test="${not empty errorMessage}">
            <p class="error-message">${errorMessage}</p>
        </c:if>

        <form action="resetPassword" method="post">
            <input type="hidden" name="email" value="${email}">
            <input type="hidden" name="role" value="${role}"> 
            <div class="form-group">
                <input type="text" class="form-control" name="otp" placeholder="Enter 6-digit OTP" required>
            </div>
            <div class="form-group">
                <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="New Password" required>
                <!-- NEW: Password criteria checklist -->
                <ul class="password-criteria" id="passwordCriteria">
                    <li id="length" class="criterion invalid">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
                        At least 8 characters
                    </li>
                    <li id="uppercase" class="criterion invalid">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
                        An uppercase letter
                    </li>
                    <li id="lowercase" class="criterion invalid">
                       <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
                        A lowercase letter
                    </li>
                    <li id="number" class="criterion invalid">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
                        A number
                    </li>
                    <li id="symbol" class="criterion invalid">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
                        A special symbol
                    </li>
                </ul>
            </div>
            <div class="form-group">
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm New Password" required>
                <div class="password-match-error" id="passwordMatchError"></div>
            </div>
            <button type="submit" class="btn-submit" id="submitBtn" disabled>Reset Password</button>
        </form>
    </div>

    <script>
        const newPasswordInput = document.getElementById('newPassword');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const submitBtn = document.getElementById('submitBtn');
        const passwordMatchError = document.getElementById('passwordMatchError');

        // NEW: Get references to criteria list items
        const criteria = {
            length: document.getElementById('length'),
            uppercase: document.getElementById('uppercase'),
            lowercase: document.getElementById('lowercase'),
            number: document.getElementById('number'),
            symbol: document.getElementById('symbol')
        };

        // NEW: Regular expressions for validation
        const regex = {
            uppercase: /[A-Z]/,
            lowercase: /[a-z]/,
            number: /[0-9]/,
            symbol: /[^A-Za-z0-9]/
        };

        function validateForm() {
            const password = newPasswordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            // NEW: Validate each criterion and update UI
            const isLengthValid = password.length >= 8;
            const hasUppercase = regex.uppercase.test(password);
            const hasLowercase = regex.lowercase.test(password);
            const hasNumber = regex.number.test(password);
            const hasSymbol = regex.symbol.test(password);

            updateCriterionUI('length', isLengthValid);
            updateCriterionUI('uppercase', hasUppercase);
            updateCriterionUI('lowercase', hasLowercase);
            updateCriterionUI('number', hasNumber);
            updateCriterionUI('symbol', hasSymbol);

            // Check if passwords match
            if (confirmPassword.length > 0 && password !== confirmPassword) {
                passwordMatchError.textContent = "Passwords do not match.";
            } else {
                passwordMatchError.textContent = "";
            }

            // Enable button only if all conditions are met
            const allCriteriaMet = isLengthValid && hasUppercase && hasLowercase && hasNumber && hasSymbol;
            const passwordsMatch = password === confirmPassword;
            
            submitBtn.disabled = !(allCriteriaMet && passwordsMatch && password.length > 0);
        }

        // NEW: Helper function to update the UI for a criterion
        function updateCriterionUI(criterionName, isValid) {
            const element = criteria[criterionName];
            if (isValid) {
                element.classList.remove('invalid');
                element.classList.add('valid');
            } else {
                element.classList.remove('valid');
                element.classList.add('invalid');
            }
        }

        newPasswordInput.addEventListener('input', validateForm);
        confirmPasswordInput.addEventListener('input', validateForm);
    </script>
</body>
</html>

