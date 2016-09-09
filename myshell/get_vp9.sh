#! /bin/bash
while read line
do
	echo $line
	gpu=`grep 'GPU Utilization' $line/${line}_Report.csv | cut -d ',' -f 3`
	echo $gpu
	cpu=`grep "CPU Usage" $line/${line}_CPU_Usage.csv | cut -d "," -f 2`
	fps=`cat ${line}.txt | cut -d "(" -f 2 | cut -d ")" -f 1`	
	echo $line,$gpu,$cpu,$fps >> result.csv
done < $1
