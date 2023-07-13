#!/bin/bash

scope_string=$2
output_file="${1}"
resolver_file="lists/resolvers.txt"
IFS='^' read -ra scope_list <<< "$scope_string"

for scope in "${scope_list[@]}"; do

    if [[ $scope == www.* ]]; then
        # Remove the "www." prefix and update the scope variable
        scope="${scope#www.}"
    fi

    echo "Running subfinder on $scope"
    subfinder -d "$scope" -silent >> "$output_file"

    echo "Running assetfinder on $scope"
    assetfinder --subs-only "$scope" >> "$output_file"

    #echo "Running Amass on $scope"
    #amass enum -silent -d "$scope" >> "$output_file"


done



#echo "Running massdns on all subdomains"
#massdns -r "$resolver_file" -t A -o S subdomains_massdns.txt

#awk '{print $3}' subdomains_massdns.txt > domains_ip.txt

echo "removing duplicate lines"
sort subdomains.txt | uniq > subdomains_unique_temp.txt
mv subdomains_unique_temp.txt "$output_file"
echo " subdomain_enurmeration done"




