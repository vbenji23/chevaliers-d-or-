#!/usr/bin/env bash

# Sorts the characters of a string alphabetically in lowercase
sort_word() {
    local lower=${1,,}
    local -a chars
    local i
    for (( i = 0; i < ${#lower}; i++ )); do
        chars+=("${lower:i:1}")
    done
    IFS=$'\n' sorted=($(sort <<< "${chars[*]}"))
    unset IFS
    echo "${sorted[*]}" | tr -d ' \n'
}

main() {
    local -r target=$1
    local -r candidates=$2

    # Lowercase version and sorted key for the target word
    local -r target_lower=${target,,}
    local -r target_sorted=$(sort_word "$target")

    local -a matches=()
    local cand cand_lower cand_sorted

    # Iterate through candidates provided as space-separated words
    for cand in $candidates; do
        cand_lower=${cand,,}

        # 1. A word is not an anagram of itself (case-insensitive)
        if [[ "$target_lower" == "$cand_lower" ]]; then
            continue
        fi

        # 2. Compare sorted characters
        cand_sorted=$(sort_word "$cand")
        if [[ "$target_sorted" == "$cand_sorted" ]]; then
            matches+=("$cand")
        fi
    done

    # Output matches separated by space
    echo "${matches[*]}"
}

main "$@"