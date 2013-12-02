#!/usr/bin/env ruby

ARGF.each do |record|
  # If the record has the student_id as a primary key:
  if (fields = record.split)[0] == 'student'
    # Build (id, 'primary', fields) tuple
    _, student_id, name = fields
    output = [student_id, 'primary', name].join "\t"

  # If the record has student_id as a secondary key:
  else
    # Build (id, 'secondary', fields) tuple
    _, course_id, student_id, mark = fields
    output = [student_id, 'secondary', course_id, mark].join "\t"
  end

  # Emit tuple
  puts output
end
