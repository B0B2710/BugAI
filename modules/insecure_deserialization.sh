#!/bin/bash

# Set output directory and file name prefix
output_dir=$1
subdomains_file="${output_dir}/subdomains.txt"
OUTPUT_FILE_PREFIX="insecure_deserialization"

# Create output directory if it doesn't exist
if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
fi

# Run GadgetProbe to identify vulnerable libraries
echo "Running GadgetProbe..."
java -jar GadgetProbe.jar --target ./target/ --output "$output_dir/$OUTPUT_FILE_PREFIX-GadgetProbe.txt"


while read -r domain; do
  # Run GadgetProbe on the domain
  echo "[*] Running GadgetProbe on $domain..."
  java -jar /opt/GadgetProbe/GadgetProbe.jar --target "$domain" --output "$output_dir/$OUTPUT_FILE_PREFIX-GadgetProbe.txt"
done < "$subdomains_file"







#ysoserial.net or ysoserial

# Run ysoserial.net to generate payloads for identified libraries
#echo "Running ysoserial.net..."
#while read -r line; do
#  lib=$(echo "$line" | awk '{print $1}')
#  gadget=$(echo "$line" | awk '{print $2}')
#  java -jar ysoserial.net-master.jar "$gadget" 'echo '"$lib"' >> '"$output_dir/$OUTPUT_FILE_PREFIX-ysoserial.txt"'
#done < "$output_dir/$OUTPUT_FILE_PREFIX-GadgetProbe.txt"

#echo "Finished. Results saved in $output_dir/$OUTPUT_FILE_PREFIX-GadgetProbe.txt and $output_dir/$OUTPUT_FILE_PREFIX-ysoserial.txt"
echo "done insecure_deserialization"
