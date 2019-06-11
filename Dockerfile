FROM adaptris/interlok:latest

EXPOSE 8080 5555

ARG java_tool_opts
ENV JAVA_TOOL_OPTIONS=$java_tool_opts

WORKDIR /opt/interlok
COPY builder /root/builder

RUN cd /root/builder && \
    rm -rf /opt/interlok/docs/javadocs && \
    chmod +x /root/builder/gradlew && \
    ./gradlew --no-daemon installDist && \
    chmod +x /docker-entrypoint.sh && \
    rm -rf /root/.gradle && \
    rm -rf /root/builder

ENV JAVA_TOOL_OPTIONS=""

VOLUME [ "/opt/interlok/config", "/opt/interlok/logs" , "/opt/interlok/ui-resources" ]
