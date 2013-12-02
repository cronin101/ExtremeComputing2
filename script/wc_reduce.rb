#!/usr/bin/env ruby

lines = words = 0

# For each (linecount, wordcount) tuple in STDIN:
ARGF.each do |line|
  # Extract the fields
  lcount, wcount = line.split(/\t/).map(&:to_i)

  # Increment the partial counts by the read values.
  lines += lcount
  words += wcount
end

# Emit the final count.
puts "#{words}\t#{lines}"
