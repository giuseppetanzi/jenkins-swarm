# Jenkins Grid with Swarm Plugin, based on Jenkins S2I for OpenShift

An example demonstrating how to start a Jenkins slave pool on OpenShift, based on the Swarm plugin for Jenkins.

## Installation

1. Create a new OpenShift project, where the Jenkins server will run:

  ```
  $ oc new-project jenkins-pool --display-name="Jenkins Pool Based on Swarm Plugin"
  ```

2. Give the Jenkins Pod service account rights to do API calls to OpenShift. This allows us to do the Jenkins Slave image discovery automatically.

  ```
  $ oc policy add-role-to-user edit -z default -n jenkins-pool
  ```

3. Install the provided OpenShift templates:

  ```
  $ oc create -f jenkins-master-s2i-template.yaml      # For creating pre-configured Jenkins master (ephemeral) using Jenkins S2I
  $ oc create -f jenkins-swarm-slave-template.yaml     # For creating swarm-enabled Jenkins slave pool
  ```
  (Alternatively, you can install the all-in-one template, containing all the needed resources for master and slaves):
  
```
  $ oc create -f jenkins-swarm-master-slave-template.yaml      # For creating pre-configured Jenkins master (ephemeral) using Jenkins S2I and swarm-enabled Jenkins slaves
  ```
  
4. Build and create Jenkins master (via Web Console or the following CLI). The template uses S2I to preload some configuration into Jenkins (plugins, JDK/Maven configuration,...)

  ```
  $ oc new-app jenkins-master-s2i
  ```
  
  (Alternatively, you can instantiate the all-in-one template for both master and slaves)
  
  ```
  $ oc new-app jenkins-master-slave-swarm
  ```
5. (To be skipped if you instantiated the all-in-one template at step 4). Build and create Jenkins slave image. The relative Dockerfile inherits from the default "openshift/jenkins-slave-maven-centos7" Docker image, so any Jenkins Maven build can be run on the slaves. Note that the EXECUTORS parameter of the template can allow a higher parallelism, configuring a number of available executor threads on each slave (default value is 3). 

  ```
  $ oc new-app jenkins-swarm-slave-builder
  ```
6. The template creates only one replica of the Swarm-enabled slave (with 3 executor threads). Scale out your Jenkins pool via the OpenShift UI or the corresponding CLI command:

  ```
  $ oc scale dc/jenkins-slave --replicas=5
  ```
The swarm plugins dynamically creates new nodes into the Jenkins master configuration and registers the slave instances accordingly when starting up.

