#!/usr/bin/env bash

# Greatest Common Divisor (Euclidean Algorithm)
gcd() {
    local -i a=${1#-}
    local -i b=${2#-}
    while (( b != 0 )); do
        local -i t=$(( a % b ))
        a=$b
        b=$t
    done
    echo "$a"
}

# Reduce rational number a/b to standard/lowest terms
reduce() {
    local -i num=$1
    local -i den=$2

    if (( den == 0 )); then
        echo "Error: Division by zero" >&2
        exit 1
    fi

    # Ensure denominator is positive
    if (( den < 0 )); then
        num=$(( -num ))
        den=$(( -den ))
    fi

    # Handle zero numerator
    if (( num == 0 )); then
        echo "0/1"
        return
    fi

    local -i g
    g=$(gcd "$num" "$den")
    num=$(( num / g ))
    den=$(( den / g ))

    echo "${num}/${den}"
}

# Parse a rational string "a/b" into components
parse_rational() {
    IFS="/" read -r num den <<< "$1"
    REPLY=("$num" "$den")
}

main() {
    local op=$1
    shift

    case "$op" in
        "+")
            parse_rational "$1"; local -i a1=${REPLY[0]} b1=${REPLY[1]}
            parse_rational "$2"; local -i a2=${REPLY[0]} b2=${REPLY[1]}
            reduce $(( a1 * b2 + a2 * b1 )) $(( b1 * b2 ))
            ;;

        "-")
            parse_rational "$1"; local -i a1=${REPLY[0]} b1=${REPLY[1]}
            parse_rational "$2"; local -i a2=${REPLY[0]} b2=${REPLY[1]}
            reduce $(( a1 * b2 - a2 * b1 )) $(( b1 * b2 ))
            ;;

        "*")
            parse_rational "$1"; local -i a1=${REPLY[0]} b1=${REPLY[1]}
            parse_rational "$2"; local -i a2=${REPLY[0]} b2=${REPLY[1]}
            reduce $(( a1 * a2 )) $(( b1 * b2 ))
            ;;

        "/")
            parse_rational "$1"; local -i a1=${REPLY[0]} b1=${REPLY[1]}
            parse_rational "$2"; local -i a2=${REPLY[0]} b2=${REPLY[1]}
            reduce $(( a1 * b2 )) $(( a2 * b1 ))
            ;;

        "abs")
            parse_rational "$1"; local -i num=${REPLY[0]} den=${REPLY[1]}
            reduce "${num#-}" "${den#-}"
            ;;

        "pow")
            parse_rational "$1"; local -i num=${REPLY[0]} den=${REPLY[1]}
            local -i n=$2
            if (( n >= 0 )); then
                reduce $(( num ** n )) $(( den ** n ))
            else
                local -i m=$(( -n ))
                reduce $(( den ** m )) $(( num ** m ))
            fi
            ;;

        "rpow")
            local x=$1
            parse_rational "$2"; local -i num=${REPLY[0]} den=${REPLY[1]}
            
            # Compute x^(num/den) with higher precision scale=20 in bc,
            # then round and format using awk
            bc -l <<< "scale=20; e(($num / $den) * l($x))" | awk '{
                # Round to 6 decimal places to eliminate bc float noise
                val = sprintf("%.6f", $1) + 0;
                if (val == int(val)) {
                    printf "%.1f\n", val
                } else {
                    printf "%.6f\n", val
                }
            }'
            ;;

        "reduce")
            parse_rational "$1"; local -i num=${REPLY[0]} den=${REPLY[1]}
            reduce "$num" "$den"
            ;;

        *)
            echo "Unknown operation: $op" >&2
            exit 1
            ;;
    esac
}

main "$@"