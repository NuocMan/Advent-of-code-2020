#!/usr/bin/bash

if [[ $# != 1 || ! -f $1 ]] ; then
    exit 1
fi

readarray -t LINE_ARRAY < $1

COUNTER=0
MIN=( $(awk -F "[- ]" '{ print $1 }' $1) )
MAX=( $(awk -F "[- ]" '{ print $2 }' $1) )
CHARS=( $(awk -F "[: ]" '{ print $2 }' $1) )

for i in "${!CHARS[@]}"; do
    COUNT=$(echo -n "${LINE_ARRAY[i]//[^${CHARS[$i]}]}" | wc -c)
    if (( (COUNT - 1) >= MIN[i] && (COUNT - 1) <= MAX[i] )) ; then
	(( COUNTER++ ))
    fi	
done

echo $COUNTER
