FROM cmp1234/python:2.7.13-alpine3.6

# A few problems with compiling Java from source:
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#       really hairy.

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u141
ENV JAVA_ALPINE_VERSION 8.141.15-r0

RUN set -ex; \
	sed -i -e 's/v3\.6/edge/g' /etc/apk/repositories; \
	apk add --no-cache \
	openjdk8-jre="$JAVA_ALPINE_VERSION"; \
	sed -i -e 's/edge/v3\.6/g' /etc/apk/repositories; 

