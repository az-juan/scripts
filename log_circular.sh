#! /usr/bin/env bash
set -euo pipefail

# funciona ?

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
            echo -e "$archivo ya esta comprimido."
        else
            TAMANIO=$(stat "$archivo" | grep -i size | cut -d" " -f4)
            declare -i OCURR=0
            declare -i TAM_TOTAL=0
    
            for i in $(cat < <(ls | grep -i "${archivo}".gz$)); do
                TAM_TOTAL+=$(stat "$i" | grep -i size | cut -d" " -f4)
            done
            echo "tamaño total $TAM_TOTAL"
            if [[ $((($TAM_TOTAL/1024)+1)) -gt $B ]]; then
                echo "El tamaño total supera los $B bytes."
            else
                if [[ $TAMANIO -gt $T ]]; then
                    sudo gzip "$archivo"
                    OCURR=$(ls -l | grep -i ${archivo}.gz$ | wc -l)
                    sudo mv "${archivo}.gz" "slot#${OCURR}-${archivo}.gz"
            
                    if [[ $OCURR -gt $L ]]; then
                        sudo rm "$(ls -l | grep -i "$archivo" | head -1 | cut -d" " -f9)"
                        declare -i IT=1
                        for i in $(cat < <(ls | grep -i "${archivo}".gz$)); do
                            sudo mv "$i" "slot#${IT}-${archivo}.gz"
                            IT+=1
                        done
                    fi
                else
                    echo -e "El archivo es menor que T.\n"
                fi
            fi
        fi
    done
else
    echo -e "El directorio no existe.\n"
    exit 1
fi
