#!/usr/bin/env bash

# Decode 4 individual 3-character lines for a single digit
decode_digit() {
    local l0="$1"
    local l1="$2"
    local l2="$3"
    local l3="$4"

    case "$l0,$l1,$l2,$l3" in
        " _ ,| |,|_|,   ") echo "0" ;;
        "   ,  |,  |,   ") echo "1" ;;
        " _ , _|,|_ ,   ") echo "2" ;;
        " _ , _|, _|,   ") echo "3" ;;
        "   ,|_|,  |,   ") echo "4" ;;
        " _ ,|_ , _|,   ") echo "5" ;;
        " _ ,|_ ,|_|,   ") echo "6" ;;
        " _ ,  |,  |,   ") echo "7" ;;
        " _ ,|_|,|_|,   ") echo "8" ;;
        " _ ,|_|, _|,   ") echo "9" ;;
        *)                  echo "?" ;;
    esac
}

main() {
    local -a lines=()

    # Read all lines preserving leading and trailing spaces
    while IFS= read -r line || [[ -n "$line" ]]; do
        lines+=("$line")
    done

    local num_lines=${#lines[@]}

    # Handle empty input case
    if (( num_lines == 0 )); then
        exit 0
    fi

    # Validate line count is a multiple of 4
    if (( num_lines % 4 != 0 )); then
        echo "Number of input lines is not a multiple of four" >&2
        exit 1
    fi

    local line_len=${#lines[0]}

    # Validate column length consistency across all lines and 3-column multiplicity
    if (( line_len % 3 != 0 )); then
        echo "Number of input columns is not a multiple of three" >&2
        exit 1
    fi

    local l
    for (( l = 0; l < num_lines; l++ )); do
        if (( ${#lines[l]} != line_len )); then
            echo "Number of input columns is not a multiple of three" >&2
            exit 1
        fi
    done

    local -a output_rows=()

    # Process block rows (each 4 lines high)
    local block_idx
    for (( block_idx = 0; block_idx < num_lines; block_idx += 4 )); do
        local decoded_row=""
        local col_idx

        # Slice 3-column wide digits across the 4 lines of the current block
        for (( col_idx = 0; col_idx < line_len; col_idx += 3 )); do
            local r0="${lines[block_idx]:col_idx:3}"
            local r1="${lines[block_idx+1]:col_idx:3}"
            local r2="${lines[block_idx+2]:col_idx:3}"
            local r3="${lines[block_idx+3]:col_idx:3}"

            # If slicing reached past string boundaries, pad with spaces to 3 chars
            printf -v r0 "%-3s" "$r0"
            printf -v r1 "%-3s" "$r1"
            printf -v r2 "%-3s" "$r2"
            printf -v r3 "%-3s" "$r3"

            decoded_row+=$(decode_digit "$r0" "$r1" "$r2" "$r3")
        done

        output_rows+=("$decoded_row")
    done

    # Join multi-line results with a comma
    local IFS=","
    echo "${output_rows[*]}"
}

main "$@"