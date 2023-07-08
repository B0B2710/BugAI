
import pandas as pd
import csv
from bardapi import Bard
import re
import subprocess
import time
import openai
import pandas as pd
import subprocess
API_KEY = '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'  # Replace with your actual API key
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

token = 'XwjlF04MT1t5eGHPdg7-YgaoekM_RD9JpccHjGXhDRJpQZTk4L41lJhI1VQZQFVK925JZA.'
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
        return modified_string
    except Exception:
        return string

def get_parms_for_tool(rules_text, tool):
    con =bardcode.get_answer(f'Important: Generate parameters for the {tool} tool based on the scope and rules "{rules_text}".The parameters should be in the following format:{tool}: (the parameters for the command).You can refer to the target as "$domain".The target must always be included in the command.The output of the tools will be saved to ~/Desktop/output/ and the name of the file will be "tool_name.txt". The double quotes are important.Only wordlists that are 100% installed with the tools used are allowed to be used.Always comply with the rules.Do not explain anything.Double-check that the command parameters follow the stated rules.')
    conversation_log = [{'role': 'system', 'content':f'Extract the bash command from \"{con["content"]}\" and print it out without additional text. If you encounter any bugs, please try to fix them and proceed with the extraction. If no command is found, please return \"None\".'}]
    print("extracting commands...")
    print("")
    conversation_log = chatgpt_conversation(conversation_log)
    content=remove_colons(conversation_log[-1]['content'])
    arg=content
    #args.append(bardcode.get_answer(f'important part plz remeber: based on scope ["{scope_text}"] and rules ["{rules_text}"] make parms for {tool} and make sure you answer only the parms in this format "{tool}: (the parms for the command)" instead of saying all the domains u can refer to it as $domains and dont include output parms,(really important!: always comply with the rules), without explaining anything,Dont Explain,and double check that the command parms follows the stated rules')) 
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
        while content == "None" and tries <= max_tries:
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
    tools_list = ["nmap","gobuster","feroxbuster","dirsearch","gospider","hakrawler"]  # Replace with your list of tools

    scope_text = extract_identifiers(scope_csv_path)
    rules_text = read_file(rules_file_path)
    
    args = get_arg_for_tools(rules_text,tools_list)
    #args= ['nmap -T4 -p- -o "$output_dir/nmap.txt" "$domain"', 'gobuster -w "$wordlist" -t 30 -u "$domain" -o "$output_dir/gobuster.txt"', 'feroxbuster -w "$wordlist" -t 30 -u "$domain" -o "$output_dir/feroxbuster.txt"', 'dirsearch -w "$wordlist" -t 30 -u "$domain" -o "$output_dir/dirsearch.txt"', 'gospider -t 30 -u "$domain" -o "$output_dir/gospider.txt" -f "$wordlist"', 'hakrawler -d 2 -t 30 -u "$domain" -o "$output_dir/hakrawler.txt" -w "$wordlist"']

    print(args)
    run_scan1(args,scope_text)

   
    #print(arg['content'])




    #print(commands)