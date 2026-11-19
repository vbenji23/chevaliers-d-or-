#!/usr/bin/env bash

main() {
    local input="$1"
    local stack=()
    local i char top

    for (( i = 0; i < ${#input}; i++ )); do
        char="${input:i:1}"

        case "$char" in
            '(' | '[' | '{')
                stack+=("$char")
                ;;
            ')')
                if [[ ${#stack[@]} -eq 0 ]]; then
                    echo "false"
                    return 0
                fi
                top="${stack[-1]}"
                if [[ "$top" != "(" ]]; then
                    echo "false"
                    return 0
                fi
                unset 'stack[-1]'
                ;;
            ']')
                if [[ ${#stack[@]} -eq 0 ]]; then
                    echo "false"
                    return 0
                fi
                top="${stack[-1]}"
                if [[ "$top" != "[" ]]; then
                    echo "false"
                    return 0
                fi
                unset 'stack[-1]'
                ;;
            '}')
                if [[ ${#stack[@]} -eq 0 ]]; then
                    echo "false"
                    return 0
                fi
                top="${stack[-1]}"
                if [[ "$top" != "{" ]]; then
                    echo "false"
                    return 0
                fi
                unset 'stack[-1]'
                ;;
            *)
                # Ignore non-bracket characters
                ;;
        esac
    done

    # If stack is empty, all brackets were matched correctly
    if [[ ${#stack[@]} -eq 0 ]]; then
        echo "true"
    else
        echo "false"
    fi
}

main "$@"