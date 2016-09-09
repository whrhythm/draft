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
		
		if [ $unit_name = "PSNRThreshold" ] ; then
			PSNRThreshold_pos=$j
			echo $PSNRThreshold_pos
		fi			
		
		if [ $unit_name = "SSIMThreshold" ] ; then
			SSIMThreshold_pos=$j
			echo $SSIMThreshold_pos
		fi	
		
		if [ $unit_name = "ExtremePSNR" ] ; then
			ExtremePSNR_pos=$j
			echo $ExtremePSNR_pos
		fi	

		if [ $unit_name = "ExtremeSSIM" ] ; then
			ExtremeSSIM_pos=$j
			echo $ExtremeSSIM_pos
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
			ExtremePSNR=`echo $line | cut -d "," -f $ExtremePSNR_pos`
			if [ ! -z $ExtremePSNR ]; then
				let failNum+=1
				echo $testId >> failed.txt
				ExtremeSSIM=`echo $line | cut -d "," -f $ExtremeSSIM_pos`
				PSNRThreshold=`echo $line | cut -d "," -f $PSNRThreshold_pos`
				SSIMThreshold=`echo $line | cut -d "," -f $SSIMThreshold_pos`
				csvfile=`basename ${resultFile}`
				echo ${csvfile},$testId,$ExtremePSNR,$ExtremeSSIM,$PSNRThreshold,$SSIMThreshold >> result.csv
			fi	
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

