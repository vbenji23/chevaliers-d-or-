#!/usr/bin/env bash

# Convert JSON array string into a Bash array
parse_json_array() {
    local input=$1
    # Strip brackets and spaces
    input=${input//[\[\] ]/}
    if [[ -z "$input" ]]; then
        return 0
    fi
    IFS=',' read -ra -d '' <<< "$input" || true
    # Print elements separated by standard space
    printf '%s\n' "${MAPFILE[@]}"
}

# Checks if array B contains array A as a contiguous sub-sequence
is_sublist() {
    local -n sub=$1
    local -n main=$2

    local -i len_sub=${#sub[@]}
    local -i len_main=${#main[@]}

    if (( len_sub == 0 )); then
        return 0
    fi

    if (( len_sub > len_main )); then
        return 1
    fi

    for (( i = 0; i <= len_main - len_sub; i++ )); do
        local match=true
        for (( j = 0; j < len_sub; j++ )); do
            if [[ "${sub[j]}" != "${main[i + j]}" ]]; then
                match=false
                break
            fi
        done
        if $match; then
            return 0
        fi
    done

    return 1
}

main() {
    # Parse JSON strings into arrays
    local list_a_str=$1
    local list_b_str=$2

    # Normalize empty lists to empty strings, otherwise strip spaces and brackets
    local clean_a=${list_a_str//[\[\] ]/}
    local clean_b=${list_b_str//[\[\] ]/}

    local -a arr_a=()
    local -a arr_b=()

    if [[ -n "$clean_a" ]]; then
        IFS=',' read -ra arr_a <<< "$clean_a"
    fi

    if [[ -n "$clean_b" ]]; then
        IFS=',' read -ra arr_b <<< "$clean_b"
    fi

    local -i len_a=${#arr_a[@]}
    local -i len_b=${#arr_b[@]}

    # Check for equal
    if (( len_a == len_b )) && is_sublist arr_a arr_b; then
        echo "equal"
    elif is_sublist arr_a arr_b; then
        echo "sublist"
    elif is_sublist arr_b arr_a; then
        echo "superlist"
    else
        echo "unequal"
    fi
}

main "$@"
