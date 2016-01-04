#!/bin/bash

if [ ! -f /.tomcat_admin_created ]; then
  /create_tomcat_admin_user.sh
fi

sed -i "/^dbHost=.*/c\dbHost=ocdb" /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^db=.*/c\db=openclinica" /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^dbPort=.*/c\dbPort=$OCDB_PORT_5432_TCP_PORT" /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^userAccountNotification=.*/c\userAccountNotification=admin" /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^# about\.text1=.*/c\about.text1= Powered by" /urs/local/tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^# about\.text2=.*/c\about.text2= mosaic-greifswald.de" /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^# supportURL=.*/c\supportURL=https://mosaic-greifswald.de/openclinica" /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^collectStats=.*/c\collectStats=false" /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^designerURL=.*/c\designerURL=" /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
cp /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties /usr/local/tomcat/webapps/OpenClinica-ws/WEB-INF/classes/

if [ -z "$LOG_LEVEL" ]; then
  echo "Using default log level."
else
  echo "org.apache.catalina.core.ContainerBase.[Catalina].level = $LOG_LEVEL" > /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/logging.properties
  echo "org.apache.catalina.core.ContainerBase.[Catalina].handlers = java.util.logging.ConsoleHandler" >> /usr/local/tomcat/webapps/OpenClinica/WEB-INF/classes/logging.properties
  echo "org.apache.catalina.core.ContainerBase.[Catalina].level = $LOG_LEVEL" > /usr/local/tomcat/webapps/OpenClinica-ws/WEB-INF/classes/logging.properties
  echo "org.apache.catalina.core.ContainerBase.[Catalina].handlers = java.util.logging.ConsoleHandler" >> /usr/local/tomcat/webapps/OpenClinica-ws/WEB-INF/classes/logging.properties
fi  

exec ${CATALINA_HOME}/bin/catalina.sh run
