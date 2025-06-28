#!/bin/bash

declare -A unique_set

str=$(kubectl get ingress -A -o jsonpath='{range .items[?(@.spec.ingressClassName=="join-nginx")]}{.metadata.namespace}{"|"}{.metadata.name}{"\n"}{end}')

newstr=$(echo "$str" | tr '\n' ' ')

# 输出数组内容
for elem in ${newstr}; do
    ns=$(echo "$elem" | cut -d "|" -f 1)
    ing=$(echo "$elem" | cut -d "|" -f 2)
    secretName=$(kubectl -n $ns get ingress $ing -ojsonpath='{.spec.tls[0].secretName}')
    if [ $? -ne 0 ];then
        echo $ns,$ing
	exit
    fi
    unique_set["$ns,$secretName"]="$ns|$secretName"
done

# 打印数组的keys
for element in "${!unique_set[@]}"; do
    ns=$(echo $element | cut -d ',' -f 1)
    secretName=$(echo $element | cut -d ',' -f 2)
    #if [ "$ns" == "kuber" ];then
    #    echo kubectl -n $ns get secret $secretName
    kubectl -n $ns patch secrets $secretName --patch='{"data":{"tls.crt":"'"$(base64 -w0 Nginx/STAR_htsztech_com_integrated.crt)"'","tls.key":"'"$(base64 -w0 Nginx/STAR_htsztech_com.key)"'"}}'
    #fi
done

# 替换
