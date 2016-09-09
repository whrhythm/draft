#! /bin/bash
maxWW=6
indexWW=1

function fReport()
{
	tptCount=0
	tptWithin=0
	while read line
	do
		ww=`echo $line | cut -d "," -f 1`
		duration=`echo $line | cut -d "," -f 10`
		if [ $ww != "WW" ] ; then
			echo $ww		
			duration=`echo $duration | cut -d ":" -f 1`
			echo $duration
			if [ $duration -lt 24 ] ; then
				let tptWithin=tptWithin+1
			fi
			let tptCount=tptCount+1
		fi
	done < $1

	echo $ww,$tptWithin,$tptCount >> result.csv
}

while true
do
	rm result.csv
	reportName=PreETMReport_${indexWW}.csv
	head -n 1 PreETMReport.csv >> $reportName
	while read line
	do
		ww=`echo $line | cut -d "," -f 1`
		if [ ${indexWW} -eq $ww ]; then
			echo $line >> $reportName
		fi
	done < PreETMReport.csv 
	
	fReport $reportName
	
	if [ ${indexWW} -eq $maxWW ]; then
		break
	fi
	
	let indexWW=indexWW+1
done

