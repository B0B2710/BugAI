#!/bin/bash

# Set default values
output_dir="$HOME/Desktop/output"
if [ ! -d "$output_dir" ]; then
    # Create the directory if it doesn't exist
    mkdir -p "$output_dir"
fi
proxy_file=""

IFS='^'

args_string=$1
scope_string=$2
scope=($scope_string)
echo "$scope"
#args_list=($args_string)
read -ra args_list <<< "$args_string"
#port scaning
nmap_args=${args_list[0]}
#content_discovery
gobuster_args=${args_list[1]}
feroxbuster_args=${args_list[2]}
dirsearch_args=${args_list[3]}
gospider_args=${args_list[4]}
hakrawler_args=${args_list[5]}

echo "$nmap_args"
echo "$gobuster_args"
echo "$feroxbuster_args"
echo "$dirsearch_args"
echo "$gospider_args"
echo "$hakrawler_args"



./modules/subdomain_enumeration.sh "${output_dir}/subdomains.txt" "${scope}" || exit 1
./modules/port_scanning.sh "${output_dir}" "${nmap_args}"|| exit 1
./modules/content_discovery.sh "${scope}" "${output_dir}" "${gobuster_args}" "${feroxbuster_args}" "${dirsearch_args}" "${gospider_args}" "${hakrawler_args}"|| exit 1
#"./modules/technologies.sh" "${output_dir}/subdomains.txt" "${output_dir}"  || exit 1
#"./modules/links.sh" "${domain}" "${output_dir}"  || exit 1