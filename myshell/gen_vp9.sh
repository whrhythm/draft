#! /bin/bash
while read line
do
	echo "mv_decoder_adv.exe --vp9 -i ${line}.webm 2>${line}.txt" > ${line}.bat
done < $1
