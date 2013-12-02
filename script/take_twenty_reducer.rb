#!/usr/bin/env ruby

# Take the first twenty (count, trigram) tuples from STDIN:
ARGF.readlines.take(20).each do |line|
  count, *trigram = line.split

  # Emit (trigran, count) for each.
  puts "#{trigram.join ' '}\t#{count}"
end

