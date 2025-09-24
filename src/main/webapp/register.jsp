<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create Account | Apartment Management</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-color: #6a5af9;
        --background-color: #1a1a2e;
        --form-bg-color: #24243e;
        --text-color: #e0e0e0;
        --label-color: #a0a0c0;
        --input-border-color: #40405c;
    }
    body, html {
        height: 100%;
        margin: 0;
        font-family: 'Poppins', sans-serif;
        background-color: var(--background-color);
        color: var(--text-color);
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .main-container {
        width: 100%;
        max-width: 980px;
        height: 90vh;
        max-height: 700px;
        background-color: var(--form-bg-color);
        border-radius: 20px;
        box-shadow: 0 20px 50px rgba(0,0,0,0.3);
        display: flex;
        overflow: hidden;
    }
    .image-section {
        width: 45%;
        background: url('images/apartment-bg2.jpg') no-repeat center center;
        background-size: cover;
        position: relative;
        display: flex;
        flex-direction: column;
        justify-content: flex-end;
        padding: 40px;
    }
    .image-overlay {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.2);
        backdrop-filter: blur(1px);
        -webkit-backdrop-filter: blur(1px);
    }
    .image-section .text-content {
        position: relative;
        z-index: 2;
        color: white;
    }
    .image-section h2 {
        font-size: 2.2rem;
        font-weight: 600;
        margin: 0 0 10px 0;
        text-shadow: 1px 1px 10px rgba(0,0,0,0.5);
    }
    .image-section p {
        font-size: 1rem;
        margin: 0;
        line-height: 1.6;
        text-shadow: 1px 1px 10px rgba(0,0,0,0.5);
    }
    .form-section {
        width: 55%;
        padding: 40px 60px;
        display: flex;
        flex-direction: column;
        overflow-y: auto;
    }
    .form-section h1 {
        font-size: 1.8rem;
        font-weight: 600;
        color: #fff;
    }
    .form-section .subtitle {
        color: var(--label-color);
        margin-bottom: 25px;
    }
    .form-group {
        margin-bottom: 15px;
        position: relative;
    }
    .form-group label {
        display: block;
        font-size: 0.9rem;
        color: var(--label-color);
        margin-bottom: 8px;
    }
    .form-control {
        width: 100%;
        padding: 12px 45px 12px 18px;
        border: 1px solid var(--input-border-color);
        border-radius: 8px;
        box-sizing: border-box;
        font-family: 'Poppins', sans-serif;
        font-size: 0.95rem;
        background-color: #1a1a2e;
        color: var(--text-color);
    }
     .form-control:focus {
        outline: none;
        border-color: var(--primary-color);
    }
    .password-toggle-icon {
        position: absolute;
        top: 70%;
        right: 15px;
        transform: translateY(-50%);
        cursor: pointer;
        color: var(--label-color);
    }
    .form-row {
        display: flex;
        gap: 20px;
    }
    .form-row .form-group {
        width: 50%;
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
        transition: background-color 0.3s;
        margin-top: 10px;
    }
    .btn-submit:hover {
        background-color: #5847d8;
    }
    .login-link {
        text-align: center;
        margin-top: 20px;
        font-size: 0.9rem;
        padding-bottom: 20px;
    }
    .login-link a {
        color: var(--primary-color);
        text-decoration: none;
        font-weight: 500;
    }
</style>
</head>
<body>
    <div class="main-container">
        <div class="image-section">
            <div class="image-overlay"></div>
            <div class="text-content">
                <h2>Join The Community</h2>
                <p>Create an account to get started with modern, efficient property management.</p>
            </div>
        </div>
        <div class="form-section">
            <h1>Create an Account</h1>
            <p class="subtitle">Let's get you set up.</p>
            <p style="color: #ff5c5c;">${errorMessage}</p>
            <form action="register" method="post" id="registrationForm">
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <input type="text" class="form-control" id="firstName" name="firstName" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" class="form-control" id="lastName" name="lastName" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" class="form-control" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters">
                    <span class="password-toggle-icon" id="togglePassword">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-eye-fill" viewBox="0 0 16 16">
                          <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                          <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                        </svg>
                    </span>
                </div>
                <div class="form-group">
                    <label for="mobile">Mobile Number</label>
                    <input type="tel" class="form-control" id="mobile" name="mobile" required pattern="[0-9]{10}" title="Please enter a 10-digit mobile number.">
                </div>
                <div class="form-group">
                    <label for="role">Register as</label>
                    <select id="role" name="role" class="form-control" required>
                        <option value="" disabled selected>-- Select a Role --</option>
                        <option value="OWNER">Owner</option>
                        <option value="TENANT">Tenant</option>
                    </select>
                </div>
                <button type="submit" class="btn-submit">Create Account</button>
            </form>
            <div class="login-link">
                Already have an account? <a href="login.jsp">Sign In</a>
            </div>
        </div>
    </div>
    <script>
        const togglePassword = document.querySelector('#togglePassword');
        const password = document.querySelector('#password');
        togglePassword.addEventListener('click', function (e) {
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);
            this.querySelector('svg').classList.toggle('bi-eye-slash-fill');
        });
    </script>
</body>
</html>
