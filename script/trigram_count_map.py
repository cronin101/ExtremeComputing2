#!/usr/bin/env python

import fileinput

trigram_count = {}

for words in (line.split() for line in fileinput.input()):
    trigrams = zip(words, words[1:], words[2:])
    for tri in trigrams:
        trigram = ' '.join(tri)
        trigram_count[trigram] = trigram_count.get(trigram, 0) + 1

for trigram, count in trigram_count.iteritems():
    print(trigram + "\t" + str(count))
