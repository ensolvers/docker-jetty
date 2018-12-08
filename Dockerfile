FROM jetty:9.4.9

ENV ENVIRONMENT $ENVIRONMENT
ENV VERSION $VERSION

USER root

COPY lib/newrelic-java-4.1.0.zip /var/lib/jetty/newrelic.zip
RUN unzip newrelic.zip

COPY scripts /tmp/scripts

# install system dependencies
RUN /bin/bash -c "source /tmp/scripts/setup.sh"

RUN rm /tmp/scripts/setup.sh

COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh

RUN sed -i 's/threads.max=200/threads.max=50/g' /var/lib/jetty/start.d/server.ini

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["java","-jar","/usr/local/jetty/start.jar", "-Djetty.http.port=80", "-Djetty.threadPool.maxThreads=500"]
