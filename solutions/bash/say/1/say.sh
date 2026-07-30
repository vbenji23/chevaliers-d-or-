#!/usr/bin/env bash

# Word lookup tables for numbers under 100
ones=("zero" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine")
teens=("ten" "eleven" "twelve" "thirteen" "fourteen" "fifteen" "sixteen" "seventeen" "eighteen" "nineteen")
tens=("" "" "twenty" "thirty" "forty" "fifty" "sixty" "seventy" "eighty" "ninety")

# Function to convert numbers 0 to 999 into words
say_small() {
    local -i n=$1
    local result=""

    # Hundreds place
    if (( n >= 100 )); then
        local -i h=$(( n / 100 ))
        result="${ones[h]} hundred"
        n=$(( n % 100 ))
        if (( n > 0 )); then
            result="${result} "
        fi
    fi

    # Tens and ones place
    if (( n >= 20 )); then
        local -i t=$(( n / 10 ))
        local -i o=$(( n % 10 ))
        if (( o > 0 )); then
            result="${result}${tens[t]}-${ones[o]}"
        else
            result="${result}${tens[t]}"
        fi
    elif (( n >= 10 )); then
        result="${result}${teens[n - 10]}"
    elif (( n > 0 || ${#result} == 0 )); then
        result="${result}${ones[n]}"
    fi

    echo "$result"
}

main() {
    local input="$1"

    # Input validation: check range [0, 999,999,999,999]
    if [[ ! "$input" =~ ^[0-9]+$ ]] || (( input < 0 || input > 999999999999 )); then
        echo "input out of range" >&2
        exit 1
    fi

    local -i n=$input

    # Special case for zero
    if (( n == 0 )); then
        echo "zero"
        return
    fi

    # Group into 3-digit chunks: billions, millions, thousands, units
    local -a scale_words=("" "thousand" "million" "billion")
    local -a chunks=()

    while (( n > 0 )); do
        chunks+=("$(( n % 1000 ))")
        n=$(( n / 1000 ))
    done

    local -a parts=()
    local -i i
    for (( i = ${#chunks[@]} - 1; i >= 0; i-- )); do
        local -i chunk=${chunks[i]}
        if (( chunk > 0 )); then
            local chunk_str
            chunk_str=$(say_small "$chunk")
            local scale="${scale_words[i]}"
            if [[ -n "$scale" ]]; then
                parts+=("${chunk_str} ${scale}")
            else
                parts+=("${chunk_str}")
            fi
        fi
    done

    # Join with space
    local IFS=" "
    echo "${parts[*]}"
}

main "$@"