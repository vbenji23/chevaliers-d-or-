#!/usr/bin/env bash

transmit_sequence() {
    local input="$1"
    [[ -z "$input" ]] && exit 0

    read -r -a hex_bytes <<< "$input"

    local bit_stream=""
    for hex in "${hex_bytes[@]}"; do
        local -i val=$hex
        for (( i=7; i>=0; i-- )); do
            bit_stream+=$(( (val >> i) & 1 ))
        done
    done

    local -i len=${#bit_stream}
    local -i pos=0
    local -a output_bytes=()

    while (( pos < len )); do
        local chunk="${bit_stream:pos:7}"
        (( pos += 7 ))

        # Pad with zeros on the right if fewer than 7 bits remain
        while (( ${#chunk} < 7 )); do
            chunk+="0"
        done

        # Count set bits (1s) in the 7-bit chunk
        local -i ones=0
        for (( i=0; i<7; i++ )); do
            [[ "${chunk:i:1}" == "1" ]] && (( ones++ ))
        done

        # Parity bit is 1 if count of 1s is odd (ensures even total 1s)
        local parity_bit=$(( ones % 2 ))
        chunk+="$parity_bit"

        # Convert 8-bit chunk back to hexadecimal
        local -i byte_val=0
        for (( i=0; i<8; i++ )); do
            (( byte_val = (byte_val << 1) | ${chunk:i:1} ))
        done

        output_bytes+=($(printf "0x%02x" "$byte_val"))
    done

    echo "${output_bytes[*]}"
}

decode_message() {
    local input="$1"
    [[ -z "$input" ]] && exit 0

    read -r -a hex_bytes <<< "$input"

    local bit_stream=""
    for hex in "${hex_bytes[@]}"; do
        local -i val=$hex

        # Count set bits in the full 8-bit frame
        local -i ones=0
        for (( i=0; i<8; i++ )); do
            (( ones += (val >> i) & 1 ))
        done

        # Total 1s must be even; otherwise output "wrong parity"
        if (( ones % 2 != 0 )); then
            echo "wrong parity"
            exit 0
        fi

        # Convert byte to bit string
        local byte_bits=""
        for (( i=7; i>=0; i-- )); do
            byte_bits+=$(( (val >> i) & 1 ))
        done

        # Retain top 7 bits (discard parity bit at LSB)
        bit_stream+="${byte_bits:0:7}"
    done

    # Reconstruct 8-bit data bytes
    local -i len=${#bit_stream}
    local -i pos=0
    local -a output_bytes=()
    local -i valid_len=$(( (len / 8) * 8 ))

    while (( pos < valid_len )); do
        local chunk="${bit_stream:pos:8}"
        (( pos += 8 ))

        local -i byte_val=0
        for (( i=0; i<8; i++ )); do
            (( byte_val = (byte_val << 1) | ${chunk:i:1} ))
        done

        output_bytes+=($(printf "0x%02x" "$byte_val"))
    done

    echo "${output_bytes[*]}"
}

main() {
    local command="$1"
    shift
    case "$command" in
        transmit_sequence)
            transmit_sequence "$@"
            ;;
        decode_message)
            decode_message "$@"
            ;;
        *)
            exit 1
            ;;
    esac
}

main "$@"