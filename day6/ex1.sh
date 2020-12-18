#!/usr/bin/bash

OLDIFS=$IFS
IFS="," RGROUPS=( $(awk -v RS= -v ORS=, '{print}' $1) )
IFS=$OLDIFS
RES=0

for RGROUP in "${RGROUPS[@]}" ; do

    REPLIES="${RGROUP//$'\n'/}"
    REPLIES="${REPLIES// /}"
    unset TABLE
    declare -A TABLE
    for (( i=0 ; i < ${#REPLIES} ; i++ )); do
	TABLE[${REPLIES:$i:1}]=t
    done

    RES=$(( "${#TABLE[@]}" + RES ))
done

echo $RES
