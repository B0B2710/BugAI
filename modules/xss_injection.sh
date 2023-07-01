#!/bin/bash

# xss_injection.sh - a script for automated XSS injection testing

# Required tools: XSStrike, xssor2, dalfox, BruteXSS


output_dir=$1
subdomains_file="${output_dir}/subdomains.txt"
output_file="${output_dir}/xss_injection"
mkdir -p "$output_dir"





# Read each subdomain from the file
while IFS= read -r domain; do
    # XSStrike
    echo "[*] Running XSStrike on $domain ..."
    xsstrike -u "$domain" -t 10 -l 3 --fuzzer --timeout 5 --crawl --blind --skip-dom --headers -o "$output_file/XSStrike.txt"
    echo "[*] Running dalfox on $domain ..."
    cookie=$(curl -s -c - $domain)
    dalfox --url "$domain" --output "$output_file/dalfox" --cookie "$cookie" --blind --find-vuln




done < "$subdomains_file"







# dalfox

#dalfox url "$target_url" -o "$output_dir/dalfox-output.txt"


echo "[*] XSS injection testing completed."

