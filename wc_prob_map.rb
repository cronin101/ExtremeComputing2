#!/usr/bin/env ruby

words = lines = 0

ARGF.each do |line|
  lines += 1 if rand(2 ** lines).zero?
  line.split(/\s/).length.times { words += 1 if rand(2 ** words).zero? }
end

puts "#{2 ** lines}\t#{2 ** words}"
