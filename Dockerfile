# Dockerfile for OpenClinica 3.4.1 
# 
# * for testing purposes only 
# * needs an additional postgres container 

FROM registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat7-openshift
 
MAINTAINER Kees Louwen (kees.louwen@vancis.nl)

USER 0
 
ENV OC_HOME $JBOSS_HOME/webapps/OpenClinica 
ENV OC_WS_HOME $JBOSS_HOME/webapps/OpenClinica-ws 
ENV OC_VERSION 3.4.1 
RUN ["mkdir", "/tmp/oc"]
RUN yum -y install wget

RUN ["wget", "-q", "--no-check-certificate", "-O/tmp/oc/openclinica.zip", "http://www2.openclinica.com/l/5352/2014-12-22/xpy3t"]
RUN ["wget", "-q", "--no-check-certificate", "-O/tmp/oc/openclinica-ws.zip", "http://www2.openclinica.com/l/5352/2014-12-22/xpy15"]
RUN cd /tmp/oc && \
    jar xvf openclinica.zip && \
    jar xf openclinica-ws.zip && \
    mkdir $OC_HOME && cd $OC_HOME && \
    cp /tmp/oc/OpenClinica-$OC_VERSION/distribution/OpenClinica.war . && \
    jar xf OpenClinica.war && cd .. && \
    mkdir $OC_WS_HOME && cd $OC_WS_HOME && \
    cp /tmp/oc/OpenClinica-ws-$OC_VERSION/distribution/OpenClinica-ws.war . && \
    jar xf OpenClinica-ws.war && cd .. && \
    rm -rf /tmp/oc

COPY run.sh /run.sh

RUN mkdir $JBOSS_HOME/openclinica.data/xslt -p && \
    mv $JBOSS_HOME/webapps/OpenClinica/WEB-INF/lib/servlet-api-2.3.jar ../ && \
    chmod +x /*.sh

ENV JAVA_OPTS -Xmx1280m -XX:+UseParallelGC -XX:MaxPermSize=180m -XX:+CMSClassUnloadingEnabled 

CMD ["/run.sh"]
