#! /bin/bash
#fail path like /opt/local/logs/transcode_stand_17-31-15
#lucas type:u mean ubuntu, s mean sles
fail_path=$1
lucas_type=$2

if [ $lucas_type = "u" ] ; then
	lucas_path=/opt/remote/Lucas.01.05.020.0098-rel-ww06.4-Ubuntu
elif [ $lucas_type = "s" ] ; then
	lucas_path=/opt/remote/Lucas.01.05.020.0098-rel-ww06.4-SLES_SP3
fi
#echo "#! /bin/bash" > runme.sh
ori_path=`pwd`

cd $lucas_path
grep -r FAIL $fail_path/*.csv | cut -d "," -f 1 | uniq > fail.list

run_type=`basename $fail_path`
run_type=`echo $run_type | cut -d "_" -f 1`_local
echo $run_type

log_path=/opt/local/rerun
mkdir -p $log_path
while read line
do 
	csv_file=`echo $line | cut -d ":" -f 1`
	csv_file=`basename $csv_file`
	csv_file=${csv_file:0:${#csv_file}-24}.csv
	csv_file=`find scenarios/$run_type -name $csv_file`
	test_id=`echo $line | cut -d ":" -f 2`
	echo $csv_file
	echo $test_id
	./lucas -s $csv_file -l debug --logfile ${log_path}/${test_id}.log --scenario-safe-mode  -o -r all $test_id
done < fail.list

find temp/ -name "*.csv" > csv.list
while read line
do
	mv $line ${log_path}
done < csv.list

rm csv.list
#rm -rf temp/*

rm fail.list
cd $ori_path
