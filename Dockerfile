FROM ubuntu:14.04
USER root

# Skip "action forbidden by policy" warning
RUN sed -i 's/101/0/g' /usr/sbin/policy-rc.d

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y curl tar openssh-server openssh-client rsync

# Passwordless ssh configuration
RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# Skip unknown host checking for localhost
ADD ssh_config /root/.ssh/config

# Java-1.6
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get -y install openjdk-6-jdk
ENV JAVA_HOME /usr/lib/jvm/java-1.6.0-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

# Install hadoop-1.2.1
RUN curl -s http://archive.apache.org/dist/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./hadoop-1.2.1 hadoop

# hadoop-env.sh configuration
ENV HADOOP_PREFIX /usr/local/hadoop
RUN sed -i -e '$aexport JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-amd64' $HADOOP_PREFIX/conf/hadoop-env.sh
RUN sed -i -e '$aexport HADOOP_PREFIX=/usr/local/hadoop' $HADOOP_PREFIX/conf/hadoop-env.sh
#RUN sed -i -e '$aexport HADOOP_HOME=/usr/local/hadoop' $HADOOP_PREFIX/conf/hadoop-env.sh
RUN sed -i -e '$aexport HADOOP_CONF_DIR=/usr/local/hadoop/conf' $HADOOP_PREFIX/conf/hadoop-env.sh

# Add hadoop configuration file
ADD core-site.xml $HADOOP_PREFIX/conf/core-site.xml
ADD hdfs-site.xml $HADOOP_PREFIX/conf/hdfs-site.xml
ADD mapred-site.xml $HADOOP_PREFIX/conf/mapred-site.xml

# Install pig-0.13.0
RUN curl -s https://archive.apache.org/dist/pig/pig-0.13.0/pig-0.13.0.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./pig-0.13.0 pig

# Add pig example for testing
RUN mkdir /root/pig-example
ADD pig-example/script.pig /root/pig-example/script.pig
ADD pig-example/student.txt /root/pig-example/student.pig
ADD pig-example/myudf.py /root/pig-example/myudf.py

# Add bootstrap script
ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

EXPOSE 50030 50060 50070
