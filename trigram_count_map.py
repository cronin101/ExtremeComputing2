#!/usr/bin/env python

import fileinput

trigram_count = {}

for line in fileinput.input():
    words = line.split()
    trigrams = zip(line, line[1:], line[2:])
    for tri in trigrams:
        trigram = ' '.join(tri)
        trigram_count[trigram] = trigram_count.get(trigram, 0) + 1

for trigram, count in trigram_count.iteritems():
    print(trigram + "\t" + str(count))
