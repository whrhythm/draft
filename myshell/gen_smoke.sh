#! /bin/bash
csv_path=$1

find $csv_path/ -name "*.csv" > csv.list
while read line
do
	csv_name=`basename $line`
	test_list=`cat $line | cut -d "," -f 1 | sed -e "1,4d" | tr -t '\n' ' '`
	echo "    ./lucas -s $line --temp-dir-cleanup --scenario-safe-mode --loglevel info -o --scenario-raw-CSV -r all --logfile \$LOGDIR/$csv_name-\`date +%H-%M-%S\`.log $test_list>> \$LOGFILE" >> smoke.sh
done < csv.list
