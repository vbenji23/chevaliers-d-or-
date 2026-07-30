#!/usr/bin/env bash

# Disable filename expansion (globbing) so '*' stays as literal '*'
set -f

die() {
    echo "Error: $1" >&2
    exit 1
}

is_number() {
    [[ "$1" =~ ^-?[0-9]+$ ]]
}

main() {
    local -a stack=()
    local -A user_words=()

    local input
    input=$(cat)

    # Normalize newlines and tabs to spaces
    input="${input//$'\n'/ }"
    input="${input//$'\t'/ }"

    local -a raw_tokens=($input)
    local -a tokens=()

    # Expand user-defined words into a flattened stream of tokens
    local i=0
    local n=${#raw_tokens[@]}

    while (( i < n )); do
        local token="${raw_tokens[i]}"
        local upper_token="${token^^}"

        if [[ "$upper_token" == ":" ]]; then
            (( i++ ))
            if (( i >= n )); then
                die "invalid definition syntax"
            fi

            local name="${raw_tokens[i]}"
            local upper_name="${name^^}"

            if is_number "$upper_name"; then
                die "illegal operation: cannot redefine numbers"
            fi

            (( i++ ))
            local -a def_tokens=()

            while (( i < n )) && [[ "${raw_tokens[i]}" != ";" ]]; do
                local w="${raw_tokens[i]}"
                local upper_w="${w^^}"

                # Substitute already defined words at definition time
                if [[ -n "${user_words[$upper_w]+x}" ]]; then
                    read -r -a expanded <<< "${user_words[$upper_w]}"
                    def_tokens+=("${expanded[@]}")
                else
                    def_tokens+=("$w")
                fi
                (( i++ ))
            done

            if (( i >= n )) || [[ "${raw_tokens[i]}" != ";" ]]; then
                die "invalid definition syntax"
            fi

            user_words["$upper_name"]="${def_tokens[*]}"
        else
            # Check if token is a user-defined word
            if [[ -n "${user_words[$upper_token]+x}" ]]; then
                read -r -a expanded <<< "${user_words[$upper_token]}"
                tokens+=("${expanded[@]}")
            else
                tokens+=("$token")
            fi
        fi
        (( i++ ))
    done

    # Stack Evaluation
    for token in "${tokens[@]}"; do
        local upper_token="${token^^}"

        if is_number "$upper_token"; then
            stack+=("$upper_token")
            continue
        fi

        case "$upper_token" in
            "+")
                (( ${#stack[@]} == 0 )) && die "empty stack"
                (( ${#stack[@]} < 2 )) && die "only one value on the stack"
                local b="${stack[-1]}"
                local a="${stack[-2]}"
                unset 'stack[-1]' 'stack[-1]'
                stack+=("$(( a + b ))")
                ;;
            "-")
                (( ${#stack[@]} == 0 )) && die "empty stack"
                (( ${#stack[@]} < 2 )) && die "only one value on the stack"
                local b="${stack[-1]}"
                local a="${stack[-2]}"
                unset 'stack[-1]' 'stack[-1]'
                stack+=("$(( a - b ))")
                ;;
            "*")
                (( ${#stack[@]} == 0 )) && die "empty stack"
                (( ${#stack[@]} < 2 )) && die "only one value on the stack"
                local b="${stack[-1]}"
                local a="${stack[-2]}"
                unset 'stack[-1]' 'stack[-1]'
                stack+=("$(( a * b ))")
                ;;
            "/")
                (( ${#stack[@]} == 0 )) && die "empty stack"
                (( ${#stack[@]} < 2 )) && die "only one value on the stack"
                local b="${stack[-1]}"
                local a="${stack[-2]}"
                (( b == 0 )) && die "divide by zero"
                unset 'stack[-1]' 'stack[-1]'
                stack+=("$(( a / b ))")
                ;;
            "DUP")
                (( ${#stack[@]} == 0 )) && die "empty stack"
                stack+=("${stack[-1]}")
                ;;
            "DROP")
                (( ${#stack[@]} == 0 )) && die "empty stack"
                unset 'stack[-1]'
                ;;
            "SWAP")
                (( ${#stack[@]} == 0 )) && die "empty stack"
                (( ${#stack[@]} < 2 )) && die "only one value on the stack"
                local b="${stack[-1]}"
                local a="${stack[-2]}"
                stack[-2]="$b"
                stack[-1]="$a"
                ;;
            "OVER")
                (( ${#stack[@]} == 0 )) && die "empty stack"
                (( ${#stack[@]} < 2 )) && die "only one value on the stack"
                stack+=("${stack[-2]}")
                ;;
            *)
                die "undefined operation: $token"
                ;;
        esac
    done

    echo "${stack[*]}"
}

main "$@"