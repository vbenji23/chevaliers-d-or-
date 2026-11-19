#!/usr/bin/env bash

# Directions ordered clockwise: 0: north, 1: east, 2: south, 3: west
directions=("north" "east" "south" "west")

# Helper function to get direction index (0..3) from direction name
get_dir_index() {
    local dir=$1
    case "$dir" in
        north) echo 0 ;;
        east)  echo 1 ;;
        south) echo 2 ;;
        west)  echo 3 ;;
        *)     echo -1 ;;
    esac
}

main() {
    # Set default values if arguments are missing
    local -i x=${1:-0}
    local -i y=${2:-0}
    local dir=${3:-north}
    local instructions=${4:-""}

    # Validate direction
    local -i dir_idx
    dir_idx=$(get_dir_index "$dir")
    if (( dir_idx == -1 )); then
        echo "invalid direction: $dir" >&2
        exit 1
    fi

    # Process instructions one character at a time
    local -i i
    for (( i = 0; i < ${#instructions}; i++ )); do
        local cmd="${instructions:i:1}"
        case "$cmd" in
            R)
                dir_idx=$(( (dir_idx + 1) % 4 ))
                ;;
            L)
                dir_idx=$(( (dir_idx + 3) % 4 ))
                ;;
            A)
                case "${directions[dir_idx]}" in
                    north) (( y++ )) ;;
                    east)  (( x++ )) ;;
                    south) (( y-- )) ;;
                    west)  (( x-- )) ;;
                esac
                ;;
            *)
                echo "invalid instruction: $cmd" >&2
                exit 1
                ;;
        esac
    done

    # Output final state
    echo "$x $y ${directions[dir_idx]}"
}

main "$@"