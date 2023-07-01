#!/bin/bash

# Function to check if a program is installed
function check_program_installed {
    command -v "$1" >/dev/null 2>&1
}
subdomains_file="${output_dir}/subdomains.txt"


# Run vulnerability scanning on each subdomain
while read -r subdomain; do
    echo "Running S3Scanner scanning on $subdomain..."
    S3Scanner -s $subdomain > s3scanner_results.txt
    echo "Running AWSBucketDump scanning on $subdomain..."
    python3  /opt/AWSBucketDump/AWSBucketDump.py -b $subdomain > awsbucketdump_results.txt
    
done < "$subdomains_file"














echo "done buckets scanning"