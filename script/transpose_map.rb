#!/usr/bin/env ruby

# For each row of the matrix, read from STDIN
ARGF.each do |line|
  # Read the index of the row and its contents.
  row, *nums = line.split
  # Emit each Aij = n, as (j, i, n).
  nums.each_with_index { |n, column| puts "#{column}\t#{row}\t#{n}" }
end
