#!/usr/bin/env bash

encode() {
    local input="$1"
    local result=""
    local current_char=""
    local -i count=0

    for (( i = 0; i < ${#input}; i++ )); do
        local char="${input:i:1}"

        if [[ "$char" == "$current_char" ]]; then
            (( count++ ))
        else
            if [[ -n "$current_char" ]]; then
                if (( count > 1 )); then
                    result="${result}${count}${current_char}"
                else
                    result="${result}${current_char}"
                fi
            fi
            current_char="$char"
            count=1
        fi
    done

    # Output the remaining run
    if [[ -n "$current_char" ]]; then
        if (( count > 1 )); then
            result="${result}${count}${current_char}"
        else
            result="${result}${current_char}"
        fi
    fi

    echo "$result"
}

decode() {
    local input="$1"
    local result=""
    local number=""

    for (( i = 0; i < ${#input}; i++ )); do
        local char="${input:i:1}"

        if [[ "$char" =~ [0-9] ]]; then
            number="${number}${char}"
        else
            local -i repeat=${number:-1}
            for (( j = 0; j < repeat; j++ )); do
                result="${result}${char}"
            done
            number=""
        fi
    done

    echo "$result"
}

main() {
    local mode="$1"
    local string="$2"

    case "$mode" in
        encode) encode "$string" ;;
        decode) decode "$string" ;;
        *)      exit 1 ;;
    esac
}

main "$@"