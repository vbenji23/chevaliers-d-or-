#!/usr/bin/env bash

# Data structures representing each part of the rhyme.
# Index 0 is unused so that index 1 corresponds directly to verse 1.
readonly NOUNS=(
    ""
    "house that Jack built"
    "malt"
    "rat"
    "cat"
    "dog"
    "cow with the crumpled horn"
    "maiden all forlorn"
    "man all tattered and torn"
    "priest all shaven and shorn"
    "rooster that crowed in the morn"
    "farmer sowing his corn"
    "horse and the hound and the horn"
)

readonly VERBS=(
    ""
    "lay in"
    "ate"
    "killed"
    "worried"
    "tossed"
    "milked"
    "kissed"
    "married"
    "woke"
    "kept"
    "belonged to"
)

build_verse() {
    local -r n=$1
    local verse="This is the ${NOUNS[$n]}"

    for (( i = n; i > 1; i-- )); do
        verse+=" that ${VERBS[$((i - 1))]} the ${NOUNS[$((i - 1))]}"
    done

    echo "${verse}."
}

main() {
    local -r start=$1
    local -r end=$2

    # Validation: both inputs must be integers between 1 and 12, and start <= end
    if (( start < 1 || start > 12 || end < 1 || end > 12 || start > end )); then
        echo "invalid verse"
        exit 1
    fi

    for (( v = start; v <= end; v++ )); do
        build_verse "$v"
    done
}

main "$@"