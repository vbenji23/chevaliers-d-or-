#!/usr/bin/env bash

# Calculate the rail index for a given character position `i` in a message
# when using `rails` number of rails.
get_rail() {
    local i=$1
    local rails=$2

    if (( rails == 1 )); then
        echo 0
        return
    fi

    local cycle=$(( 2 * (rails - 1) ))
    local pos=$(( i % cycle ))

    if (( pos < rails )); then
        echo "$pos"
    else
        echo "$(( cycle - pos ))"
    fi
}

encode() {
    local rails=$1
    local text=$2
    local len=${#text}

    if (( len == 0 )); then
        echo ""
        return
    fi

    # Create an array of strings for each rail
    local -a rail_strings=()
    for (( r=0; r<rails; r++ )); do
        rail_strings[r]=""
    done

    # Distribute characters across rails
    for (( i=0; i<len; i++ )); do
        local r
        r=$(get_rail "$i" "$rails")
        rail_strings[r]+="${text:i:1}"
    done

    # Concatenate all rail strings
    local result=""
    for (( r=0; r<rails; r++ )); do
        result+="${rail_strings[r]}"
    done

    echo "$result"
}

decode() {
    local rails=$1
    local text=$2
    local len=${#text}

    if (( len == 0 )); then
        echo ""
        return
    fi

    # Count how many characters land on each rail
    local -a rail_counts=()
    for (( r=0; r<rails; r++ )); do
        rail_counts[r]=0
    done

    for (( i=0; i<len; i++ )); do
        local r
        r=$(get_rail "$i" "$rails")
        (( rail_counts[r]++ ))
    done

    # Partition the ciphertext into chunks for each rail based on counts
    local -a rail_chunks=()
    local offset=0
    for (( r=0; r<rails; r++ )); do
        local count=${rail_counts[r]}
        rail_chunks[r]="${text:offset:count}"
        (( offset += count ))
    done

    # Reconstruct original text by picking characters in zig-zag order
    local -a rail_indices=()
    for (( r=0; r<rails; r++ )); do
        rail_indices[r]=0
    done

    local result=""
    for (( i=0; i<len; i++ )); do
        local r
        r=$(get_rail "$i" "$rails")
        local idx=${rail_indices[r]}
        result+="${rail_chunks[r]:idx:1}"
        (( rail_indices[r]++ ))
    done

    echo "$result"
}

main() {
    if (( $# < 3 )); then
        echo "Error: Invalid number of arguments" >&2
        exit 1
    fi

    local mode=$1
    local rails=$2
    local text=$3

    # Validate rails count
    if ! [[ "$rails" =~ ^[0-9]+$ ]] || (( rails < 1 )); then
        echo "Error: Rails must be a positive integer" >&2
        exit 1
    fi

    case "$mode" in
        -e) encode "$rails" "$text" ;;
        -d) decode "$rails" "$text" ;;
        *)
            echo "Error: Unknown option $mode" >&2
            exit 1
            ;;
    esac
}

main "$@"