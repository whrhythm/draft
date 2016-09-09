#! /bin/bash
while read line
do 
	sed -i "s/VP8Version/Version/g" $line
	sed -i "s/NumPartitions/NumTokenPartitions/g" $line
	sed -i "s/NumFramesForIVF/NumFramesForIVFHeaded/g" $line
	sed -i "s/RefTypeLFDelta/LoopFilterRefTypeDelta/g" $line
	sed -i "s/MBTypeLFDelta/LoopFilterMbModeDelta/g" $line
	sed -i "s/CTQPDelta/CoeffTypeQPDelta/g" $line
done < $1
