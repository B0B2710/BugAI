#!/bin/bash

output_dir=$1
output_file=${output_dir}/command_injection.txt


# Commix
echo "[*] Running Commix..."
commix --url "$domain" --batch --output-dir "$outdir/commix" > "$output_file" 2>&1


echo "[*] Command Injection scan completed."

