#!/bin/bash

#
# This script expects the standdard JMeter command parameters.
#

set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

echo "START Running Apache JMeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo "$CMD args=$@"

# Keep entrypoint simple: we must pass the standard JMeter arguments
jmeter $@
echo "END Running Jmeter on `date`"

# sh ${JMETER_HOME}/bin/jmeter.sh -n -t ${JMETER_HOME}/bin/examples/${SCRIPT_NAME} -R $REMOTE_HOSTS -l ${JMETER_HOME}/bin/reports/report1.jtl -e -o ${JMETER_HOME}/bin/reports  \
#   	&& cd ${JMETER_HOME}/bin/reports/  \
#    	&& zip -r API_PERF_Results.zip .

# -n -t ${JMETER_HOME}/bin/examples/${SCRIPT_NAME} -l "/tests/${TEST_DIR}/${TEST_PLAN}.jtl" exec tail -f jmeter.log -D "java.rmi.server.hostname=${IP}" -D "client.rmi.localport=${RMI_PORT}" -R $REMOTE_HOSTS
