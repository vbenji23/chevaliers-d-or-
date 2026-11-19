#!/usr/bin/env bash

# Minimum coin change calculator using Dynamic Programming.

main() {
    local target="$1"
    shift
    local -a coins=("$@")

    # 1. Validation checks
    if (( target < 0 )); then
        echo "target can't be negative" >&2
        exit 1
    fi

    if (( target == 0 )); then
        echo ""
        exit 0
    fi

    # Filter out coins larger than target
    local -a valid_coins=()
    for c in "${coins[@]}"; do
        if (( c <= target )); then
            valid_coins+=("$c")
        fi
    done

    if (( ${#valid_coins[@]} == 0 )); then
        echo "can't make target with given coins" >&2
        exit 1
    fi

    # 2. Dynamic Programming array initialization
    # min_coins[i] stores the minimum number of coins needed for amount i
    # last_coin[i] stores the last coin added to achieve amount i
    local INF=99999999
    local -a min_coins=(0)
    local -a last_coin=(-1)

    for (( i=1; i<=target; i++ )); do
        min_coins[i]=$INF
        last_coin[i]=-1
    done

    # 3. Fill the DP table
    for (( i=1; i<=target; i++ )); do
        for c in "${valid_coins[@]}"; do
            if (( i >= c )); then
                local prev=$(( i - c ))
                if (( min_coins[prev] != INF && min_coins[prev] + 1 < min_coins[i] )); then
                    min_coins[i]=$(( min_coins[prev] + 1 ))
                    last_coin[i]=$c
                fi
            fi
        done
    done

    # 4. Check if target is achievable
    if (( min_coins[target] == INF )); then
        echo "can't make target with given coins" >&2
        exit 1
    fi

    # 5. Backtrack to reconstruct the coin sequence
    local -a result=()
    local curr=$target
    while (( curr > 0 )); do
        local c=${last_coin[curr]}
        result+=("$c")
        curr=$(( curr - c ))
    done

    # Sort coins in ascending numerical order
    local -a sorted_result
    readarray -t sorted_result < <(printf '%s\n' "${result[@]}" | sort -n)

    echo "${sorted_result[*]}"
}

main "$@"