#!/bin/bash

scope_string=$2
output_file="${1}"
resolver_file="lists/resolvers.txt"
echo $scope_string
IFS='^' read -ra scope_list <<< "$scope_string"

for scope in "${scope_list[@]}"; do

    if [[ $scope == www.* ]]; then
        # Remove the "www." prefix and update the scope variable
        scope="${scope#www.}"
    fi
    if [[ $string == *"*"* ]]; then
        echo "Running subfinder on $scope"
        subfinder -d "$scope" -silent >> "$output_file"
        
    else
        echo "The string contains an asterisk (*) so BUG"
    fi
done


echo "removing duplicate lines"
sort "$output_file" | uniq > subdomains_unique_temp.txt
mv subdomains_unique_temp.txt "$output_file"
echo " subdomain_enurmeration done"




