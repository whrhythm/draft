#! /bin/bash

export DISPLAY=:0.0

lucasPath=/opt/remote/bdw/tony_lucas/Lucas.01.05.025.0133-rel-ww16.3-CentOS-vpg-staging-libva

./detect_block_reboot.sh& 

cd $lucasPath

csvList=`cat csv.list`
if [ "$csvList" = "" ] ; then
	exit
fi

statusFile=`find temp/ -name "*.status"`

echo $statusFile 
if [ "$statusFile" != "" ] ; then
	echo "system reboot, continue run"
	lastCase=`cat $statusFile`	
	csvName=`basename $statusFile`
	csvName=${csvName:0:${#csvName}-27}.csv
	csvPath=`echo $statusFile | cut -d "/" -f 2-4`
	lastNum=`grep -n $lastCase $csvPath/$csvName | cut -d ":" -f 1`
	let startNum=$lastNum+1
	startCase=`sed -n "${startNum}p" $csvPath/$csvName | cut -d "," -f 1`
	endCase=`tail -n 1 $csvPath/$csvName | cut -d "," -f 1`
	echo $lastCase
	echo $csvName	
	echo $csvPath
	echo $lastNum
	echo $startNum
	echo $startCase
	echo $endCase
	
	resultCsv=`find temp/ -name "*.csv"`
	mv $resultCsv logs/transcode/
	rm temp/* -rf
	./lucas -s $csvPath/$csvName -l debug --logfile logs/LucasTest.log --scenario-safe-mode -o -r all $startCase - $endCase | tee logs/test.log
	
	resultCsv=`find temp/ -name "*.csv"`
	mv $resultCsv logs/transcode/
	sed -i "1d" csv.list
	
	echo "new csv"
	while read line
	do
		echo $line
		rm temp/* -rf
		./lucas -s $line -l debug --logfile logs/LucasTest.log --scenario-safe-mode -o -r all | tee logs/test.log
		resultCsv=`find temp/ -name "*.csv"`
		mv $resultCsv logs/transcode/
		
	done < csv.list
	
else
	echo "new csv"
	while read line
	do
		echo $line
		rm temp/* -rf
		./lucas -s $line -l debug --logfile logs/LucasTest.log --scenario-safe-mode -o -r all | tee logs/test.log
		resultCsv=`find temp/ -name "*.csv"`
		mv $resultCsv logs/transcode/
		
	done < csv.list
fi

