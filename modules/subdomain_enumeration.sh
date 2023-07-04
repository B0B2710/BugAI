#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

domain="${1}"
output_file="${2:-$domain/subdomains.txt}"

echo "Starting subdomain enumeration for $domain..."

# First-degree enumeration
echo "Running subfinder..."
subfinder -d "$domain" -silent > "$output_file"
echo "Running assetfinder..."
assetfinder --subs-only "$domain" >> "$output_file"
echo "Running Amass..."
amass enum -silent -d "$domain" >> "$output_file"
echo "Running massdns..."
massdns -r /opt/massdns/lists/resolvers.txt -t A -o S -w subdomains_massdns.txt "$output_file"
awk '{print $1}' subdomains_massdns.txt | sort -u >> "$output_file"
echo "$domain" >> "$output_file"
rm subdomains_massdns.txt
echo " subdomain_enurmeration done"



