#!/bin/bash



output_dir=$1
ip=""
subdomains="${output_dir}/subdomains.txt"
ip_addresses=""
nmap_args=$2











get_subdomain_ips() {

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


for ip in "${ip_addresses[@]}"
do
nmap $nmap_args
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
echo "[*] Running Nmap..."
#nmapScanHandler



# Masscan

#masscan -p1-65535 $ip_address -oL $output_dir/masscan.txt --rate=10000
masscanScanHandler(){
    
    if [[ "$scan_speed" == "s" ]]; then
        speed="1000"
    elif [[ "$scan_speed" == "m" ]]; then
        speed="5000"
    elif [[ "$scan_speed" == "f" ]]; then
        speed="10000"
    fi

    for ip in "${ip_addresses[@]}"; do
        if [[ $scan_mod == "a" ]]; then
            sudo masscan -p1-65535 "$ip" -oL "$output_dir/masscan.txt" --rate "$speed"
        elif [[ $scan_mod == "s" || $scan_mod == "S" ]]; then
            sudo masscan -sS -Pn -p1-65535 "$ip" -oL "$output_dir/masscan.txt" --rate "$speed"
        elif [[ $scan_mod == "d" || $scan_mod == "D" ]]; then
            sudo masscan -sU -p1-65535 "$ip" -oL "$output_dir/masscan.txt" --rate "$speed"
        fi
    done

}
#masscanScanHandler






echo "[+] Port scanning complete! Output saved to: $outdir"

