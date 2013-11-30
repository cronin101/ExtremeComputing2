streaming = hadoop jar /opt/hadoop/hadoop-0.20.2/contrib/streaming/hadoop-0.20.2-streaming.jar
size = Small

./binaries/u_map:
	ghc -O3 ./upper_map.hs -o ./binaries/u_map

task_one.out: clean ./binaries/u_map
	$(streaming) \
		-input  /user/s1250553/ex2/web$(size).txt\
		-output /user/s0925570/s0925570_task_1.out\
		-file ./ -mapper ./binaries/u_map\
		-file ./binaries/u_reduce -reducer ./binaries/u_reduce
	hadoop dfs -cat /user/s0925570/s0925570_task_1.out | head -20 > task_one.out

clean:
	hadoop dfs -rmr /user/s0925570/s0925570_*.out
