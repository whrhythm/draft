#! /bin/bash
new="/media/PARTITION4/SOFTWARECOMPONENT/926743328/:/media/PARTITION4/SOFTWARECOMPONENT/926743328/0a0c233dfe0f34a90410227f86e73a65_cached:/media/PARTITION4/SOFTWARECOMPONENT/926743328/lucas:/media/PARTITION4/APP/924384484/:/media/PARTITION4/SHAREDBINARY/201772492/:/media/PARTITION4/SHAREDBINARY/911640584/content:/media/PARTITION4/SHAREDBINARY/911640584/:/media/PARTITION4/SHAREDBINARY/924032600/:/usr/sbin:/usr/bin:/sbin:/bin:"

IFS=: DIRS=($new) 
echo ${#DIRS[@]} 
echo ${DIRS[3]} 

for ((i=0;i<${#DIRS[@]};i++))
do
	if [ ! -z `echo ${DIRS[i]} | grep lucas ` ]; then
		echo ${DIRS[i]}
	fi
done