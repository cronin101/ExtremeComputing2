#!/usr/bin/env ruby

def format(join)
  "#{join[:name]} --> " << join[:marks].map { |course, score| "(#{course}, #{score})" }.join(' ')
end

join = nil

ARGF.each do |record|
  if (fields = record.split)[1] == 'primary'
    puts format(join) if join && !join[:marks].empty?
    join_id, _, name = fields
    join = { :id => join_id, :name => name, :marks => [] }
  else
    join_id, _, course_id, mark = fields
    join[:marks].push [course_id, mark] if join_id == join[:id]
  end
end

puts format(join) if join && !join[:marks].empty?
