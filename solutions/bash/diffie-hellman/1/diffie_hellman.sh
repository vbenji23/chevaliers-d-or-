#!/usr/bin/env bash

# Modular exponentiation: computes (base^exp) % modulus efficiently
power_mod() {
    local -i base=$1 exp=$2 modulus=$3
    local -i result=1

    base=$(( base % modulus ))

    while (( exp > 0 )); do
        if (( exp % 2 == 1 )); then
            result=$(( (result * base) % modulus ))
        fi
        exp=$(( exp / 2 ))
        base=$(( (base * base) % modulus ))
    done

    echo "$result"
}

# Generate a random private key in the range 2 <= key < p
generate_private_key() {
    local -i p=$1
    local -i range=$(( p - 2 ))
    local -i key=$(( 2 + RANDOM % range ))
    echo "$key"
}

main() {
    local action="$1"

    case "$action" in
        "privateKey")
            local -i p=$2
            generate_private_key "$p"
            ;;

        "publicKey")
            local -i p=$2 g=$3 private_key=$4
            # A = g^a mod p
            power_mod "$g" "$private_key" "$p"
            ;;

        "secret")
            local -i p=$2 public_key=$3 private_key=$4
            # s = B^a mod p
            power_mod "$public_key" "$private_key" "$p"
            ;;
    esac
}

main "$@"