#! /bin/bash
rm bert.txt
while read line
do 
	configId=`echo $line | cut -d "," -f 1`
	name=`echo $line | cut -d "," -f 2`
	echo " {" >> bert.txt 
    echo "    \"name\": \"${name}\","  >> bert.txt 
    echo "    \"component\": \"media-vp(PreSi)\","  >> bert.txt 
    echo "    \"coverage\": \"Default\","  >> bert.txt 
    echo "    \"os\": \"Windows\","  >> bert.txt
    echo "    \"baseline\": \"Unified\","   >> bert.txt 
    echo "    \"vertical\": \"Media\","   >> bert.txt 
    echo "    \"scope\": \"Pre-Si\","   >> bert.txt 
    echo "    \"tests\": ["  >> bert.txt 
    echo "      {" >> bert.txt 
    echo "        \"instance\": \"https://10.80.155.1/RPC2\","   >> bert.txt 
    echo "        \"build_type\": \"Release-Internal\","   >> bert.txt 
    echo "        \"stream\": \"Media-VP-BXT-PreETM\","   >> bert.txt 
    echo "        \"testing_plan_configs\": ["  >> bert.txt 
    echo "          ${configId}"  >> bert.txt 
    echo "        ]"  >> bert.txt 
    echo "      }"  >> bert.txt 
    echo "    ],"   >> bert.txt 
    echo "    \"test_grids\": \"media-vp(PreSi)\""  >> bert.txt 
	echo "  }," >> bert.txt
done < bertaList.csv


