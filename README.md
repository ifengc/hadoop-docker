# hadoop-docker

- The Dockerfile and config files are referenced from sequenceiq/hadoop-docker 
- This testing environment is for hadoop-1.2.1, java-1.6 and pig-0.13.0

##### Build the image
```
docker build -t ifengc/hadoop-docker:1.2.1 .
```

##### Run the container
```
docker run -it -p 50030:50030 -p 50060:50060 -p 50070:50070 ifengc/hadoop-docker:1.2.1 /etc/bootstrap.sh -bash
```

##### Hadoop testing
```bash
$HADOOP_PREFIX/bin/hadoop fs -put $HADOOP_PREFIX/conf input
$HADOOP_PREFIX/bin/hadoop jar hadoop-examples-*.jar grep input output 'dfs[a-z.]+'
$HADOOP_PREFIX/bin/hadoop fs -cat output/*
```

##### Pig testing
```bash
$HADOOP_PREFIX/bin/hadoop fs -put /root/pig-example/student.txt input
/usr/local/pig/bin/pig /root/pig-example/script.pig
```

