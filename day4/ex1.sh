#!/usr/bin/bash
MANDATORY=( "eyr" "hcl" "byr" "hgt" "iyr" "pid" )
OPTIONAL=( "cid" )

if [[ $# != 1 || ! -f $1 ]] ; then
    exit 1
fi

awk -v RS= -f ex1.awk $1
