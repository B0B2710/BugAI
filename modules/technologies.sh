#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Usage: ./technologies.sh <subdomains_file> <output_dir>"
    exit 1
fi

subdomains_file=$1
output_dir=$2

# Create output directory
mkdir -p "$output_dir"

# Iterate over subdomains and run scans
echo "[*] Scanning subdomains..."
while read -r subdomain; do
    echo "[*] Scanning $subdomain..."
    docker run --rm -v "$(pwd)":/mnt/app wappalyzer/cli -g "https://$subdomain" > "$output_dir/wappalyzer_$subdomain.json"
    webanalyze -host "$subdomain" -crawl 1 -output "$output_dir/webanalyze_$subdomain.json"
done < "$subdomains_file"

# Consolidate results into a single text file
#echo "[*] Consolidating results..."
#cat "$output_dir/wappalyzer.json" > "$output_dir/technologies.txt"
#cat "$output_dir/webanalyze.json" >> "$output_dir/technologies.txt"
#for file in "$output_dir/wappalyzer_"*.json; do
#    cat "$file" >> "$output_dir/technologies.txt"
#    rm "$file"  # Remove individual JSON file
#done
#for file in "$output_dir/webanalyze_"*.json; do
#    cat "$file" >> "$output_dir/technologies.txt"
#    rm "$file"  # Remove individual JSON file
#done

#echo "[+] Technology detection complete! Consolidated results saved to: $output_dir/technologies.txt"