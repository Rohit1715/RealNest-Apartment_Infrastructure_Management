<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Forgot Password</title>
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
    }
    .subtitle {
        text-align: center;
        color: var(--label-color);
        margin-bottom: 30px;
    }
    .form-control {
        width: 100%;
        padding: 14px 18px;
        border: 1px solid var(--input-border-color);
        border-radius: 8px;
        box-sizing: border-box;
        font-family: 'Poppins', sans-serif;
        font-size: 0.95rem;
        margin-bottom: 20px;
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
    }
    .error-message {
        color: var(--error-color);
        text-align: center;
        margin-bottom: 15px;
    }
    /* NEW: Styles for role selection */
    .role-selection {
        display: flex;
        justify-content: center;
        margin-bottom: 20px;
    }
    .role-selection label {
        margin: 0 15px;
        cursor: pointer;
    }
</style>
</head>
<body>
    <div class="card">
        <h1>Forgot Your Password?</h1>
        <p class="subtitle">Enter your email and select your role to receive a verification code.</p>

        <c:if test="${not empty errorMessage}">
            <p class="error-message">${errorMessage}</p>
        </c:if>

        <form action="forgotPassword" method="post">
            <input type="email" class="form-control" name="email" placeholder="Enter your registered email" required>
            
            <!-- NEW: Role selection radio buttons -->
            <div class="role-selection">
                <label>
                    <input type="radio" name="role" value="TENANT" checked> I am a Tenant
                </label>
                <label>
                    <input type="radio" name="role" value="OWNER"> I am an Owner
                </label>
            </div>
            
            <button type="submit" class="btn-submit">Send Verification Code</button>
        </form>
    </div>
</body>
</html>

