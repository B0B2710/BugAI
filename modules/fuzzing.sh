#!/bin/bash

# Fuzzing script using wfuzz, ffuf, and fuzzdb

# Function to check if the tool is installed
check_installed() {
  if ! command -v $1 &> /dev/null
  then
      echo "$1 could not be found. Please install it and try again."
      exit
  fi
}
output_dir=$1
output_file=${output_dir}/fuzzing.txt


# Check if tools are installed
#check_installed wfuzz
#check_installed ffuf


subdomains_file="${output_dir}/subdomains.txt"


# Read each subdomain from the file
while IFS= read -r domain; do
    # Run wfuzz and append output to the main file
    echo "[*] Running wfuzz on $domain..."
    wfuzz -w /usr/share/seclists/Discovery/Web_Content/common.txt -u "http://$domain/FUZZ" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0" --hc 404 -t 50 >> "$output_file"

    # Run ffuf and append output to the main file
    echo "[*] Running ffuf on $domain..."
    ffuf -w /usr/share/seclists/Discovery/Web_Content/common.txt -u "http://$domain/FUZZ" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0" -fc 404 -c -t 50 >> "$output_file"

    # Run fuzzdb and append output to the main file
    echo "[*] Running fuzzdb on $domain..."
    fuzzdb_dir=/opt/fuzzdb/
    ffuf -w "$fuzzdb_dir/attack-payloads/Injections/SQL.txt" -u "http://$domain/FUZZ" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0" -fc 404 -c -t 50 >> "$output_file"

done < "$subdomains_file"