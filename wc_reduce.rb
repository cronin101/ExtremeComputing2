#!/usr/bin/env ruby

lines = words = 0

ARGF.each do |line|
  lcount, wcount = line.split(/\t/).map(&:to_i)
  lines += lcount
  words += wcount
end

puts "#{lines}\t#{words}"
