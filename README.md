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

4. Build and create Jenkins master (via Web Console or the following CLI). The template uses S2I to preload some configuration into Jenkins (plugins, JDK/Maven configuration,...)

  ```
  $ oc new-app jenkins-master-s2i
  ```
5. Build and create Jenkins slave image. The image Dockerfile inherits from the default "

  ```
  $ oc new-app jenkins-slave-builder
  ```

