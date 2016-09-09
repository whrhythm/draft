#! /bin/bash
count=1
startline=3
while :
do
	oldsize=`ls -l /opt/local/logs/transcode_16.3_2014-06-10-04-40-21/transcode_l6.3.log | cut -d " " -f 5`
	#sleep 120
	sleep 60
	newsize=`ls -l /opt/local/logs/transcode_16.3_2014-06-10-04-40-21/transcode_l6.3.log | cut -d " " -f 5`
	if [ "$oldsize" = "$newsize" ] ; then
		if [ $count -gt $startline ] ; then
			pkill -2 lucas
		fi
		echo "no change"
		pkill -2 mfx_transcoder
		let count=$count+1
	else
		echo "change"
		let count=1
	fi	
done
