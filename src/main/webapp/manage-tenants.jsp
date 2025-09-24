<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.apartment.model.User" %>
<%@ page import="com.apartment.model.Apartment" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Tenants | Apartment MS</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
    /* Page-specific styles */
    .page-container {
        display: grid;
        grid-template-columns: 400px 1fr;
        gap: 30px;
        align-items: flex-start;
    }
    .form-container {
        position: sticky;
        top: 20px;
    }
    .table-header {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        margin-bottom: 20px;
    }
    .search-bar-container {
        max-width: 300px;
        width: 100%;
    }

    /* Card list styles */
    .tenant-list { display: flex; flex-direction: column; gap: 12px; }
    .tenant-card {
        background: #ffffff; border: 1px solid #e9ecef; border-radius: 8px;
        padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.04); display: grid;
        grid-template-columns: 1fr 1.5fr 1fr; gap: 15px; align-items: center;
        /* ADDED: Transition for the hover effect */
        transition: box-shadow 0.2s ease-in-out, transform 0.2s ease-in-out;
    }
     /* ADDED: Hover effect for a modern, interactive feel */
    .tenant-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    .tenant-card p { margin: 0; font-size: 0.9rem; color: #6c757d; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .tenant-card p strong { display: block; color: #495057; font-size: 0.8rem; margin-bottom: 4px; font-weight: 500; }
    .empty-list-message { text-align: center; padding: 40px 20px; background: #f8f9fa; border: 1px dashed #ced4da; border-radius: 8px; color: #6c757d; }
    
    /* Pagination styles */
    .pagination { display: flex; justify-content: flex-end; align-items: center; margin-top: 25px; gap: 6px; }
    .pagination a { padding: 8px 14px; border: 1px solid #dee2e6; border-radius: 5px; color: #5E54D8; text-decoration: none; font-size: 0.9rem; }
    .pagination a:hover { background-color: #e9ecef; }
    .pagination a.active { background-color: #5E54D8; color: white; border-color: #5E54D8; }
    .pagination a.disabled { color: #6c757d; pointer-events: none; background-color: #fff; }

    /* Button Styles */
    .btn {
        display: inline-block; font-weight: 500; color: #212529; text-align: center;
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
    .btn-full {
        width: 100%;
        display: block;
    }
</style>
</head>
<body>
    <div class="dashboard-wrapper">
        <c:set var="pageName" value="tenants" scope="request" />
        <%@ include file="/common/header.jsp" %>

        <main class="main-content">
            <header class="content-header">
                <h1>Manage Tenants</h1>
            </header>
            
            <div class="page-container">
                <div class="form-container">
                    <div class="form-card">
                        <h2>Assign Tenant to Apartment</h2>
                        <c:if test="${param.assign == 'success'}">
		                    <div class="alert alert-success">Tenant assigned successfully!</div>
		                </c:if>
		                 <c:if test="${param.assign == 'error'}">
		                    <div class="alert alert-error">Error assigning tenant. They may already be assigned.</div>
		                </c:if>
                        <form action="tenants" method="post">
                            <div class="form-group">
                                <label for="tenantId">Select Tenant</label>
                                <select id="tenantId" name="tenantId" class="form-control" required>
                                    <option value="">-- Choose a Tenant --</option>
                                    <c:forEach var="tenant" items="${allTenants}">
                                        <option value="${tenant.userId}">${tenant.firstName} ${tenant.lastName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="apartmentId">Select Available Apartment</label>
                                <select id="apartmentId" name="apartmentId" class="form-control" required>
                                    <option value="">-- Choose an Apartment --</option>
                                    <c:forEach var="apt" items="${availableApartments}">
                                        <option value="${apt.apartmentId}">Block: ${apt.blockName}, Flat: ${apt.flatNumber}</option>
                                    </c:forEach>
                                </select>
                            </div>
                             <div class="form-group">
                                <label for="moveInDate">Move-In Date</label>
                                <input type="date" id="moveInDate" name="moveInDate" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="monthlyRent">Monthly Rent</label>
                                <input type="number" step="0.01" id="monthlyRent" name="monthlyRent" class="form-control" required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-full">Assign Tenant</button>
                        </form>
                    </div>
                </div>

                <div class="table-container">
                    <div class="table-card">
                        <div class="table-header">
                             <form action="tenants" method="get" class="search-bar-container" id="searchForm">
                                 <input type="text" name="search" id="searchInput" class="form-control" placeholder="Search by name, email, or mobile..." value="${search}">
                            </form>
                        </div>

                        <div class="tenant-list">
                            <c:if test="${empty tenantList}">
                                <div class="empty-list-message"><p>No tenants found.</p></div>
                            </c:if>
                            <c:forEach var="tenant" items="${tenantList}">
                                <div class="tenant-card">
                                    <p><strong>Name</strong> <c:out value="${tenant.firstName} ${tenant.lastName}" /></p>
                                    <p><strong>Email</strong> <c:out value="${tenant.email}" /></p>
                                    <p><strong>Mobile</strong> <c:out value="${tenant.mobile}" /></p>
                                </div>
                            </c:forEach>
                        </div>

                        <c:if test="${totalPages > 1}">
                            <div class="pagination">
                                <a href="tenants?page=${currentPage - 1}&search=${search}" class="btn ${currentPage <= 1 ? 'disabled' : ''}">Previous</a>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a href="tenants?page=${i}&search=${search}" class="btn ${currentPage == i ? 'active' : ''}">${i}</a>
                                </c:forEach>
                                <a href="tenants?page=${currentPage + 1}&search=${search}" class="btn ${currentPage >= totalPages ? 'disabled' : ''}">Next</a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        const searchInput = document.getElementById('searchInput');
        const searchForm = document.getElementById('searchForm');
        let searchTimeout;

        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                searchForm.submit();
            }, 500);
        });
    </script>
</body>
</html>

