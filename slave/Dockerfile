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
RUN yum install xorg-x11-server-Xvfb && yum install firefox \
&& chmod +x $HOME/jenkins-swarm-slave.sh

USER 1001
ENTRYPOINT ["/home/jenkins/jenkins-swarm-slave.sh"]
