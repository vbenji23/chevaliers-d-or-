#!/usr/bin/env bash

# Convert ASCII character to a 0-25 value ('a' -> 0)
char_to_val() {
    printf '%d' "'$1" | awk '{print $1 - 97}'
}

# Convert a 0-25 value back to an ASCII character (0 -> 'a')
val_to_char() {
    printf "\\$(printf '%03o' $(($1 + 97)))"
}

# Generate a random 100-character lowercase key
generate_key() {
    local key=""
    local i
    for (( i = 0; i < 100; i++ )); do
        key+="${alphabet:$(( RANDOM % 26 )):1}"
    done
    echo "$key"
}

alphabet="abcdefghijklmnopqrstuvwxyz"

main() {
    local key=""

    # Parse options
    while getopts "k:" opt; do
        case "$opt" in
            k) key="$OPTARG" ;;
            *) exit 1 ;;
        esac
    done
    shift $(( OPTIND - 1 ))

    local mode="$1"
    local text="$2"

    # If mode is "key", generate and print a random key
    if [[ "$mode" == "key" ]]; then
        generate_key
        return 0
    fi

    # If no key was passed via -k, generate one
    if [[ -z "$key" ]]; then
        key=$(generate_key)
    fi

    # Validate key (must contain only lowercase Latin letters)
    if [[ ! "$key" =~ ^[a-z]+$ ]]; then
        echo "invalid key" >&2
        exit 1
    fi

    # Lowercase text (if provided)
    text="${text,,}"

    local key_len=${#key}
    local result=""
    local i

    for (( i = 0; i < ${#text}; i++ )); do
        local char="${text:i:1}"
        
        # Non-alphabetical characters pass through as-is if present
        if [[ ! "$char" =~ [a-z] ]]; then
            result+="$char"
            continue
        fi

        local text_val
        text_val=$(char_to_val "$char")

        local key_char="${key: $(( i % key_len )):1}"
        local key_val
        key_val=$(char_to_val "$key_char")

        local new_val
        if [[ "$mode" == "encode" ]]; then
            new_val=$(( (text_val + key_val) % 26 ))
        elif [[ "$mode" == "decode" ]]; then
            new_val=$(( (text_val - key_val + 26) % 26 ))
        else
            echo "invalid mode" >&2
            exit 1
        fi

        result+=$(val_to_char "$new_val")
    done

    echo "$result"
}

main "$@"