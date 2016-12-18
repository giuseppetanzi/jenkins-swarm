# The FROM will be replaced when building in OpenShift
FROM openshift/jenkins-slave-maven-centos7

MAINTAINER Giuseppe Tanzi <gtanzi@redhat.com>
LABEL io.k8s.display-name="Jenkins Slave - With Swarm plugin installed" \
      io.k8s.description="The jenkins slave swarm image has the swarm plugin on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,slave,swarm"
      
      
 ENV JENKINS_SWARM_VERSION 2.2
 ENV JNLP_SLAVE_VERSION 2.52
 
 RUN curl -sSLo $HOME/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar \
  && curl -sSLo $HOME/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JNLP_SLAVE_VERSION/remoting-$JNLP_SLAVE_VERSION.jar

COPY jenkins-swarm-slave.sh /$HOME
USER root
RUN yum install -y xorg-x11-server-Xvfb  && yum install -y firefox \
&& chmod +x $HOME/jenkins-swarm-slave.sh
ENV GECKODRIVER_VERSION=0.11.1
RUN wget --no-verbose -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv /opt/geckodriver /opt/geckodriver-$GECKODRIVER_VERSION \
  && chmod 755 /opt/geckodriver-$GECKODRIVER_VERSION \
  && ln -fs /opt/geckodriver-$GECKODRIVER_VERSION /usr/bin/geckodriver

USER 1001
ENTRYPOINT ["/home/jenkins/jenkins-swarm-slave.sh"]
