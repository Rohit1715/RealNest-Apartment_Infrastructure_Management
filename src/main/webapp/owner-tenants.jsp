<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.apartment.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Tenants | Apartment MS</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
    /* Styles for the tenants page */
    .table-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        flex-wrap: wrap;
        gap: 15px;
    }
    .search-bar-container { max-width: 300px; width: 100%; margin-left: auto; }

    .tenants-table {
        width: 100%;
        border-collapse: collapse;
    }
    .tenants-table th, .tenants-table td {
        padding: 15px;
        text-align: left;
        border-bottom: 1px solid var(--border-color);
        vertical-align: middle;
    }
    .tenants-table th {
        font-weight: 600;
        color: var(--label-color);
    }
    .empty-list-message { text-align: center; padding: 40px 20px; background: #f8f9fa; border: 1px dashed #ced4da; border-radius: 8px; color: #6c757d; }
</style>
</head>
<body>
    <div class="dashboard-wrapper">
        <%-- Set page name and include the consistent header --%>
        <c:set var="pageName" value="owner-tenants" scope="request" />
        <%@ include file="/common/header.jsp" %>

        <main class="main-content">
            <header class="content-header">
                <h1>My Tenants</h1>
            </header>
            <div class="table-card">
                <div class="table-header">
                    <h2>A list of all tenants in your properties.</h2>
                     <form action="owner-tenants" method="get" class="search-bar-container" id="searchForm">
                         <input type="text" name="search" id="searchInput" class="form-control" placeholder="Search by name, email, or mobile..." value="${search}">
                    </form>
                </div>

                <c:if test="${empty tenantList}">
                    <div class="empty-list-message"><p>No tenants found matching your criteria.</p></div>
                </c:if>
                <c:if test="${not empty tenantList}">
                    <table class="tenants-table">
                        <thead>
                            <tr>
                                <th>Tenant ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Mobile</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="tenant" items="${tenantList}">
                                <tr>
                                    <td><c:out value="${tenant.userId}" /></td>
                                    <td><c:out value="${tenant.firstName} ${tenant.lastName}" /></td>
                                    <td><c:out value="${tenant.email}" /></td>
                                    <td><c:out value="${tenant.mobile}" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
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

