#!/bin/bash

output_dir=$1
subdomains_file="${output_dir}/subdomains.txt"


can_i_take_over_xyz_path="/opt/can-i-take-over-xyz/can-i-take-over-xyz.py"

# Output file
output_file="$output_dir/subdomain_takeover_results.txt"

# Create output file or clear its contents
> $output_file



# Read each subdomain from the file
while IFS= read -r domain; do
    


    # Run subjack
    echo "[*] Running subjack on $domain..."
    subjack -a -d $domain -t 10 -ssl -v -o $output_file





done < "$subdomains_file"


# Run autosubtakeover. the tools accepts lists so no need for loop 
echo "[*] Running autosubtakeover..."
autosubtakeover --wordlist $subdomains_file -t 10 -o $output_file


#no idea
# Subdomain Takeover using can-i-take-over-xyz
echo "[*] Running can-i-take-over-xyz..."
python3 $can_i_take_over_xyz_path -d $1 -o $output_file

echo "[+] Subdomain takeover scan completed. Results saved to $output_file"

