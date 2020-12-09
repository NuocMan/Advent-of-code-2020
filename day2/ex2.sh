#!/usr/bin/bash

if [[ $# != 1 || ! -f $1 ]] ; then
    exit 1
fi

COUNTER=0
POS1=( $(awk -F "[- ]" '{ print $1 }' $1) )
POS2=( $(awk -F "[- ]" '{ print $2 }' $1) )
CHARS=( $(awk -F "[: ]" '{ print $2 }' $1) )
PASSWORD=( $(awk '{ print $3 }' $1) )

for i in "${!CHARS[@]}"; do
    pos1=${POS1[i]}
    pos2=${POS2[i]}
    if [[ "${PASSWORD[i]:pos1-1:1}" == "${CHARS[i]}" || "${PASSWORD[i]:pos2-1:1}" == "${CHARS[i]}" ]] &&
	   [[ "${PASSWORD[i]:pos1-1:1}" != "${PASSWORD[i]:pos2-1:1}" ]]; then
	(( COUNTER++ ))
    fi
done

echo $COUNTER
