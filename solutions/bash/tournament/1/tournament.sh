#!/usr/bin/env bash

# Associative arrays to hold stats per team
declare -A wins losses draws points

# Ensure a team is registered in the tracking arrays
init_team() {
    local team=$1
    if [[ -z "${wins[$team]}" ]]; then
        wins["$team"]=0
        losses["$team"]=0
        draws["$team"]=0
        points["$team"]=0
    fi
}

main() {
    local file="${1:-/dev/stdin}"

    if [[ -f "$file" || "$file" == "/dev/stdin" ]]; then
        while IFS=';' read -r team1 team2 outcome || [[ -n "$team1" ]]; do
            # Trim trailing carriage returns if present
            team1=$(echo "$team1" | tr -d '\r')
            team2=$(echo "$team2" | tr -d '\r')
            outcome=$(echo "$outcome" | tr -d '\r')

            # Ignore empty or malformed lines
            if [[ -z "$team1" || -z "$team2" || -z "$outcome" ]]; then
                continue
            fi

            init_team "$team1"
            init_team "$team2"

            case "$outcome" in
                win)
                    (( wins["$team1"]++ ))
                    (( losses["$team2"]++ ))
                    (( points["$team1"] += 3 ))
                    ;;
                loss)
                    (( losses["$team1"]++ ))
                    (( wins["$team2"]++ ))
                    (( points["$team2"] += 3 ))
                    ;;
                draw)
                    (( draws["$team1"]++ ))
                    (( draws["$team2"]++ ))
                    (( points["$team1"] += 1 ))
                    (( points["$team2"] += 1 ))
                    ;;
            esac
        done < "$file"
    fi

    # Print table header
    printf "%-30s | MP |  W |  D |  L |  P\n" "Team"

    # Gather results and sort:
    # 1. Points descending (-k2,2nr)
    # 2. Team name ascending (-k1,1)
    if ((${#wins[@]} > 0)); then
        for team in "${!wins[@]}"; do
            local w=${wins["$team"]}
            local d=${draws["$team"]}
            local l=${losses["$team"]}
            local p=${points["$team"]}
            local mp=$(( w + d + l ))

            printf "%s;%d;%d;%d;%d;%d\n" "$team" "$p" "$mp" "$w" "$d" "$l"
        done | sort -t';' -k2,2nr -k1,1 | while IFS=';' read -r team p mp w d l; do
            printf "%-30s | %2d | %2d | %2d | %2d | %2d\n" "$team" "$mp" "$w" "$d" "$l" "$p"
        done
    fi
}

main "$@"