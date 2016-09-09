#! /bin/bash
while read line
do
	num=`grep FAIL $line | cut -d "," -f 1 | uniq | wc -l`
	list=`grep FAIL $line | cut -d "," -f 1 | uniq | cut -d "." -f 1 | tr -t "\n" ";"`
	echo $line,$num,$list"qaulity drop" >> result.csv
done < $1



