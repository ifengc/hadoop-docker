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

##### Hadoop functionality test
```bash
cd /usr/local/hadoop
bin/hadoop fs -put conf input
bin/hadoop jar hadoop-examples-*.jar grep input output 'dfs[a-z.]+'
bin/hadoop fs -cat output/*
```

##### Pig installation and functionality test
```bash
//create the following files (script.pig, myudf.py, student.txt) first
curl -s http://apache.stu.edu.tw/pig/pig-0.13.0/pig-0.13.0.tar.gz | tar -xz -C /usr/local/
cd /usr/local && ln -s ./pig-0.13.0 pig

#create script.pig, myudf.py, student.txt
$HADOOP_PREFIX/bin/hadoop fs -put student.txt input
/usr/local/pig/bin/pig script.pig
```


- __script.pig (pig script example)__

```bash
REGISTER '/root/myudf.py' USING jython AS myudf;

student = LOAD 'hdfs://localhost:9000/user/root/input/student.txt' USING PigStorage(',')
   as (id:int, firstname:chararray, lastname:chararray, age:int, phone:chararray, city:chararray);

student_order = ORDER student BY age DESC;

student_new = FOREACH student_order GENERATE myudf.idNew(id), firstname, age;

student_limit = LIMIT student_new 4;

Dump student_limit;
```


- __myudf.py (python udf example)__

```python
import re
@outputSchema('id:int')
def idNew(idOld):
        match = re.search(r'\d', str(idOld))
        if match:
                newId = int(match.group()) * 10
        return newId
```


- __student.txt (input data)__

```
001,Rajiv,Reddy,21,9848022337,Hyderabad
002,siddarth,Battacharya,22,9848022338,Kolkata
003,Rajesh,Khanna,22,9848022339,Delhi
004,Preethi,Agarwal,21,9848022330,Pune
005,Trupthi,Mohanthy,23,9848022336,Bhuwaneshwar
006,Archana,Mishra,23,9848022335,Chennai
007,Komal,Nayak,24,9848022334,trivendram
008,Bharathi,Nambiayar,24,9848022333,Chennai
```