#!/usr/bin/env bash

# Helper: format epoch timestamp to ISO-8601 string (YYYY-MM-DDTHH:MM:SS) in UTC
format_date() {
    local epoch="$1"
    TZ=UTC printf '%(%Y-%m-%dT%H:%M:%S)T\n' "$epoch"
}

# Helper: find the first workday (Mon-Fri) of a given YYYY-MM
get_first_workday() {
    local year="$1"
    local month="$2"

    local day=1
    while true; do
        printf -v date_str '%04d-%02d-%02d' "$year" "$month" "$day"
        local dow
        dow=$(TZ=UTC date -u -d "$date_str" +%u) # 1=Mon, ..., 7=Sun
        if (( dow <= 5 )); then
            echo "$date_str"
            return 0
        fi
        (( day++ ))
    done
}

# Helper: find the last workday (Mon-Fri) of a given YYYY-MM
get_last_workday() {
    local year="$1"
    local month="$2"

    # Get the last day of the month by taking 1st of next month minus 1 day
    local next_year="$year"
    local next_month=$(( month + 1 ))
    if (( next_month > 12 )); then
        next_month=1
        (( next_year++ ))
    fi

    printf -v next_first_str '%04d-%02d-01' "$next_year" "$next_month"
    local next_first_epoch
    next_first_epoch=$(TZ=UTC date -u -d "$next_first_str" +%s)
    local last_day_epoch=$(( next_first_epoch - 86400 ))

    while true; do
        local dow
        dow=$(TZ=UTC date -u -d "@$last_day_epoch" +%u)
        if (( dow <= 5 )); then
            TZ=UTC date -u -d "@$last_day_epoch" +%Y-%m-%d
            return 0
        fi
        (( last_day_epoch -= 86400 ))
    done
}

main() {
    local desc="$1"
    local meeting_start="$2"

    # Replace 'T' with space for date -d compatibility
    local meeting_formatted="${meeting_start/T/ }"

    # Convert meeting start to epoch and extract date components
    local start_epoch
    start_epoch=$(TZ=UTC date -u -d "$meeting_formatted" +%s)

    local cur_year cur_month cur_day cur_hour cur_dow
    read -r cur_year cur_month cur_day cur_hour cur_dow < <(
        TZ=UTC date -u -d "@$start_epoch" +'%Y %m %d %H %u'
    )

    # Strip leading zero for numeric comparisons
    cur_month=$(( 10#$cur_month ))
    cur_hour=$(( 10#$cur_hour ))

    case "$desc" in
        "NOW")
            local target_epoch=$(( start_epoch + 7200 ))
            format_date "$target_epoch"
            ;;

        "ASAP")
            if (( cur_hour < 13 )); then
                printf -v date_str '%04d-%02d-%02dT17:00:00' "$cur_year" "$cur_month" "$cur_day"
                echo "$date_str"
            else
                local tomorrow_epoch=$(( start_epoch + 86400 ))
                local tom_year tom_month tom_day
                read -r tom_year tom_month tom_day < <(
                    TZ=UTC date -u -d "@$tomorrow_epoch" +'%Y %m %d'
                )
                printf -v date_str '%04d-%02d-%02dT13:00:00' "$tom_year" "$tom_month" "$tom_day"
                echo "$date_str"
            fi
            ;;

        "EOW")
            # cur_dow: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri
            local days_to_add=0
            local target_time=""

            if (( cur_dow <= 3 )); then
                # Target: Friday (5) at 17:00:00
                days_to_add=$(( 5 - cur_dow ))
                target_time="17:00:00"
            else
                # Target: Sunday (7) at 20:00:00
                days_to_add=$(( 7 - cur_dow ))
                target_time="20:00:00"
            fi

            local target_epoch=$(( start_epoch + days_to_add * 86400 ))
            local target_date
            target_date=$(TZ=UTC date -u -d "@$target_epoch" +%Y-%m-%d)
            echo "${target_date}T${target_time}"
            ;;

        *M)
            # Match <N>M pattern
            local target_m="${desc%M}"
            target_m=$(( 10#$target_m ))

            local target_year="$cur_year"
            if (( cur_month >= target_m )); then
                (( target_year++ ))
            fi

            local workday_date
            workday_date=$(get_first_workday "$target_year" "$target_m")
            echo "${workday_date}T08:00:00"
            ;;

        Q*)
            # Match Q<N> pattern
            local q_num="${desc#Q}"
            q_num=$(( 10#$q_num ))

            local cur_quarter=$(( (cur_month - 1) / 3 + 1 ))
            local target_year="$cur_year"
            if (( cur_quarter > q_num )); then
                (( target_year++ ))
            fi

            # End month of quarter Q1=3, Q2=6, Q3=9, Q4=12
            local end_month=$(( q_num * 3 ))

            local workday_date
            workday_date=$(get_last_workday "$target_year" "$end_month")
            echo "${workday_date}T08:00:00"
            ;;
    esac
}

main "$@"