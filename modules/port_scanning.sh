#!/bin/bash



output_dir=$1
args_string=$2
error_file=$3
IFS='^' read -ra args_list <<< "$args_string"
ip=""
subdomains_file="${output_dir}/subdomains.txt"
ip_addresses=""
nmap_args=${args_list[0]}



get_subdomain_ips() {
    # Iterate over subdomains and retrieve IP addresses
    for subdomain in "${subdomains[@]}"; do
        ip=$(nslookup -type=A "$subdomain" | awk '/^Address:/{print $2}')

        # Remove port number from IP address if present
        ip_without_port=$(echo "$ip" | cut -d '#' -f 1)

        # Check if IP address without port already exists in the ip_addresses array
        if [[ ! " ${ip_addresses[@]} " =~ " ${ip_without_port} " ]]; then
            # Append IP address without port to the ip_addresses array
            ip_addresses+=("$ip_without_port")
        fi
    done
}


check_error() {
    exit_status=$1
    tool_name=$2
    output_file=$3
    tool_index_in_py=$4
    
    if [ $exit_status -ne 0 ]; then
        echo "Error: $tool_name encountered an error. Exit status: $exit_status"
        python3 bruh.py "$tool_name" "$tool_index_in_py" "$full_path" "$args_string" "$output_dir" "$error_file"
        exit
    fi
}

while IFS= read -r domain; do
    if curl --head --silent --fail $domain 2> /dev/null;
        then
        echo "[*] Running Nmap on ${domain}"
        sudo $nmap_args 2> "error.txt"
        check_error $? "nmap" "$output_dir/nmap.txt" "0"
        else
        echo "This ${domain} does not exist."
    fi
    
done < "$subdomains_file"






#nmap
#nmap -sS -p- -sV -T4 -iL $outdir/masscan.txt -oA $outdir/nmap
nmapScanHandler() {
    
    funcStartTime="start time: $current_datetime"

    if [[ "$scan_speed" == "s" ]]; then
        speed="T1"
    elif [[ "$scan_speed" == "m" ]]; then
        speed="T3"
    elif [[ "$scan_speed" == "f" ]]; then
        speed="T5"
    fi
    for ip in "${ip_addresses[@]}"; do
        if [[ $scan_mod == "a" ]]; then
            sudo nmap -sS -sU "$speed" -A -v -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script discovery "$ip" -oN "$output_dir"/portscan.txt
            sudo nmap -p- -sV -O -sF "$speed" -A "$ip" -oN "$output_dir"/portscan.txt
        elif [[ $scan_mod == "s" || $scan_mod == "S" ]]; then
            sudo nmap -sS -Pn -p- -sV -O "$speed" "$ip" -oN "$output_dir"/portscan.txt
        elif [[ $scan_mod == "d" || $scan_mod == "D" ]]; then
            sudo nmap -sU -sS "$speed" "$ip" -oN "$output_dir"/portscan.txt
            sudo nmap -O -sF "$speed" "$ip" -oN "$output_dir"/portscan.txt
        fi
    done


}
# Nmap








echo "[+] Port scanning complete! Output saved to: $outdir"

