#!/bin/bash


# Variables
output_dir=$1
subdomains_file="${output_dir}/subdomains.txt"
output_file="${output_dir}/xxe_injection"

# Create output directory if it does not exist
if [ ! -d "$output_dir" ]; then
    mkdir "$output_dir"
fi

# Run ground-control
echo "[*] Running ground-control..."
python3 ~/tools/ground-control/ground-control.py "$target_url" > "$output_dir/ground-control.txt"

# Run dtd-finder
echo "[*] Running dtd-finder..."
dtd-finder "$target_url" > "$output_dir/dtd-finder.txt"

echo "[*] XXE Injection scan completed!"

