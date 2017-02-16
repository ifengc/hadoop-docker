REGISTER '/root/myudf.py' USING jython AS myudf;

student = LOAD 'hdfs://localhost:9000/user/root/input/student.txt' USING PigStorage(',')
   as (id:int, firstname:chararray, lastname:chararray, age:int, grade:int);

student_order = ORDER student BY age DESC;

student_new = FOREACH student_order GENERATE id, firstname, lastname, age, myudf.add(grade);

Dump student_new;
