FROM tomcat:9-jdk8
ARG WAR_FILE 
ARG CONTEXT 
COPY ${WAR_FILE} /usr/local/tomcat/webapps/${CONTEXT}.war
