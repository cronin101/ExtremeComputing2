#!/usr/bin/env python

import fileinput
from heapq import heappush, heapreplace

top_twenty = []

for parts in (line.split() for line in fileinput.input()):
  trigram = ' '.join(parts[:-1])
  count = int(parts[-1])

  if len(top_twenty) < 20: heappush(top_twenty, (count, trigram))
  elif count > top_twenty[0][0]: heapreplace(top_twenty, (count, trigram))

for c, t in top_twenty: print(str(c) + "\t" + t)
