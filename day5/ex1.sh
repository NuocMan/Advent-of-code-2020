#!/usr/bin/bash

function get_id() {
    echo $(( $1 * 8 + $2 ))
}

MAX=0
while read LINE ; do

    ROW=$(echo ${LINE:0:7})
    ROW=${ROW[@]//B/1}
    ROW=${ROW[@]//F/0}
    ROW=$(( 2#$ROW ))

    COLUMN=$(echo ${LINE:7:3})
    COLUMN=${COLUMN[@]//R/1}
    COLUMN=${COLUMN[@]//L/0}
    COLUMN=$(( 2#$COLUMN ))

    ID=$(get_id $ROW $COLUMN)
    if (( $ID > $MAX )) ; then
	MAX=$ID
    fi
done < $1

echo $MAX
