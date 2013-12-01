#!/usr/bin/env ruby

seen = false

ARGF.each do |record|
  if (fields = record.split)[1] = 'primary'
    puts if seen
    seen ||= true
    _, _, name = fields
    print "#{name} -->"
  else
    _, _, course_id, mark = fields
    print " (#{course_id}, #{mark})"
  end
end

puts
