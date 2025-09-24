# Use an official OpenJDK runtime as a parent image
FROM tomcat:9.0-jdk11-corretto

# Remove the default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the WAR file to the webapps directory
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port the app runs on
EXPOSE 8080

# Run the server
CMD ["catalina.sh", "run"]
