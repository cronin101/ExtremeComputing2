#!/usr/bin/env python

import fileinput
from heapq import heappush, heapreplace

# Heap to keep track of the top 20 frequency trigrams seen.
top_twenty = []

# Read (trigram, count) tuples from STDIN
for parts in (line.split() for line in fileinput.input()):
  trigram = ' '.join(parts[:-1])
  count = int(parts[-1])

  # Insert into heap if the heap is not full yet.
  if len(top_twenty) < 20: heappush(top_twenty, (count, trigram))
  # Otherwise, replace the minimum item in heap if the seen count is higher.
  elif count > top_twenty[0][0]: heapreplace(top_twenty, (count, trigram))

# Emit (count, trigram) for the members of the heap.
for c, t in top_twenty: print(str(c) + "\t" + t)
