streaming = hadoop jar /opt/hadoop/hadoop-0.20.2/contrib/streaming/hadoop-0.20.2-streaming.jar
exists = hadoop fs -test -e
delete = hadoop dfs -rmr
mydir = /user/s0925570/
size = Large

assignment: ./results/task_one.out ./results/task_two.out ./results/task_three.out ./results/task_four.out \
		./results/task_five.out ./results/task_six.out ./results/task_seven.out ./results/task_eight.out

./binaries/u_map:
	ghc -O3 ./upper_map.hs -o ./binaries/u_map

./binaries/u_reduce:
	ghc -O3 ./upper_reducer.hs -o ./binaries/u_reduce

./binaries/u_reduce_uniq:
	ghc -O3 ./upper_reducer_uniq.hs -o ./binaries/u_reduce_uniq

./binaries/t_reduce:
	g++ -O3 ./transpose_reduce.cpp -o ./binaries/t_reduce

./results/task_one.out: ./binaries/u_map ./binaries/u_reduce
	($(exists) $(mydir)s0925570_task_1.out && $(delete) $(mydir)s0925570_task_1.out) || true
	$(streaming) \
		-input  /user/s1250553/ex2/web$(size).txt \
		-output $(mydir)s0925570_task_1.out \
		-file ./binaries/u_map -mapper ./binaries/u_map \
		-file ./binaries/u_reduce -reducer ./binaries/u_reduce
	(hadoop dfs -cat $(mydir)s0925570_task_1.out/part-00000 | head -20 > ./results/task_one.out) || true

./results/task_two.out: ./binaries/u_map ./binaries/u_reduce_uniq
	($(exists) $(mydir)s0925570_task_2.out && $(delete) $(mydir)s0925570_task_2.out) || true
	$(streaming) \
		-input  /user/s1250553/ex2/web$(size).txt \
		-output $(mydir)s0925570_task_2.out \
		-file ./binaries/u_map -mapper ./binaries/u_map \
		-file ./binaries/u_reduce_uniq -reducer ./binaries/u_reduce_uniq
	(hadoop dfs -cat $(mydir)s0925570_task_2.out/part-00000 | head -20 > ./results/task_two.out) || true

./results/task_three.out:
	($(exists) $(mydir)s0925570_task_3.out && $(delete) $(mydir)s0925570_task_3.out) || true
	$(streaming) \
		-D mapred.reduce.tasks=1 \
		-input  /user/s1250553/ex2/web$(size).txt \
		-output $(mydir)s0925570_task_3.out \
		-file ./wc_map.rb -mapper ./wc_map.rb \
		-file ./wc_reduce.rb -reducer ./wc_reduce.rb
	(hadoop dfs -cat $(mydir)s0925570_task_3.out/part-00000 | head -20 > ./results/task_three.out) || true

./results/task_four.out:
	($(exists) $(mydir)s0925570_task_4.out && $(delete) $(mydir)s0925570_task_4.out) || true
	$(streaming) \
		-D mapred.reduce.tasks=1 \
		-input  /user/s1250553/ex2/web$(size).txt \
		-output $(mydir)s0925570_task_4.out \
		-file ./wc_prob_map.rb -mapper ./wc_prob_map.rb \
		-file ./wc_reduce.rb -reducer ./wc_reduce.rb
	(hadoop dfs -cat $(mydir)s0925570_task_4.out/part-00000 | head -20 > ./results/task_four.out) || true

./results/task_five.out: ./results/task_two.out
	($(exists) $(mydir)s0925570_task_5.out && $(delete) $(mydir)s0925570_task_5.out) || true
	$(streaming) \
		-input $(mydir)s0925570_task_2.out \
		-output $(mydir)s0925570_task_5.out \
		-file ./trigram_count_map.py -mapper ./trigram_count_map.py \
		-file ./trigram_count_reducer.py -reducer ./trigram_count_reducer.py
	(hadoop dfs -cat $(mydir)s0925570_task_5.out/part-00000 | head -20 > ./results/task_five.out) || true

./results/task_six.out: ./results/task_five.out
	($(exists) $(mydir)s0925570_task_6.out && $(delete) $(mydir)s0925570_task_6.out) || true
	$(streaming) \
		-D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
		-D mapred.text.key.comparator.options="-k1nr" \
		-D mapred.reduce.tasks=1 \
		-input $(mydir)s0925570_task_5.out \
		-output $(mydir)s0925570_task_6.out \
		-file ./flip_top_twenty.py -mapper ./flip_top_twenty.py \
		-file ./take_twenty_reducer.rb -reducer ./take_twenty_reducer.rb
	(hadoop dfs -cat $(mydir)s0925570_task_6.out/part-00000 | head -20 > ./results/task_six.out) || true

./results/task_seven.out: ./binaries/t_reduce
	($(exists) $(mydir)s0925570_task_7.out && $(delete) $(mydir)s0925570_task_7.out) || true
	$(streaming) \
		-D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
		-D stream.num.map.output.key.fields=2 \
		-D mapred.reduce.tasks=1 \
		-D mapred.text.key.comparator.options="-k1n -k2n" \
		-partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
		-input  /user/s1250553/ex2/matrix$(size).txt \
		-output $(mydir)s0925570_task_7.out \
		-file ./transpose_map.rb -mapper ./transpose_map.rb \
		-file ./binaries/t_reduce -reducer ./binaries/t_reduce
	(hadoop dfs -cat $(mydir)s0925570_task_7.out/part-00000 | head -20 > ./results/task_seven.out) || true

./results/task_eight.out:
	($(exists) $(mydir)s0925570_task_8.out && $(delete) $(mydir)s0925570_task_8.out) || true
	$(streaming) \
		-D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
		-D mapred.text.key.comparator.options="-k1n -k2" \
		-D stream.num.map.output.key.fields=2 \
		-D num.key.fields.for.partition=1 \
		-partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
		-input /user/s1250553/ex2/uni$(size).txt \
		-output $(mydir)s0925570_task_8.out \
		-file ./join_map.rb -mapper ./join_map.rb \
		-file ./join_reduce.rb -reducer ./join_reduce.rb
	(hadoop dfs -cat $(mydir)s0925570_task_8.out/part-00000 | head -20 > ./results/task_eight.out) || true

clean:
	rm ./results/*.out
	hadoop dfs -rmr $(mydir)s0925570_*.out
