#!/bin/bash

# Set default values
output_dir_path="$HOME/Desktop/output"
proxy_file=""
rull_policy_file_path=""



show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -Rp, --rull_policy_file, rull policy file location" 
    echo "  -h, --help Show this help message"
    echo "  -P, add a proxy file for all the scanners"
    echo "  -o, output_dir_path"
    # Add more options and descriptions as needed
}


# Parse command line arguments
while getopts "Rp:o:P:h" opt; do
    case "${opt}" in
        R) rull_policy_file_path="${OPTARG}" ;;
        o) output_dir_path="${OPTARG}" ;;
        P) proxy_file="${OPTARG}" ;;
        h) show_help; exit 0 ;;
        *) exit 1 ;;
    esac
done



python3 main.py $rull_policy_file_path $output_dir_path/gptoutput