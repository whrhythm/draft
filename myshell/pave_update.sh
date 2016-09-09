#! /bin/bash

#find_path=/opt/remote/lucas_default_config/scenarios/transcode_local/HSW_16.3/
find_path=/opt/remote/lucas_default_config/scenarios/transcode_local/HSW_4K/
find $find_path -name "*.csv" > list.log

dist_path=/opt/remote/lucas_default_config/scenarios/pave/transcode
#while read line
#do
#	file_name=`basename $line`
#	cat $line | sed -e "s/\/opt\/local\/content\/transcode/content/g" > $dist_path/$file_name
#	cat $line | sed -e "s/\/opt\/local\/content\/vc1.et/g" > $dist_path/$file_name
#done < list.log

cp $find_path/* $dist_path/
sed -i "s/\/opt\/local\/content\/transcode/content/g" `grep "\/opt\/local\/content\/transcode" -rl $dist_path`
sed -i "s/\/opt\/local\/content\/vc1.et/content/g" `grep "\/opt\/local\/content\/vc1.et" -rl $dist_path`

rm list.log