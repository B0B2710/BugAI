
import pandas as pd
import csv
from bardapi import Bard
import re
#API_KEY = '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'  # Replace with your actual API key

token = 'XwjlF04MT1t5eGHPdg7-YgaoekM_RD9JpccHjGXhDRJpQZTk4L41lJhI1VQZQFVK925JZA.'
bardcode = Bard(token=token)
def extract_identifiers(csv_file):
    identifiers = []
    with open(csv_file, 'r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            identifier = row.get('identifier')
            if identifier:
                identifiers.append(identifier)
    return identifiers


def read_file(filename):
    with open(filename, 'r', encoding='utf-8') as file:
        return file.read()


def extract_command(text, tool_name):
    """Extracts the command for the given tool name and arguments from the given text."""
    pattern = r"{} (.+?)(?=$|\snmap|\smasscan|\sgobuster)".format(tool_name)
    matches = re.findall(pattern, text, re.DOTALL)
    return [match.strip() for match in matches]



#args list format [nmap -a -b -c -bbc ,masscan -a -b -c -bbc]
#*def run_scan1(args_as_list):
#    args_string = ' '.join(args_as_list)
#    subprocess.call(["bash", "scan1.sh", args_string])

def get_arg_for_tools(scope_text, rules_text, tools_list):

    args = []
    for tool in tools_list:
        args.append(bardcode.get_answer(f'based on rules "{rules_text}" make parms for {tool} and output only the args," dont include output parms and the toolname in the command and give only one command for each tool that is as efficienive and id allowed by the rules very important'))  
    return args

if __name__ == "__main__":
    scope_csv_path = "scope.csv"
    rules_file_path = "rules.txt"
    tools_list = ["nmap", "masscan"]  # Replace with your list of tools

    scope_text = extract_identifiers(scope_csv_path)
    rules_text = read_file(rules_file_path)

    arg = get_arg_for_tools(scope_text, rules_text,tools_list)
    #text = "Sure, here are the parameters for the commands you mentioned, using the scope and rules you provided:**Nmap**Use code with caution. Learn more nmap -sT -p- $domainsnmap -sV -p- $domains nmap -sS -p- $domains nmap --script whois-domain $domains nmap --script smb-enum-domains $domains Code snippet **Masscan** Use code with caution. Learn more masscan -p0-65535 -iL $domains Code snippet **Gobuster** Use code with caution. Learn more gobuster -w /usr/share/wordlists/common.txt -u $domains -t 30 Please note that these are just a few examples of parameters that you can use. You may need to adjust them depending on the specific hosts and services you are scanning. You should also carefully read the rules and policiesof the program you are participating in before running any scans.Here are some additional tips for using these commands:Use the -sT option for a TCP connect scan, which is the most reliable way to scan for open ports.Use the -sV option to perform version detection, which can help you identify the specific software running on a host.Use the -sS option for a SYN scan, which is a less reliable way to scan for open ports but is less likely to be blocked by firewalls.Use the whois-domain script to enumerate domains associated with a host.Use the smb-enum-domains script to enumerate domains associated with a host that is running Microsoft Windows.Use the -w option to specify a wordlist of common usernames and passwords.Use the -u option to specify the URL of the host you want to scan.Use the -t option to specify the number of concurrent threads to use.I hope this helps!"
    for e in arg:
        print("code:")
        print(e["code"])
    for e in arg:
        print("Text: /n")
        print(e["content"])
    #print(arg['content'])




    #print(commands)