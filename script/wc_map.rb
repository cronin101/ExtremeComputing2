#!/usr/bin/env ruby

words = lines = 0

# For each line of STDIN
ARGF.each do |line|
  # Increment the line counter once
  lines += 1

  # Increment the line counter by the number of tokenized words
  words += line.split.length
end

# Emit the (lines, words) count.
puts "#{lines}\t#{words}"
