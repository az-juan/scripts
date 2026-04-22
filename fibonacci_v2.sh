#! /usr/bin/env bash
set -euo pipefail

NUMS=$@
COMPUTED=~/computed.txt
declare -i F1=0
declare -i F2=0
declare -i RES=0

for NUM in $NUMS; do
    # echo "num: " $NUM
    if [ $NUM -eq 0 ]; then
        echo "0=1" > $COMPUTED
    elif [ $NUM -eq 1 ]; then
        echo "0=1" > $COMPUTED
        echo "1=1" >> $COMPUTED
    elif [ $NUM -gt 1 ]; then
        if [ -e $COMPUTED ]; then
            LAST=$(tail -1 $COMPUTED | cut -d"=" -f1)
            if [ $NUM -gt $LAST ]; then
                declare -i LINEA=$(($LAST+2))
                for ((i = $(($LAST + 1)); i <= $NUM; i++)); do
                    F1=$(sed -n "$(($LINEA-1))p" $COMPUTED | cut -d"=" -f2)
                    F2=$(sed -n "$(($LINEA-2))p" $COMPUTED | cut -d"=" -f2)
                    RES=$((F1 + F2))
                    echo "$i=$RES" >> $COMPUTED
                    LINEA+=1
                done
                echo "fibonacci de $NUM =" $(sed -n "$(($NUM+1))p" $COMPUTED | cut -d"=" -f2)
            else
                echo "fibonacci de $NUM =" $(sed -n "$(($NUM+1))p" $COMPUTED | cut -d"=" -f2)
            fi
        else
            declare -i LINEA=3
            echo "0=1" > $COMPUTED
            echo "1=1" >> $COMPUTED
        
            for ((i = 2; i <= $NUM; i++)); do
                F1=$(sed -n "$(($LINEA-1))p" $COMPUTED | cut -d"=" -f2)
                F2=$(sed -n "$(($LINEA-2))p" $COMPUTED | cut -d"=" -f2)
                RES=$((F1 + F2))
                echo "$i=$RES" >> $COMPUTED
                LINEA+=1
            done
            echo "fibonacci de $NUM =" $(sed -n "$(($NUM+1))p" $COMPUTED | cut -d"=" -f2)
        fi
    else
        echo -e "El numero no es valido.\n"
        exit 1
    fi
done
