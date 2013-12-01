#!/usr/bin/env python

import fileinput

for parts in (line.split() for line in fileinput.input()):
  trigram = ' '.join(parts[:-1])
  count = parts[-1]

  if int(count) > 500:
    print(count + "\t" + trigram)
