#!/bin/bash

# Set default values
output_dir="$HOME/Desktop/output"
threads=10
scan_mod="a"
scan_speed="m"
proxy_file=""




show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help Show this help message"
    echo "  -Pm, port scan mod : a,A = agresive s,S = silent d,D = defult"
    echo "  -Ps, port scan speed : m,M = meduim s,S = slow f,F = fast"
    echo "  -P, add a proxy file for all the scanners"
    echo "  -d, domain"
    echo "  -o, output_dir"
    # Add more options and descriptions as needed
}


# Parse command line arguments
while getopts "d:o:P:t:Pm:Ps:h" opt; do
    case "${opt}" in
        d) domain="${OPTARG}" ;;
        o) output_dir="${OPTARG}" ;;
        P) proxy_file="${OPTARG}" ;;
        t) threads="${OPTARG}" ;; 
        Pm) scan_mod="${OPTARG}" ;;
        Ps) scan_speed="${OPTARG}" ;;
        h) show_help; exit 0 ;;
        *) exit 1 ;;
    esac
done


# Create output directory if it doesn't exist
if [ ! -o "$output_dir" ]; then
  echo "Creating output directory: $output_dir"
  mkdir -p "$output_dir"
fi

# Check if domain is set
if [[ -z "${domain}" ]]; then
    echo "Usage: $0 [-d domain] [-o output_dir] [-P proxy file] [-t threads] [-h all commands] "
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "${output_dir}"

# Run modules
for module in subdomain_enumeration; do
    "./modules/${module}.sh" "${domain}" "${output_dir}/subdomains.txt" || exit 1
done
   
"./modules/port_scanning.sh" "${domain}" "${output_dir}/portscan.txt" "${scan_mod}" "${scan_speed}"|| exit 1


#for module in port_scanning screenshots technologies content_discovery links parameters fuzzing command_injection cors_misconfiguration crlf_injection csrf_injection directory_traversal file_inclusion graphql_injection header_injection http_splitting sql_injection open_redirect subdomain_takeover vulnerability_scanning; do
#    "./modules/${module}.sh" -i "${output_dir}/subdomains.txt" -o "${output_dir}/${module}" -t "${threads}" "${depth}" || exit 1
#done

# Generate final report
#"./modules/report_generator.sh" -i "${output_dir}" -o "${output_dir}/final_report.txt" || exit 1

echo "Pentesting completed successfully. Results can be found in ${output_dir}/final_report.txt."
