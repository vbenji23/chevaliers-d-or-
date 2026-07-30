#!/usr/bin/env bash

# Encode a single 32-bit unsigned hex integer into VLQ hex bytes
encode_one() {
    local val=$(( 16#$1 ))
    local -a bytes=()
    local continuation=0

    while true; do
        local byte=$(( (val & 0x7F) | continuation ))
        bytes=($(printf "%02X" "$byte") "${bytes[@]}")
        val=$(( val >> 7 ))
        (( val == 0 )) && break
        continuation=0x80
    done

    echo "${bytes[*]}"
}

encode() {
    local result=()
    local arg
    for arg in "$@"; do
        result+=("$(encode_one "$arg")")
    done
    echo "${result[*]}"
}

decode() {
    local result=()
    local val=0
    local in_sequence=0

    local hex
    for hex in "$@"; do
        local byte=$(( 16#$hex ))
        val=$(( (val << 7) | (byte & 0x7F) ))
        in_sequence=1

        # Bit 7 clear indicates the end of a VLQ sequence
        if (( (byte & 0x80) == 0 )); then
            if (( val == 0 )); then
                result+=("00")
            else
                result+=($(printf "%X" "$val"))
            fi
            val=0
            in_sequence=0
        fi
    done

    # If all input bytes were consumed but bit 7 was set on the last byte
    if (( in_sequence == 1 )); then
        echo "incomplete byte sequence" >&2
        exit 1
    fi

    echo "${result[*]}"
}

main() {
    local subcmd="${1:-}"
    shift || true

    case "$subcmd" in
        encode) encode "$@" ;;
        decode) decode "$@" ;;
        *)
            echo "unknown subcommand: $subcmd" >&2
            exit 1
            ;;
    esac
}

main "$@"