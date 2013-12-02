#!/usr/bin/env python

import fileinput

trigram_count = {}

# Tokenise each line of STDIN into words,
for words in (line.split() for line in fileinput.input()):

    # Enumerate all trigrams from the line's words.
    trigrams = zip(words, words[1:], words[2:])

    # Increment the frequency of having seen each trigram
    for tri in trigrams:
        trigram = ' '.join(tri)
        trigram_count[trigram] = trigram_count.get(trigram, 0) + 1

# Emit (trigram, count) for each trigram seen.
for trigram, count in trigram_count.iteritems():
    print(trigram + "\t" + str(count))
