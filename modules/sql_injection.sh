#!/bin/bash



subdomains_file="${output_dir}/subdomains.txt"
# SQL Injection Scanning Script

# Required tools: sqlmap, NoSQLMap, SQLiScanner

# Usage: ./sql_injection.sh <target_url>

# Get the target URL from command line argument
output_dir="$1"

# Create a directory for storing the scan results
output_path="$output_dir/sql_injection"
mkdir -p "$output_path"


# Read each subdomain from the file
while IFS= read -r domain; do
   
    echo "[*] Running sqlmap for basic SQL injection detection on $domain..."
    sqlmap -u "$domain" --batch --level 1 --risk 1 -o -f -a | tee "$output_path/sqlmap-basic.txt"

    # Run sqlmap for more advanced SQL injection detection
    echo "[*] Running sqlmap for advanced SQL injection detection  on $domain..."
    sqlmap -u "$domain" --batch --level 5 --risk 3 -o -f -a | tee "$output_path/sqlmap-advanced.txt"

    # Run NoSQLMap for NoSQL injection detection
    echo "[*] Running NoSQLMap for NoSQL injection detection on $domain..."
    nosqlmap -u "$domain" --batch | tee "$output_path/nosqlmap.txt"

    echo "[*] Running SQLiScanner for SQL injection detection on $domain..."
    sqliscanner -u "$domain" -o "$output_path/sqliscanner.txt"
done < "$subdomains_file"
echo "[*] SQL injection scanning completed!"



