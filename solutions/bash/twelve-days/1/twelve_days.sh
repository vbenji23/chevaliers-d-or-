#!/usr/bin/env bash

main() {
    local start="$1"
    local end="$2"

    local -a days=(
        "" "first" "second" "third" "fourth" "fifth" "sixth"
        "seventh" "eighth" "ninth" "tenth" "eleventh" "twelfth"
    )

    local -a gifts=(
        ""
        "a Partridge in a Pear Tree."
        "two Turtle Doves"
        "three French Hens"
        "four Calling Birds"
        "five Gold Rings"
        "six Geese-a-Laying"
        "seven Swans-a-Swimming"
        "eight Maids-a-Milking"
        "nine Ladies Dancing"
        "ten Lords-a-Leaping"
        "eleven Pipers Piping"
        "twelve Drummers Drumming"
    )

    for (( day = start; day <= end; day++ )); do
        printf "On the %s day of Christmas my true love gave to me: " "${days[day]}"

        for (( g = day; g >= 1; g-- )); do
            if (( g == 1 && day > 1 )); then
                printf "and %s" "${gifts[1]}"
            elif (( g == 1 )); then
                printf "%s" "${gifts[1]}"
            else
                printf "%s, " "${gifts[g]}"
            fi
        done

        printf "\n"
    done
}

main "$@"