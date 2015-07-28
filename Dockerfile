FROM ipython/scipystack

MAINTAINER Wang Qiang "wangqiang8511@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y python libnss3 openjdk-7-jre-headless curl

RUN curl https://s3.amazonaws.com/bigdata-thirdparty/spark/spark-1.4.0-bin-hadoop2.6.tgz \
    | tar -xzC /opt && \
    mv /opt/spark* /opt/spark

RUN curl -s -O  https://s3.amazonaws.com/bigdata-thirdparty/mesos_cluster/mesos_0.22.1/mesos-0.22.1.deb && \
    dpkg --unpack mesos-0.22.1.deb && \
    apt-get install -f -y && \
    rm mesos-0.22.1.deb && \
    apt-get clean

# Fix pypspark six error.
RUN pip2 install -U six
RUN pip2 install boto
RUN pip2 install msgpack-python
RUN pip2 install avro

COPY spark_conf/* /opt/spark/conf/
COPY scripts /scripts

ENV SPARK_HOME /opt/spark

ENTRYPOINT ["/scripts/run.sh"]
