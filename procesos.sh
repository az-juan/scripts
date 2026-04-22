#! /usr/bin/env bash
set -euo pipefail

# FUNCIONAAA

SLICE=$1
declare -i MINUTOS=1
ps -A | tail -$(($(wc -l <(ps -A) | cut -d" " -f1)-1)) > procesos.txt

if [ -z $SLICE ]; then
    while read -r LINEA; do
        if [ $(cut -d" " -f3 < <(echo $LINEA) | cut -d":" -f2) -gt $MINUTOS ]; then
            echo $LINEA
        fi
    done < procesos.txt
else
    while read -r LINEA; do
        if [[ $(grep -i $SLICE < <(echo $LINEA)) ]] &&
           [ $(cut -d" " -f3 < <(echo $LINEA) | cut -d":" -f2) -gt $MINUTOS ]; then
            echo $LINEA
        fi
    done < procesos.txt
fi

rm procesos.txt
