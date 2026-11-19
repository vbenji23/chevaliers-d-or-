#!/usr/bin/env bash

die() {
    echo "$1" >&2
    exit 1
}

is_int() {
    [[ "$1" =~ ^-?[0-9]+$ ]]
}

main() {
    local question="$1"

    # Handle exact "What is?" or empty expression after "What is"
    if [[ "$question" == "What is?" ]]; then
        die "syntax error"
    fi

    # Questions must start with "What is " and end with "?"
    if [[ ! "$question" =~ ^What\ is\ (.*)\?$ ]]; then
        die "unknown operation"
    fi

    # Extract inner expression
    local expr="${BASH_REMATCH[1]}"

    # Normalize multi-word operators
    expr="${expr//multiplied by/multiplied}"
    expr="${expr//divided by/divided}"

    if [[ -z "$expr" ]]; then
        die "syntax error"
    fi

    # Read tokens into an array
    read -r -a tokens <<< "$expr"

    local -i result=0
    local state="EXPECT_NUMBER"
    local current_op=""

    for token in "${tokens[@]}"; do
        if [[ "$state" == "EXPECT_NUMBER" ]]; then
            if is_int "$token"; then
                if [[ -z "$current_op" ]]; then
                    result=$token
                else
                    case "$current_op" in
                        plus)       (( result += token )) ;;
                        minus)      (( result -= token )) ;;
                        multiplied) (( result *= token )) ;;
                        divided)    (( result /= token )) ;;
                    esac
                    current_op=""
                fi
                state="EXPECT_OPERATOR"
            elif [[ "$token" =~ ^(plus|minus|multiplied|divided)$ ]]; then
                die "syntax error"
            elif [[ "$token" =~ ^[0-9-]+$ ]]; then
                die "syntax error"
            else
                die "unknown operation"
            fi
        elif [[ "$state" == "EXPECT_OPERATOR" ]]; then
            if [[ "$token" =~ ^(plus|minus|multiplied|divided)$ ]]; then
                current_op="$token"
                state="EXPECT_NUMBER"
            elif is_int "$token"; then
                die "syntax error"
            else
                die "unknown operation"
            fi
        fi
    done

    # Reaching the end while expecting a number is a syntax error
    if [[ "$state" == "EXPECT_NUMBER" ]]; then
        die "syntax error"
    fi

    echo "$result"
}

main "$@"