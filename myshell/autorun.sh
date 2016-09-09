#! /bin/bash
csvList=`cat csv.list`

if [ "$csvList" = "" ] ; then
	exit
fi


export DISPLAY=:0.0

lucasPath=/opt/remote/bdw/tony_lucas/Lucas.01.05.025.0133-rel-ww16.3-SLES-SP3-vpg-staging-libva

cd $lucasPath
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
	rm temp/* -rf
	./lucas -s $csvPath/$csvName -l debug --logfile logs/test.log --scenario-safe-mode -o -r all $startCase - $endCase &
	statusFile=`find temp/ -name "*.status"`
	while [ "$statusFile" != "" ]
	do
		oldsize=`ls -l /opt/local/logs/test.log | cut -d " " -f 5`
		#sleep 120
		sleep 60
		newsize=`ls -l /opt/local/logs/test.log | cut -d " " -f 5`
		if [ "$oldsize" = "$newsize" ] ; then
			echo "no change, reboot"
			echo -e "intel" | sudo -S /sbin/reboot
		else
			echo "change"
		fi
		
		statusFile=`find temp/ -name "*.status"`
	done
	
	resultCsv=`find temp/ -name "*.csv"`
	mv $resultCsv logs/transcode/
	sed -e "1d" csv.list
else
	echo "new csv"
	while read line
	do
		echo $line
		rm temp/* -rf
		./lucas -s $line -l debug --logfile logs/test.log --scenario-safe-mode -o -r all &
		sleep 5
		statusFile=`find temp/ -name "*.status"`
		while [ "$statusFile" != "" ]
		do
			oldsize=`ls -l /opt/local/logs/test.log | cut -d " " -f 5`
			#sleep 120
			sleep 60
			newsize=`ls -l /opt/local/logs/test.log | cut -d " " -f 5`
			if [ "$oldsize" = "$newsize" ] ; then
				echo "no change, reboot"
				echo -e "intel" | sudo -S /sbin/reboot
			else
				echo "change"
			fi
			
			statusFile=`find temp/ -name "*.status"`
		done
		
		resultCsv=`find temp/ -name "*.csv"`
		mv $resultCsv logs/transcode/
		
	done < csv.list
fi

