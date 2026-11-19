#!/usr/bin/env bash

# Test de palindrome ultra-rapide par inversion arithmétique
is_palindrome() {
    local -i n=$1 rev=0 rem tmp=$1
    while (( tmp > 0 )); do
        (( rem = tmp % 10 ))
        (( rev = rev * 10 + rem ))
        (( tmp /= 10 ))
    done
    (( n == rev ))
}

main() {
    local property="$1"
    local -i min="$2"
    local -i max="$3"

    # Validation des arguments
    if [[ "$property" != "smallest" && "$property" != "largest" ]]; then
        echo "first arg should be 'smallest' or 'largest'" >&2
        exit 1
    fi

    if (( min > max )); then
        echo "min must be <= max" >&2
        exit 1
    fi

    local -i best_prod=-1
    local factors=()

    if [[ "$property" == "smallest" ]]; then
        for (( i = min; i <= max; i++ )); do
            # Arrêt précoce : si i^2 dépasse déjà le plus petit palindrome trouvé
            if (( best_prod != -1 && i * i > best_prod )); then
                break
            fi

            for (( j = i; j <= max; j++ )); do
                local -i p=$(( i * j ))

                # Si le produit dépasse le meilleur résultat actuel, inutil d'augmenter j
                if (( best_prod != -1 && p > best_prod )); then
                    break
                fi

                if is_palindrome "$p"; then
                    if (( best_prod == -1 || p < best_prod )); then
                        best_prod=$p
                        factors=("[$i, $j]")
                    elif (( p == best_prod )); then
                        factors+=("[$i, $j]")
                    fi
                fi
            done
        done
    else # largest
        for (( i = max; i >= min; i-- )); do
            # Arrêt précoce : si i * max ne peut pas battre le plus grand palindrome trouvé
            if (( best_prod != -1 && i * max < best_prod )); then
                break
            fi

            for (( j = max; j >= i; j-- )); do
                local -i p=$(( i * j ))

                # Si le produit est inférieur au meilleur résultat actuel, inutil de diminuer j
                if (( best_prod != -1 && p < best_prod )); then
                    break
                fi

                if is_palindrome "$p"; then
                    if (( best_prod == -1 || p > best_prod )); then
                        best_prod=$p
                        factors=("[$i, $j]")
                    elif (( p == best_prod )); then
                        # On insère au début pour conserver l'ordre croissant des facteurs i
                        factors=("[$i, $j]" "${factors[@]}")
                    fi
                fi
            done
        done
    fi

    # Affichage du résultat si trouvé
    if (( best_prod != -1 )); then
        local IFS=" "
        echo "${best_prod}: ${factors[*]}"
    fi
}

main "$@"