#!/usr/bin/env bash

main() {
    local -r score=$1
    local -r command=$2
    local -r item=${3:-""}

    local -r items=(
        "eggs"
        "peanuts"
        "shellfish"
        "strawberries"
        "tomatoes"
        "chocolate"
        "pollen"
        "cats"
    )

    case "$command" in
        "allergic_to")
            for i in "${!items[@]}"; do
                if [[ "${items[$i]}" == "$item" ]]; then
                    if (( (score & (1 << i)) != 0 )); then
                        echo "true"
                    else
                        echo "false"
                    fi
                    return 0
                fi
            done
            echo "false"
            ;;

        "list")
            local list=()
            for i in "${!items[@]}"; do
                if (( (score & (1 << i)) != 0 )); then
                    list+=("${items[$i]}")
                fi
            done
            echo "${list[*]}"
            ;;
    esac
}

main "$@"