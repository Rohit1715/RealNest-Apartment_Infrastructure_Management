<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* Notification Dropdown Styles */
    .notification-bell-wrapper { position: relative; }
    .notification-bell { position: relative; cursor: pointer; }
    .notification-dot { position: absolute; top: 0px; right: 0px; width: 8px; height: 8px; background-color: red; border-radius: 50%; border: 1.5px solid var(--nav-bg); }
    .notification-dropdown { display: none; position: absolute; top: 45px; right: 0; width: 350px; background-color: #fff; border-radius: 8px; box-shadow: 0 5px 15px rgba(0,0,0,0.15); z-index: 1000; overflow: hidden; }
    .dropdown-header { padding: 1rem; font-weight: bold; font-size: 1rem; border-bottom: 1px solid #f0f0f0; }
    .dropdown-list { max-height: 300px; overflow-y: auto; }
    .dropdown-item { display: flex; align-items: flex-start; padding: 1rem; border-bottom: 1px solid #f0f0f0; text-decoration: none; color: #333; }
    .dropdown-item:last-child { border-bottom: none; }
    .dropdown-item:hover { background-color: #f9f9f9; }
    .item-icon { margin-right: 1rem; color: var(--primary-color); flex-shrink: 0; margin-top: 2px; }
    .item-content { flex-grow: 1; }
    .item-message { font-size: 0.9rem; line-height: 1.4; }
    .item-time { font-size: 0.75rem; color: #888; margin-top: 4px; }
    .dropdown-footer { padding: 0.75rem; text-align: center; background-color: #f9f9f9; border-top: 1px solid #f0f0f0; }
    .dropdown-footer a { text-decoration: none; color: var(--primary-color); font-weight: bold; }
</style>

<nav class="top-nav">
    <div class="nav-left">
        <div class="logo">RealNest</div>
        <div class="nav-links">
             <ul>
                <c:set var="contextPath" value="<%= request.getContextPath() %>" />
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'ADMIN'}">
                        <li><a href="${contextPath}/dashboard" class="${pageName == 'dashboard' ? 'active' : ''}">Dashboard</a></li>
                        <li><a href="${contextPath}/apartments" class="${pageName == 'apartments' ? 'active' : ''}">Apartments</a></li>
                        <li><a href="${contextPath}/owners" class="${pageName == 'owners' ? 'active' : ''}">Owners</a></li>
                        <li><a href="${contextPath}/tenants" class="${pageName == 'tenants' ? 'active' : ''}">Tenants</a></li>
                        <li><a href="${contextPath}/complaints" class="${pageName == 'complaints' ? 'active' : ''}">Complaints</a></li>
                        <li><a href="${contextPath}/notices" class="${pageName == 'notices' ? 'active' : ''}">Notices</a></li>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'OWNER'}">
                        <li><a href="${contextPath}/dashboard" class="${pageName == 'dashboard' ? 'active' : ''}">Dashboard</a></li>
                        <li><a href="${contextPath}/my-properties" class="${pageName == 'my-properties' ? 'active' : ''}">Properties</a></li>
                        <li><a href="${contextPath}/owner-tenants" class="${pageName == 'owner-tenants' ? 'active' : ''}">Tenants</a></li>
                        <li><a href="${contextPath}/owner-payments" class="${pageName == 'owner-payments' ? 'active' : ''}">Payments</a></li>
                        <li><a href="${contextPath}/owner-complaints" class="${pageName == 'owner-complaints' ? 'active' : ''}">Complaints</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${contextPath}/dashboard" class="${pageName == 'dashboard' ? 'active' : ''}">Dashboard</a></li>
                        <li><a href="${contextPath}/payments" class="${pageName == 'payments' ? 'active' : ''}">Payments</a></li>
                        <li><a href="${contextPath}/complaints" class="${pageName == 'complaints' ? 'active' : ''}">Complaints</a></li>
                        <li><a href="${contextPath}/notices" class="${pageName == 'notices' ? 'active' : ''}">Notices</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
    <div class="nav-right">
        <div class="notification-bell-wrapper" id="notificationBellWrapper">
	        <div class="notification-bell" id="notificationBell">
	            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="currentColor" class="bi bi-bell-fill" viewBox="0 0 16 16"><path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zm.995-14.901a1 1 0 1 0-1.99 0A5.002 5.002 0 0 0 3 6c0 1.098-.5 6-2 7h14c-1.5-1-2-5.902-2-7 0-2.42-1.72-4.44-4.005-4.901z"/></svg>
	            <c:if test="${requestScope.unreadCount > 0}">
	                <span class="notification-dot" id="notificationDot"></span>
	            </c:if>
	        </div>
            <div class="notification-dropdown" id="notificationDropdown">
                <div class="dropdown-header">Notifications</div>
                <div class="dropdown-list" id="notificationList"></div>
                <div class="dropdown-footer">
                    <a href="${contextPath}/notifications">View All Notifications</a>
                </div>
            </div>
        </div>
        
        <div class="profile-section" id="profileSection">
            <div class="profile-info">
                <div class="avatar"><c:out value="${sessionScope.user.firstName.substring(0, 1)}" /></div>
                <div class="user-details">
                    <div class="username"><c:out value="${sessionScope.user.firstName} ${sessionScope.user.lastName}" /></div>
                    <div class="role"><c:out value="${sessionScope.user.role}" /></div>
                </div>
            </div>
            <div class="profile-dropdown" id="profileDropdown">
                <%-- NEW: The link now points to the new settings servlet --%>
                <a href="${contextPath}/settings">Settings</a>
                <a href="${contextPath}/logout" class="logout">Logout</a>
            </div>
        </div>
    </div>
</nav>

<script>
document.addEventListener('DOMContentLoaded', function() {
    function getTimeAgo(dateInput) {
        var date = new Date(dateInput);
        var now = new Date();
        var seconds = Math.floor((now - date) / 1000);

        if (seconds < 5) return "Just now";
        if (seconds < 60) return seconds + ' seconds ago';
        
        var minutes = Math.floor(seconds / 60);
        if (minutes < 60) return minutes + ' minute' + (minutes === 1 ? '' : 's') + ' ago';
        
        var hours = Math.floor(seconds / 3600);
        if (hours < 24) return hours + ' hour' + (hours === 1 ? '' : 's') + ' ago';

        var notificationDate = new Date(date);
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        
        var yesterday = new Date();
        yesterday.setDate(yesterday.getDate() - 1);
        yesterday.setHours(0, 0, 0, 0);

        if (notificationDate >= yesterday && notificationDate < today) return "Yesterday";
        
        return notificationDate.toLocaleString('en-US', { month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit', hour12: true });
    }

    var profileSection = document.getElementById('profileSection');
    var profileDropdown = document.getElementById('profileDropdown');
    var notificationBellWrapper = document.getElementById('notificationBellWrapper');
    var notificationDropdown = document.getElementById('notificationDropdown');
    var notificationList = document.getElementById('notificationList');
    var notificationDot = document.getElementById('notificationDot');

    if (profileSection) {
        profileSection.addEventListener('click', function(event) {
            if(notificationDropdown) notificationDropdown.style.display = 'none';
            profileDropdown.style.display = profileDropdown.style.display === 'block' ? 'none' : 'block';
            event.stopPropagation();
        });
    }
    
    if(notificationBellWrapper) {
        notificationBellWrapper.addEventListener('click', function(event) {
            event.stopPropagation();
            if(profileDropdown) profileDropdown.style.display = 'none';

            if (notificationDropdown.style.display === 'block') {
                notificationDropdown.style.display = 'none';
            } else {
                fetchNotifications();
                notificationDropdown.style.display = 'block';
            }
        });
    }

    function fetchNotifications() {
        var contextPath = '<%= request.getContextPath() %>';
        fetch(contextPath + '/getNotifications')
            .then(function(response) { return response.json(); })
            .then(function(notifications) {
                notificationList.innerHTML = ''; 
                
                if (notifications.length === 0) {
                     notificationList.innerHTML = '<div style="text-align: center; padding: 2rem; color: #888;">No new notifications</div>';
                } else {
                    notifications.forEach(function(n) {
                        var item = document.createElement('a');
                        item.href = contextPath + '/' + n.link;
                        item.className = 'dropdown-item';
                        
                        var timeAgo = getTimeAgo(n.createdAt);

                        item.innerHTML = 
                            '<div class="item-icon">' +
                                '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                                    '<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>' +
                                    '<path d="M13.73 21a2 2 0 0 1-3.46 0"></path>' +
                                '</svg>' +
                            '</div>' +
                            '<div class="item-content">' +
                                '<div class="item-message">' + n.message + '</div>' +
                                '<div class="item-time">' + timeAgo + '</div>' +
                            '</div>';
                        notificationList.appendChild(item);
                    });
                }

                if (notificationDot) {
                    notificationDot.style.display = 'none';
                }
            })
            .catch(function(error) {
                console.error('Error fetching notifications:', error);
                notificationList.innerHTML = '<div style="text-align: center; padding: 1rem; color: red;">Could not load notifications.</div>';
            });
    }

    window.addEventListener('click', function(event) {
        if (profileDropdown && profileDropdown.style.display === 'block' && !profileSection.contains(event.target)) {
            profileDropdown.style.display = 'none';
        }
        
        if (notificationDropdown && notificationDropdown.style.display === 'block' && !notificationBellWrapper.contains(event.target)) {
            notificationDropdown.style.display = 'none';
        }
    });
});
</script>

