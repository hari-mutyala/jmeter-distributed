
FROM alpine:3.12

LABEL AUTHOR="Hari Mutyala"
LABEL ORG="Innominds Software Inc"

ARG JMETER_VERSION="5.5"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JMETER_PLUGINS_DOWNLOAD_URL http://repo1.maven.org/maven2/kg/apc
ENV JMETER_PLUGINS_FOLDER ${JMETER_HOME}/lib/ext
#ENV SCRIPT_NAME Distri_Test1.jmx
#ENV REMOTE_HOSTS="10.0.2.2,10.0.2.3"

# Install extra packages
# Set TimeZone, See: https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-612751142
ARG TZ="America/New_York"
ENV TZ ${TZ}
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk11-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies  \
	&& chmod +x ${JMETER_HOME}/bin/  \
	&& chmod +x ${JMETER_HOME}/bin/examples/  \
	&& apk add --update zip  \
	&& mkdir -p -m 777 ${JMETER_HOME}/bin/reports  \
	&& chmod 777 ${JMETER_HOME}/bin/reports  \
	&& echo "server.rmi.ssl.disable=true" >> ${JMETER_HOME}/bin/jmeter.properties

RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-dummy/0.4/jmeter-plugins-dummy-0.4.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-dummy-0.4.jar
RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-cmn-jmeter/0.7/jmeter-plugins-cmn-jmeter-0.7.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-cmn-jmeter-0.7.jar

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

WORKDIR ${JMETER_HOME}

#EXPOSE 1099
#EXPOSE 1100

COPY ${SCRIPT_NAME} ${JMETER_HOME}/bin/examples/

RUN  chmod +x ${JMETER_HOME}/bin/examples/${SCRIPT_NAME}

#COPY launch.sh /

#ENTRYPOINT ["/launch.sh"]
	 	
#ENTRYPOINT ["/entrypoint.sh"]

#ENTRYPOINT sh ${JMETER_HOME}/bin/jmeter.sh -n -t ${JMETER_HOME}/bin/examples/${SCRIPT_NAME} -R 10.0.2.2,10.0.2.3 -l ${JMETER_HOME}/bin/reports/report1.log -e -o ${JMETER_HOME}/bin/reports  \
#    	&& cd ${JMETER_HOME}/bin/reports/  \
#    	&& zip -r API_PERF_Results.zip .
