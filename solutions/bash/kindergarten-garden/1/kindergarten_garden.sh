#!/usr/bin/env bash

main() {
    local diagram="$1"
    local student="$2"

    # Map single-letter plant codes to their plural names
    declare -A plants=(
        [G]="grass"
        [C]="clover"
        [R]="radishes"
        [V]="violets"
    )

    # Ordered list of students in the class
    local students=(
        "Alice" "Bob" "Charlie" "David"
        "Eve" "Fred" "Ginny" "Harriet"
        "Ileana" "Joseph" "Kincaid" "Larry"
    )

    # Find the index of the requested student
    local student_idx=-1
    for i in "${!students[@]}"; do
        if [[ "${students[$i]}" == "$student" ]]; then
            student_idx=$i
            break
        fi
    done

    # Split the diagram into two rows by newline
    IFS=$'\n' read -r -d '' row1 row2 <<< "$diagram"

    # Each student gets 2 cups per row, starting at index student_idx * 2
    local start_idx=$(( student_idx * 2 ))

    local c1="${row1:start_idx:1}"
    local c2="${row1:start_idx+1:1}"
    local c3="${row2:start_idx:1}"
    local c4="${row2:start_idx+1:1}"

    # Output the 4 plants corresponding to the student's cups
    echo "${plants[$c1]} ${plants[$c2]} ${plants[$c3]} ${plants[$c4]}"
}

main "$@"