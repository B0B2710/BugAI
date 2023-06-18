#!/bin/bash

if [ -z "$1" ]
then
    echo "Usage: ./content_discovery.sh <domain>"
    exit 1
fi

domain=$1
output_dir=$2
scan_mod=$3
scan_speed=$4

# Create output directory
outdir=$output_dir/content_discovery
mkdir -p $outdir

# Gobuster
echo "[*] Running Gobuster..."
gobuster dir -q -u $domain -w /usr/share/wordlists/dirb/common.txt -o $outdir/gobuster.txt -k


# Determine scan speed
if [[ "$scan_speed" == "m" || "$scan_speed" == "M" ]]; then
    gobuster_speed="medium"
elif [[ "$scan_speed" == "s" || "$scan_speed" == "S" ]]; then
    gobuster_speed="slow"
elif [[ "$scan_speed" == "f" || "$scan_speed" == "F" ]]; then
    gobuster_speed="fast"
else
    gobuster_speed="medium"  # Default to medium if scan speed is not specified or invalid
fi

# Determine gobuster options based on scan mode
if [[ "$scan_mod" == "a" || "$scan_mod" == "A" ]]; then
    gobuster_options="-a -e -k -q -u $domain -w $wordlist -o $outdir/gobuster.txt"
elif [[ "$scan_mod" == "s" || "$scan_mod" == "S" ]]; then
    gobuster_options="-q -u $domain -w $wordlist -o $outdir/gobuster.txt"
else
    gobuster_options="-u $domain -w $wordlist -o $outdir/gobuster.txt"  # Default to basic scan if scan mode is not specified or invalid
fi




# Feroxbuster
echo "[*] Running Feroxbuster..."
feroxbuster -u $domain -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o $outdir/feroxbuster.txt -k

# Dirsearch
echo "[*] Running Dirsearch..."
dirsearch -u $domain -e php,asp,aspx,jsp,html,zip,jar,txt,log -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o $outdir/dirsearch.txt -t 50 -r -f

# Dirsearch (Go implementation)
echo "[*] Running GoDirsearch..."
GoDirSearch -u $domain -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o $outdir/godirsearch.txt -t 50 -r -f

# Gospider
echo "[*] Running Gospider..."
gospider -S $domain -w -c 10 -o $outdir/gospider.txt

# Hakrawler
echo "[*] Running Hakrawler..."
hakrawler -url $domain -depth 2 -plain -insecure -outfile $outdir/hakrawler.txt

echo "[+] Content discovery complete! Output saved to: $outdir"

