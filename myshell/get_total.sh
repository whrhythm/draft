#! /bin/bash
while read line
do
	num=`cat $line | sed -e "1d" | cut -d "," -f 1 | uniq | wc -l`
	echo $line,$num >> result_total.csv
done < $1



