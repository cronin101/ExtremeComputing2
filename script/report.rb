#!/usr/bin/env ruby

def code_segment(task, files)
  puts "\nTask #{task} code begin\n"
  files.each do |file|
    puts "\n<#{file}>\n\n"
    puts IO.read file
    puts "\n</#{file}>\n"
  end
  puts "\nTask #{task} code end\n"
end

def results(task, file)
  puts "\nTask #{task} results begin\n\n"
  puts IO.read file
  puts "\nTask #{task} results end\n"
end

puts "Code (Makefile used for all tasks) begin\n\n<./Makefile>\n\n"
puts IO.read './Makefile'
puts "\n<./Makefile>\n\nCode (Makefile used for all tasks) end\n"

code_segment 1, ['./src/upper_map.hs']
results 1, './results/task_one.out'

code_segment 2, ['./src/upper_map_uniq.hs', './src/upper_reducer_uniq.hs']
results 2, './results/task_two.out'

code_segment 3, ['./script/wc_map.rb', './script/wc_reduce.rb']
results 3, './results/task_three.out'

code_segment 4, ['./script/wc_prob_map.rb']
results 4, './results/task_four.out'

code_segment 5, ['./script/trigram_count_map.py', './script/trigram_count_reducer.py']
results 5, './results/task_five.out'

code_segment 6, ['./script/flip_top_twenty.py', './script/take_twenty_reducer.rb']
results 6, './results/task_six.out'

code_segment 7, ['./script/transpose_map.rb', './src/transpose_reduce.cpp']
results 7, './results/task_seven.out'

code_segment 8, ['./script/join_map.rb', './script/join_reduce.rb']
results 8, './results/task_eight.out'

puts "\nCode (used to generate this report file) begin\n\n<./script/report.rb>\n\n"
puts IO.read './script/report.rb'
puts "\n</./script/report.rb>\n\nCode (used to generate this report file) end\n"
