#! /bin/bash

rm result*.csv

while read line
do
	#grep "${line},manual-main" $1 > $line.csv
	./BertaReportOneFirst.sh $line.csv
	./BertaReportOne48First.sh $line.csv
done < $2

