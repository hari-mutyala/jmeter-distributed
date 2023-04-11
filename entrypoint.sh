#!/bin/bash
#


# Execute JMeter command
set -e
freeMem=`awk '/MemAvailable/ { print int($2/1024) }' /proc/meminfo`

[[ -z ${JVM_XMN} ]] && JVM_XMN=$(($freeMem/10*2))
[[ -z ${JVM_XMS} ]] && JVM_XMS=$(($freeMem/10*8))
[[ -z ${JVM_XMX} ]] && JVM_XMX=$(($freeMem/10*8))

export JVM_ARGS="-Xmn${JVM_XMN}m -Xms${JVM_XMS}m -Xmx${JVM_XMX}m"

echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo "jmeter args=$@"

EXTRA_ARGS=-Dlog4j2.formatMsgNoLookups=true
echo "jmeter ALL ARGS=${EXTRA_ARGS} $@"
jmeter ${EXTRA_ARGS} $@

echo "END Running Jmeter on `date`"


sh ${JMETER_HOME}/bin/jmeter.sh -n -t ${JMETER_HOME}/bin/examples/${SCRIPT_NAME} -R $REMOTE_HOSTS -l ${JMETER_HOME}/bin/reports/report1.jtl -e -o ${JMETER_HOME}/bin/reports  \
  	&& cd ${JMETER_HOME}/bin/reports/  \
   	&& zip -r API_PERF_Results.zip .

# -n -t ${JMETER_HOME}/bin/examples/${SCRIPT_NAME} -l "/tests/${TEST_DIR}/${TEST_PLAN}.jtl" exec tail -f jmeter.log -D "java.rmi.server.hostname=${IP}" -D "client.rmi.localport=${RMI_PORT}" -R $REMOTE_HOSTS
