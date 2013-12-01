#!/usr/bin/env ruby

ARGF.each do |line|
  row, *nums = line.split
  nums.each_with_index { |n, column| puts "#{column}\t#{row}\t#{n}" }
end
