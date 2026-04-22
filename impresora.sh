#! /usr/bin/env bash
set -euo pipefail

# FUNCIONAAAA

ARCHIVO="$1"
ID_IMP="$2"
TIPO_PAG="$3"
declare -i FILAS=24
declare -i COL=80
declare -i PAG=1

while read -r LINEA; do
    ID=$(cut -d":" -f1 <(cat $LINEA))
    FORM_PAG=$(cut -d":" -f2 <(cat $LINEA))

    if [[ "$ID" -eq "$ID_IMP" ]] && [[ "$TIPO_PAG" == "$FORM_PAG" ]]; then
        FILAS=$(cut -d":" -f3 <(cat $LINEA))
        COL=$(cut -d ":" -f4 <(cat $LINEA))
    fi
done < /etc/cups/printers.conf

if [ -e $ARCHIVO ]; then
    declare -i IT=0
    while read -r LINEA; do
        CARACTERES=$(wc -c <(echo $LINEA) | cut -d" " -f1)
        
        if [ $CARACTERES -gt $COL ]; then
            AUX=$(($CARACTERES / $COL))
            IT+=$AUX
        fi
        IT+=1

        if [ $IT -gt $FILAS ]; then
            PAG+=$(($IT / $FILAS))
            IT=$(($IT - $FILAS))
        fi
        
    done < $ARCHIVO
    echo "cant de paginas:" $PAG
else
    echo "El archivo no existe."
    exit 1
fi
