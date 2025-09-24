<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard | RealNest</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
    /* --- MODERN UI UPGRADE FOR DASHBOARD --- */

    /* 1. Main Layout & Background */
    .main-content {
        background-color: #f8fafc; /* A very light, clean grey */
        padding: 40px;
    }

    /* 2. Redesigned Welcome Section */
    .welcome-section {
        display: flex;
        gap: 40px;
        align-items: center;
        margin-bottom: 50px;
        opacity: 0;
        transform: translateY(20px);
        animation: fadeInUp 0.8s 0.2s ease-out forwards;
        background: #fff;
        border-radius: 20px;
        padding: 40px;
        border: 1px solid #e2e8f0;
    }
    .welcome-text {
        flex: 1;
    }
    .welcome-text .sub-heading {
        font-weight: 500;
        color: #64748b;
        margin-bottom: 10px;
        text-transform: uppercase;
        letter-spacing: 1px;
    }
    .welcome-text h1 {
        font-size: 3.5rem;
        font-weight: 700;
        margin: 0 0 15px 0;
        line-height: 1.2;
        color: #1e293b;
    }
    .welcome-text p {
        font-size: 1.1rem;
        color: #64748b;
        max-width: 450px;
        margin-bottom: 30px;
    }
    .welcome-image {
        flex-basis: 60%;
        min-width: 500px;
        height: 450px;
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 20px 40px -10px rgba(0,0,0,0.2);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .welcome-image:hover {
        transform: scale(1.02);
        box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);
    }
    .welcome-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    /* 3. Quick Actions Section */
    .quick-actions { display: flex; gap: 15px; }
    .action-button {
        display: flex; align-items: center; padding: 12px 20px; border-radius: 12px;
        text-decoration: none; font-weight: 500; transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0,0,0,0.05);
    }
    .action-button svg { margin-right: 10px; }
    .action-button.primary { background: linear-gradient(135deg, #6a5af9, #8b5cf6); color: white; }
    .action-button.primary:hover { transform: translateY(-2px); box-shadow: 0 7px 14px rgba(106, 90, 249, 0.3); }
    .action-button.secondary { background-color: #fff; color: #334155; border: 1px solid #e2e8f0; }
    .action-button.secondary:hover { background-color: #f8fafc; transform: translateY(-2px); box-shadow: 0 7px 14px rgba(0,0,0,0.05); }

    /* 4. Summary Cards */
    .card-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin-top: 50px; }
    .card {
        background-color: #ffffff; padding: 25px; border-radius: 15px; border: 1px solid #e2e8f0;
        opacity: 0; transform: translateY(20px); animation: fadeInUp 0.6s ease-out forwards;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.07); }
    .card-header { display: flex; align-items: center; margin-bottom: 15px; }
    .card-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; margin-right: 15px; }
    .card-icon.icon-rent { background-color: #eef2ff; color: #4f46e5; }
    .card-icon.icon-complaint { background-color: #fff1f2; color: #e11d48; }
    .card-icon.icon-notice { background-color: #fefce8; color: #ca8a04; }
    .card-icon.icon-tenant { background-color: #f0fdf4; color: #16a34a; }
    .card-icon.icon-property { background-color: #f0f9ff; color: #0284c7; }
    .card-icon.icon-revenue { background-color: #f0fdf4; color: #16a34a; }
    .card-title { font-weight: 600; font-size: 1rem; color: #334155; }
    .card-body .value { font-size: 2.2rem; font-weight: 700; margin-bottom: 5px; color: #1e293b; }
    .card-body .description { font-size: 0.9rem; color: #64748b; }

    /* 5. Apartment Portfolio Section */
    .portfolio-section {
        margin-top: 50px;
        opacity: 0;
        transform: translateY(20px);
        animation: fadeInUp 0.8s 0.6s ease-out forwards;
    }
    .portfolio-section h2 { font-size: 2.5rem; font-weight: 700; margin-bottom: 25px; color: #1e293b; text-align: center;}
    .portfolio-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; }
    .portfolio-card {
        background: #fff; border-radius: 15px; overflow: hidden;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #e2e8f0;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .portfolio-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.07); }
    .portfolio-card img { width: 100%; height: 220px; object-fit: cover; }
    .portfolio-info { padding: 20px; }
    .portfolio-info h3 { margin: 0 0 15px 0; font-size: 1.2rem; color: #1e293b; }
    .portfolio-details { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #e2e8f0; padding-top: 15px; }
    .detail-item { text-align: center; }
    .detail-item strong { display: block; font-size: 1rem; color: #334155; }
    .detail-item span { font-size: 0.85rem; color: #64748b; }
    
    /* 6. Facilities Section */
    .facilities-section {
        margin-top: 50px;
        opacity: 0;
        transform: translateY(20px);
        animation: fadeInUp 0.8s 0.8s ease-out forwards;
    }
    .facilities-section h2 { font-size: 2.5rem; font-weight: 700; margin-bottom: 25px; color: #1e293b; text-align: center;}
    .facilities-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 25px; }
    .facility-card {
        background: #fff;
        padding: 25px;
        border-radius: 15px;
        border: 1px solid #e2e8f0;
        text-align: center;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .facility-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.07); }
    .facility-icon {
        background-color: #eef2ff;
        color: #4f46e5;
        width: 60px;
        height: 60px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 15px;
    }
    .facility-card h3 { font-size: 1.2rem; margin: 0 0 10px 0; color: #1e293b;}
    .facility-card p { margin: 0; color: #64748b; font-size: 0.9rem; }

    /* 7. Footer v3 - Compact and Simple --- NEWLY UPDATED --- */
    .site-footer {
        background-color: #212529; /* Darker, simpler background */
        color: #adb5bd; /* Softer text color */
        padding: 20px 40px; /* Compact padding */
        position: relative;
        margin-top: auto;
        border-top: 1px solid #343a40;
        
        /* --- Styles for scroll behavior --- */
        opacity: 0;
        transform: translateY(100px);
        visibility: hidden;
        transition: opacity 0.6s ease-out, transform 0.6s ease-out, visibility 0.6s;
    }
    .site-footer.footer-visible {
        opacity: 1;
        transform: translateY(0);
        visibility: visible;
    }
    
    .footer-container {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .footer-brand {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .footer-brand .logo {
        font-size: 1.5rem;
        font-weight: 600;
        color: #fff;
        text-decoration: none;
        margin: 0;
    }
    .footer-brand .copyright {
        font-size: 0.9rem;
        border-left: 1px solid #495057;
        padding-left: 12px;
    }

    .footer-links {
        display: flex;
        gap: 25px;
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .footer-links a {
        color: #adb5bd;
        text-decoration: none;
        font-size: 0.9rem;
        transition: color 0.3s ease;
    }
    .footer-links a:hover {
        color: #fff;
    }

    /* Floating Action Button (FAB) for Chat */
    .chat-fab {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 56px;
        height: 56px;
        background: #ef4444;
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        z-index: 1000;
        transition: transform 0.3s ease-out, opacity 0.3s ease-out;
        transform: scale(0);
        opacity: 0;
    }
    .chat-fab.fab-visible {
        transform: scale(1);
        opacity: 1;
    }

    /* Animation Keyframes */
    @keyframes fadeInUp { to { opacity: 1; transform: translateY(0); } }

    /* Responsive adjustments */
    @media (max-width: 992px) {
        .welcome-section { flex-direction: column-reverse; text-align: center; }
        .welcome-text p { margin-left: auto; margin-right: auto; }
        .welcome-image { min-width: 100%; height: 300px; }
        .quick-actions { justify-content: center; }
        .portfolio-grid { grid-template-columns: 1fr; }
        
        .footer-container {
            flex-direction: column;
            gap: 20px;
        }
        .footer-brand {
            flex-direction: column;
            gap: 10px;
        }
        .footer-brand .copyright {
            border-left: none;
            padding-left: 0;
        }
    }

</style>
</head>
<body>
    <div class="dashboard-wrapper">
        <c:set var="pageName" value="dashboard" scope="request" />
        <%@ include file="/common/header.jsp" %>
        
        <main class="main-content">
            <header class="content-header" style="display: none;"><h1>Dashboard</h1></header>
            
            <div class="welcome-section">
                <div class="welcome-text">
                    <p class="sub-heading">Building Your Dreams</p>
                    <h1>
                        <c:if test="${sessionScope.user.role == 'TENANT'}">Welcome Back, <c:out value="${sessionScope.user.firstName}" />!</c:if>
                        <c:if test="${sessionScope.user.role == 'OWNER'}">Welcome, <c:out value="${sessionScope.user.firstName}" />!</c:if>
                    </h1>
                    <p>
                        <c:if test="${sessionScope.user.role == 'TENANT'}">Your personal hub for everything related to your home. Pay rent, file complaints, and stay updated with notices.</c:if>
                        <c:if test="${sessionScope.user.role == 'OWNER'}">Here is an overview of your properties and tenant activities.</c:if>
                    </p>
                    <div class="quick-actions">
                        <c:if test="${sessionScope.user.role == 'TENANT'}">
                            <a href="${pageContext.request.contextPath}/make-payment" class="action-button primary"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M11 5.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1-.5-.5v-1z"/><path d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v1.5a.5.5 0 0 1-1 0V2a1 1 0 0 0-1-1H4a1 1 0 0 0-1 1v10a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V9.5a.5.5 0 0 1 1 0V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2z"/><path d="M2 5.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z"/></svg> Pay Rent</a>
                            <a href="${pageContext.request.contextPath}/complaints" class="action-button secondary"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M16 2a2 2 0 0 0-2-2H2a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h9.586a1 1 0 0 1 .707.293l2.853 2.853a.5.5 0 0 0 .854-.353V2zM3.5 3h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1 0-1zm0 2.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1 0-1zm0 2.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1 0-1z"/></svg> File Complaint</a>
                        </c:if>
                        <c:if test="${sessionScope.user.role == 'OWNER'}">
                            <a href="${pageContext.request.contextPath}/my-properties" class="action-button primary">View Properties</a>
                            <a href="${pageContext.request.contextPath}/owner-tenants" class="action-button secondary">Manage Tenants</a>
                        </c:if>
                    </div>
                </div>
                <div class="welcome-image">
                    <c:if test="${sessionScope.user.role == 'TENANT'}"><img src="https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=2070&auto=format&fit=crop" alt="Modern Apartment Interior"></c:if>
                     <c:if test="${sessionScope.user.role == 'OWNER'}"><img src="https://images.unsplash.com/photo-1580587771525-78b9dba3b914?q=80&w=1974&auto=format&fit=crop" alt="Luxury House Exterior"></c:if>
                </div>
            </div>
            
            <div class="card-grid">
                <c:if test="${sessionScope.user.role == 'TENANT'}">
                    <div class="card" style="animation-delay: 0.4s;">
                        <div class="card-header">
                            <div class="card-icon icon-rent"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-wallet2" viewBox="0 0 16 16"><path d="M12.136.326A1.5 1.5 0 0 1 14 1.78V3h.5A1.5 1.5 0 0 1 16 4.5v7a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 0 11.5v-7A1.5 1.5 0 0 1 1.5 3H2V1.78a1.5 1.5 0 0 1 1.447-1.474l8-1a1.5 1.5 0 0 1 1.189.524zM3.5 3h9a.5.5 0 0 0 0-1h-9a.5.5 0 0 0 0 1zM2 5.5a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-2z"/></svg></div>
                            <span class="card-title">My Rent Dues</span>
                        </div>
                        <div class="card-body">
                            <div class="value animate-number" data-target="${empty sessionScope.rentDues ? 0 : sessionScope.rentDues}" data-currency="true">
                                <fmt:formatNumber value="${empty sessionScope.rentDues ? 0 : sessionScope.rentDues}" type="currency" currencyCode="INR" />
                            </div>
                            <div class="description">Current outstanding balance</div>
                        </div>
                    </div>
                    <div class="card" style="animation-delay: 0.5s;">
                        <div class="card-header">
                            <div class="card-icon icon-complaint"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-chat-right-quote" viewBox="0 0 16 16"><path d="M2 1a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h9.586a2 2 0 0 1 1.414.586l2 2V2a1 1 0 0 0-1-1H2zm3.5 4a.5.5 0 0 1 0-1h4a.5.5 0 0 1 0 1h-4zm0 2a.5.5 0 0 1 0-1h2a.5.5 0 0 1 0 1h-2z"/><path d="M13 3a1 1 0 0 1 1 1v2.414L11.414 8H9.5A.5.5 0 0 1 9 7.5V5.5A.5.5 0 0 1 9.5 5H11V4a1 1 0 0 1 1-1z"/></svg></div>
                            <span class="card-title">Open Complaints</span>
                        </div>
                        <div class="card-body">
                            <div class="value animate-number" data-target="${empty sessionScope.openComplaints ? 0 : sessionScope.openComplaints}">
                                <c:out value="${empty sessionScope.openComplaints ? 0 : sessionScope.openComplaints}" />
                            </div>
                            <div class="description">Currently active issues</div>
                        </div>
                    </div>
                    <div class="card" style="animation-delay: 0.6s;">
                        <div class="card-header">
                            <div class="card-icon icon-notice"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bell" viewBox="0 0 16 16"><path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zM8 1.918l-.797.161A4.002 4.002 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4.002 4.002 0 0 0-3.203-3.92L8 1.917zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5.002 5.002 0 0 1 13 6c0 .88.32 4.2 1.22 6z"/></svg></div>
                            <span class="card-title">Recent Notices</span>
                        </div>
                        <div class="card-body">
                            <div class="value animate-number" data-target="${empty sessionScope.recentNotices ? 0 : sessionScope.recentNotices}">
                                <c:out value="${empty sessionScope.recentNotices ? 0 : sessionScope.recentNotices}" />
                            </div>
                            <div class="description">New updates from management</div>
                        </div>
                    </div>
                </c:if>
                <c:if test="${sessionScope.user.role == 'OWNER'}">
                     <div class="card" style="animation-delay: 0.4s;">
                        <div class="card-header">
                            <div class="card-icon icon-tenant"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-people" viewBox="0 0 16 16"><path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.274.274H7.022zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM6.957 11.27A5.996 5.996 0 0 0 7 11c-2.685 0-4.5 2-4.5 4 0 .524.225.983.622 1.294A6.967 6.967 0 0 1 5 11.27zM4.5 9a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z"/></svg></div>
                            <span class="card-title">Total Tenants</span>
                        </div>
                        <div class="card-body">
                            <div class="value animate-number" data-target="${empty sessionScope.totalTenants ? 0 : sessionScope.totalTenants}">
                                <c:out value="${empty sessionScope.totalTenants ? 0 : sessionScope.totalTenants}" />
                            </div>
                            <div class="description">Across all your properties</div>
                        </div>
                    </div>
                    <div class="card" style="animation-delay: 0.5s;">
                        <div class="card-header">
                            <div class="card-icon icon-rent"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-currency-dollar" viewBox="0 0 16 16"><path d="M4 10.781c.148 1.667 1.513 2.85 3.591 2.85c2.08 0 3.473-1.185 3.473-2.85c0-1.583-1.146-2.316-2.9-2.75l-.75-.187c-1.135-.283-1.446-1.116-1.446-1.807c0-.736.637-1.296 1.743-1.296c1.026 0 1.613.522 1.743 1.296h1.92c-.126-1.633-1.54-2.85-3.67-2.85c-2.015 0-3.428 1.185-3.428 2.85c0 1.488 1.053 2.318 2.834 2.753l.75.187c1.334.33 1.616 1.205 1.616 1.872c0 .788-.702 1.34-1.854 1.34c-1.135 0-1.854-.537-1.92-1.34H4zM8 13.25c-3.328 0-6-2.67-6-5.99c0-2.05.994-3.832 2.55-4.995a.5.5 0 1 1 .5 1a5.002 5.002 0 0 0-2.05 4c0 3.1 2.373 5.5 5.5 5.5c3.128 0 5.5-2.4 5.5-5.5c0-.925-.26-1.785-.68-2.524a.5.5 0 1 1 .84-.53c.48 1 .84 2.11.84 3.274c0 3.32-2.672 5.99-6 5.99z"/></svg></div>
                            <span class="card-title">Unpaid Rents</span>
                        </div>
                        <div class="card-body">
                            <div class="value animate-number" data-target="${empty sessionScope.unpaidRents ? 0 : sessionScope.unpaidRents}">
                                <c:out value="${empty sessionScope.unpaidRents ? 0 : sessionScope.unpaidRents}" />
                            </div>
                            <div class="description">Tenants with balance due</div>
                        </div>
                    </div>
                    <div class="card" style="animation-delay: 0.6s;">
                        <div class="card-header">
                            <div class="card-icon icon-complaint"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-chat-square-dots" viewBox="0 0 16 16"><path d="M14 1a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1h-2.5a2 2 0 0 0-1.6.8L8 14.333 6.1 11.8a2 2 0 0 0-1.6-.8H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h2.5a1 1 0 0 1 .8.4l1.9 2.533a1 1 0 0 0 1.6 0l1.9-2.533a1 1 0 0 1 .8-.4H14a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path d="M5 6.5a.5.5 0 0 1 .5-.5h.01a.5.5 0 0 1 0 1H5.5a.5.5 0 0 1-.5-.5zM8 6.5a.5.5 0 0 1 .5-.5h.01a.5.5 0 0 1 0 1H8.5a.5.5 0 0 1-.5-.5zm3.5 0a.5.5 0 0 1 .5-.5h.01a.5.5 0 0 1 0 1H11.5a.5.5 0 0 1-.5-.5z"/></svg></div>
                            <span class="card-title">Open Complaints</span>
                        </div>
                        <div class="card-body">
                            <div class="value animate-number" data-target="${empty sessionScope.openComplaints ? 0 : sessionScope.openComplaints}">
                               <c:out value="${empty sessionScope.openComplaints ? 0 : sessionScope.openComplaints}" />
                            </div>
                            <div class="description">From your tenants</div>
                        </div>
                    </div>
                </c:if>
            </div>
            
            <div class="portfolio-section">
                <h2>Explore Our Property Portfolio</h2>
                <div class="portfolio-grid">
                    <div class="portfolio-card"><img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2070&auto=format&fit=crop" alt="Property"><div class="portfolio-info"><h3>Azure Heights Residences</h3><div class="portfolio-details"><div class="detail-item"><strong>₹2.5 Cr</strong><span>Price</span></div><div class="detail-item"><strong>10%</strong><span>Installment</span></div><div class="detail-item"><strong>09/2025</strong><span>Handover</span></div></div></div></div>
                    <div class="portfolio-card"><img src="https://images.unsplash.com/photo-1600585154526-990dced4db0d?q=80&w=1974&auto=format&fit=crop" alt="Property"><div class="portfolio-info"><h3>Emerald Bay Apartments</h3><div class="portfolio-details"><div class="detail-item"><strong>₹1.8 Cr</strong><span>Price</span></div><div class="detail-item"><strong>15%</strong><span>Installment</span></div><div class="detail-item"><strong>12/2024</strong><span>Handover</span></div></div></div></div>
                    <div class="portfolio-card"><img src="images/meadows.jpg" alt="Property"><div class="portfolio-info"><h3>The Grand Meadows</h3><div class="portfolio-details"><div class="detail-item"><strong>₹3.2 Cr</strong><span>Price</span></div><div class="detail-item"><strong>10%</strong><span>Installment</span></div><div class="detail-item"><strong>03/2026</strong><span>Handover</span></div></div></div></div>
                    <div class="portfolio-card"><img src="https://images.unsplash.com/photo-1494203484021-3c454daf695d?q=80&w=2070&auto=format&fit=crop" alt="Property"><div class="portfolio-info"><h3>Skyline Towers</h3><div class="portfolio-details"><div class="detail-item"><strong>₹2.1 Cr</strong><span>Price</span></div><div class="detail-item"><strong>20%</strong><span>Installment</span></div><div class="detail-item"><strong>06/2025</strong><span>Handover</span></div></div></div></div>
                    <div class="portfolio-card"><img src="https://images.unsplash.com/photo-1572120360610-d971b9d7767c?q=80&w=2070&auto=format&fit=crop" alt="Property"><div class="portfolio-info"><h3>Oceanview Villas</h3><div class="portfolio-details"><div class="detail-item"><strong>₹4.5 Cr</strong><span>Price</span></div><div class="detail-item"><strong>10%</strong><span>Installment</span></div><div class="detail-item"><strong>01/2027</strong><span>Handover</span></div></div></div></div>
                    <div class="portfolio-card"><img src="https://images.unsplash.com/photo-1558036117-15d82a90b9b1?q=80&w=1965&auto=format&fit=crop" alt="Property"><div class="portfolio-info"><h3>Maple Creek Homes</h3><div class="portfolio-details"><div class="detail-item"><strong>₹1.5 Cr</strong><span>Price</span></div><div class="detail-item"><strong>25%</strong><span>Installment</span></div><div class="detail-item"><strong>Ready</strong><span>Handover</span></div></div></div></div>
                </div>
            </div>
            
            <div class="facilities-section">
                <h2>Our World-Class Facilities</h2>
                <div class="facilities-grid">
                    <div class="facility-card"><div class="facility-icon"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-lightbulb" viewBox="0 0 16 16"><path d="M2 6a6 6 0 1 1 10.174 4.31c-.203.196-.359.4-.453.619l-.762 1.769A.5.5 0 0 1 10.5 13h-5a.5.5 0 0 1-.46-.302l-.761-1.77a1.964 1.964 0 0 0-.453-.618A5.984 5.984 0 0 1 2 6zm6 8.5a.5.5 0 0 1 .5-.5h.5a.5.5 0 0 1 0 1h-.5a.5.5 0 0 1-.5-.5z"/></svg></div><h3>Best Interior Design</h3><p>Modern, aesthetic interiors designed for comfort and style in every apartment.</p></div>
                    <div class="facility-card"><div class="facility-icon"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-tree" viewBox="0 0 16 16"><path d="M8.416.223a.5.5 0 0 0-.832 0l-3 4.5A.5.5 0 0 0 5 5.5h.098L3.076 8.735A.5.5 0 0 0 3.5 9.5h.191l-1.638 3.276a.5.5 0 0 0 .447.724H7V16h2v-2.5h4.5a.5.5 0 0 0 .447-.724L12.31 9.5h.191a.5.5 0 0 0 .424-.765L10.902 5.5H11a.5.5 0 0 0 .416-.777l-3-4.5zM6.437 4.75h3.126L8 1.171 6.437 4.75zM3.5 10l1.03-2.06h7l1.03 2.06H3.5z"/></svg></div><h3>Gardens & Parks</h3><p>Lush green spaces and beautifully landscaped parks for relaxation and recreation.</p></div>
                    <div class="facility-card"><div class="facility-icon"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-droplet-half" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M7.21.8C7.69.295 8 0 8 0c.109.363.234.708.371 1.038.812 1.946 2.073 3.35 3.197 4.6C12.878 7.096 14 8.345 14 10a6 6 0 0 1-12 0C2 6.668 5.58 2.517 7.21.8zm.413 1.021A31.25 31.25 0 0 0 5.794 3.748c-.996 1.127-2.006 2.32-2.786 3.465C2.313 8.24 2 9.072 2 10a5 5 0 0 0 10 0c0-1.113-.318-2.028-.832-3.018-.833-1.076-2-2.3-3-3.489z"/></svg></div><h3>Swimming Pool</h3><p>A state-of-the-art swimming pool for a refreshing escape from the everyday.</p></div>
                    <div class="facility-card"><div class="facility-icon"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-heart-pulse" viewBox="0 0 16 16"><path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.05c-1.114 2.172-.239 4.823 2.22 6.342L8 13.192l4.38-3.799c2.459-1.52 3.334-4.17 2.22-6.342C13.486.878 10.4.281 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17c4.545-4.183 15.157 3.73 7.824 13.857L8 15z"/><path d="M10.464 3.314a.5.5 0 0 0-.945.049L7.921 8.956 6.464 5.314a.5.5 0 0 0-.945.049L3.536 11H2.5a.5.5 0 0 0 0 1h2a.5.5 0 0 0 .464-.314L6.21 8.044l1.5 3.5a.5.5 0 0 0 .945-.049l1.585-5.283 1.115 3.967a.5.5 0 0 0 .945-.049L13.5 4H14.5a.5.5 0 0 0 0-1h-2.146z"/></svg></div><h3>Fitness Center</h3><p>A fully equipped gym with modern machines to help you stay fit and healthy.</p></div>
                </div>
            </div>
        </main>
    </div>

    <footer class="site-footer">
        <div class="footer-container">
            <div class="footer-brand">
                <a href="#" class="logo">RealNest</a>
                <span class="copyright">&copy; 2025 All Rights Reserved.</span>
            </div>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/make-payment">Pay Rent</a></li>
                <li><a href="${pageContext.request.contextPath}/complaints">Complaints</a></li>
                <li><a href="#">Contact Us</a></li>
                <li><a href="#">Privacy Policy</a></li>
            </ul>
        </div>
    </footer>

    <a href="#" class="chat-fab" aria-label="Open Chat">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
            <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2.5a1 1 0 0 0-.8.4l-1.9 2.533a1 1 0 0 1-1.6 0L5.3 12.4a1 1 0 0 0-.8-.4H2a2 2 0 0 1-2-2V2zm5 4a1 1 0 1 0-2 0 1 1 0 0 0 2 0zm4 0a1 1 0 1 0-2 0 1 1 0 0 0 2 0zm3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
        </svg>
    </a>
    
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // Card Number Animation Script
            const animateValue = (el, start, end, duration, isCurrency) => {
                if (start === end) {
                    if (isCurrency) { el.textContent = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(end); } 
                    else { el.textContent = end; }
                    return;
                }
                const startTime = performance.now();
                const formatCurrency = (value) => new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(value);
                const step = (currentTime) => {
                    const elapsedTime = currentTime - startTime;
                    const progress = Math.min(elapsedTime / duration, 1);
                    const currentValue = start + (end - start) * progress;
                    if (isCurrency) { el.textContent = formatCurrency(currentValue); } 
                    else { el.textContent = Math.ceil(currentValue); }
                    if (progress < 1) { requestAnimationFrame(step); } 
                    else {
                        if (isCurrency) { el.textContent = formatCurrency(end); } 
                        else { el.textContent = end; }
                    }
                };
                requestAnimationFrame(step);
            };
            
            const numberElements = document.querySelectorAll('.animate-number');
            numberElements.forEach(el => {
                const targetValue = parseFloat(el.dataset.target);
                const isCurrency = el.dataset.currency === 'true';
                if (!isNaN(targetValue)) {
                    animateValue(el, 0, targetValue, 1200, isCurrency);
                }
            });

            // --- Footer Visibility on Scroll Script ---
            const footer = document.querySelector('.site-footer');
            const fab = document.querySelector('.chat-fab');
            const showFooterOnScroll = () => {
                const isAtBottom = (window.innerHeight + window.scrollY) >= document.body.offsetHeight - 50;
                
                if (isAtBottom) {
                    footer.classList.add('footer-visible');
                    fab.classList.add('fab-visible');
                } else {
                    footer.classList.remove('footer-visible');
                    fab.classList.remove('fab-visible');
                }
            };
            window.addEventListener('scroll', showFooterOnScroll);
        });
    </script>

</body>
</html>

