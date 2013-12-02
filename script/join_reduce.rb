#!/usr/bin/env ruby

def format(join)
  "#{join[:name]} --> " << join[:marks].map { |course, score| "(#{course}, #{score})" }.join(' ')
end

join = nil

# Read (id, type, fields) tuples from STDIN
ARGF.each do |record|
  # If we see a record with the id as the primary key:
  if (fields = record.split)[1] == 'primary'
    # Emit the previous join if there is any
    # and it has marks (this is a strictly INNER JOIN)
    puts format(join) if join && !join[:marks].empty?

    # Read the field values from the record
    join_id, _, name = fields

    # Produce a buffer for the join in memory and continue reading
    # for secondary records.
    join = { :id => join_id, :name => name, :marks => [] }
  else
    # Read the field values from the record
    join_id, _, course_id, mark = fields

    # Add the (course, marks) to the join buffer iff the IDs match.
    # (Avoids bug if there are marks without matching primary records)
    join[:marks].push [course_id, mark] if join_id == join[:id]
  end
end

# Print the final join buffer before exiting.
puts format(join) if join && !join[:marks].empty?
