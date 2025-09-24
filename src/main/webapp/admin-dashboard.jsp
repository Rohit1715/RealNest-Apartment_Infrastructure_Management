<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard | RealNest</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        flex-basis: 45%;
        height: 350px;
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .welcome-image:hover {
        transform: scale(1.02);
        box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);
    }
    .welcome-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }


    /* 4. Summary Cards */
    .card-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; }
    .card {
        background-color: #ffffff; padding: 25px; border-radius: 15px; border: 1px solid #e2e8f0;
        opacity: 0; transform: translateY(20px); animation: fadeInUp 0.6s ease-out forwards;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.07); }
    .card-header { display: flex; align-items: center; margin-bottom: 15px; }
    .card-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; margin-right: 15px; }
    .card-icon.icon-complaint { background-color: #fff1f2; color: #e11d48; }
    .card-icon.icon-property { background-color: #f0f9ff; color: #0284c7; }
    .card-icon.icon-revenue { background-color: #f0fdf4; color: #16a34a; }
    .card-title { font-weight: 600; font-size: 1rem; color: #334155; }
    .card-body .value { font-size: 2.2rem; font-weight: 700; margin-bottom: 5px; color: #1e293b; }
    .card-body .description { font-size: 0.9rem; color: #64748b; }

    /* Animation Keyframes */
    @keyframes fadeInUp { to { opacity: 1; transform: translateY(0); } }

    /* Chart Styles */
    .chart-grid {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 25px;
        margin-top: 50px;
    }
    .chart-container {
        background: #fff;
        padding: 25px;
        border-radius: 15px;
        border: 1px solid #e2e8f0;
        opacity: 0;
        transform: translateY(20px);
        animation: fadeInUp 0.8s 0.4s ease-out forwards;
    }
    .chart-container h3 {
        margin-top: 0;
        margin-bottom: 20px;
        font-size: 1.2rem;
        font-weight: 600;
        color: #334155;
    }
    @media (max-width: 992px) {
        .welcome-section {
            flex-direction: column;
            text-align: center;
        }
        .chart-grid {
            grid-template-columns: 1fr;
        }
    }

</style>
</head>
<body>
    <div class="dashboard-wrapper">
        <c:set var="pageName" value="dashboard" scope="request" />
        <%@ include file="/common/header.jsp" %>
        
        <main class="main-content">
            <header class="content-header" style="display: none;"><h1>Admin Dashboard</h1></header>
            
            <div class="welcome-section">
                <div class="welcome-text">
                    <p class="sub-heading">Management Overview</p>
                    <h1>Welcome, Admin!</h1>
                    <p>Here's a summary of the key metrics for the RealNest platform.</p>
                </div>
                <div class="welcome-image">
                    <img src="${pageContext.request.contextPath}/images/admin.webp" alt="Admin Dashboard Illustration">
                </div>
            </div>

            <div class="card-grid">
                <div class="card" style="animation-delay: 0.4s;">
                    <div class="card-header">
                        <div class="card-icon icon-property"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-building" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M14.763.075A.5.5 0 0 1 15 .5v15a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5V14h-1v1.5a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5V14h-1v1.5a.5.5 0 0 1-.5.5H1a.5.5 0 0 1-.5-.5v-15a.5.5 0 0 1 .237-.425l4.5-3a.5.5 0 0 1 .526 0l4.5 3 .474.316zM11.5 13V2.889l-3-2V13h3zm-4 0V.889l-3 2V13h3zM3 13V3.764l1-.667V13H3zm10 0V3.097l-1 .667V13h1z"/><path d="M2 11h1v1H2v-1zm2 0h1v1H4v-1zm-2 2h1v1H2v-1zm2 0h1v1H4v-1zm4-4h1v1H8V9zm2 0h1v1h-1V9zm-2 2h1v1H8v-1zm2 0h1v1h-1v-1zm2-2h1v1h-1V9zm0 2h1v1h-1v-1zM8 7h1v1H8V7zm2 0h1v1h-1V7zm2 0h1v1h-1V7zM8 5h1v1H8V5zm2 0h1v1h-1V5zm2 0h1v1h-1V5zm0-2h1v1h-1V3z"/></svg></div>
                        <span class="card-title">Total Properties</span>
                    </div>
                    <div class="card-body">
                        <div class="value animate-number" data-target="${empty sessionScope.totalProperties ? 0 : sessionScope.totalProperties}">
                            <c:out value="${empty sessionScope.totalProperties ? 0 : sessionScope.totalProperties}" />
                        </div>
                        <div class="description">Managed across the platform</div>
                    </div>
                </div>
                <div class="card" style="animation-delay: 0.5s;">
                    <div class="card-header">
                        <div class="card-icon icon-complaint"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-exclamation-octagon" viewBox="0 0 16 16"><path d="M4.54.146A.5.5 0 0 1 4.893 0h6.214a.5.5 0 0 1 .353.146l4.394 4.394a.5.5 0 0 1 .146.353v6.214a.5.5 0 0 1-.146.353l-4.394 4.394a.5.5 0 0 1-.353.146H4.893a.5.5 0 0 1-.353-.146L.146 11.46A.5.5 0 0 1 0 11.107V4.893a.5.5 0 0 1 .146-.353L4.54.146zM5.1 1 1 5.1v5.8L5.1 15h5.8l4.1-4.1V5.1L10.9 1H5.1z"/><path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/></svg></div>
                        <span class="card-title">Pending Complaints</span>
                    </div>
                    <div class="card-body">
                        <div class="value animate-number" data-target="${empty sessionScope.pendingComplaints ? 0 : sessionScope.pendingComplaints}">
                            <c:out value="${empty sessionScope.pendingComplaints ? 0 : sessionScope.pendingComplaints}" />
                        </div>
                        <div class="description">Require immediate attention</div>
                    </div>
                </div>
                <div class="card" style="animation-delay: 0.6s;">
                    <div class="card-header">
                        <div class="card-icon icon-revenue"><svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-cash-stack" viewBox="0 0 16 16"><path d="M1 3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1H1zm7 8a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/><path d="M0 5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V5zm3 0a2 2 0 0 1-2 2v4a2 2 0 0 1 2 2h10a2 2 0 0 1 2-2V7a2 2 0 0 1-2-2H3z"/></svg></div>
                        <span class="card-title">Monthly Revenue</span>
                    </div>
                    <div class="card-body">
                        <div class="value animate-number" data-target="${empty sessionScope.monthlyRevenue ? 0 : sessionScope.monthlyRevenue}" data-currency="true">
                            <fmt:formatNumber value="${empty sessionScope.monthlyRevenue ? 0 : sessionScope.monthlyRevenue}" type="currency" currencyCode="INR" />
                        </div>
                        <div class="description">Total for the current month</div>
                    </div>
                </div>
            </div>
            
            <div class="chart-grid">
                <div class="chart-container">
                    <h3>Revenue (Last 6 Months)</h3>
                    <canvas id="revenueChart"></canvas>
                </div>
                <div class="chart-container">
                    <h3>Complaints by Status</h3>
                    <canvas id="complaintChart"></canvas>
                </div>
            </div>

        </main>
    </div>
    
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

            // --- Charting ---
            
            // 1. Monthly Revenue Bar Chart
            const revenueCtx = document.getElementById('revenueChart');
            <c:if test="${not empty sessionScope.revenueChartLabels}">
                const revenueLabels = ${sessionScope.revenueChartLabels};
                const revenueData = ${sessionScope.revenueChartData};

                new Chart(revenueCtx, {
                    type: 'bar',
                    data: {
                        labels: revenueLabels,
                        datasets: [{
                            label: 'Monthly Revenue',
                            data: revenueData,
                            backgroundColor: 'rgba(75, 192, 192, 0.6)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1,
                            borderRadius: 5
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: { legend: { display: false } },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value, index, values) {
                                        return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', notation: 'compact' }).format(value);
                                    }
                                }
                            }
                        }
                    }
                });
            </c:if>

            // 2. Complaint Status Doughnut Chart
            const complaintCtx = document.getElementById('complaintChart');
            <c:if test="${not empty sessionScope.complaintChartLabels}">
                 const complaintLabels = ${sessionScope.complaintChartLabels};
                 const complaintData = ${sessionScope.complaintChartData};

                new Chart(complaintCtx, {
                    type: 'doughnut',
                    data: {
                        labels: complaintLabels,
                        datasets: [{
                            label: 'Complaints',
                            data: complaintData,
                            backgroundColor: [
                                'rgba(255, 99, 132, 0.7)',
                                'rgba(54, 162, 235, 0.7)',
                                'rgba(255, 206, 86, 0.7)',
                                'rgba(75, 192, 192, 0.7)',
                                'rgba(153, 102, 255, 0.7)'
                            ],
                            borderColor: [
                                'rgba(255, 99, 132, 1)',
                                'rgba(54, 162, 235, 1)',
                                'rgba(255, 206, 86, 1)',
                                'rgba(75, 192, 192, 1)',
                                'rgba(153, 102, 255, 1)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'top',
                            }
                        }
                    }
                });
            </c:if>
        });
    </script>
</body>
</html>

