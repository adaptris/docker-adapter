FROM openjdk:8-jdk-slim

MAINTAINER Adaptris

EXPOSE 8080 5555

ARG INTERLOK_VERSION=3.8.4
ARG BASE_URL=https://development.adaptris.net/installers/Interlok/${INTERLOK_VERSION}/

RUN apt-get -y -q update && \
    apt-get -y -q upgrade && \
    apt-get install -y curl bash unzip && \
    rm -rf /var/lib/apt/lists/*

ADD docker-entrypoint.sh /
RUN mkdir -p /opt/interlok/logs
WORKDIR /opt/interlok/

RUN  \
    curl -fsSL -o base-filesystem.zip -q ${BASE_URL}/base-filesystem.zip && \
    curl -fsSL -o runtime-libraries.zip ${BASE_URL}/runtime-libraries.zip && \
    curl -fsSL -o javadocs.zip ${BASE_URL}/javadocs.zip && \
    unzip -o -q javadocs.zip && \
    unzip -o -q  runtime-libraries.zip && \
    unzip -o -q  base-filesystem.zip && \
    rm -rf /opt/interlok/optional && \
    rm -rf /opt/interlok/docs/javadocs/optional && \
    chmod +x /docker-entrypoint.sh && \
    rm -rf *.zip

VOLUME [ "/opt/interlok/config", "/opt/interlok/logs" , "/opt/interlok/ui-resources" ]

ENTRYPOINT ["/docker-entrypoint.sh"]
