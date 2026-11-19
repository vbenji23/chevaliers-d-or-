#!/usr/bin/env bash

main() {
    TEXT="$1" awk '
    BEGIN {
        text = tolower(ENVIRON["TEXT"])

        # Match alphanumeric words, including internal apostrophes (e.g., "don't", "you're")
        while (match(text, /[a-z0-9]+('\''[a-z0-9]+)*/)) {
            word = substr(text, RSTART, RLENGTH)
            counts[word]++
            text = substr(text, RSTART + RLENGTH)
        }

        for (w in counts) {
            print w ": " counts[w]
        }
    }'
}

main "$@"