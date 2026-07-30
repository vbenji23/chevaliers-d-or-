#!/usr/bin/env bash

translate_word() {
    local word="$1"

    # Rule 1: Begins with vowel (a, e, i, o, u) or "xr" or "yt"
    if [[ "$word" =~ ^([aeiou]|xr|yt) ]]; then
        echo "${word}ay"
        return 0
    fi

    # Rule 3: Begins with zero or more consonants followed by "qu"
    if [[ "$word" =~ ^([^aeiou]*qu)(.*) ]]; then
        echo "${BASH_REMATCH[2]}${BASH_REMATCH[1]}ay"
        return 0
    fi

    # Rule 4: Begins with one or more consonants followed by "y"
    if [[ "$word" =~ ^([^aeiou]+)(y.*) ]]; then
        echo "${BASH_REMATCH[2]}${BASH_REMATCH[1]}ay"
        return 0
    fi

    # Rule 2: Begins with one or more consonants
    if [[ "$word" =~ ^([^aeiou]+)(.*) ]]; then
        echo "${BASH_REMATCH[2]}${BASH_REMATCH[1]}ay"
        return 0
    fi

    echo "${word}ay"
}

main() {
    local translated=()

    # Process each positional argument (preserving globs or special chars)
    for word in "$@"; do
        translated+=("$(translate_word "$word")")
    done

    # Output translated words separated by single spaces
    echo "${translated[*]}"
}

main "$@"