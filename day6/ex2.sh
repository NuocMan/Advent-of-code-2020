#!/usr/bin/bash

OLDIFS=$IFS
IFS="," RGROUPS=( $(awk -v RS= -v ORS=, '{print}' $1) )
IFS=$OLDIFS
RES=0

for RGROUP in "${RGROUPS[@]}" ; do
    PERSONS=$(echo "${RGROUP}" | wc -l)
    REPLIES="${RGROUP//$'\n'/}"
    REPLIES="${REPLIES// /}"
    unset TABLE
    declare -A TABLE
    for (( i=0 ; i < ${#REPLIES} ; i++ )); do
	if [[ -z TABLE[${REPLIES:$i:1}] ]]; then
	    TABLE[${REPLIES:$i:1}]=1
	else
	    (( TABLE[${REPLIES:$i:1}] += 1 ))
	fi
    done

    for reply in "${!TABLE[@]}"; do
	if (( TABLE[$reply] == PERSONS )); then
	    (( RES += 1 ))
	fi
    done
done

echo $RES
