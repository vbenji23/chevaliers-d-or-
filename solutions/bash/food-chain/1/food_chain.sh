#!/usr/bin/env bash

# Data structures defining the animals and their unique second lines
animals=(
    "" # 1-based indexing placeholder
    "fly"
    "spider"
    "bird"
    "cat"
    "dog"
    "goat"
    "cow"
    "horse"
)

remarks=(
    "" # 1-based indexing placeholder
    ""
    "It wriggled and jiggled and tickled inside her."
    "How absurd to swallow a bird!"
    "Imagine that, to swallow a cat!"
    "What a hog, to swallow a dog!"
    "Just opened her throat and swallowed a goat!"
    "I don't know how she swallowed a cow!"
    "She's dead, of course!"
)

verse() {
    local -i n=$1
    local animal="${animals[n]}"

    echo "I know an old lady who swallowed a $animal."

    # Unique second line for the animal (if present)
    if [[ -n "${remarks[n]}" ]]; then
        echo "${remarks[n]}"
    fi

    # The horse (verse 8) ends immediately after its unique second line
    if (( n == 8 )); then
        return
    fi

    # Cumulative verses: chain down from the current animal to the fly
    for (( i = n; i > 1; i-- )); do
        local current="${animals[i]}"
        local prev="${animals[i-1]}"
        local extra=""

        # Special phrasing when catching the spider
        if [[ "$prev" == "spider" ]]; then
            extra=" that wriggled and jiggled and tickled inside her"
        fi

        echo "She swallowed the $current to catch the $prev$extra."
    done

    # Final line for verses 1 through 7
    echo "I don't know why she swallowed the fly. Perhaps she'll die."
}

main() {
    # Validate arguments length
    if (( $# != 2 )); then
        echo "2 arguments expected" >&2
        exit 1
    fi

    local -i start=$1
    local -i end=$2

    # Validate range
    if (( start > end )); then
        echo "Start must be less than or equal to End" >&2
        exit 1
    fi

    # Generate requested verses separated by a blank line
    for (( v = start; v <= end; v++ )); do
        if (( v > start )); then
            echo ""
        fi
        verse "$v"
    done
}

main "$@"