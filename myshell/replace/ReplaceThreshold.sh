#! /bin/bash

function fGet_pos()
{
	csv_file=$1
	first_line=`head -n 1 $csv_file`
	for j in {1..1000}
	do
		unit_name=`echo $first_line | cut -d "," -f $j | cut -d " " -f 1`
		#echo $unit_name	
		if [ -z $unit_name ] ; then
			break
		fi	
		if [ $unit_name = "Status" ] ; then
			Status_pos=$j
			echo $Status_pos
		fi
		
		if [ $unit_name = "Errors" ] ; then
			Errors_pos=$j
			echo $Errors_pos
		fi	
		
		if [ $unit_name = "PSNRThreshold" ] ; then
			PSNRThreshold_pos=$j
			echo PSNRThreshold_pos
			echo $PSNRThreshold_pos
		fi			
		
		if [ $unit_name = "SSIMThreshold" ] ; then
			SSIMThreshold_pos=$j
			echo SSIMThreshold_pos
			echo $SSIMThreshold_pos
		fi	
		
		if [ $unit_name = "ExtremePSNR" ] ; then
			ExtremePSNR_pos=$j
			echo $ExtremePSNR_pos
		fi	

		if [ $unit_name = "ExtremeSSIM" ] ; then
			ExtremeSSIM_pos=$j
			echo $ExtremeSSIM_pos
		fi			
	done
}

function fReplace_threshold()
{
	resultFile=$1
	
	while read line
	do
		orignalBaseFile=`echo $line | cut -d "," -f 1`
		orignalFile=${orignalBaseFile}.csv
		testId=`echo $line | cut -d "," -f 2`
		needUpdate=`echo $line | cut -d "," -f 11 | sed -e "s/\n//g"`
		if test ${needUpdate}x = "no"x ; then
			echo "no need update"
		else
			echo $needUpdate
			echo ${orignalFile}
			fGet_pos ${orignalFile}
			temp_psnr=`echo $line | cut -d "," -f 3`
			temp_psnr=${temp_psnr:0:${#temp_psnr}-1}
			PSNR_threshold=${temp_psnr:0:5}
			temp_ssim=`echo $line | cut -d "," -f 4`
			temp_ssim=${temp_ssim:0:${#temp_ssim}-1}
			SSIM_threshold=${temp_ssim:0:4}			
			old_line=`grep $testId $orignalFile`
			new_line=`echo $old_line | awk -F, '{OFS=",";$'$PSNRThreshold_pos'="'${PSNR_threshold}'";$'$SSIMThreshold_pos'="'${SSIM_threshold}'";print $0}'`
			sed -i "s/$old_line/$new_line/g" $orignalFile
		fi
	done < ${resultFile}

}

function fAddVerify()
{
	csvFile=$1
	count=1
	while read line
	do
		if test ${count} -eq 1 ; then
			echo "first"
			newLine=${line},VerifPlanes
			sed -i "s/$line/$newLine/g" $csvFile
		elif test ${count} -gt 3 ; then
			newLine=${line},overall
			sed -i "s/$line/$newLine/g" $csvFile
		fi
		let count=$count+1
	done < $csvFile
}

#fAddVerify $1
#fReplace_threshold $1 
#fGet_pos $1
#csvList=$1
#logPath=$2
#while read line
#do 
#	baseCsv=`echo $line | sed -e "s/.csv//g"`
#	echo $baseCsv
#	logCsv=`find $logPath -name "${baseCsv}*.csv"`
#	rm result.csv
#	echo $logCsv
#	echo $line
#	./GenThreshold.sh $logCsv
#	fReplace_threshold $line result.csv
#done < $csvList

#fget_pos $1
#for ((i=0;i<${#hswFeautre[@]};i++))
#do
	#echo ${hswCsv[$i]}
	#fget_status ${hswCsv[$i]}
#done
csvPath=/opt/lucas_default_config/scenarios/transcode_local/HSW_4K
preName=""
while read line
do
	filename=`echo $line | cut -d "," -f 1`
	filename=${filename:0:${#filename}-24}
	filename=${filename}.csv
	bdwName=`echo $filename | sed -e "s/HSW/BDW/g"`
	testId=`echo $line | cut -d "," -f 2`
	if !(test ${filename}x = ${preName}x) ; then
		echo $filename 
		preName=$filename
		echo $bdwName
		cp $csvPath/$filename $bdwName
	fi
	fGet_pos $bdwName
	PSNR_threshold=`echo $line | cut -d "," -f 5`
	SSIM_threshold=`echo $line | cut -d "," -f 6`		
	old_line=`grep $testId $bdwName`
	new_line=`echo $old_line | awk -F, '{OFS=",";$'$PSNRThreshold_pos'="'${PSNR_threshold}'";$'$SSIMThreshold_pos'="'${SSIM_threshold}'";print $0}'`
	sed -i "s/$old_line/$new_line/g" $bdwName	
done < test.csv



