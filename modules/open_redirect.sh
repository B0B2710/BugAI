#!/bin/bash


output_dir="$1/open_redirect"
subdomains_file="${output_dir}/subdomains.txt"
output_file="$output_dir/open_redirect_vulnerabilities.txt"
mkdir -p "$output_dir"

# Run Oralyzer
echo "[*] Running Oralyzer..."
oralyzer -l "$subdomains_file" -o "$output_dir/oralyzer.txt" >/dev/null

# Run Injectus
echo "[*] Running Injectus..."
injectus -f "$subdomains_file" -o "$output_dir/injectus.txt" >/dev/null

# Consolidate results
echo "[*] Consolidating results..."
cat "$output_dir/oralyzer.txt" "$output_dir/injectus.txt" | sort -u > "$output_dir/results.txt"

echo "[*] Checking for open redirects..."
grep -E "(http(s)?://)|(/)|(\.\.)" "$output_dir/results.txt" | while read url
do
    # Check if the URL is vulnerable to open redirect
    if curl -Is "$url" | grep -q "Location: $url"
    then
        echo "[+] Open redirect vulnerability found: $url"
        echo "$url" >> "$output_file"
    fi
done

echo "[*] Open redirect scan completed!"