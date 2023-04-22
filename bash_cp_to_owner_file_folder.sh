#!/bin/bash
(( $# < 1 )) && echo "One arg - path to folder need!" && exit -1
dir=$1
[ ! -d ${dir} ] && echo "Directory ${dir} not exists." && exit 0

owners_at_dir=($(stat -c %U * | uniq))
owners_at_dir=($(echo "${owners_at_dir[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

for entry in "$dir"/*
do
 owner_name="$(stat --format '%U' "$entry")" &&
 fname=$(basename -- "$entry") &&
 new_path="$dir/$owner_name/$fname" &&
 mkdir -p "$dir/$owner_name/" &&
 chown $owner_name "$dir/$owner_name/";
 #block copy already folders
 [[ ! " ${owners_at_dir[*]} " =~ " ${fname} " ]] && 
 cp -rf "$entry" $new_path && 
 chown -R $owner_name "$dir/$owner_name/"  #R for folders

done