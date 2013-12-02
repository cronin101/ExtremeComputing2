#!/usr/bin/env ruby

ARGF.readlines.take(20).each do |line|
  count, *trigram = line.split
  puts "#{trigram.join ' '}\t#{count}"
end

