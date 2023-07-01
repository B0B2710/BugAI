#!/bin/bash

# Set default values
output_dir="$HOME/Desktop/output"
threads=10
scan_mod="a"
scan_speed="m"
proxy_file=""
rate_limit=



show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help Show this help message"
    echo "  -Pm, scan mod : a,A = agresive s,S = silent d,D = defult"
    echo "  -Ps, scan speed : m,M = meduim s,S = slow f,F = fast"
    echo "  -P, add a proxy file for all the scanners"
    echo "  -Rl, rate limit, how mant request pre seccond"
    echo "  -t, threads deafult 10"
    echo "  -d, domain"
    echo "  -o, output_dir"
    # Add more options and descriptions as needed
}


# Parse command line arguments
while getopts "d:o:P:Rl:t:Pm:Ps:h" opt; do
    case "${opt}" in
        d) domain="${OPTARG}" ;;
        o) output_dir="${OPTARG}" ;;
        P) proxy_file="${OPTARG}" ;;
        Rl) rate_limit="${OPTARG}" ;;
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
#Recon:
"./modules/subdomain_enumeration.sh" "${domain}" "${output_dir}/subdomains.txt" || exit 1
"./modules/port_scanning.sh" "${output_dir}/subdomains.txt" "${output_dir}/portscan.txt" "${scan_mod}" "${scan_speed}"|| exit 1
"./modules/content_discovery" "${domain}" "${output_dir}" "${scan_mod}" "${scan_speed}" || exit 1
"./modules/technologies.sh" "${output_dir}/subdomains.txt" "${output_dir}"  || exit 1
"./modules/links.sh" "${domain}" "${output_dir}"  || exit 1
#"./modules/wordpresscheck.sh" "${output_dir}" || exit 1 
#"./modules/cms.sh" "${output_dir}" || exit 1 
#all the information above will go the the first gpt request
#Vulnerability testing :
#"./modules/parameters.sh" "${domain}" "${output_dir}"  || exit 1
#"./modules/fuzzing.sh" "${output_dir}"  || exit 1
#"./modules/command_injection.sh" "${output_dir}"  || exit 1
#"./modules/cors_misconfiguration.sh" "${output_dir}"  || exit 1
#"./modules/crlf_injection.sh" "${output_dir}" "${threads}" || exit 1
#"./modules/csrf_injection.sh" "${output_dir}" "${threads}" || exit 1
#"./modules/directory_traversal.sh" "${output_dir}" || exit 1
#"./modules/file_inclusion.sh" "${output_dir}" || exit 1
#"./modules/graphql_injection.sh" "${output_dir}" || exit 1
#"./modules/header_injection.sh" "${output_dir}" || exit 1
#"./modules/insecure_deserialization.sh" "${output_dir}" || exit 1 #need to find a solution for ysoserial.net
#"./modules/insecure_direct_object_references.sh" "${output_dir}" || exit 1
#"./modules/http_splitting.sh" "${output_dir}" || exit 1
#"./modules/open_redirect.sh" "${output_dir}" || exit 1 
#"./modules/race_condition.sh" "${output_dir}" || exit 1 to hard to understand
#"./modules/request_smuggling.sh" "${output_dir}" || exit 1
#"./modules/server_side_request_forgery.sh" "${output_dir}" || exit 1
#"./modules/sql_injection.sh" "${output_dir}" || exit 1
#"./modules/xss_injection.sh" "${output_dir}" || exit 1 
#"./modules/xxe_injection.sh" "${output_dir}" || exit 1 #need to find tools that can be added (not done)
#"./modules/buckets.sh" "${output_dir}" || exit 1 (not done)
#"./modules/json_web_token.sh" "${output_dir}" || exit 1 #we need to check first if the site even uses JWT (not done)
#"./modules/post_message.sh" "${output_dir}" || exit 1 #tools cant be imported (not done)

#"./modules/subdomain_takeover.sh" "${output_dir}" || exit 1 #(not done,i have no idea how to use can-i-take-over-xyz )
"./modules/vulnerability_scanning.sh" "${output_dir}" "${scan_mod}" "${scan_speed}" || exit 1




#useless:
#"./modules/passwords.sh" || exit 1 #i have no idea what we should do with this (its a basic account brute force )
#"./modules/secrets.sh" || exit 1 #it check for api,passwords etc.. but in our code 


#for module in  screenshots   http_splitting  subdomain_takeover vulnerability_scanning; do
#    "./modules/${module}.sh" -i "${output_dir}/subdomains.txt" -o "${output_dir}/${module}" -t "${threads}" "${depth}" || exit 1
#done

# Generate final report
#"./modules/report_generator.sh" -i "${output_dir}" -o "${output_dir}/final_report.txt" || exit 1
 
echo "Pentesting completed successfully. Results can be found in ${output_dir}/final_report.txt."




#input:scope and rules for chat-gpt out:params for port_scannig,subdomian,cotact descovier
#port_scannig,subdomian,cotact descovier,list for tools for chat-gpt out:params for every one
#in:combined output of tools for chat-gpt out:soultion for probloms