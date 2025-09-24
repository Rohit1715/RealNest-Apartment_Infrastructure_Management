<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.apartment.model.Complaint" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Complaints | Apartment MS</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
    /* Styles for the restored card-based layout */
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

    .complaint-list { display: flex; flex-direction: column; gap: 15px; }
    .complaint-card {
        background: #fff;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        padding: 20px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        transition: box-shadow 0.2s ease-in-out, transform 0.2s ease-in-out;
    }
    .complaint-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    .card-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        border-bottom: 1px solid #e9ecef;
        padding-bottom: 15px;
        margin-bottom: 15px;
    }
    .card-header h3 { margin: 0; font-size: 1.1rem; font-weight: 600; color: #343a40; }
    .card-header h3 small { font-weight: 400; color: #6c757d; display: block; font-size: 0.85rem; margin-top: 4px; }
    .card-body {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
    }
    .card-body p { margin: 0; font-size: 0.9rem; color: #6c757d; }
    .card-body p strong { display: block; color: #495057; font-size: 0.8rem; margin-bottom: 4px; font-weight: 500; }
    .card-footer {
        margin-top: 20px;
        padding-top: 15px;
        border-top: 1px solid #e9ecef;
    }
    .update-form {
        display: flex;
        align-items: center;
        gap: 10px;
        justify-content: flex-end;
    }
    .update-form select.form-control {
        width: auto;
        flex-grow: 0;
    }
    .update-form button { flex-shrink: 0; }
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
    .btn-primary {
        color: #fff;
        background-color: #5E54D8;
        border-color: #5E54D8;
    }
    .btn-primary:hover {
        background-color: #4D45B4;
        border-color: #4D45B4;
    }
</style>
</head>
<body>
    <div class="dashboard-wrapper">
        <c:set var="pageName" value="complaints" scope="request" />
        <%@ include file="/common/header.jsp" %>

        <main class="main-content">
            <header class="content-header">
                <h1>Manage Complaints</h1>
            </header>
            
            <div class="table-card">
                <div class="table-header">
                    <div class="filter-buttons">
                        <a href="complaints?filter=all&search=${search}" class="btn ${empty filter or filter == 'all' ? 'active' : ''}">All</a>
                        <a href="complaints?filter=Open&search=${search}" class="btn ${filter == 'Open' ? 'active' : ''}">Open</a>
                        <a href="complaints?filter=In Progress&search=${search}" class="btn ${filter == 'In Progress' ? 'active' : ''}">In Progress</a>
                        <a href="complaints?filter=Resolved&search=${search}" class="btn ${filter == 'Resolved' ? 'active' : ''}">Resolved</a>
                    </div>
                    <form action="complaints" method="get" class="search-bar-container" id="searchForm">
                         <input type="hidden" name="filter" value="${filter}">
                         <input type="text" name="search" id="searchInput" class="form-control" placeholder="Search by resident or apartment..." value="${search}">
                    </form>
                </div>

                <div class="complaint-list">
                    <c:if test="${empty complaintList}">
                        <div class="empty-list-message"><p>No complaints found.</p></div>
                    </c:if>
                    <c:forEach var="complaint" items="${complaintList}">
                        <div class="complaint-card">
                            <div class="card-header">
                                <h3>
                                    ${complaint.issueType}
                                    <small>Complaint ID: ${complaint.complaintId}</small>
                                </h3>
                                <span class="status-badge status-${complaint.status.toLowerCase().replace(' ', '-')}">${complaint.status}</span>
                            </div>
                            <div class="card-body">
                                <p><strong>Resident:</strong> ${complaint.residentName}</p>
                                <p><strong>Apartment:</strong> 
                                    <c:if test="${not empty complaint.blockName}">Block ${complaint.blockName}, Flat ${complaint.flatNumber}</c:if>
                                    <c:if test="${empty complaint.blockName}">N/A</c:if>
                                </p>
                                <p><strong>Submitted:</strong> <fmt:formatDate value="${complaint.createdAt}" pattern="MMM dd, yyyy, hh:mm a" /></p>
                                <p><strong>Description:</strong> ${complaint.description}</p>
                            </div>
                             <div class="card-footer">
                                <form action="updateComplaintStatus" method="post" class="update-form">
                                    <input type="hidden" name="complaintId" value="${complaint.complaintId}">
                                    <select name="newStatus" class="form-control">
                                        <option value="Open" ${complaint.status == 'Open' ? 'selected' : ''}>Open</option>
                                        <option value="In Progress" ${complaint.status == 'In Progress' ? 'selected' : ''}>In Progress</option>
                                        <option value="Resolved" ${complaint.status == 'Resolved' ? 'selected' : ''}>Resolved</option>
                                    </select>
                                    <button type="submit" class="btn btn-primary">Update</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <a href="complaints?page=${currentPage - 1}&search=${search}&filter=${filter}" class="btn ${currentPage <= 1 ? 'disabled' : ''}">Previous</a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="complaints?page=${i}&search=${search}&filter=${filter}" class="btn ${currentPage == i ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <a href="complaints?page=${currentPage + 1}&search=${search}&filter=${filter}" class="btn ${currentPage >= totalPages ? 'disabled' : ''}">Next</a>
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

