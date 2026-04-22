#! /usr/bin/env bash
set -euo pipefail

ARCHIVO=$1

if [ -e $ARCHIVO ]; then
    for i in $(cat $ARCHIVO | tr -d [:punct:] | tr A-Z a-z); do
        echo $i >> aux.txt
    done
    cat aux.txt | sort > aux_sorted.txt
    rm aux.txt

    declare -i IT=1
    declare -i MEJOR=1
    PALABRA=$(cat aux_sorted.txt | head -1)
    MEJOR_PALABRA=""

    for i in $(cat aux_sorted.txt); do
        if [ $i == $PALABRA ]; then
            IT+=1
        else
            if [ $IT -gt $MEJOR ]; then
                MEJOR=$IT
                MEJOR_PALABRA=$PALABRA
            fi
            IT=1
            PALABRA=$i
        fi
    done

    for i in $(cat aux_sorted.txt); do
        if [ $i == $PALABRA ]; then
            IT+=1
        else
            echo "TF($PALABRA) = " $(echo "scale=2; $IT / $MEJOR" | bc)
            IT=1
            PALABRA=$i
        fi
    done
    echo "    Palabra mas ocurrente: $MEJOR_PALABRA"
    echo "              Ocurrencias: $MEJOR"
    rm aux_sorted.txt
else
    echo "El archivo no existe."
    exit 1
fi
