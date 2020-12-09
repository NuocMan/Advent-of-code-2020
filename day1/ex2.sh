#!/usr/bin/bash

if [[ $# != 1 || ! -f $1 ]] ; then
    exit 1
fi

readarray -t LINE_ARRAY < $1

for i in "${!LINE_ARRAY[@]}"; do
    j_indexes=( "${!LINE_ARRAY[@]}" )
    for j in "${j_indexes[@]:$i}"; do
	if (( LINE_ARRAY[i] + LINE_ARRAY[j] >= 2020 )); then
	    continue
	fi
	for k in "${LINE_ARRAY[@]:$j}"; do
	    if (( LINE_ARRAY[i] + LINE_ARRAY[j] + k == 2020 )); then
    		echo "${LINE_ARRAY[i]} * ${LINE_ARRAY[j]} * $k" = $(( LINE_ARRAY[i] * LINE_ARRAY[j] * k ))
		exit 0
	    fi
	done
    done
done

exit 2
