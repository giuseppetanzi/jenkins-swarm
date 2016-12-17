# The FROM will be replaced when building in OpenShift
FROM openshift3/jenkins-slave-base-rhel7

MAINTAINER Giuseppe Tanzi <gtanzi@redhat.com>
LABEL io.k8s.display-name="Jenkins Slave - With Swarm plugin installed" \
      io.k8s.description="The jenkins slave swarm image has the swarm plugin on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,slave,swarm"
      
      
 ENV JENKINS_SWARM_VERSION 2.2
 USER root
 RUN curl -sSLo /var/lib/jenkins/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar \
  && curl -sSLo /var/lib/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JNLP_SLAVE_VERSION/remoting-$JNLP_SLAVE_VERSION.jar
 
COPY jenkins-slave.sh /var/lib/jenkins/

# Install headless Java
# USER root
#RUN yum install -y centos-release-scl-rh && \
#    INSTALL_PKGS="bc gettext git java-1.8.0-openjdk-headless lsof nss_wrapper rsync tar unzip which zip" && \
#    yum install -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
 #   rpm -V $INSTALL_PKGS && \
 #   yum clean all && \
  #   mkdir -p /var/lib/jenkins && \
#    chown -R 1001:0 /var/lib/jenkins && \
 #   chmod -R g+w /var/lib/jenkins && \

  #  curl -L https://github.com/openshift/origin/releases/download/v1.3.0/openshift-origin-client-tools-v1.3.0-3ab7af3d097b57f933eccef684a714f2368804e7-linux-64bit.tar.gz | \
#    tar -zx && \
 #   mv openshift*/oc /usr/local/bin && \
  #  rm -rf openshift-origin-client-tools-*

# Copy the entrypoint
#COPY configuration/* /var/lib/jenkins/
#USER 1001

# Run the JNLP client by default
# To use swarm client, specify "/var/lib/jenkins/run-swarm-client" as Command
USER 1001
ENTRYPOINT ["/var/lib/jenkins/jenkins-slave.sh"]
