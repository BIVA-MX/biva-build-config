FROM @conf.docker.from@

ARG UID=1000
ARG GID=1000

RUN addgroup --gid "$GID" appgroup && \
    adduser --uid $UID --ingroup appgroup \
    --disabled-password appuser

USER appuser

VOLUME /tmp
ADD ./@archivesBaseName@-@version@.jar app.jar
@conf.docker.extraCommands@

ENV TZ="America/Mexico_City"

ENTRYPOINT ["java", "-jar", "/app.jar", "--spring.config.location=/config/application.yml"]
