#!/usr/bin/env python

import fileinput

trigram_count = {}

previous = None
count = 0

# Read (trigram, count) tuples from STDIN.
for line in fileinput.input():
    parts = line.split()
    trigram = ' '.join(parts[:-1])
    par_count = int(parts[-1])

    # If we are accumulating a new trigram:
    if not previous == trigram:
      # Emit the previous (trigram, count) if it exists.
      if previous:
        print(previous + "\t" + str(count))

      # Initialise the new trigram, count
      previous = trigram
      count = par_count

    # Otherwise increment the existing trigram's count.
    else:
      count += par_count

# Emit the final (trigram, count) before exiting.
if previous:
  print(previous + "\t" + str(count))
