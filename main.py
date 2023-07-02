import openai
import pandas as pd
import csv

API_KEY = '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'  # Replace with your actual API key
openai.api_key = API_KEY
model_id = 'gpt-3.5-turbo'

def extract_identifiers(csv_file):
    identifiers = []
    with open(csv_file, 'r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            identifier = row.get('identifier')
            if identifier:
                identifiers.append(identifier)
    return identifiers

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

def read_file(filename):
    with open(filename, 'r', encoding='utf-8') as file:
        return file.read()

def get_params_for_tools(scope_text, rules_text, tools_list):
    params_list = []

    for tool in tools_list:
        conversation_log = [{'role': 'system', 'content': f'important part plz remeber:make parms for {tool},masscan and make sure you answer only the parms in this format "{tool}: (the parms for the command)" instead of saying all the domains u can refer to it as $domains and dont include output parms, the scan must be as affective as it can be but not overpass the rules, the , without explaining anything,DONT EXPLAIN , doesnt matter what you CANT EXPLAIN JUST GIVE THE PLAIN COMMAND!!. based on scope "{scope_text}" and rules "{rules_text}" '}]
        conversation_log = chatgpt_conversation(conversation_log)
        params = conversation_log[-1]['content']
        params_list.append(params)

    return params_list

if __name__ == "__main__":
    scope_csv_path = "scope.csv"
    rules_file_path = "rules.txt"
    tools_list = ["nmap", "masscan"]  # Replace with your list of tools

    scope_text = extract_identifiers(scope_csv_path)
    print(scope_text)
    rules_text = read_file(rules_file_path)

    params_list = get_params_for_tools(scope_text, rules_text, tools_list)
    print(params_list)