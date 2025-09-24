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
<title>My Tenant Complaints | Apartment MS</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
    /* Styles for the complaints page */
    .table-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        flex-wrap: wrap;
        gap: 15px;
    }
    .filter-buttons { display: flex; gap: 10px; }
    .search-bar-container { max-width: 300px; width: 100%; }

    .complaints-table {
        width: 100%;
        border-collapse: collapse;
    }
    .complaints-table th, .complaints-table td {
        padding: 15px;
        text-align: left;
        border-bottom: 1px solid var(--border-color);
        vertical-align: middle;
    }
    .complaints-table th {
        font-weight: 600;
        color: var(--label-color);
    }
    .empty-list-message { text-align: center; padding: 40px 20px; background: #f8f9fa; border: 1px dashed #ced4da; border-radius: 8px; color: #6c757d; }
    .pagination { display: flex; justify-content: flex-end; align-items: center; margin-top: 25px; gap: 6px; }

    .btn {
        display: inline-block; font-weight: 500; text-align: center;
        vertical-align: middle; cursor: pointer; user-select: none; background-color: transparent;
        border: 1px solid #dee2e6; padding: 0.5rem 1rem; font-size: 0.9rem;
        line-height: 1.5; border-radius: 0.3rem; text-decoration: none;
        transition: all 0.15s ease-in-out; color: #5E54D8;
    }
    .btn:hover { background-color: #f8f9fa; }
    .btn.active {
        color: #fff;
        background-color: #5E54D8;
        border-color: #5E54D8;
    }
</style>
</head>
<body>
    <div class="dashboard-wrapper">
        <c:set var="pageName" value="owner-complaints" scope="request" />
        <%@ include file="/common/header.jsp" %>

        <main class="main-content">
            <header class="content-header">
                <h1>Tenant Complaints</h1>
            </header>
            
            <div class="table-card">
                <div class="table-header">
                     <div class="filter-buttons">
                        <a href="owner-complaints?filter=all&search=${search}" class="btn ${empty filter or filter == 'all' ? 'active' : ''}">All</a>
                        <a href="owner-complaints?filter=Open&search=${search}" class="btn ${filter == 'Open' ? 'active' : ''}">Open</a>
                        <a href="owner-complaints?filter=In Progress&search=${search}" class="btn ${filter == 'In Progress' ? 'active' : ''}">In Progress</a>
                        <a href="owner-complaints?filter=Resolved&search=${search}" class="btn ${filter == 'Resolved' ? 'active' : ''}">Resolved</a>
                    </div>
                     <form action="owner-complaints" method="get" class="search-bar-container" id="searchForm">
                         <input type="hidden" name="filter" value="${filter}">
                         <input type="text" name="search" id="searchInput" class="form-control" placeholder="Search by Tenant or Apartment..." value="${search}">
                    </form>
                </div>

                 <c:if test="${empty complaintList}">
                    <div class="empty-list-message"><p>No complaints found matching your criteria.</p></div>
                </c:if>
                <c:if test="${not empty complaintList}">
                    <table class="complaints-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tenant</th>
                                <th>Apartment</th>
                                <th>Issue Type</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Date Submitted</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="complaint" items="${complaintList}">
                                <tr>
                                    <td><c:out value="${complaint.complaintId}" /></td>
                                    <td><c:out value="${complaint.residentName}" /></td>
                                    <td>Block ${complaint.blockName}, Flat ${complaint.flatNumber}</td>
                                    <td><c:out value="${complaint.issueType}" /></td>
                                    <td><c:out value="${complaint.description}" /></td>
                                    <td><span class="status-badge status-${complaint.status.toLowerCase().replace(' ', '-')}"><c:out value="${complaint.status}" /></span></td>
                                    <td><fmt:formatDate value="${complaint.createdAt}" pattern="MMM d, yyyy, hh:mm a"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                 <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <a href="owner-complaints?page=${currentPage - 1}&search=${search}&filter=${filter}" class="btn ${currentPage <= 1 ? 'disabled' : ''}">Previous</a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="owner-complaints?page=${i}&search=${search}&filter=${filter}" class="btn ${currentPage == i ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <a href="owner-complaints?page=${currentPage + 1}&search=${search}&filter=${filter}" class="btn ${currentPage >= totalPages ? 'disabled' : ''}">Next</a>
                    </div>
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
