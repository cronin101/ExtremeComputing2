#!/usr/bin/env ruby

ARGF.each do |record|
  if (fields = record.split)[0] == 'student'
    _, student_id, name = fields
    output = [student_id, 'primary', name].join "\t"
  else
    _, course_id, student_id, mark = fields
    output = [student_id, 'secondary', course_id, mark].join "\t"
  end

  puts output
end
