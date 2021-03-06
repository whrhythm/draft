#! /bin/bash
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

echo $ww,$tptWithin,$tptCount >> result24.csv