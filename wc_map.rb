#!/usr/bin/env ruby

words = lines = 0

ARGF.each { |line| lines += 1; words += line.split(/\s/).length }

puts "#{lines}\t#{words}"
