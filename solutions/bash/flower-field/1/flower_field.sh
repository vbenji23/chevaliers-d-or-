#!/usr/bin/env bash

main() {
    local -a grid=("$@")
    local -i rows="${#grid[@]}"

    # Handle empty input
    if (( rows == 0 )); then
        exit 0
    fi

    local -i cols="${#grid[0]}"

    # Handle edge case with empty string rows
    if (( cols == 0 )); then
        for (( r = 0; r < rows; r++ )); do
            echo ""
        done
        exit 0
    fi

    local -a result=()

    for (( r = 0; r < rows; r++ )); do
        local row_out=""
        for (( c = 0; c < cols; c++ )); do
            local char="${grid[r]:c:1}"

            if [[ "$char" == "*" ]]; then
                row_out+="*"
            else
                local -i count=0

                # Check all 8 neighboring squares
                for dr in -1 0 1; do
                    for dc in -1 0 1; do
                        # Skip current cell
                        if (( dr == 0 && dc == 0 )); then
                            continue
                        fi

                        local -i nr=$(( r + dr ))
                        local -i nc=$(( c + dc ))

                        # Bounds checking
                        if (( nr >= 0 && nr < rows && nc >= 0 && nc < cols )); then
                            if [[ "${grid[nr]:nc:1}" == "*" ]]; then
                                (( count++ ))
                            fi
                        fi
                    done
                done

                if (( count > 0 )); then
                    row_out+="$count"
                else
                    row_out+=" "
                fi
            fi
        done
        result+=("$row_out")
    done

    printf '%s\n' "${result[@]}"
}

main "$@"