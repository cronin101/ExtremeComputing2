#!/usr/bin/env ruby

current = nil
ARGF.each do |line|
  #puts line
  row, col, n = line.chomp.split
  current ||= row

  if current == row
    print n
    print "\t"
  else
    current = row
    puts
    print n
    print "\t"
  end
end
puts
