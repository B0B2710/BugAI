#!/bin/bash

# Output directory
output_dir=$1
output_file=${output_dir}/cors_misconfiguration.txt
subdomains_file="${output_dir}/subdomains.txt"




# Read each subdomain from the file and run the scans
while IFS= read -r subdomain; do
    # Corsy
    echo "[*] Running Corsy on $subdomain..."
    python3 /opt/Corsy/corsy.py -u "http://${subdomain}" -o "${outdir}/${subdomain}_corsy.txt" > /dev/null 2>&1

    # CORStest
    echo "[*] Running CORScanner on $subdomain..."
    python3 corscanner -t "$subdomain" -o "${outdir}/${subdomain}_corstest.txt" > /dev/null 2>&1
done < "$subdomains_file"