#!/bin/bash

# Define variables

output_dir=$1
wordpress_domains="${output_dir}/wordpress_domains.txt"



# Define functions
# Check if wordpress_domains.txt is empty
if [ -s "$wordpress_domains" ]; then
  echo "The file $wordpress_domains is not empty. Skipping WPScan."
else
  while IFS= read -r target; do
    echo "Running WPScan for $target..."
    wpscan --url "$target" -o "$output_dir/cms/wpscan.txt"
  done < "$wordpress_domains"
fi


echo "CMS scan completed or no wordpress."

