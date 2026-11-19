#!/usr/bin/env bash

NUMBER_WORDS=("no" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten")

capitalize() {
    local word=$1
    echo "${word^}"
}

bottle_noun() {
    local count=$1
    if (( count == 1 )); then
        echo "bottle"
    else
        echo "bottles"
    fi
}

generate_verse() {
    local start=$1
    local next=$(( start - 1 ))

    local start_word=$(capitalize "${NUMBER_WORDS[start]}")
    local next_word=${NUMBER_WORDS[next]}

    local start_noun=$(bottle_noun "$start")
    local next_noun=$(bottle_noun "$next")

    echo "${start_word} green ${start_noun} hanging on the wall,"
    echo "${start_word} green ${start_noun} hanging on the wall,"
    echo "And if one green bottle should accidentally fall,"
    echo "There'll be ${next_word} green ${next_noun} hanging on the wall."
}

main() {
    if (( $# != 2 )); then
        echo "2 arguments expected" >&2
        return 1
    fi

    local start_bottles=$1
    local take_down=$2

    if (( take_down > start_bottles )); then
        echo "cannot generate more verses than bottles" >&2
        return 1
    fi

    local i
    for (( i = 0; i < take_down; i++ )); do
        if (( i > 0 )); then
            echo ""
        fi
        generate_verse $(( start_bottles - i ))
    done
}

main "$@"