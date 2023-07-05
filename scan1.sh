#!/bin/bash

# Set default values
output_dir_path="$HOME/Desktop/output"
proxy_file=""

args_string=$1
scope_string=$2
scope=($scope_string)
args_list=($args_string)

#port scaning
nmap_args=${args_list[1]}
#content_discovery
gobuster_args=${args_list[2]}
feroxbuster_args=${args_list[3]}
dirsearch_args=${args_list[4]}
gospider_args=${args_list[5]}
hakrawler_args=${args_list[6]}



"./modules/subdomain_enumeration.sh" "${output_dir}/subdomains.txt" "${scope}" || exit 1
"./modules/port_scanning.sh" "${output_dir}" "${nmap_args}"|| exit 1
"./modules/content_discovery" "${scope}" "${output_dir}" "${gobuster_args}" "${feroxbuster_args}" "${dirsearch_args}" "${gospider_args}" "${hakrawler_args}"|| exit 1
#"./modules/technologies.sh" "${output_dir}/subdomains.txt" "${output_dir}"  || exit 1
#"./modules/links.sh" "${domain}" "${output_dir}"  || exit 1