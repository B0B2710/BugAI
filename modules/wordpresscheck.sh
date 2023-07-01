
#!/bin/bash



output_dir=$1
subdomains_file="${output_dir}/subdomains.txt"
wordpress_domains="${output_dir}/wordpress_domains.txt"
# Create output directory if it doesn't exist
mkdir -p "$output_dir"

while IFS= read -r url; do
  response=$(curl -s "$url")
  if [[ $response =~ "wp-content" ]]; then
    echo "The page at $url is made with WordPress."
    echo "$url" >> "$wordpress_domains"
  else
    echo "The page at $url is not made with WordPress."
  fi
done < "$subdomains_file"