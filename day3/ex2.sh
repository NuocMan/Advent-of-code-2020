#!/usr/bin/bash

if [[ $# != 1 || ! -f $1 ]] ; then
    exit 1
fi

readarray -t LINE_ARRAY < $1
map_width=$(echo -n ${LINE_ARRAY[0]} | wc -c)

function tree_encountered() {
    local counter=0
    local line=0
    local column=0

    while (( line < ${#LINE_ARRAY[@]} )); do
	if [[ ${LINE_ARRAY[line]:column:1} == '#' ]]; then
	    (( counter++ ))
	fi

	column=$(( (column + $1) % map_width ))
        line=$(( line + $2 ))
    done
    echo $counter
}

echo $(( $(tree_encountered 1 1) *
	 $(tree_encountered 3 1) *
	 $(tree_encountered 5 1) *
	 $(tree_encountered 7 1) *
	 $(tree_encountered 1 2) ))
