#!/usr/bin/env bash

# Convert card rank to numeric value (2..14)
rank_val() {
    case "$1" in
        2) echo 2 ;; 3) echo 3 ;; 4) echo 4 ;; 5) echo 5 ;;
        6) echo 6 ;; 7) echo 7 ;; 8) echo 8 ;; 9) echo 9 ;;
        10) echo 10 ;; J) echo 11 ;; Q) echo 12 ;; K) echo 13 ;; A) echo 14 ;;
    esac
}

# Evaluates a 5-card poker hand string into a sortable key string.
# Returns space-separated integers: category_rank [tiebreaker values ...]
evaluate_hand() {
    local hand="$1"
    local -a cards=($hand)
    local -a ranks=()
    local -a suits=()

    for card in "${cards[@]}"; do
        local r="${card%[SCDH]}"
        local s="${card#$r}"
        ranks+=("$(rank_val "$r")")
        suits+=("$s")
    done

    # Check flush
    local is_flush=1
    for (( i=1; i<5; i++ )); do
        if [[ "${suits[$i]}" != "${suits[0]}" ]]; then
            is_flush=0
            break
        fi
    done

    # Sort ranks descending
    local -a sorted_ranks
    readarray -t sorted_ranks < <(printf '%s\n' "${ranks[@]}" | sort -nr)

    # Count frequencies of each rank
    local -A freq=()
    for r in "${sorted_ranks[@]}"; do
        (( freq[$r]++ ))
    done

    # Check straight
    local is_straight=0
    local straight_high=0

    # Normal straight check (5 consecutive unique ranks)
    if (( ${#freq[@]} == 5 )); then
        local max="${sorted_ranks[0]}"
        local min="${sorted_ranks[4]}"
        if (( max - min == 4 )); then
            is_straight=1
            straight_high=$max
        elif (( sorted_ranks[0] == 14 && sorted_ranks[1] == 5 && sorted_ranks[2] == 4 && sorted_ranks[3] == 3 && sorted_ranks[4] == 2 )); then
            # Ace-low straight (A 2 3 4 5)
            is_straight=1
            straight_high=5
        fi
    fi

    # Group ranks by count, then by rank descending
    # Format: count * 100 + rank
    local -a group_keys=()
    for r in "${!freq[@]}"; do
        local count="${freq[$r]}"
        group_keys+=("$(( count * 100 + r ))")
    done

    local -a sorted_groups
    readarray -t sorted_groups < <(printf '%s\n' "${group_keys[@]}" | sort -nr)

    # Extract rank ordering based on counts
    local -a tiebreakers=()
    for key in "${sorted_groups[@]}"; do
        local count=$(( key / 100 ))
        local r=$(( key % 100 ))
        tiebreakers+=("$r")
    done

    # Determine hand category (8 = Straight Flush, 7 = 4 of a kind, ..., 0 = High Card)
    local category=0

    if (( is_straight && is_flush )); then
        category=8
        tiebreakers=("$straight_high")
    elif (( ${freq[${tiebreakers[0]}]} == 4 )); then
        category=7
    elif (( ${#freq[@]} == 2 && ${freq[${tiebreakers[0]}]} == 3 )); then
        category=6
    elif (( is_flush )); then
        category=5
        tiebreakers=("${sorted_ranks[@]}")
    elif (( is_straight )); then
        category=4
        tiebreakers=("$straight_high")
    elif (( ${freq[${tiebreakers[0]}]} == 3 )); then
        category=3
    elif (( ${#freq[@]} == 3 && ${freq[${tiebreakers[0]}]} == 2 && ${freq[${tiebreakers[1]}]} == 2 )); then
        category=2
    elif (( ${freq[${tiebreakers[0]}]} == 2 )); then
        category=1
    else
        category=0
        tiebreakers=("${sorted_ranks[@]}")
    fi

    echo "$category ${tiebreakers[*]}"
}

# Compares two evaluation key strings.
# Returns 1 if key1 > key2, -1 if key1 < key2, 0 if equal.
compare_keys() {
    local -a k1=($1)
    local -a k2=($2)

    for (( i=0; i<${#k1[@]}; i++ )); do
        if (( k1[i] > k2[i] )); then
            echo 1
            return
        elif (( k1[i] < k2[i] )); then
            echo -1
            return
        fi
    done

    echo 0
}

main() {
    if (( $# == 0 )); then
        exit 0
    fi

    local -a best_hands=()
    local best_key=""

    for hand in "$@"; do
        local key
        key=$(evaluate_hand "$hand")

        if [[ -z "$best_key" ]]; then
            best_key="$key"
            best_hands=("$hand")
        else
            local cmp
            cmp=$(compare_keys "$key" "$best_key")
            if (( cmp > 0 )); then
                best_key="$key"
                best_hands=("$hand")
            elif (( cmp == 0 )); then
                best_hands+=("$hand")
            fi
        fi
    done

    printf '%s\n' "${best_hands[@]}"
}

main "$@"