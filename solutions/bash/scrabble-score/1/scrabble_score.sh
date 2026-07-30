#!/usr/bin/env bash

main() {
    # Convert input to uppercase
    local -r word="${1^^}"
    local -i score=0
    local char

    # Iterate character by character
    for (( i=0; i<${#word}; i++ )); do
        char="${word:i:1}"
        case "$char" in
            [AEIOULNRST]) score+=1 ;;
            [DG])         score+=2 ;;
            [BCMP])       score+=3 ;;
            [FHVWY])      score+=4 ;;
            K)            score+=5 ;;
            [JX])         score+=8 ;;
            [QZ])         score+=10 ;;
        esac
    done

    echo "$score"
}

main "$@"