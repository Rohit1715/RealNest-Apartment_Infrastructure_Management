package com.apartment.util;

import java.io.InputStream;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {

    private static Properties properties = new Properties();
    private static String fromEmail;
    private static String fromPassword;

    // Load the configuration from the mail.properties file when the class is first loaded.
    static {
        try (InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (input == null) {
                System.out.println("Sorry, unable to find mail.properties");
            } else {
                properties.load(input);
                fromEmail = properties.getProperty("mail.from.email");
                fromPassword = properties.getProperty("mail.from.password");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to load mail.properties file.", e);
        }
    }
    
    /**
     * Sends an email in a new background thread to avoid blocking the main application.
     * * @param toEmail The recipient's email address.
     * @param subject The subject of the email.
     * @param body    The HTML or plain text content of the email.
     */
    public static void sendEmail(String toEmail, String subject, String body) {
        // Create a new thread to send the email asynchronously.
        new Thread(() -> {
            try {
                // Set up the mail session with authentication.
                Authenticator authenticator = new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(fromEmail, fromPassword);
                    }
                };
                
                Session session = Session.getInstance(properties, authenticator);

                // Create the email message.
                Message mimeMessage = new MimeMessage(session);
                mimeMessage.setFrom(new InternetAddress(fromEmail));
                mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                mimeMessage.setSubject(subject);
                
                // Set the content as HTML to allow for better formatting.
                mimeMessage.setContent(body, "text/html; charset=utf-8");

                // Send the email.
                Transport.send(mimeMessage);
                
                System.out.println("Email sent successfully to " + toEmail);

            } catch (Exception e) {
                System.err.println("Failed to send email to " + toEmail);
                e.printStackTrace();
            }
        }).start();
    }
}
