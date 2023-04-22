#!/bin/bash
(( $# < 1 )) && echo "One arg - path to folder need!" && exit -1
dir=$1
[ ! -d ${dir} ] && echo "Directory ${dir} not exists." && exit 0

clearIT=(".bak" ".tmp" ".backup")

for fn in "${clearIT[@]}"; do find ${dir} -name "*$fn" -type f -delete; done