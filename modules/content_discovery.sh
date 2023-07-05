#!/bin/bash


domain=$1
output_dir=$2


# Create output directory
outdir=$output_dir/content_discovery
mkdir -p $outdir



#gobuster
echo "[*] Running gobuster..."
gobuster dir -q -u $domain -w /usr/share/wordlists/dirb/common.txt -o $outdir/gobuster.txt -k

# Feroxbuster
echo "[*] Running Feroxbuster..."
feroxbuster -u $domain -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o $outdir/feroxbuster.txt -k

# Dirsearch
echo "[*] Running Dirsearch..."
dirsearch -u $domain -e php,asp,aspx,jsp,html,zip,jar,txt,log -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o $outdir/dirsearch.txt -t 50 -r -f

# Gospider
echo "[*] Running Gospider..."
gospider -S $domain -w -c 10 -o $outdir/gospider.txt

# Hakrawler
echo "[*] Running Hakrawler..."
hakrawler -url $domain -depth 2 -plain -insecure -outfile $outdir/hakrawler.txt

echo "[+] Content discovery complete! Output saved to: $outdir"

