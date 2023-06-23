#!/bin/bash

output_dir=$1
subdomains_file="${output_dir}/subdomains.txt"

# Tools required
subover_path="/opt/SubOver/subover.py"
autosubtakeover_path="/opt/autosubtakeover/autosubtakeover.py"
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
    # Run FDsploit
    echo "[*] Running FDsploit on $domain..."


done < "$subdomains_file"




# Subdomain Takeover using SubOver
echo "[*] Running SubOver..."
python3 $subover_path -l subdomains_file -t 20 >> $output_file

# Subdomain Takeover using autosubtakeover
echo "[*] Running autosubtakeover..."
python3 $autosubtakeover_path -w $1 -o $output_file -t 20

# Subdomain Takeover using can-i-take-over-xyz
echo "[*] Running can-i-take-over-xyz..."
python3 $can_i_take_over_xyz_path -d $1 -o $output_file

echo "[+] Subdomain takeover scan completed. Results saved to $output_file"

