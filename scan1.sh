#!/bin/bash

# Set default values
output_dir_path="$HOME/Desktop/output"
proxy_file=""

args_string=$1
my_array=($args_string)

# Access and print elements of the array
nmap_par=${my_array[0]}
masscan_par=${my_array[1]}

"./modules/subdomain_enumeration.sh"  "${output_dir}/subdomains.txt" || exit 1
"./modules/port_scanning.sh" "${output_dir}/subdomains.txt" "${output_dir}/portscan.txt" "${scan_mod}" "${scan_speed}"|| exit 1
"./modules/content_discovery" "${domain}" "${output_dir}" "${scan_mod}" "${scan_speed}" || exit 1
"./modules/technologies.sh" "${output_dir}/subdomains.txt" "${output_dir}"  || exit 1
"./modules/links.sh" "${domain}" "${output_dir}"  || exit 1