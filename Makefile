streaming = hadoop jar /opt/hadoop/hadoop-0.20.2/contrib/streaming/hadoop-0.20.2-streaming.jar
exists = hadoop fs -test -e
delete = hadoop dfs -rmr
mydir = /user/s0925570/
size = Large

assignment: ./exc-mr.txt

./exc-mr.txt: ./results/task_one.out ./results/task_two.out ./results/task_three.out ./results/task_four.out \
		./results/task_five.out ./results/task_six.out ./results/task_seven.out ./results/task_eight.out
	ruby ./script/report.rb > ./exc-mr.txt

./bin/u_map:
	ghc -O3 ./src/upper_map.hs -o ./bin/u_map

./bin/u_map_uniq:
	ghc -O3 ./upper_map_uniq.hs -o ./bin/u_map_uniq

./bin/u_reduce_uniq:
	ghc -O3 ./src/upper_reducer_uniq.hs -o ./bin/u_reduce_uniq

./bin/t_reduce:
	g++ -O3 ./src/transpose_reduce.cpp -o ./bin/t_reduce

./results/task_one.out: ./bin/u_map
	- $(exists) $(mydir)s0925570_task_1.out && $(delete) $(mydir)s0925570_task_1.out
	# We do not need to run any Reducers for this task. Simply map every line of the input to uppercase.
	$(streaming) \
		-D mapred.reduce.tasks=0 \
		-input  /user/s1250553/ex2/web$(size).txt \
		-output $(mydir)s0925570_task_1.out \
		-file ./bin/u_map -mapper ./bin/u_map
	- hadoop dfs -cat $(mydir)s0925570_task_1.out/part-00000 | head -20 > ./results/task_one.out

./results/task_two.out: ./bin/u_map_uniq ./bin/u_reduce_uniq
	- $(exists) $(mydir)s0925570_task_2.out && $(delete) $(mydir)s0925570_task_2.out
	$(streaming) \
		-input  /user/s1250553/ex2/web$(size).txt \
		-output $(mydir)s0925570_task_2.out \
		-file ./bin/u_map_uniq -mapper ./bin/u_map_uniq \
		-file ./bin/u_reduce_uniq -reducer ./bin/u_reduce_uniq
	- hadoop dfs -cat $(mydir)s0925570_task_2.out/part-00000 | head -20 > ./results/task_two.out

./results/task_three.out:
	($(exists) $(mydir)s0925570_task_3.out && $(delete) $(mydir)s0925570_task_3.out) || true
	#Only using one Reducer, its job is to combine the partial counts with complexity O(Mappers).
	$(streaming) \
		-D mapred.reduce.tasks=1 \
		-input  /user/s1250553/ex2/web$(size).txt \
		-output $(mydir)s0925570_task_3.out \
		-file ./script/wc_map.rb -mapper ./script/wc_map.rb \
		-file ./script/wc_reduce.rb -reducer ./script/wc_reduce.rb
	- hadoop dfs -cat $(mydir)s0925570_task_3.out/part-00000 | head -20 > ./results/task_three.out

./results/task_four.out:
	- $(exists) $(mydir)s0925570_task_4.out && $(delete) $(mydir)s0925570_task_4.out
	#Same as previous task, a single Reducer is used.
	$(streaming) \
		-D mapred.reduce.tasks=1 \
		-input  /user/s1250553/ex2/web$(size).txt \
		-output $(mydir)s0925570_task_4.out \
		-file ./script/wc_prob_map.rb -mapper ./script/wc_prob_map.rb \
		-file ./script/wc_reduce.rb -reducer ./script/wc_reduce.rb
	- hadoop dfs -cat $(mydir)s0925570_task_4.out/part-00000 | head -20 > ./results/task_four.out

./results/task_five.out: ./results/task_two.out
	- $(exists) $(mydir)s0925570_task_5.out && $(delete) $(mydir)s0925570_task_5.out
	$(streaming) \
		-input $(mydir)s0925570_task_2.out \
		-output $(mydir)s0925570_task_5.out \
		-file ./script/trigram_count_map.py -mapper ./script/trigram_count_map.py \
		-file ./script/trigram_count_reducer.py -reducer ./script/trigram_count_reducer.py
	- hadoop dfs -cat $(mydir)s0925570_task_5.out/part-00000 | head -20 > ./results/task_five.out

./results/task_six.out: ./results/task_five.out
	- $(exists) $(mydir)s0925570_task_6.out && $(delete) $(mydir)s0925570_task_6.out
	# Each Mapper emits the top 20 frequency (count, trigram) pairs.
	# The result, sized O(Mappers), is sorted by decreasing numerical frequency and the single Reducer
	# prints the first 20.
	$(streaming) \
		-D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
		-D mapred.text.key.comparator.options="-k1nr" \
		-D mapred.reduce.tasks=1 \
		-input $(mydir)s0925570_task_5.out \
		-output $(mydir)s0925570_task_6.out \
		-file ./script/flip_top_twenty.py -mapper ./script/flip_top_twenty.py \
		-file ./script/take_twenty_reducer.rb -reducer ./script/take_twenty_reducer.rb
	- hadoop dfs -cat $(mydir)s0925570_task_6.out/part-00000 | head -20 > ./results/task_six.out

./results/task_seven.out: ./bin/t_reduce
	- $(exists) $(mydir)s0925570_task_7.out && $(delete) $(mydir)s0925570_task_7.out
	# The Mappers emit (j, i, n) for each Aij = n. The result is sorted by increasing j then increasing i.
	# The processing is done by a single Reducer with complexity O(M) for a matrix with M elements, this could
	# be spread across multiple reducers and then combined by using a total-order-partitioner and
	# specifying split-points.
	$(streaming) \
		-D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
		-D stream.num.map.output.key.fields=2 \
		-D mapred.reduce.tasks=1 \
		-D mapred.text.key.comparator.options="-k1n -k2n" \
		-partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
		-input  /user/s1250553/ex2/matrix$(size).txt \
		-output $(mydir)s0925570_task_7.out \
		-file ./script/transpose_map.rb -mapper ./script/transpose_map.rb \
		-file ./bin/t_reduce -reducer ./bin/t_reduce
	- hadoop dfs -cat $(mydir)s0925570_task_7.out/part-00000 | head -20 > ./results/task_seven.out

./results/task_eight.out:
	- $(exists) $(mydir)s0925570_task_8.out && $(delete) $(mydir)s0925570_task_8.out
	# Each record with student_id as its primary key emits (id, 'primary', fields).
	# Each record with student_id as its foreign key emits (id, 'secondry', fields).
	# The data is partitioned so that tuples sharing the same id will go to the same reducer.
	# The data is sorted so that within a reducer, the secondary records for a given id will
	# follow the primary record for that id, by numeric sorting on id
	# followed by sorting on 'primary'/'secondary'.
	$(streaming) \
		-D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
		-D mapred.text.key.comparator.options="-k1n -k2" \
		-D stream.num.map.output.key.fields=2 \
		-D num.key.fields.for.partition=1 \
		-partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
		-input /user/s1250553/ex2/uni$(size).txt \
		-output $(mydir)s0925570_task_8.out \
		-file ./script/join_map.rb -mapper ./script/join_map.rb \
		-file ./script/join_reduce.rb -reducer ./script/join_reduce.rb
	- hadoop dfs -cat $(mydir)s0925570_task_8.out/part-00000 | head -20 > ./results/task_eight.out

clean:
	rm ./bin/*
	rm ./results/*.out
	hadoop dfs -rmr $(mydir)s0925570_*.out
