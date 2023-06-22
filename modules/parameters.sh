#!/bin/bash

if [ -z "$1" ]
then
    echo "Usage: ./parameters.sh <domain>"
    exit 1
fi

domain=$1
output_dir=$2
subdomains_file="${output_dir}/subdomains.txt"
outdir="$output_dir/parameters"
output_file="$outdir/parameters.txt"


# Create output directory
mkdir -p $outdir

# ParamSpider 
echo "[*] Running ParamSpider..."



# Run Arjun on each subdomain
while read domain; do
    echo "Running Arjun on $domain"
    arjun -u "https://$domain" >> "$output_file"
done < "$subdomains_file"




# Iterate over each domain from the file
while IFS= read -r domain || [[ -n "$domain" ]]; do
    domain=$(echo "$domain" | tr -d '\r')  # Remove carriage return character if present
    echo "Scanning domain: $domain"

    # Run ParamSpider
    python3 /opt/ParamSpider/paramspider.py -d "$domain" -o "$output_dir/$domain" --quiet

    # Run GF on ParamSpider output
    gf urls "$output_dir/$domain/paramspider_output.txt" | tee "$output_dir/$domain/gf_output.txt"
done < "$domains_file"





# x8
#echo "[*] Running x8..."
#x8 -target https://$domain -all > $outdir/x8.txt

echo "[+] Parameter discovery complete! Output saved to: $outdir"

