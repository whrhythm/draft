#! /bin/bash

#use result csv file to update the threshold of original csv file 
ori_csv_path=$1
result_csv_path=$2
extreme_psnr_pos=
psnr_thr_pos=
extreme_ssim_pos=
psnr_ssim_pos=

#rm -rf result/*

function fget_pos()
{
	csv_file=$1
	first_line=`head -n 1 $csv_file`
	for i in {1..100}
	do
		unit_name=`echo $first_line | cut -d "," -f $i | cut -d " " -f 1`
		echo $unit_name	
		if [ -z $unit_name ] ; then
			break
		fi	
		if [ $unit_name = "PSNRThreshold" ] ; then
			psnr_thr_pos=$i
		fi
		
		if [ $unit_name = "ExtremePSNR" ] ; then
			extreme_psnr_pos=$i
		fi

		if [ $unit_name = "SSIMThreshold" ] ; then
			ssim_thr_pos=$i
		fi
		
		if [ $unit_name = "ExtremeSSIM" ] ; then
			extreme_ssim_pos=$i
		fi		
	done
}

fget_pos $result_csv_path

startline=1

count=1
new_name=`basename $ori_csv_path`
#echo $new_name
#cp $ori_csv_path result/$new_name

while read line
do
	if [ $count -gt $startline ] ; then
		echo ${extreme_psnr_pos}
		temp_psnr=`echo $line | cut -d "," -f ${extreme_psnr_pos}`
		if [ -z $temp_psnr ] ; then
			continue
		fi	
		echo $temp_psnr
		temp_psnr=${temp_psnr:0:${#temp_psnr}-1}
		extreme_psnr=${temp_psnr:0:5}
		temp_ssim=`echo $line | cut -d "," -f $extreme_ssim_pos`
		echo $temp_ssim
		temp_ssim=${temp_ssim:0:${#temp_ssim}-1}
		extreme_ssim=${temp_ssim:0:4}
		test_id=`echo $line | cut -d "," -f 1`
		old_line=`grep $test_id $ori_csv_path`
		new_line=`echo $old_line | awk -F, '{OFS=",";$'$psnr_thr_pos'="'${extreme_psnr}'";$'$ssim_thr_pos'="'${extreme_ssim}'";print $0}'`
		sed -i "s/$old_line/$new_line/g" $ori_csv_path
		echo $test_id
		echo $extreme_psnr
		echo $extreme_ssim
	fi
	let count=$count+1
done < $result_csv_path






