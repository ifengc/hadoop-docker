#!/bin/bash

service ssh start
$HADOOP_PREFIX/bin/hadoop namenode -format
$HADOOP_PREFIX/bin/start-all.sh

if [[ $1 == "-d" ]]; then
        while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
        /bin/bash
fi
