# Spark Docker for Mesos (DCOS)

Docker image for running spark with mesos (DCOS).
Build with 

* spark 2.1.1 (hadoop 2.7) (https://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz)
* mesos 1.1.0 (http://repos.mesosphere.com/debian/pool/main/m/mesos/mesos_1.1.0-2.0.107.debian81_amd64.deb)

# How to use

Build Image

```bash
make docker-build
```

Pull Image

```bash
make docker-pull
```

Start spark driver inside docker container

```bash
MESOS_IP=mesos://<ip>:<port>
EXECUTOR_IMAGE=dmitryb/mesos-spark:2.1.1
CORES=2
RAM=2g

docker run -it --rm --net=host dmitryb/mesos-spark:2.1.1 bash /opt/spark/bin/spark-shell \
    --conf spark.master=${MESOS_IP} \
    --conf spark.driver.host=${DRIVER_IP} \
    --conf spark.mesos.coarse=true \
    --conf spark.mesos.executor.docker.image=${EXECUTOR_IMAGE} \
    --conf spark.mesos.executor.home=/opt/spark \
    --conf spark.task.maxFailures=10 \
    --conf spark.sql.parquet.compression.codec=gzip \
    --conf spark.sql.warehouse.dir=file:///tmp \
    --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
    --conf spark.kryoserializer.buffer.max=1g \
    --conf spark.task.cpus=1 \
    --conf spark.executor.memory=${RAM} \
    --conf spark.cores.max=${CORES} \
    --conf spark.sql.shuffle.partitions=2000 \
    --conf spark.shuffle.spill=true \
    --conf spark.executor.heartbeatInterval=10
```

# TODO

Integrate with pyspark
