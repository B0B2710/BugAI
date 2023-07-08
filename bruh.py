
import pandas as pd
import csv
from bardapi import Bard
import re
import subprocess
import time
import openai
import pandas as pd
import subprocess
import sys

tool_buged=sys.argv[1]
tool_index=int(sys.argv[2])
module_path=sys.argv[3]
args_string=sys.argv[4]
output_dir=sys.argv[5]
error_file_to_pass=sys.argv[6]

#get the error content
error_file= open("error.txt", "r")
error_content = error_file.read()
error_file.close()
#get the original list of args
delimiter = "^"
args = args_string.split(delimiter)
broken_command=args[tool_index]


API_KEY = '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'  # Replace with your actual API key
openai.api_key = API_KEY
model_id = 'gpt-3.5-turbo'
print("fixing command")
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
def run_scan_again(args_as_list,scope_text):
    args_string = '^'.join(args_as_list)
    scope_string = '^'.join(scope_text)
    subprocess.call(["bash",module_path,output_dir,args_string,error_file_to_pass,scope_string])


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
    con =bardcode.get_answer(f'**Important:this {broken_command} was generated with this ([ Based on the scope and rules:"{rules_text}", generate parameters for the **{tool}** tool.* The parameters should be in the following format: {tool}: (the parameters for the command) .* You can refer to the target as `"$domain"`.* the output of the tools will be to a folder on the Desktop named output and the name of the file is tool_name.txt ,the only wordlists that are allowed to use are thoses that 100% installed with the tools used, previous command generated {broken_command} , the error : {error_content} .* Always comply with the rules.* Do not explain anything.* Double-check that the command parameters follow the stated rules.]) promot is *not working* and returned this {error_content} *Fix it and still follow the instructions of the previous promot*')
    conversation_log = [{'role': 'system', 'content':f'extract the bash command from "{con["content"]}" and print it out without additional text if You cant print it out just say "None" '}]
    print("extracting commands...")
    print("")
    conversation_log = chatgpt_conversation(conversation_log)
    content=remove_colons(conversation_log[-1]['content'])
    arg=content
    #args.append(bardcode.get_answer(f'important part plz remeber: based on scope ["{scope_text}"] and rules ["{rules_text}"] make parms for {tool} and make sure you answer only the parms in this format "{tool}: (the parms for the command)" instead of saying all the domains u can refer to it as $domains and dont include output parms,(really important!: always comply with the rules), without explaining anything,Dont Explain,and double check that the command parms follows the stated rules')) 
    return arg

def get_arg_for_tools(rules_text,tool):

    
    #print(f'finding parms for {tool} {count} out of {len(tools_list)}')
    print(f'fixing args for the tool {tool}')
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
    args[tool_index]=content
    #args.append(bardcode.get_answer(f'important part plz remeber: based on scope ["{scope_text}"] and rules ["{rules_text}"] make parms for {tool} and make sure you answer only the parms in this format "{tool}: (the parms for the command)" instead of saying all the domains u can refer to it as $domains and dont include output parms,(really important!: always comply with the rules), without explaining anything,Dont Explain,and double check that the command parms follows the stated rules')) 
    

if __name__ == "__main__":
    scope_csv_path = "scope.csv"
    rules_file_path = "rules.txt"

    scope_text = extract_identifiers(scope_csv_path)
    rules_text = read_file(rules_file_path)
    
    get_arg_for_tools(rules_text,tool_buged) 
    print(args)
    run_scan_again(args,scope_text)

   
    #print(arg['content'])




    #print(commands)