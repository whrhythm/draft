#! /bin/bash
#CURRENT_ST=`date +%Y-%m-%d-%H-%M-%S`
CURRENT_ST=2014-08-27-13-14-13
#lucasPath=/opt/remote/bdw/tony_lucas/Lucas.01.05.033.0200-rel-ww26.5-SLES-SP3-vpg-staging-libva
lucasPath=/opt/local/lucas
cd $lucasPath

echo "#!/bin/sh" > mem_leak.sh

while read line
do
	testNum=0
	echo $line
	csvName=`basename $line`
	rm mem_leak.sh
	rm -rf temp/*
	echo "rm logs/mem_leak_${CURRENT_ST}/${csvName}/${csvName}.csv" >> mem_leak.sh
	#echo $csvName
	cat $line | sed -e "1,4d" | cut -d "," -f 1 > idlist_temp.txt
	cat idlist_temp.txt | tr -s "\n" > idlist.txt
	rm idlist_temp.txt
	while read testId
	do
		echo $testId
		echo $testNum
		echo $testId | grep -q "#"
		if [ $? -eq 0 ]; then
			continue
		fi
		echo "rm /etc/log/* -rf" >> mem_leak.sh
		echo "mkdir -p logs/mem_leak_${CURRENT_ST}/${csvName}/${testId}" >> mem_leak.sh
		echo "./lucas -s $line --scenario-safe-mode $testId" >> mem_leak.sh
		echo "mv /etc/log/* logs/mem_leak_${CURRENT_ST}/${csvName}/${testId}/" >> mem_leak.sh
		echo "cd logs/mem_leak_${CURRENT_ST}/${csvName}/${testId}/" >> mem_leak.sh
		echo "perl ${lucasPath}/../MemNinja/mymemninjalogparser.pl *.log" >> mem_leak.sh
		echo cd $lucasPath >> mem_leak.sh 
		let testNum=testNum+1	
		
		#if [ $testNum -eq 2 ]; then
		#	break
		#fi		
	done < idlist.txt	
	
	cd $lucasPath	

	chmod +x mem_leak.sh
	#./mem_leak.sh	

	testNum=0
	while read testId
	do
		cd logs/mem_leak_${CURRENT_ST}/${csvName}/${testId}/
		index=0
		while read info
		do
			echo $info
			echo $index
			if [ $index -eq 0 ]; then
				tile=testId,$info
				echo $tile
				if [ $testNum -eq 0 ]; then
					echo $tile >>  ../${csvName}.csv
					echo write ../${csvName}.csv
				fi
			elif [ $index -eq 1 ]; then
				echo $testId,$info >> ../${csvName}.csv
			else
				echo ,$info >> ../${csvName}.csv
			fi	
			let index=index+1
		done < memleak.csv
		
		let testNum=testNum+1
		
		#if [ $testNum -eq 2 ]; then
		#	break
		#fi	
		
		cd $lucasPath
	done < idlist.txt	
	
done < $1


