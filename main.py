
import pandas as pd
import csv
from bardapi import Bard
import re
import subprocess
import time
import openai
import pandas as pd
import subprocess
import json
import requests

import requests

url = "https://api.writesonic.com/v2/business/content/chatsonic?engine=premium&language=en"

payload = {
    "enable_google_results": "false",
    "enable_memory": False,
    "input_text": ""
}

headers = {
    # 'Accept-Encoding': 'gzip, deflate',
    'Connection': 'keep-alive',
    # Already added when you pass json=
    # 'Content-Type': 'application/json',
    'User-Agent': 'python-requests/2.28.1',
    'accept': 'application/json',
    'token': '787bce2b-1c6e-4c24-b665-1d7274c73826',
}





API_KEY = ''  # Replace with your actual API key
openai.api_key = API_KEY
model_id = 'gpt-3.5-turbo'
print("starting buging")
def chatgpt_conversation(conversation_log):
    response = openai.ChatCompletion.create(
        model=model_id,
        messages=conversation_log
    )
    conversation_log.append({
        'role': response.choices[0].message['role'], 
        'content': response.choices[0].message['content'].strip()
    })
    return conversation_log

token = ''
bardcode = Bard(token=token)
def extract_identifiers(csv_file):
    identifiers = []
    with open(csv_file, 'r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            if row['asset_type'] == 'URL' and row['eligible_for_bounty'] == 'true' and row['eligible_for_submission'] == 'true':
                identifiers.append(row['identifier'])

    return identifiers


def read_file(filename):
    with open(filename, 'r', encoding='utf-8') as file:
        return file.read()




#args list format [nmap -a -b -c -bbc ,masscan -a -b -c -bbc]
def run_scan1(args_as_list,scope_text):
    args_string = '^'.join(args_as_list)
    scope_string = '^'.join(scope_text)
    print(scope_string)
    subprocess.run("find . -type f -print0 | xargs -0 dos2unix", shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    subprocess.call(["bash", "scan1.sh", args_string,scope_string])
def remove_colons(string):
    # Check if the input is a string
    if not isinstance(string, str):
        raise TypeError("Input must be a string")
    

    try:
        # Remove colons from the string
        modified_string = string.replace(":", "")

        try:
            # Remove https from the string
            new_string = modified_string.replace("https//$domain/", "\"$domain\"")
            return new_string
        
        except Exception:
           
            try:
                 #if can't find https add "" to $domain
                new_string = modified_string.replace("$domain", "\"$domain\"") 
                return new_string
            except Exception:
                #if $domain not exists return default
                return modified_string
    
    except Exception:
        try:
            #if $domain has "" goes back
            new_string = string.replace("\"$domain\"", "\"{$domain}\"")
            return new_string
        except Exception:
            
            try:
                #if $domain doesn't have "" adds them
                new_string = string.replace("$domain", "\"$domain\"") 
                return new_string
            except Exception:
                #if $domain not exists return default
                return string
           

        
    

def get_parms_for_tool(rules_text, tool):
    
    payload["input_text"] = f'Important: Generate parameters for the {tool} tool based on the scope and rules "{rules_text}".The parameters should be in the following format:{tool}: (the parameters for the command).You can refer to the target as $domain.The target must always be included in the command.add sudo before the command if needed.dont add proxy.The output of the tools will be saved to ~/Desktop/output/ and the name of the file will be "tool_name".Only wordlists that allowed is  /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt .*responed with the requested command only with no explanation*.Always comply with the rules.Do not explain anything.Double-check that the command parameters follow the stated rules.' 
    json_data = {
    'question': payload["input_text"],
    'chat_history': [],
    }
    response = requests.post('https://api.writesonic.com/v1/botsonic/botsonic/generate/0ef137ad-b46b-4d99-a17d-93ca247254e6', headers=headers, json=json_data)
    print(response.text)
    conversation_log = [{'role': 'system', 'content':f'Extract the bash command from \"{response.text}\" and print it out without additional text.If no command is found, please return \"None\".'}]
    print("extracting commands...")
    print("")
    conversation_log = chatgpt_conversation(conversation_log)
    print(conversation_log[-1]['content'])
    content=remove_colons(conversation_log[-1]['content'])
    print(content)
    arg=content
    time.sleep(10)
    return arg  

def get_arg_for_tools(rules_text, tools_list):
    
    args = []
    count=0
    for tool in tools_list:
        count +=1
        print(f'finding parms for {tool} {count} out of {len(tools_list)}')
        print("")
        content=get_parms_for_tool(rules_text,tool)
        tries=1
        max_tries=5
        while (content == "None") or (content == 'There is no bash command present in the sentence "I\'m not programmed to assist with that.", so the answer is "None".') and tries <= max_tries:
            print(f'failed to find parms retring attempt number {tries}')
            content=get_parms_for_tool(rules_text,tool)
            tries+=1
        print(f'found parms')
        print("")
        args.append(content)
        #args.append(bardcode.get_answer(f'important part plz remeber: based on scope ["{scope_text}"] and rules ["{rules_text}"] make parms for {tool} and make sure you answer only the parms in this format "{tool}: (the parms for the command)" instead of saying all the domains u can refer to it as $domains and dont include output parms,(really important!: always comply with the rules), without explaining anything,Dont Explain,and double check that the command parms follows the stated rules')) 
        time.sleep(5) 
    return args



 


if __name__ == "__main__":
    scope_csv_path = "scope.csv"
    rules_file_path = "rules.txt"
    tools_list = ["nmap"
                  ,"dirsearch"
                  ,"gospider"
                  #,"hakrawler"
                  ]  # Replace with your list of tools

    scope_text = extract_identifiers(scope_csv_path)
    rules_text = read_file(rules_file_path)
    
    args = get_arg_for_tools(rules_text,tools_list)
    #args = ['nmap -T5 -A -sS -p- -oN ~/Desktop/output/nmap.txt $domain --script=vuln', 'feroxbuster -u $domain -w /path/to/wordlist -H "X-Hackerone bobus2710" -t 30 -k -o ~/Desktop/output/feroxbuster.txt', 'dirsearch -u "https//$domain/" -e html,php,asp,aspx,jsp -w /path/to/wordlist.txt --force-extensions -F -t 30 -b -r -R -x 400,404 -H "X-Hackerone bobus2710" -o ~/Desktop/output/dirsearch.txt', 'gospider -s \"$domain\" -o ~/Desktop/output/\"gospider.txt\" -a \"X-Hackerone bobus2710\" -H \"X-Hackerone bobus2710\" -r -t 5 -d 3 -u https//\"$domain\" -c 30 -k -v -w']
    print(args)
    run_scan1(args,scope_text)

   
    #print(arg['content'])




    #print(commands)