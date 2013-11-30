streaming = hadoop jar /opt/hadoop/hadoop-0.20.2/contrib/streaming/hadoop-0.20.2-streaming.jar
size = Small

task_one.out: clean
	$(streaming)\
		-input  /user/s1250553/ex2/web$(size).txt\
		-output /user/s0925570/s0925570_task_1.out\
		-file ./binaries/u_map -mapper ./binaries/u_map\
		-file ./binaries/u_reduce -reducer ./binaries/u_reduce
	hadoop dfs -cat /user/s0925570/s0925570_task_1.out | head -20 > task_one.out

clean:
	hadoop dfs -rmr /user/s0925570/s0925570_*.out
