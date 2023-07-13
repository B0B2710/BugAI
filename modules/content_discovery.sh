#!/bin/bash

script_dir=$(dirname "$(readlink -f "$0")")
script_name=$(basename "$0")
full_path="$script_dir/$script_name"
output_dir=$1
args_string=$2
error_file=$3
scope_string=$4
IFS='^' read -ra args_list <<< "$args_string"
IFS='^' read -ra scope_list <<< "$scope_string"


#gobuster_args=${args_list[1]}
#feroxbuster_args=${args_list[1]}
dirsearch_args=${args_list[1]}
gospider_args=${args_list[2]}
hakrawler_args=${args_list[3]}





check_error() {
    exit_status=$1
    tool_name=$2
    output_file=$3
    tool_index_in_py=$4
    
    if [ $exit_status -ne 0 ]; then
        echo "Error: $tool_name encountered an error. Exit status: $exit_status"
        python3 bruh.py "$tool_name" "$tool_index_in_py" "$full_path" "$args_string" "$output_dir" "$error_file"
        exit
    fi
}

for domain in "${scope_list[@]}"
do
    #if [[ $domain == www.* ]]; then
        # Remove the "www." prefix and update the scope variable
    #    domain="${domain#www.}"
    #fi
    ##gobuster
    #echo "[*] Running gobuster on ${domain}"
    #gobuster dir -q -u $domain -w /usr/share/wordlists/dirb/common.txt -o $outdir/gobuster.txt -k
    #$gobuster_args 2> "error.txt"
    #check_error $? "gobuster" "$output_dir/gobuster.txt" "1"

    # Dirsearch
    echo "[*] Running Dirsearch on ${domain}"
    #dirsearch -u $domain -e php,asp,aspx,jsp,html,zip,jar,txt,log -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o $outdir/dirsearch.txt -t 50 -r -f
    $dirsearch_args 2> "error.txt"
    check_error $? "dirsearch" "$output_dir/dirsearch.txt" "1"
    # Gospider
    echo "[*] Running Gospider on ${domain}"
    #gospider -S $domain -w -c 10 -o $outdir/gospider.txt
    $gospider_args 2> "error.txt"
    check_error $? "gospider" "$output_dir/gospider.txt" "2"
    # Hakrawler
    #echo "[*] Running Hakrawler on ${domain}"
    #hakrawler -url $domain -depth 2 -plain -insecure -outfile $outdir/hakrawler.txt
    #$hakrawler_args 2> "error.txt"
    #check_error $? "hakrawler" "$output_dir/hakrawler.txt" "5"
done




echo "[+] Content discovery complete! Output saved to: $outdir"

