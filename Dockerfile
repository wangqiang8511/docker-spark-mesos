FROM java:openjdk-8-jdk

MAINTAINER Dmitry B "ficha83@gmail.com"

RUN apt-get update && \
    apt-get install -y python libnss3 curl

RUN cd /tmp && \
        wget http://repos.mesosphere.com/debian/pool/main/m/mesos/mesos_1.1.0-2.0.107.debian81_amd64.deb && \
        dpkg --unpack mesos_1.1.0-2.0.107.debian81_amd64.deb && \
        apt-get install -f -y && \
        rm mesos_1.1.0-2.0.107.debian81_amd64.deb && \
        apt-get clean

RUN cd /tmp && \
        wget https://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz && \
        tar -xzvf spark-2.1.1-bin-hadoop2.7.tgz && \
        mv spark-2.1.1-bin-hadoop2.7 /opt/spark && \
        rm spark-2.1.1-bin-hadoop2.7.tgz

ENV MESOS_NATIVE_JAVA_LIBRARY /usr/lib/libmesos.so
ENV SPARK_HOME /opt/spark

COPY spark_conf/* /opt/spark/conf/
COPY scripts /scripts

ENTRYPOINT ["/scripts/run.sh"]
