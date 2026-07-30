#!/usr/bin/env bash

# Implémentation du chiffrement Atbash
# Usage :
#   atbash_cipher.sh encode "texte à encoder"
#   atbash_cipher.sh decode "texte à décoder"

main() {
    local action="$1"
    local input="$2"

    # Conversion en minuscules
    input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    # Filtrage : ne conserver que les lettres minuscules et les chiffres (A-Z -> Z-A, 0-9 inchangés)
    local ciphered
    ciphered=$(echo "$input" | tr 'a-z' 'zyxwvutsrqponmlkjihgfedcba' | tr -cd 'a-z0-9')

    if [[ "$action" == "encode" ]]; then
        # Pour l'encodage : regrouper les caractères par paquets de 5 séparés par des espaces
        echo "$ciphered" | sed 's/.\{5\}/& /g' | sed 's/ $//'
    elif [[ "$action" == "decode" ]]; then
        # Pour le décodage : renvoyer directement la chaîne continue
        echo "$ciphered"
    fi
}

main "$@"