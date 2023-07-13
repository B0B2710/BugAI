#!/bin/bash

# Set default values
output_dir="$HOME/Desktop/output"
if [ ! -d "$output_dir" ]; then
    # Create the directory if it doesn't exist
    mkdir -p "$output_dir"
fi
proxy_file=""

# Get the directory path of the script
script_dir=$(dirname "$(readlink -f "$0")")

# File path of temp.txt
error_file="$script_dir/error.txt"
> "$error_file"
args_string=$1
scope_string=$2
#scope=($scope_string)
#IFS='^'
#read -ra scope <<< "$scope_string"
#args_list=($args_string)
IFS='^' read -ra args_list <<< "$args_string"

#port scaning
nmap_args=${args_list[0]}
#content_discovery
#gobuster_args=${args_list[1]}
dirsearch_args=${args_list[1]}
gospider_args=${args_list[2]}


echo "$nmap_args"
#echo "$gobuster_args"
echo "$feroxbuster_args"
echo "$dirsearch_args"
echo "$gospider_args"
#echo "$hakrawler_args"



#./modules/subdomain_enumeration.sh "${output_dir}/subdomains.txt" "${scope_string}" || exit 1
#./modules/port_scanning.sh "${output_dir}" "${args_string}"  "${error_file}"|| exit 1
./modules/content_discovery.sh "${output_dir}" "${args_string}"  "${error_file}" "${scope_string}"|| exit 1
#"./modules/technologies.sh" "${output_dir}/subdomains.txt" "${output_dir}"  || exit 1
#"./modules/links.sh" "${domain}" "${output_dir}"  || exit 1

echo "all done"