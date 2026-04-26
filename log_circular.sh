#! /usr/bin/env bash
set -euo pipefail

DIR=$1
T=$2
L=$3
B=$4

if [[ $# -ne 4 ]]; then
    echo -e "Cantidad de argumentos incorrecto.\n"
    exit 2
fi

if [[ -d "/var/log/$DIR" ]]; then
    cd "/var/log/$DIR"
    for archivo in $(cat < <(ls)); do
        if [[ "$archivo" == *.gz ]]; then
            echo -e "$archivo ya esta comprimido.\n"
            continue
        else
            TAMANIO=$(stat "$archivo" | grep -i size | cut -d" " -f4)
            declare -i OCURR=0
            if [[ $TAMANIO -gt $T ]]; then
                sudo gzip -k "$archivo"
                OCURR=$(ls -l | grep -i "$archivo" | wc -l)
                sudo mv "$archivo.gz" "slot#$(($OCURR))-$archivo.gz"
                if [[ $OCURR -gt $L ]]; then
                    sudo rm "$(ls -l | grep -i "$archivo" | head -1 | cut -d" " -f9)"
                    declare -i IT=1
                    for i in $(cat < <(ls)); do
                        sudo mv "$i" "slot#$(($IT))-$archivo.gz"
                        IT+=1
                    done
                fi
            else
                echo "El archivo es menor que T."
            fi
        fi
    done
else
    echo -e "El directorio no existe.\n"
    exit 1
fi
