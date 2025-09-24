<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.apartment.model.Apartment" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Apartments | Apartment MS</title>
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
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        flex-wrap: wrap;
        gap: 15px;
    }
    .search-bar-container { max-width: 300px; width: 100%; }

    /* Apartment Card Styles */
    .apartment-list {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }
    .apartment-card {
        background: #ffffff;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        padding: 15px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        /* FIX 2: Added transition for the hover effect */
        transition: box-shadow 0.2s ease-in-out, transform 0.2s ease-in-out;
    }
    /* FIX 2: Added hover effect for a modern, interactive feel */
    .apartment-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    .card-main-info {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #e9ecef;
        padding-bottom: 10px;
        margin-bottom: 10px;
    }
    .card-main-info h3 { margin: 0; font-size: 1.05rem; font-weight: 600; color: #343a40; }
    .card-details { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
    .card-details p { margin: 0; font-size: 0.85rem; color: #6c757d; }
    .card-details p strong { color: #495057; }
    .empty-list-message { text-align: center; padding: 40px 20px; background: #f8f9fa; border: 1px dashed #ced4da; border-radius: 8px; color: #6c757d; }

    /* FIX 1 & 3: Button and Filter Styles to match UI */
    .filter-buttons { display: flex; gap: 10px; }
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
        background-color: #5E54D8; /* Updated color to match UI */
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
    .pagination { display: flex; justify-content: flex-end; align-items: center; margin-top: 25px; gap: 6px; }
</style>
</head>
<body>
    <div class="dashboard-wrapper">
        <c:set var="pageName" value="apartments" scope="request" />
        <%@ include file="/common/header.jsp" %>

        <main class="main-content">
            <header class="content-header">
                <h1>Manage Apartments</h1>
            </header>
            
            <div class="page-container">
                <div class="form-container">
                    <div class="form-card">
                         <h2>Add New Apartment</h2>
                         <c:if test="${param.add == 'success'}">
		                    <div class="alert alert-success">Apartment added successfully!</div>
		                </c:if>
		                 <c:if test="${param.add == 'error'}">
		                    <div class="alert alert-error">Error adding apartment. Please try again.</div>
		                </c:if>
                         <form action="apartments" method="post">
                             <div class="form-group">
                                 <label for="blockName">Block Name</label>
                                 <input type="text" id="blockName" name="blockName" class="form-control" required>
                             </div>
                             <div class="form-group">
                                 <label for="flatNumber">Flat Number</label>
                                 <input type="text" id="flatNumber" name="flatNumber" class="form-control" required>
                             </div>
                             <div class="form-group">
                                 <label for="floor">Floor</label>
                                 <input type="number" id="floor" name="floor" class="form-control" required>
                             </div>
                             <div class="form-group">
                                 <label for="houseType">House Type (e.g., 2BHK)</label>
                                 <input type="text" id="houseType" name="houseType" class="form-control" required>
                             </div>
                             <div class="form-group">
                                 <label for="otherDetails">Other Details</label>
                                 <textarea id="otherDetails" name="otherDetails" rows="3" class="form-control"></textarea>
                             </div>
                             <button type="submit" class="btn btn-primary btn-full">Add Apartment</button>
                         </form>
                    </div>
                </div>

                <div class="table-container">
                    <div class="table-card">
                        <div class="table-header">
                            <div class="filter-buttons">
                                <a href="apartments?filter=all&search=${search}" class="btn ${empty filter or filter == 'all' ? 'active' : ''}">All</a>
                                <a href="apartments?filter=assigned&search=${search}" class="btn ${filter == 'assigned' ? 'active' : ''}">Assigned</a>
                                <a href="apartments?filter=unassigned&search=${search}" class="btn ${filter == 'unassigned' ? 'active' : ''}">Unassigned</a>
                            </div>
                            <form action="apartments" method="get" class="search-bar-container" id="searchForm">
                                 <input type="hidden" name="filter" value="${filter}">
                                 <input type="text" name="search" id="searchInput" class="form-control" placeholder="Search by Block or Flat..." value="${search}">
                            </form>
                        </div>
                        
                        <div class="apartment-list">
                            <c:if test="${empty apartmentList}">
                                <div class="empty-list-message">
                                    <p>No apartments found.</p>
                                </div>
                            </c:if>

                            <c:forEach var="apt" items="${apartmentList}">
                                <div class="apartment-card">
                                    <div class="card-main-info">
                                        <h3><c:out value="${apt.blockName}" /> - <c:out value="${apt.flatNumber}" /></h3>
                                        <c:choose>
                                            <c:when test="${apt.ownerId > 0}"><span class="status-badge status-assigned">Assigned</span></c:when>
                                            <c:otherwise><span class="status-badge status-unassigned">Unassigned</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="card-details">
                                        <p><strong>Floor:</strong> <c:out value="${apt.floor}" /></p>
                                        <p><strong>Type:</strong> <c:out value="${apt.houseType}" /></p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <c:if test="${totalPages > 1}">
                            <div class="pagination">
                                <a href="apartments?page=${currentPage - 1}&search=${search}&filter=${filter}" class="btn ${currentPage <= 1 ? 'disabled' : ''}">Previous</a>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a href="apartments?page=${i}&search=${search}&filter=${filter}" class="btn ${currentPage == i ? 'active' : ''}">${i}</a>
                                </c:forEach>
                                <a href="apartments?page=${currentPage + 1}&search=${search}&filter=${filter}" class="btn ${currentPage >= totalPages ? 'disabled' : ''}">Next</a>
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
