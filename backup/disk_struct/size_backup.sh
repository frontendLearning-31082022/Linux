#!/bin/bash

curPath=$(echo $PWD)
disk="$(basename "$(dirname "$curPath")"):\\"

#du -cBM --max-depth=1
#du -hs /s/

#df -k /s
#df -BM /s
used_disk="$(df -BM /s | awk 'END {print $3}' | sed "s/[^0-9.]*//g")"
echo "used_disk $used_disk MB"

not_for_backup_usage=0
while IFS= read -r line; do
	linux_path=$(echo "/$line" | sed 's/\\/\//g' | sed 's/://'  ) 
	#| sed 's/ /\\ /g'
	#nowDate=$(date)
	#echo "Calculating size ... $linux_path $nowDate"
	cd "$linux_path"
	
	#lsSize="$(ls -l --block-size=M /s  | awk 'END {print $3}')"

	#echo " lsSize - $lsSize"
	#du -s -m "$linux_path"
	sizeFolder="$(du -s -m "$linux_path" | sed "s/[^0-9.]*//g")"
	echo "usage folder --$linux_path-- $sizeFolder MB"
	not_for_backup_usage=$(($not_for_backup_usage+$sizeFolder))
	
	continue
	
	
done < exclude_backup

echo "usage not_for_backup_usage $not_for_backup_usage"
backup_size=$(($used_disk-$not_for_backup_usage))
echo "usage backup $backup_size"

$SHELL
exit 0
	
	
	
	
	
	
	
	
	
	
	
	
	
	totalSize=0
	sizesString=$(ls -l -R --block-size=M | grep -E -o 'total [0-9]+' )
	echo "sizeString -- $sizeString"
	
	$SHELL
	
	sizesString=$(echo $sizesString |  sed 's/total//' | sed 's/\s\+/\n/g'  )
	echo "sizes String $sizesString "
	splitByWords=( $sizesString )
	#IFS='\w' read -r -a sizesArray <<< "$sizesString"
	for element in "${splitByWords[@]}"
	do
		[[ $element =~ ([0-9]*) ]] && totalSize=$(($totalSize+$element))
	done
	
	echo "$linux_path size - $totalSize"
	
	
	
	sizeFolder=$(du -hs "$linux_path")
	
	sizeFolder=$(du -hs "$linux_path")
	
	
	echo "$linux_path $sizeFolder MB"
	#cd "$linux_path"
	
`
	#du -s "$linux_path"
	#du -sh "$linux_path" | awk '{print $1}'
	
	
	#dir /s 'FolderName'
	#du -h --total "$linux_path"
	#break
	#du -hs "/S/Program Files/ANDROID_SDK_HOME"
	#du -csh --block-size=1G "$linux_path"
	# -- du -h --max-depth=0 "$linux_path"
	#du -hs "\"$linux_path\""
	#echo "path - $line *used "

    #[[ line_num%input_data_columns_count!=0 ]] && continue
   # [[ ${#line}>0 ]] && validated_input_data=false && \
   # echo "incorrect input data structure" && exit 1
  #  line_num=$((line_num++))
#echo  $disk

$SHELL