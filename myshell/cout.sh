#! /bin/bash
new=test
pos=3
awk -F, '{OFS=",";$'$pos'="'$new'";print $0}' test.csv
