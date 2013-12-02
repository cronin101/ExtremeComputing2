#!/usr/bin/env ruby

words = lines = 0

# For each line of input on STDIN:
ARGF.each do |line|
  # Increment linecount with prob 1 / 2 ^ linecount
  lines += 1 if rand(2 ** lines).zero?
  # For each word, increment wordcount with prob 1 / 2 ^ wordcount
  line.split(/\s/).length.times { words += 1 if rand(2 ** words).zero? }
end

# Emit the estimated counts.
puts "#{(2 ** lines) - 1}\t#{(2 ** words) - 1}"
