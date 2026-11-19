#!/usr/bin/env bash

square_of_sum() {
    local -r n=$1
    local sum=$(( n * (n + 1) / 2 ))
    echo $(( sum * sum ))
}

sum_of_squares() {
    local -r n=$1
    echo $(( n * (n + 1) * (2 * n + 1) / 6 ))
}

difference() {
    local -r n=$1
    local sq_sum
    local sum_sq

    sq_sum=$(square_of_sum "$n")
    sum_sq=$(sum_of_squares "$n")

    echo $(( sq_sum - sum_sq ))
}

main() {
    local -r command=$1
    local -r n=$2

    case "$command" in
        "square_of_sum")  square_of_sum "$n" ;;
        "sum_of_squares") sum_of_squares "$n" ;;
        "difference")     difference "$n" ;;
        *)                exit 1 ;;
    esac
}

main "$@"