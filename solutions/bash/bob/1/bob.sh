#!/usr/bin/env bash

main() {
    local input=$1

    # Strip all leading/trailing whitespace (spaces, tabs, newlines, carriage returns)
    # without using xargs
    while [[ "$input" =~ ^[[:space:]] ]]; do
        input="${input#[[:space:]]}"
    done
    while [[ "$input" =~ [[:space:]]$ ]]; do
        input="${input%[[:space:]]}"
    done

    # 1. Silence
    if [[ -z "$input" ]]; then
        echo "Fine. Be that way!"
        return 0
    fi

    # Check for question mark at the end
    local is_question=false
    if [[ "$input" == *\? ]]; then
        is_question=true
    fi

    # Check for shouting: contains at least one uppercase letter AND no lowercase letters
    local is_shouting=false
    if [[ "$input" =~ [[:upper:]] ]] && [[ ! "$input" =~ [[:lower:]] ]]; then
        is_shouting=true
    fi

    # 2. Determine response based on conditions
    if $is_shouting && $is_question; then
        echo "Calm down, I know what I'm doing!"
    elif $is_shouting; then
        echo "Whoa, chill out!"
    elif $is_question; then
        echo "Sure."
    else
        echo "Whatever."
    fi
}

main "$@"