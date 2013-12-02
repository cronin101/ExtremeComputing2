#!/usr/bin/env python

import fileinput

trigram_count = {}

previous = None
count = 0

for line in fileinput.input():
    parts = line.split()
    trigram = ' '.join(parts[:-1])
    par_count = int(parts[-1])

    if not previous == trigram:
      if previous:
        print(previous + "\t" + str(count))

      previous = trigram
      count = par_count

    else:
      count += par_count

if previous:
  print(previous + "\t" + str(count))
