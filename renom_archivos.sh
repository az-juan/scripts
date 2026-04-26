#! /usr/bin/env bash
set -euo pipefail

# revisar

DIR=$1

if [[ $# -ne 1 ]]; then
    echo -e "Cantidad de argumentos incorrecta.\n"
    exit 2
fi

if [[ -d "$DIR" ]]; then
    cd "$DIR"
    declare -i CANT=0
    for archivo in $(cat < <(ls | tr [:blank:] _)); do
        original=$(echo "$archivo" | tr _ ' ')
        renombrado=$(echo "$original" | tr A-Z a-z | tr [:blank:] _)
        if [[ "$renombrado" != "$original" ]]; then
            CANT+=1
            mv "$original" "$renombrado"
        fi
    done
    echo -e "Archivos renombrados: $CANT\n"
else
    echo -e "El directorio no existe.\n"
    exit 1
fi
