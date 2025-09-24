package com.apartment.util;

/**
 * A utility class to generate professional HTML email templates.
 * This keeps the email styling separate from the business logic in the servlets.
 */
public class EmailTemplateUtil {

    /**
     * Generates a beautiful HTML welcome email.
     * @param firstName The first name of the new user.
     * @return A string containing the full HTML body of the email.
     */
    public static String getWelcomeEmailBody(String firstName) {
        // Using a modern, clean HTML email template structure.
        return "<!DOCTYPE html>"
             + "<html>"
             + "<head>"
             + "<style>"
             + "  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');"
             + "  body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; margin: 0; padding: 0; }"
             + "  .container { max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }"
             + "  .header { background-color: #4A90E2; color: #ffffff; padding: 40px; text-align: center; }"
             + "  .header h1 { margin: 0; font-size: 28px; }"
             + "  .content { padding: 40px 30px; color: #555; line-height: 1.7; }"
             + "  .content h2 { color: #333; font-size: 22px; }"
             + "  .content p { margin-bottom: 20px; }"
             + "  .button { display: inline-block; background-color: #4A90E2; color: #ffffff; padding: 12px 25px; border-radius: 5px; text-decoration: none; font-weight: 600; }"
             + "  .footer { background-color: #f4f7f6; color: #999; text-align: center; padding: 20px; font-size: 12px; }"
             + "</style>"
             + "</head>"
             + "<body>"
             + "  <div class='container'>"
             + "    <div class='header'>"
             + "      <h1>Welcome to RealNest!</h1>"
             + "    </div>"
             + "    <div class='content'>"
             + "      <h2>Hello, " + firstName + "!</h2>"
             + "      <p>Thank you for joining RealNest, your new hub for seamless apartment management. We're thrilled to have you with us.</p>"
             + "      <p>You can now log in to your account to manage your property, pay rent, file complaints, and stay updated with community notices.</p>"
             + "      <p>If you have any questions, feel free to contact our support team.</p>"
             + "      <p>Best regards,<br/>The RealNest Team</p>"
             + "    </div>"
             + "    <div class='footer'>"
             + "      <p>&copy; 2025 RealNest. All rights reserved.</p>"
             + "    </div>"
             + "  </div>"
             + "</body>"
             + "</html>";
    }
    
    // You can add more template methods here later, e.g., getPaymentReceiptBody(), getComplaintUpdateBody(), etc.
    /**
     * Generates an HTML email alert for a new complaint.
     * @param tenantName The name of the tenant who filed the complaint.
     * @param issueType The type of issue reported.
     * @param description The detailed description of the complaint.
     * @param apartmentInfo A string describing the apartment (e.g., "Block A, Flat 101").
     * @return A string containing the full HTML body of the email.
     */
    public static String getNewComplaintAlertBody(String tenantName, String issueType, String description, String apartmentInfo) {
        return "<!DOCTYPE html>"
             + "<html>"
             + "<head>"
             + "<style>"
             + "  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');"
             + "  body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; margin: 0; padding: 0; }"
             + "  .container { max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }"
             + "  .header { background-color: #E74C3C; color: #ffffff; padding: 40px; text-align: center; }"
             + "  .header h1 { margin: 0; font-size: 28px; }"
             + "  .content { padding: 40px 30px; color: #555; line-height: 1.7; }"
             + "  .content h2 { color: #333; font-size: 22px; border-bottom: 2px solid #f0f0f0; padding-bottom: 10px; margin-bottom: 20px; }"
             + "  .complaint-details { margin-bottom: 25px; }"
             + "  .complaint-details p { margin: 5px 0; }"
             + "  .complaint-details strong { color: #333; }"
             + "  .description { background-color: #f9f9f9; border-left: 4px solid #E74C3C; padding: 15px; margin-top: 15px; border-radius: 4px; }"
             + "  .footer { background-color: #f4f7f6; color: #999; text-align: center; padding: 20px; font-size: 12px; }"
             + "</style>"
             + "</head>"
             + "<body>"
             + "  <div class='container'>"
             + "    <div class='header'>"
             + "      <h1>New Complaint Alert</h1>"
             + "    </div>"
             + "    <div class='content'>"
             + "      <h2>A new complaint has been filed and requires your attention.</h2>"
             + "      <div class='complaint-details'>"
             + "        <p><strong>Tenant:</strong> " + tenantName + "</p>"
             + "        <p><strong>Apartment:</strong> " + apartmentInfo + "</p>"
             + "        <p><strong>Issue Type:</strong> " + issueType + "</p>"
             + "      </div>"
             + "      <p><strong>Description:</strong></p>"
             + "      <div class='description'>"
             + "        <p>" + description + "</p>"
             + "      </div>"
             + "      <p>Please log in to the admin dashboard to view the full details and take action.</p>"
             + "    </div>"
             + "    <div class='footer'>"
             + "      <p>&copy; 2025 RealNest. All rights reserved.</p>"
             + "    </div>"
             + "  </div>"
             + "</body>"
             + "</html>";
    }

    /**
     * Generates an HTML email for a complaint status update.
     * @param tenantName The name of the tenant receiving the update.
     * @param issueType The type of issue that was filed.
     * @param newStatus The new status of the complaint (e.g., "In Progress", "Resolved").
     * @return A string containing the full HTML body of the email.
     */
    public static String getComplaintStatusUpdateBody(String tenantName, String issueType, String newStatus) {
        String statusColor = newStatus.equalsIgnoreCase("Resolved") ? "#2ECC71" : "#F39C12"; // Green for resolved, Orange otherwise
        
        return "<!DOCTYPE html>"
             + "<html>"
             + "<head>"
             + "<style>"
             + "  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');"
             + "  body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; margin: 0; padding: 0; }"
             + "  .container { max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }"
             + "  .header { background-color: #3498DB; color: #ffffff; padding: 40px; text-align: center; }"
             + "  .header h1 { margin: 0; font-size: 28px; }"
             + "  .content { padding: 40px 30px; color: #555; line-height: 1.7; }"
             + "  .content h2 { color: #333; font-size: 22px; }"
             + "  .status-box { padding: 15px 20px; margin: 25px 0; border-radius: 5px; text-align: center; color: #fff; font-size: 18px; font-weight: 600; background-color: " + statusColor + "; }"
             + "  .footer { background-color: #f4f7f6; color: #999; text-align: center; padding: 20px; font-size: 12px; }"
             + "</style>"
             + "</head>"
             + "<body>"
             + "  <div class='container'>"
             + "    <div class='header'>"
             + "      <h1>Complaint Status Update</h1>"
             + "    </div>"
             + "    <div class='content'>"
             + "      <h2>Hello, " + tenantName + "!</h2>"
             + "      <p>This is an update regarding your complaint about: <strong>'" + issueType + "'</strong>.</p>"
             + "      <p>The status has been updated to:</p>"
             + "      <div class='status-box'>"
             + "        " + newStatus
             + "      </div>"
             + "      <p>Thank you for your patience as we work to resolve your issue.</p>"
             + "    </div>"
             + "    <div class='footer'>"
             + "      <p>&copy; 2025 RealNest. All rights reserved.</p>"
             + "    </div>"
             + "  </div>"
             + "</body>"
             + "</html>";
    }

    /**
     * Generates a professional HTML email receipt for a payment.
     * @param tenantName The full name of the tenant.
     * @param amount The payment amount.
     * @param paymentDate The formatted date and time of the payment.
     * @param transactionId The unique transaction ID.
     * @param apartmentDetails The tenant's apartment details (e.g., "A - 101").
     * @param paymentMethod The method used for payment (e.g., "Credit Card").
     * @return A string containing the full HTML body of the email receipt.
     */
    public static String getPaymentReceiptBody(String tenantName, double amount, String paymentDate, String transactionId, String apartmentDetails, String paymentMethod) {
        return "<!DOCTYPE html>"
             + "<html>"
             + "<head>"
             + "<style>"
             + "  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');"
             + "  body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }"
             + "  .container { max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-top: 5px solid #2ECC71; }"
             + "  .header { text-align: center; padding: 40px 20px; border-bottom: 1px solid #eee; }"
             + "  .header h1 { margin: 0; font-size: 28px; color: #2ECC71; }"
             + "  .header p { margin: 5px 0 0; font-size: 16px; color: #555; }"
             + "  .content { padding: 30px; }"
             + "  .content h2 { color: #333; font-size: 20px; border-bottom: 2px solid #f0f0f0; padding-bottom: 10px; margin-bottom: 20px; }"
             + "  .details-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }"
             + "  .details-table td { padding: 12px 0; border-bottom: 1px solid #f0f0f0; color: #555; }"
             + "  .details-table td:first-child { font-weight: 600; color: #333; }"
             + "  .total-row td { font-size: 18px; font-weight: 600; color: #333; border-top: 2px solid #333; padding-top: 15px; }"
             + "  .footer { background-color: #f4f7f6; color: #999; text-align: center; padding: 20px; font-size: 12px; }"
             + "</style>"
             + "</head>"
             + "<body>"
             + "  <div class='container'>"
             + "    <div class='header'>"
             + "      <h1>Payment Successful!</h1>"
             + "      <p>Here is your receipt</p>"
             + "    </div>"
             + "    <div class='content'>"
             + "      <h2>Hi, " + tenantName + "</h2>"
             + "      <p>Thank you for your payment. Here are the details of your transaction:</p>"
             + "      <table class='details-table'>"
             + "        <tr><td>Transaction ID:</td><td style='text-align: right;'>" + transactionId + "</td></tr>"
             + "        <tr><td>Payment Date:</td><td style='text-align: right;'>" + paymentDate + "</td></tr>"
             + "        <tr><td>Apartment:</td><td style='text-align: right;'>" + apartmentDetails + "</td></tr>"
             + "        <tr><td>Payment Method:</td><td style='text-align: right;'>" + paymentMethod + "</td></tr>"
             + "        <tr class='total-row'><td>Amount Paid:</td><td style='text-align: right;'>₹" + String.format("%.2f", amount) + "</td></tr>"
             + "      </table>"
             + "    </div>"
             + "    <div class='footer'>"
             + "      <p>&copy; 2025 RealNest. All rights reserved.</p>"
             + "    </div>"
             + "  </div>"
             + "</body>"
             + "</html>";
    }

    /**
     * Generates an HTML email to notify a property owner of a received payment.
     * @param ownerName The name of the property owner.
     * @param tenantName The name of the tenant who made the payment.
     * @param amount The amount that was paid.
     * @param apartmentDetails The apartment for which the payment was made.
     * @param paymentDate The formatted date of the payment.
     * @return A string containing the full HTML body of the email.
     */
    public static String getOwnerPaymentNotificationBody(String ownerName, String tenantName, double amount, String apartmentDetails, String paymentDate) {
        return "<!DOCTYPE html>"
             + "<html>"
             // ... (styles are similar to other templates, so they can be reused or copied) ...
             + "<style>"
             + "  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');"
             + "  body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }"
             + "  .container { max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-top: 5px solid #3498DB; }"
             + "  .header { text-align: center; padding: 40px 20px; border-bottom: 1px solid #eee; }"
             + "  .header h1 { margin: 0; font-size: 28px; color: #3498DB; }"
             + "  .content { padding: 30px; }"
             + "  .content h2 { color: #333; font-size: 20px; }"
             + "  .details-table { width: 100%; border-collapse: collapse; margin-top: 20px; }"
             + "  .details-table td { padding: 12px 0; border-bottom: 1px solid #f0f0f0; color: #555; }"
             + "  .details-table td:first-child { font-weight: 600; color: #333; }"
             + "  .footer { background-color: #f4f7f6; color: #999; text-align: center; padding: 20px; font-size: 12px; }"
             + "</style>"
             + "<body>"
             + "  <div class='container'>"
             + "    <div class='header'>"
             + "      <h1>Payment Received Notification</h1>"
             + "    </div>"
             + "    <div class='content'>"
             + "      <h2>Hi, " + ownerName + "</h2>"
             + "      <p>This is an automated notification to inform you that a payment has been successfully processed for one of your properties. Here are the details:</p>"
             + "      <table class='details-table'>"
             + "        <tr><td>Tenant Name:</td><td style='text-align: right;'>" + tenantName + "</td></tr>"
             + "        <tr><td>Property:</td><td style='text-align: right;'>" + apartmentDetails + "</td></tr>"
             + "        <tr><td>Payment Date:</td><td style='text-align: right;'>" + paymentDate + "</td></tr>"
             + "        <tr><td>Amount Received:</td><td style='text-align: right; font-weight: 600;'>₹" + String.format("%.2f", amount) + "</td></tr>"
             + "      </table>"
             + "    </div>"
             + "    <div class='footer'>"
             + "      <p>&copy; 2025 RealNest. All rights reserved.</p>"
             + "    </div>"
             + "  </div>"
             + "</body>"
             + "</html>";
    }

    /**
     * Generates a clean HTML email for sending a One-Time Password (OTP).
     * @param userName The first name of the user.
     * @param otpCode The 6-digit OTP code.
     * @return A string containing the full HTML body of the email.
     */
    public static String getOtpEmailBody(String userName, String otpCode) {
        return "<!DOCTYPE html>"
             + "<html>"
             + "<head>"
             + "<style>"
             + "  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap');"
             + "  body { font-family: 'Poppins', sans-serif; background-color: #f9f9f9; margin: 0; padding: 20px; }"
             + "  .container { max-width: 500px; margin: 20px auto; background-color: #ffffff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); overflow: hidden; }"
             + "  .header { background-color: #4A90E2; color: white; text-align: center; padding: 30px 20px; }"
             + "  .header h1 { margin: 0; font-size: 24px; }"
             + "  .content { padding: 30px; text-align: center; color: #555; }"
             + "  .content p { font-size: 16px; line-height: 1.6; }"
             + "  .otp-code { font-size: 36px; font-weight: 700; color: #4A90E2; letter-spacing: 5px; margin: 25px 0; padding: 15px; background-color: #f1f8ff; border-radius: 8px; }"
             + "  .footer { background-color: #f1f1f1; color: #aaa; text-align: center; padding: 20px; font-size: 12px; }"
             + "</style>"
             + "</head>"
             + "<body>"
             + "  <div class='container'>"
             + "    <div class='header'>"
             + "      <h1>Your One-Time Password</h1>"
             + "    </div>"
             + "    <div class='content'>"
             + "      <p>Hi, " + userName + "</p>"
             + "      <p>Please use the following code to complete your login. This code is valid for 10 minutes.</p>"
             + "      <div class='otp-code'>" + otpCode + "</div>"
             + "      <p>If you did not request this code, please ignore this email or contact support.</p>"
             + "    </div>"
             + "    <div class='footer'>"
             + "      <p>&copy; 2025 RealNest. All rights reserved.</p>"
             + "    </div>"
             + "  </div>"
             + "</body>"
             + "</html>";
    }


}
