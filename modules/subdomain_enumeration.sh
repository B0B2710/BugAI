#!/bin/bash

scope_list=$2
output_file="${1}"

``
for scope in "${scope_list[@]}"
do
   
    echo "Running subfinder..."
    subfinder -d "$scope" -silent > "$output_file"
    echo "Running assetfinder..."
    assetfinder --subs-only "$scope" >> "$output_file"
    echo "Running Amass..."
    amass enum -silent -d "$scope" >> "$output_file"
    echo "Running massdns..."
    massdns -r /lists/resolvers.txt -t A -o S -w subdomains_massdns.txt "$output_file"
    awk '{print $1}' subdomains_massdns.txt | sort -u >> "$output_file"
    echo "$scope" >> "$output_file"
    rm subdomains_massdns.txt
done
echo " subdomain_enurmeration done"




