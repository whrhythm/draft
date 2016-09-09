#! /bin/bash

function fget_pos()
{
	csv_file=$1
	first_line=`head -n 1 $csv_file`
	for j in {1..1000}
	do
		unit_name=`echo $first_line | cut -d "," -f $j | cut -d " " -f 1`
		#echo $unit_name	
		if [ -z $unit_name ] ; then
			break
		fi	
		if [ $unit_name = "Status" ] ; then
			Status_pos=$j
			echo $Status_pos
		fi
		
		if [ $unit_name = "Errors" ] ; then
			Errors_pos=$j
			echo $Errors_pos
		fi	
	done
}

function fget_status()
{
	rm passed.txt
	rm failed.txt
	rm erred.txt
	resultFile=$1
	fget_pos ${resultFile}
	passNum=0
	failNum=0
	errNum=0
	while read line
	do
		status=`echo $line | cut -d "," -f $Status_pos`
		testId=`echo $line | cut -d "," -f 1`
		if [ "$status"x = "PASSED"x ]; then
			let passNum+=1
			echo $testId >> passed.txt
		elif [ "$status"x = "FAILED"x ]; then
			errors=`echo $line | cut -d "," -f $Errors_pos`
			let failNum+=1
			echo $testId >> failed.txt
		elif [ "$status"x = "ERRED"x ]; then
			errors=`echo $line | cut -d "," -f $Errors_pos`
			let errNum+=1
			echo $testId >> erred.txt
		else
			echo $status
		fi
	done < ${resultFile}
	echo "PASS:${passNum}"
	echo "FAIL:${failNum}"
	echo "Error:${errNum}"
}

fget_status $1
#fget_pos $1
#for ((i=0;i<${#hswFeautre[@]};i++))
#do
	#echo ${hswCsv[$i]}
	#fget_status ${hswCsv[$i]}
#done

