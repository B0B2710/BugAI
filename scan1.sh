#!/bin/bash

# Set default values
output_dir_path="$HOME/Desktop/output"
proxy_file=""

args_string=$1
scope_string=$2
scope=($scope_string)
my_array=($args_string)

# Access and print elements of the array
nmap_args=${my_array[0]}


"./modules/subdomain_enumeration.sh" "${output_dir}/subdomains.txt" "${scope}" || exit 1
"./modules/port_scanning.sh" "${output_dir}" "${nmap_args}"|| exit 1
"./modules/content_discovery" "${domain}" "${output_dir}" "${scan_mod}" "${scan_speed}" || exit 1
"./modules/technologies.sh" "${output_dir}/subdomains.txt" "${output_dir}"  || exit 1
"./modules/links.sh" "${domain}" "${output_dir}"  || exit 1