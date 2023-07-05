#!/bin/bash


scope_list=$1
output_dir=$2
gobuster_args=$3
feroxbuster_args=$4
dirsearch_args=$5
gospider_args=$6
hakrawler_args=$7


for domain in "${scope_list[@]}"
do
    #gobuster
    echo "[*] Running gobuster..."
    #gobuster dir -q -u $domain -w /usr/share/wordlists/dirb/common.txt -o $outdir/gobuster.txt -k
    gobuster $gobuster_args

    # Feroxbuster
    echo "[*] Running Feroxbuster..."
    #feroxbuster -u $domain -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o $outdir/feroxbuster.txt -k
    feroxbuster $feroxbuster_args
    # Dirsearch
    echo "[*] Running Dirsearch..."
    #dirsearch -u $domain -e php,asp,aspx,jsp,html,zip,jar,txt,log -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o $outdir/dirsearch.txt -t 50 -r -f
    dirsearch $dirsearch_args
    # Gospider
    echo "[*] Running Gospider..."
    #gospider -S $domain -w -c 10 -o $outdir/gospider.txt
    gospider $gospider_args
    # Hakrawler
    echo "[*] Running Hakrawler..."
    #hakrawler -url $domain -depth 2 -plain -insecure -outfile $outdir/hakrawler.txt
    hakrawler $hakrawler_args
done




echo "[+] Content discovery complete! Output saved to: $outdir"

