#!/bin/bash

# Directory Traversal
echo "Directory Traversal"
echo "-------------------"


output_dir=$1
subdomains_file="${output_dir}/subdomains.txt"



# Read each subdomain from the file
while IFS= read -r domain; do
    


    # Run dotdotpwn
    echo "[*] Running dotdotpwn on $domain..."
    dotdotpwn -m http -h "$domain" -o "$output_dir/dotdotpwn.txt"
    # Run FDsploit
    echo "[*] Running FDsploit on $domain..."
    fdsploit -u "$domain" -o "$output_dir/fdsploit.txt"

done < "$subdomains_file"





# Run off-by-slash
#echo "Running off-by-slash..."
#off-by-slash -u "$url" -o "$output_dir/off-by-slash.txt"

# Print completion message
echo "Directory traversal scan completed."

