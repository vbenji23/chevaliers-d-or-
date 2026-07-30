#!/usr/bin/env bash

# Greatest Common Divisor
gcd() {
    local -i a=$1 b=$2
    while (( b != 0 )); do
        local -i t=$b
        b=$(( a % b ))
        a=$t
    done
    echo "$a"
}

# Modular Multiplicative Inverse of a mod m
mmi() {
    local -i a=$1 m=$2
    local -i x
    for (( x = 1; x < m; x++ )); do
        if (( (a * x) % m == 1 )); then
            echo "$x"
            return 0
        fi
    done
    echo -1
}

encode() {
    local -i a=$1 b=$2
    local text="$3"
    local alphabet="abcdefghijklmnopqrstuvwxyz"
    local result=""
    local -i count=0

    # Lowercase text
    text="${text,,}"

    local -i i
    for (( i = 0; i < ${#text}; i++ )); do
        local char="${text:i:1}"

        if [[ "$char" =~ [a-z] ]]; then
            # Index i in alphabet (0..25)
            local -i idx
            idx=$(printf '%d' "'$char")
            idx=$(( idx - 97 ))

            # Encrypt: E(x) = (a * x + b) mod 26
            local -i enc_idx=$(( (a * idx + b) % 26 ))
            local enc_char="${alphabet:enc_idx:1}"

            # Group in chunks of 5
            if (( count > 0 && count % 5 == 0 )); then
                result+=" "
            fi
            result+="$enc_char"
            (( count++ ))
        elif [[ "$char" =~ [0-9] ]]; then
            # Digits are kept as-is
            if (( count > 0 && count % 5 == 0 )); then
                result+=" "
            fi
            result+="$char"
            (( count++ ))
        fi
    done

    echo "$result"
}

decode() {
    local -i a=$1 b=$2
    local text="$3"
    local alphabet="abcdefghijklmnopqrstuvwxyz"
    local result=""

    # Compute MMI of a mod 26
    local -i a_inv
    a_inv=$(mmi "$a" 26)

    # Lowercase text
    text="${text,,}"

    local -i i
    for (( i = 0; i < ${#text}; i++ )); do
        local char="${text:i:1}"

        if [[ "$char" =~ [a-z] ]]; then
            local -i y
            y=$(printf '%d' "'$char")
            y=$(( y - 97 ))

            # Decrypt: D(y) = a^-1 * (y - b) mod 26
            local -i dec_idx=$(( (a_inv * (y - b)) % 26 ))
            # Handle negative mod result in Bash
            if (( dec_idx < 0 )); then
                dec_idx=$(( dec_idx + 26 ))
            fi

            result+="${alphabet:dec_idx:1}"
        elif [[ "$char" =~ [0-9] ]]; then
            result+="$char"
        fi
    done

    echo "$result"
}

main() {
    local mode="$1"
    local -i a=$2
    local -i b=$3
    local text="$4"

    # Validate key parameter 'a': a and 26 must be coprime (gcd == 1)
    if (( $(gcd "$a" 26) != 1 )); then
        echo "a and m must be coprime." >&2
        exit 1
    fi

    case "$mode" in
        encode) encode "$a" "$b" "$text" ;;
        decode) decode "$a" "$b" "$text" ;;
        *)      exit 1 ;;
    esac
}

main "$@"