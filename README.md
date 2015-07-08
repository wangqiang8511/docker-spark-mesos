# Introduction

Docker image for running spark with mesos.
Build with 

* latest scipystack images to unlock pyspark power.
* spark 1.4.0
* mesos 0.22.1

# Reference

* [Deploy spark on mesos cluster with docker](https://spark.apache.org/docs/latest/running-on-mesos.html#mesos-docker-support)
* [Ipython Scipystack Image](https://registry.hub.docker.com/u/ipython/scipystack/)

# How to use

Build Image

```bash
./build
```

Spark driver config in your $SPARK\_HOME/conf/spark-defaults.conf

```bash
spark.master                       mesos://your_mesos_master:5050
spark.mesos.mesosExecutor.cores    0.8
spark.mesos.executor.docker.image  sparkmesos:lastest
spark.mesos.executor.home          /opt/spark
```

Run the following script in any instance with mesos, docker installed to driver spark with mesos

```bash
docker run -it --rm \
  -e SPARK_MASTER="mesos://zk://$ZOOKEEPER_HOSTS" \
  -e SPARK_IMAGE="sparkmesos:latest" \
  -e PYSPARK_DRIVER_PYTHON=ipython2 \
  sparkmesos:latest /opt/spark/bin/pyspark
```

Run a jupyter server with pyspark running on mesos cluster.

```bash
docker run -it --rm \
  -e SPARK_MASTER="mesos://zk://$ZOOKEEPER_HOSTS" \
  -e SPARK_IMAGE="sparkmesos:latest" \
  -e PYSPARK_DRIVER_PYTHON=ipython2 \
  -e PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip='*'" \
  sparkmesos:latest /opt/spark/bin/pyspark
```

We suggest start the jupyter docker container with marathon as a services.

# How to set other configurations

You can set following config with ENV

* spark.master  $SPARK\_MASTER
* spark.mesos.mesosExecutor.cores   $MESOS\_EXECUTOR\_CORE
* spark.mesos.executor.docker.image  $SPARK\_IMAGE

The other settings like spark.executor.memory can be set when you run the driver docker container with --conf. 

```bash
docker run -it --rm \
  -e SPARK_MASTER="mesos://zk://$ZOOKEEPER_HOSTS" \
  -e SPARK_IMAGE="sparkmesos:latest" \
  -e PYSPARK_DRIVER_PYTHON=ipython2 \
  sparkmesos:latest /opt/spark/bin/spark-submit --name "My app" \
  --driver-memory=2g \
  --conf spark.executor.memory=5g \
  --conf spark.shuffle.spill=false \
  --conf "spark.executor.extraJavaOptions=-XX:+PrintGCDetails -XX:+PrintGCTimeStamps" myApp.jar
```

You can also mount docker volume to replace /opt/spark/conf/spark-defaults.conf

```bash
docker run -it --rm \
  -e SPARK_MASTER="mesos://zk://$ZOOKEEPER_HOSTS" \
  -e SPARK_IMAGE="sparkmesos:latest" \
  -e PYSPARK_DRIVER_PYTHON=ipython2 \
  -v /path/to/your/spark-defaults.conf:/opt/spark/conf/spark-defaults.conf \
  sparkmesos:latest /opt/spark/bin/pyspark
```

# TODO

Add native netlib-java in the image for mllib. See [here](https://spark.apache.org/docs/latest/mllib-guide.html)
