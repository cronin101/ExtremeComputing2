#!/usr/bin/env python

import fileinput

trigram_count = {}

for line in fileinput.input():
    parts   = line.split('\t')
    trigram = ' '.join(parts[:-1])
    count   = int(parts[-1])
    trigram_count[trigram] = trigram_count.get(trigram, 0) + count

for trigram, count in trigram_count.iteritems():
    print(trigram + "\t" + str(count))
