FROM python:2.7.13

ENV SUPERSET_VERSION=0.17.4

RUN apt-get -y update && \
    apt-get -y install build-essential libssl-dev libffi-dev python-dev python-pip libsasl2-dev libldap2-dev && \
    pip install superset==$SUPERSET_VERSION mysqlclient==1.3.7 && \
    addgroup superset && \
    adduser --home /home/superset --group superset superset && \
    mkdir -p /home/superset/.superset && \
    touch /home/superset/.superset/superset.db && \
    chown -R superset:superset /home/superset

# Configure Filesystem

WORKDIR /home/superset
COPY  superset .
VOLUME /home/superset/.superset

# Deploy application
EXPOSE 8088
HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]
ENTRYPOINT ["superset"]
CMD ["runserver"]
USER superset


