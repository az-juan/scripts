#! /usr/bin/env bash
set -euo pipefail

DIR="$1"
NIVEL=$2
# RUTA=$(echo $(pwd)/$DIR)

# FUNCIONAAA

function buscar_dir() {
    local dir="$1"
    declare -i local pos="$2"
    
    if [ $pos -ge $NIVEL ]; then
        command
    else
        cd "$dir"
        while read -r i; do
            if [[ -d "$i" ]]; then
                pos+=1
                case "$pos" in
                    0)
                        echo -e "* $i"
                        ;;
                    1)
                        echo -e "    * $i"
                        ;;
                    2)
                        echo -e "        * $i"
                        ;;
                    3)
                        echo -e "            * $i"
                        ;;
                    4)
                        echo -e "                * $i"
                        ;;
                esac
                buscar_dir "$i" "$pos"
                pos+=-1
            else
                case "$pos" in
                    0)
                        echo -e "    * $i"
                        ;;
                    1)
                        echo -e "        * $i"
                        ;;
                    2)
                        echo -e "            * $i"
                        ;;
                    3)
                        echo -e "                * $i"
                        ;;
                    4)
                        echo -e "                    * $i"
                        ;;
                esac
            fi
        done < <(ls "$(pwd)")
        cd ..
    fi
}

if [[ -d "$DIR" ]]; then
    cd "$DIR"
    while read -r i; do
        if [[ -d "$i" ]]; then
            declare -i POS=0
            echo -e "* $i"
            buscar_dir "$i" $POS
        else
            echo -e "* $i"
        fi
    done < <(ls "$DIR")
else
    echo "No es un directorio."
    exit 1
fi
