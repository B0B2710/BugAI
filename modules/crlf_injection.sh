#!/bin/bash

# set default values
output_dir=$1
input_file="${output_dir}/subdomains.txt"
threads=$2




# loop through each subdomain in the input file and run CRLF injection
while read subdomain; do
    # run crlfuzz
    crlfuzz -u ${subdomain} -t ${threads} -o ${output_dir}/crlf_injection/${subdomain}.txt
    
    # run CRLFsuite
    crlfsuite -u ${subdomain} -o ${output_dir}/crlf_injection/${subdomain}_crlfsuite.txt
    
done < ${input_file}

echo "CRLF injection completed successfully. Results can be found in ${output_dir}/crlf_injection directory."

