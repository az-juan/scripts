#! /usr/bin/env bash
set -euo pipefail

ARCHIVO=$1
LINEAS=$(wc -l $ARCHIVO | cut -d" " -f1)

for ((i = $LINEAS; i > 0; i--)); do
    echo $(sed -n "$(($i))p" $ARCHIVO)
done < $ARCHIVO
