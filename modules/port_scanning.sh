#!/bin/bash



output_dir=$1
args_string=$2
error_file=$3
IFS='^' read -ra args_list <<< "$args_string"
ip=""
subdomains="${output_dir}/subdomains.txt"
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


get_subdomain_ips


for domain in "${ip_addresses[@]}"; do
    echo "[*] Running Nmap on ${domain}"
    $nmap_args 2> "error.txt"
done

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

