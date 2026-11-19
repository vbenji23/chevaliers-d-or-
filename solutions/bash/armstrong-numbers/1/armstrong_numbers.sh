#!/usr/bin/env bash

main() {
    local -r num=$1
    local -r len=${#num}
    local sum=0

    for (( i=0; i<len; i++ )); do
        local digit="${num:i:1}"
        sum=$(( sum + digit ** len ))
    done

    if (( sum == num )); then
        echo "true"
    else
        echo "false"
    fi
}

main "$@"