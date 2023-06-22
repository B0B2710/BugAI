#!/bin/bash


# Set the target URL
output_dir=$1
subdomains_file="${output_dir}/subdomains.txt"


# Run Liffy
echo "[*] Running Liffy..."
python3 /opt/liffy/liffy.py -u "$target_url" -o "output/file_inclusion/liffy.txt"

# Run Burp-LFI-Tests
echo "[*] Running Burp-LFI-Tests..."
python3 /opt/Burp-LFI-Tests/burp_lfi_tests.py "$target_url" -o "output/file_inclusion/burp_lfi_tests.txt"

# Run LFI-Enum
echo "[*] Running LFI-Enum..."
python3 /opt/LFI-Enum/lfi_enum.py -u "$target_url" -o "output/file_inclusion/lfi_enum.txt"

echo "[*] Done. Results saved in output/file_inclusion directory."

