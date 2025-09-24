# RealNest - Apartment Management System

RealNest is a comprehensive, modern web application designed to streamline the management of apartment complexes. Built with Java Servlets and JSP, this project provides a multi-user platform for Admins, Owners, Tenants, and Security personnel to manage properties, handle payments, track complaints, and ensure a secure environment.

The system is designed with a classic MVC (Model-View-Controller) architecture, ensuring a clean separation of concerns and making the codebase scalable and easy to maintain.

---

## ✨ Features

The application provides a tailored experience for four distinct user roles:

### 👤 Admin

* **Dashboard:** A central hub with key metrics, including total properties, pending complaints, and monthly revenue, complete with charts for financial and operational overviews.
* **Property Management:** Full CRUD (Create, Read, Update, Delete) functionality for apartments.
* **User Management:** Onboard and manage property Owners, Tenants, and Security staff.
* **Complaint Tracking:** View, manage, and update the status of all complaints filed within the system.
* **Notice Board:** Create and manage community-wide announcements.
* **Secure Login:** Bypasses OTP for administrative convenience.

### 🏠 Owner

* **Personalized Dashboard:** A summary of their property portfolio, including total tenants and open complaints.
* **Property Overview:** View all apartments they own and their current occupancy status.
* **Tenant Management:** View a list of tenants currently residing in their properties.
* **Payment Tracking:** View a complete history of payments received from tenants.
* **Complaint Monitoring:** Stay informed about complaints related to their properties.

### 🙋 Tenant

* **Personalized Dashboard:** A clear overview of their rent dues, open complaints, and recent notices.
* **Online Payments:** A secure and simple interface to pay monthly rent.
* **Complaint System:** Easily file new complaints with detailed descriptions and track their status.
* **Notice Board:** View all community announcements from the administration.
* **Profile Settings:** Update personal information like name, mobile number, and email.

### 🛡️ Security

* **Visitor Log Management:** A dedicated interface to log and manage the entry and exit of all visitors to the property, enhancing security.

---

## 🚀 System-Wide Features

* **Secure Authentication:** Robust, two-factor authentication (2FA) using OTPs sent via email for Tenants, Owners, and Security roles.
* **In-App Notifications:** A real-time notification system (bell icon) with a dropdown for instant alerts on critical events.
* **Automated Email System:** Professional, HTML-formatted emails for welcoming new users, payment receipts, complaint updates, and OTP delivery.
* **Forgot Password:** A secure, OTP-based flow for users to reset their passwords.

---

## 🛠️ Tech Stack

* **Backend:** Java 8+, Java Servlets, JDBC
* **Frontend:** JSP, JSTL (JSP Standard Tag Library), HTML5, CSS3, JavaScript (ES6)
* **Database:** MySQL 8.0
* **Web Server:** Apache Tomcat 9.0
* **Libraries:**
    * JavaMail API (for sending emails)
    * Gson (for JSON serialization)
    * MySQL Connector/J (JDBC driver)

---

## ⚙️ Setup and Installation

Follow these steps to get the project running on your local machine.

### 1. Prerequisites

Make sure you have the following software installed:

* JDK (Java Development Kit) (Version 11 or higher)
* Apache Tomcat (Version 9.0)
* MySQL (Version 8.0) & a client like MySQL Workbench or phpMyAdmin.
* Eclipse IDE for Enterprise Java and Web Developers
* Git

### 2. Clone the Repository

Open your terminal or command prompt and clone the project:


* git clone <your-repository-url>
* cd <your-project-directory>

### 3. Database Setup

1.  Open your MySQL client (e.g., phpMyAdmin) and create a new database.
    ```sql
    CREATE DATABASE apartment_db;
    ```
2.  Select the new database and import the `database_schema.sql` file provided in the project. This will create all the necessary tables.

---

### 4. Application Configuration

* **Database Credentials:** Open the `src/main/java/com/apartment/util/DatabaseUtil.java` file and update the `LOCAL_DB_USER` and `LOCAL_DB_PASSWORD` variables with your local MySQL username and password.

* **Email Credentials (Crucial):**
    1.  Navigate to `src/main/resources/`.
    2.  Create a new file named `mail.properties`.
    3.  Generate a 16-character App Password for your Gmail account (requires 2-Step Verification).
    4.  Add the following content to the file, replacing the placeholders with your credentials:

    ```properties
    mail.smtp.host=smtp.gmail.com
    mail.smtp.port=587
    mail.smtp.auth=true
    mail.smtp.starttls.enable=true
    mail.username=your-email@gmail.com
    mail.password=your16characterapppassword
    ```

### 5. Import and Run in Eclipse

1.  Open Eclipse and go to `File` -> `Import...`.
2.  Choose "General" -> "Existing Projects into Workspace" and select the cloned project directory.
3.  **Configure Build Path:**
    * Right-click the project -> `Properties` -> `Java Build Path` -> `Source`.
    * Ensure both `src/main/java` and `src/main/resources` are listed as source folders.
4.  **Configure Deployment Assembly:**
    * Right-click the project -> `Properties` -> `Deployment Assembly`.
    * Ensure it includes mappings for `src/main/java`, `src/main/resources`, and `src/main/webapp`.
5.  **Run the Application:**
    * In the "Servers" tab, add the project to your Tomcat server.
    * Start the server. The application will be accessible at: `http://localhost:8080/YourProjectName/`

---

## 🚀 Usage

1.  Navigate to the registration page to create your first user. It is recommended to create an **ADMIN** user first.
2.  Log in with the admin credentials. You can now start adding apartments, owners, and tenants through the admin dashboard.
3.  Log out and log in with Owner, Tenant, or Security credentials to explore their specific features.