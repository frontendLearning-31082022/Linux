#!/bin/bash
function normalRegex_PyScript() {
[ -e regex_matches_array.py ] && return
echo  "import re
import sys

regex= sys.argv[1] 
test_str= sys.argv[2] 

#print(regex)
#print(test_str)

matches = re.finditer(regex, test_str, re.MULTILINE)

for matchNum, match in enumerate(matches, start=1):
    print(match.group())" > regex_matches_array.py
}
normalRegex_PyScript

user=$(head -n 1 user)
db=$(head -n 1 dbName)

table=$(head -n 1 CreateTable)
[[ $table =~ (^[^\`]*.{1}(.*?)\`) ]] && table="${BASH_REMATCH[2]}"

create_table="use $db; $(cat CreateTable)"

columns_schema=$(cat CreateTable)
columns=$(python3 regex_matches_array.py '^\s*[^CREATE][A-z]+\s' "$columns_schema" )
count_columns="$(echo "$columns" | wc -l)"
autoincrement_colums=$(python3 regex_matches_array.py 'AUTO_INCREMENT' "$columns_schema" )
count_auto_increment=${#autoincrement_colums[*]}
input_data_columns_count=$(($count_columns-$count_auto_increment+1))

validated_input_data=true
line_num=0
while IFS= read -r line; do
    [[ line_num%input_data_columns_count!=0 ]] && continue
    echo $line || 
    [[ ${#line}>0 ]] && validated_input_data=false && \
    echo "incorrect input data structure" && exit 1
    line_num=$((line_num++))
done < data

mysql -e "CREATE DATABASE IF NOT EXISTS ${db}"
mysql -u$user -p -e "$create_table"

#TODO no autoincrement - NULL
list_inserts=""
value_to_insert="use $db; INSERT INTO $table VALUES(NULL,"
line_num=0
while IFS= read -r line; do
    line_num=$((line_num+1))
    if [ $(($line_num % $input_data_columns_count)) == 0 ] 
    then
    	value_to_insert=${value_to_insert::-2}
    	value_to_insert="$value_to_insert);"
    	
    	list_inserts="$list_inserts\n$value_to_insert"
    	echo -e "$value_to_insert"

	value_to_insert="use $db; INSERT INTO $table VALUES(NULL,"
    	continue;
    fi
    value_to_insert="$value_to_insert '$line', "
done < data

mysql -u$user -p -e "$list_inserts"