#!/usr/bin/env ruby

current = nil
ARGF.each do |line|
  row, col, n = line.chomp.split
  current ||= row

  if current == row
    print n
    print " "
  else
    current = row
    puts
    print n
    print " "
  end
end

puts
