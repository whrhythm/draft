#! /bin/bash
CURRENT_ST=`date +%Y-%m-%d-%H-%M-%S`
lucasPath=/opt/remote/bdw/tony_lucas/Lucas.01.05.033.0200-rel-ww26.5-SLES-SP3-vpg-staging-libva
cd $lucasPath

while read line
do
	echo $line
	csvName=`basename $line`
	#echo $csvName
	cat $line | sed -e "1,4d" | cut -d "," -f 1 > idlist.txt
	while read id
	do
		rm /etc/log/* -rf
		mkdir -p logs/mem_leak_${CURRENT_ST}/${csvName}/${id}
		./lucas -s $line $id
		mv /etc/log/* logs/mem_leak_${CURRENT_ST}/${csvName}/${id}/
		cd logs/mem_leak_${CURRENT_ST}/${csvName}/${id}/
		perl ${lucasPath}/../MemNinja/memninjalogparser.pl *.log
		cd $lucasPath 
	done < idlist.txt
done < $1
