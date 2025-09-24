# Use an official Tomcat image, which is perfect for running .war files
FROM tomcat:9.0-jdk11-corretto

# Remove the default ROOT application from the server
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the .war file from our 'deploy' folder into Tomcat's webapps directory.
# We rename it to ROOT.war so the application runs at the base URL (e.g., realnest-app.onrender.com/)
COPY deploy/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port the app runs on
EXPOSE 8080

# The default command for the tomcat image is to start the server, so we don't need a CMD line.

