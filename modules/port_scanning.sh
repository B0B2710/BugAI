#!/bin/bash


if [ -z "$1" ] || [ -z "$3"]
then
    echo "Usage: ./port_scanning.sh <ip_address> <output_dir (optional)> <scan_mod>"
    exit 1
fi

ip=$1
output_dir=$2
scan_mod=$3
scan_speed=$4
subdomains=$5
ip_addresses=""
#nmap

get_subdomain_ips() {
    local domain="$1"

    # Iterate over subdomains and retrieve IP addresses
    for subdomain in $subdomains; do
        ip=$(nslookup -type=A "$subdomain" | awk '/^Address:/{print $2}')

        # Check if IP address already exists in the ip_addresses array
        if [[ ! " ${ip_addresses[@]} " =~ " ${ip} " ]]; then
            # Append IP address to the ip_addresses array
            ip_addresses+=("$ip")
        fi
    done
}

get_subdomain_ips
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

nmapScanHandler



# Masscan
echo "[*] Running Masscan..."
masscan -p1-65535 $ip_address -oL $output_dir/masscan.txt --rate=10000

# Nmap
echo "[*] Running Nmap..."
nmap -sS -p- -sV -T4 -iL $outdir/masscan.txt -oA $outdir/nmap

echo "[+] Port scanning complete! Output saved to: $outdir"

