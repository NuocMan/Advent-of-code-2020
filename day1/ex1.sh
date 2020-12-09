#!/usr/bin/bash

if [[ $# != 1 || ! -f $1 ]] ; then
    exit 1
fi

readarray -t LINE_ARRAY < $1

for i in "${!LINE_ARRAY[@]}"; do
    for j in "${LINE_ARRAY[@]:$i+1}"; do
	if (( LINE_ARRAY[i] + j == 2020 )); then
    	    echo $(( LINE_ARRAY[i] * j ))
	    exit 0
	fi
    done
done

exit 2
