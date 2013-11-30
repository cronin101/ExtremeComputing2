streaming = hadoop jar /opt/hadoop/hadoop-0.20.2/contrib/streaming/hadoop-0.20.2-streaming.jar
exists = hadoop fs -test -e
delete = hadoop dfs -rmr
mydir = /user/s0925570/
size = Small

./binaries/u_map:
	ghc -O3 ./upper_map.hs -o ./binaries/u_map

./binaries/u_reduce:
	ghc -O3 ./upper_reducer.hs -o ./binaries/u_reduce

./binaries/u_reduce_uniq:
	ghc -O3 ./upper_reducer_uniq.hs -o ./binaries/u_reduce_uniq

task_one.out: ./binaries/u_map ./binaries/u_reduce
	($(exists) $(mydir)s0925570_task_1.out && $(delete) $(mydir)s0925570_task_1.out) || true
	$(streaming) \
		-input  /user/s1250553/ex2/web$(size).txt\
		-output $(mydir)s0925570_task_1.out\
		-file ./binaries/u_map -mapper ./binaries/u_map\
		-file ./binaries/u_reduce -reducer ./binaries/u_reduce
	(hadoop dfs -cat $(mydir)s0925570_task_1.out/part-00000 | head -20 > task_one.out) || true

task_two.out: ./binaries/u_map ./binaries/u_reduce_uniq
	($(exists) $(mydir)s0925570_task_2.out && $(delete) $(mydir)s0925570_task_2.out) || true
	$(streaming) \
		-input  /user/s1250553/ex2/web$(size).txt\
		-output $(mydir)s0925570_task_2.out\
		-file ./binaries/u_map -mapper ./binaries/u_map\
		-file ./binaries/u_reduce_uniq -reducer ./binaries/u_reduce_uniq
	(hadoop dfs -cat $(mydir)s0925570_task_2.out/part-00000 | head -20 > task_two.out) || true

task_three.out:
	($(exists) $(mydir)s0925570_task_3.out && $(delete) $(mydir)s0925570_task_3.out) || true
	$(streaming) \
		-D mapred.reduce.tasks=1 \
		-input  /user/s1250553/ex2/web$(size).txt\
		-output $(mydir)s0925570_task_3.out\
		-file ./wc_map.rb -mapper ./wc_map.rb\
		-file ./wc_reduce.rb -reducer ./wc_reduce.rb
	(hadoop dfs -cat $(mydir)s0925570_task_3.out/part-00000 | head -20 > task_three.out) || true

assignment: task_one.out task_two.out task_three.out

clean:
	rm ./*.out
	hadoop dfs -rmr $(mydir)s0925570_*.out
