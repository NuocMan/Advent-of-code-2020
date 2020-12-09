#!/usr/bin/bash

# byr (Birth Year) - four digits; at least 1920 and at most 2002.
# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
# hgt (Height) - a number followed by either cm or in:
#     If cm, the number must be at least 150 and at most 193.
#     If in, the number must be at least 59 and at most 76. 
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.

if [[ $# != 1 || ! -f $1 ]] ; then
    exit 1
fi

COLORS=( amb blu brn gry grn hzl oth )
COUNTER=0
OLDIFS=$IFS
IFS="," PASSPORTS=( $(awk -v RS= -v ORS=, '{print $0}' $1) )
IFS=$OLDIFS

function check_color() {
    for i in "${COLORS[@]}"; do
	if [[ $i == $1 ]]; then
	   return 0
	fi
    done
    return 1
}

function check_date() {
    if [[ -z $1 ]] || (( "$1" < "$2" || "$1" > "$3" )) ; then
	echo "BAD $4 :" ${1:-empty} "- should be between $2 and $3"
        return 1
    fi
    return 0
}

for passport in "${PASSPORTS[@]}"; do
    infos=( $(echo $passport) )
    unset info_array
    declare -A info_array
    for info in "${infos[@]}"; do
	key=$(echo $info | cut -d':' -f1)
        value=$(echo $info | cut -d':' -f2)
	info_array[$key]=$value
    done

    if ! check_date "${info_array[byr]}" 1920 2002 byr ; then
        continue
    fi

    if ! check_date "${info_array[iyr]}" 2010 2020 iyr ; then
        continue
    fi

    if ! check_date "${info_array[eyr]}" 2020 2030 eyr ; then
        continue
    fi

    if ! check_color ${info_array["ecl"]} ; then
	echo BAD ecl : ${info_array["ecl"]:-empty} "- should be one of these value ${COLORS[@]}"1>&2
	continue
    fi
    
    if ! echo ${info_array["hgt"]} | grep -xEq "[0-9]+(in|cm)" ; then
	echo BAD hgt : ${info_array["hgt"]:-empty} "- format should be {size}in or {size}cm"
	continue
    fi

    size=$(echo ${info_array["hgt"]} | grep -Eo "[0-9]+")
    if echo ${info_array["hgt"]} | grep -q "in"; then
	if (( size < 59 || size > 76 )); then
	    echo BAD hgt : ${info_array["hgt"]:-empty} "- should be between 59 and 76 in"
	    continue
	fi
    else
	if (( size < 150 || size > 193 )); then
	    echo BAD hgt : ${info_array["hgt"]:-empty} "- should be between 150 and 193 cm"
	    continue
	fi
    fi

    if ! echo ${info_array["hcl"]} | grep -xEq "#[0-9a-f]{6}" ; then
	echo BAD hcl : ${info_array["hcl"]:-empty} "- format should be #123abc"
        continue
    fi

    if ! echo ${info_array["pid"]} | grep -xEq "[0-9]{9}" ; then
	echo "BAD pid :" ${info_array["pid"]:-empty} "-" ${#info_array["pid"]} "digits"
        continue
    fi

    echo "GOOD    :" ${info_array[@]}

    (( COUNTER++ ))
done 1>&2

echo $COUNTER
