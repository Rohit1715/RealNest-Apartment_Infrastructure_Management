<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login | RealNest</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-color: #7A52E7; /* Using the purple from your other pages */
        --primary-color-hover: #6941C6;
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
        max-height: 680px; /* Increased height slightly */
        background-color: var(--form-bg-color);
        border-radius: 20px;
        box-shadow: 0 20px 50px rgba(0,0,0,0.3);
        display: flex;
        overflow: hidden;
    }
    .image-section {
        width: 45%;
        background: url('images/apartment-bg.jpg') no-repeat center center;
        background-size: cover;
        position: relative;
        display: flex;
        flex-direction: column;
        justify-content: flex-end;
        padding: 40px;
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
        padding: 50px 60px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }
    .form-section h1 {
        font-size: 1.8rem;
        font-weight: 600;
        color: #fff;
    }
    .form-section .subtitle {
        color: var(--label-color);
        margin-bottom: 30px;
    }
    .form-group {
        margin-bottom: 20px;
        position: relative;
    }
    .form-control {
        width: 100%;
        padding: 14px 45px 14px 18px;
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
        top: 50%;
        right: 15px;
        transform: translateY(-50%);
        cursor: pointer;
        color: var(--label-color);
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
        background-color: var(--primary-color-hover);
    }
    .register-link {
        text-align: center;
        margin-top: 30px;
        font-size: 0.9rem;
    }
    .register-link a {
        color: var(--primary-color);
        text-decoration: none;
        font-weight: 500;
    }
    /* Styles for forgot password link and messages */
    .options-group {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 20px;
    }
    .options-group a {
        font-size: 0.9rem;
        color: var(--primary-color);
        text-decoration: none;
    }
    .message {
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 15px;
        text-align: center;
        font-size: 0.9rem;
    }
    .error-message {
        color: #ff9b9b;
        background-color: rgba(231, 76, 60, 0.15);
    }
    .success-message {
        color: #a6ffc9;
        background-color: rgba(39, 174, 96, 0.15);
    }
</style>
</head>
<body>
    <div class="main-container">
        <div class="image-section">
            <div class="text-content">
                <h2>Welcome Back</h2>
                <p>Login to access your dashboard and manage your apartment details seamlessly.</p>
            </div>
        </div>
        <div class="form-section">
            <h1>Sign In</h1>
            <p class="subtitle">Enter your credentials to continue.</p>
            
            <%-- Display Messages --%>
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
                <div class="message error-message"><%= errorMessage %></div>
            <%
                }
                String resetSuccess = request.getParameter("reset");
                if ("success".equals(resetSuccess)) {
            %>
                <div class="message success-message">Your password has been reset successfully. Please log in.</div>
            <%
                }
            %>

            <form action="login" method="post">
                <div class="form-group">
                    <input type="text" class="form-control" id="loginIdentifier" name="loginIdentifier" placeholder="Your Email or Username" required>
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                    <span class="password-toggle-icon" id="togglePassword">
                        <!-- Eye Icon -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-eye-fill" viewBox="0 0 16 16">
                          <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                          <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                        </svg>
                    </span>
                </div>
                
                <div class="options-group">
                    <a href="forgot-password.jsp">Forgot Password?</a>
                </div>
                
                <button type="submit" class="btn-submit">Login</button>
            </form>
            <div class="register-link">
                Don't have an account? <a href="register.jsp">Register</a>
            </div>
        </div>
    </div>
<script>
    const togglePassword = document.getElementById('togglePassword');
    const password = document.getElementById('password');
    const eyeIcon = `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-eye-fill" viewBox="0 0 16 16"><path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/><path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/></svg>`;
    const eyeSlashIcon = `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-eye-slash-fill" viewBox="0 0 16 16"><path d="m10.79 12.912-1.614-1.615a3.5 3.5 0 0 1-4.474-4.474l-2.06-2.06C.938 6.278 0 8 0 8s3 5.5 8 5.5a7.029 7.029 0 0 0 2.79-.588zM5.21 3.088A7.028 7.028 0 0 1 8 2.5c5 0 8 5.5 8 5.5s-.939 1.721-2.641 3.238l-2.062-2.062a3.5 3.5 0 0 0-4.474-4.474L5.21 3.089z"/><path d="M5.525 7.646a2.5 2.5 0 0 0 2.829 2.829l-2.83-2.829zm4.95.708-2.829-2.83a2.5 2.5 0 0 1 2.829 2.829zm3.171 6-12-12 .708-.708 12 12-.708.708z"/></svg>`;
    
    togglePassword.addEventListener('click', function () {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        
        // Switch the icon
        if (type === 'password') {
            this.innerHTML = eyeIcon;
        } else {
            this.innerHTML = eyeSlashIcon;
        }
    });
</script>
</body>
</html>

