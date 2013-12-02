#!/usr/bin/env ruby

words = lines = 0

ARGF.each do |line|
  lines += 1
  words += line.split.length
end

puts "#{lines}\t#{words}"
