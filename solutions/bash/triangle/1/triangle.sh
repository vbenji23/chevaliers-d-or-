#!/usr/bin/env bash

main() {
    local type="$1"
    local a="$2"
    local b="$3"
    local c="$4"

    # Use awk to evaluate floating-point math, triangle inequalities, and side equality
    awk -v type="$type" -v a="$a" -v b="$b" -v c="$c" '
    BEGIN {
        # Check basic triangle validity:
        # 1. All sides must be strictly positive (> 0)
        # 2. Sum of any two sides must be greater than or equal to the third side
        if (a <= 0 || b <= 0 || c <= 0 || (a + b < c) || (b + c < a) || (a + c < b)) {
            print "false"
            exit
        }

        # Check requested triangle type
        if (type == "equilateral") {
            print (a == b && b == c) ? "true" : "false"
        } else if (type == "isosceles") {
            print (a == b || b == c || a == c) ? "true" : "false"
        } else if (type == "scalene") {
            print (a != b && b != c && a != c) ? "true" : "false"
        } else {
            print "false"
        }
    }'
}

main "$@"