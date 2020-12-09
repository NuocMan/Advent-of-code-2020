#!/usr/bin/bash

function get_id() {
    echo $(( $1 * 8 + $2 ))
}

declare SEATS

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

    SEATS[$ID]=occupied
    if [[ -z ${SEATS[$(($ID - 1))]} ]] ; then
	SEATS[$(($ID - 1))]=free
    fi

    if [[ -z ${SEATS[$(($ID+1))]} ]] ; then
	SEATS[$(($ID + 1))]=free
    fi
done < $1

first=true
for seat in "${!SEATS[@]}" ; do
    if [[ ${SEATS[seat]} == free ]]; then
	if [[ $first == true ]] ; then
	    first=false
	    continue
	fi
	echo $seat
	exit 0
    fi
done
