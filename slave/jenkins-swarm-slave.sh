#!/bin/bash

master_username=${JENKINS_USERNAME:-"admin"}
master_password=${JENKINS_PASSWORD:-"password"}
slave_executors=${EXECUTORS:-"1"}
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

source /usr/local/bin/generate_container_user

function get_server_num() {
  echo $(echo $DISPLAY | sed -r -e 's/([^:]+)?:([0-9]+)(\.[0-9]+)?/\2/')
}

function shutdown {
  kill -s SIGTERM $NODE_PID
  wait $NODE_PID
}

echo "Running Jenkins Swarm Plugin...."

# jenkins swarm slave
JAR=`ls -1 /home/jenkins/swarm-client-*.jar | tail -n 1`

if [[ "$@" != *"-master "* ]] && [ ! -z "$JENKINS_PORT_8080_TCP_ADDR" ]; then
#PARAMS="-master http://${JENKINS_SERVICE_HOST}:${JENKINS_SERVICE_PORT}${JENKINS_CONTEXT_PATH} -tunnel ${JENKINS_SLAVE_SERVICE_HOST}:${JENKINS_SLAVE_SERVICE_PORT}${JENKINS_SLAVE_CONTEXT_PATH} -username ${master_username} -password ${master_password} -executors ${slave_executors}"
PARAMS="-master http://${JENKINS_SERVICE_HOST}:${JENKINS_SERVICE_PORT}${JENKINS_CONTEXT_PATH} -username ${master_username} -password ${master_password} -executors ${slave_executors} -labels ${SLAVE_LABEL}"
fi

echo Running java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@" in xvfb environment

SERVERNUM=$(get_server_num)
echo SERVERNUM $SERVERNUM

rm -f /tmp/.X*lock

xvfb-run -n $SERVERNUM --server-args="-screen 0 $GEOMETRY -ac +extension RANDR" \
java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@" &
NODE_PID=$!

trap shutdown SIGTERM SIGINT
wait $NODE_PID
