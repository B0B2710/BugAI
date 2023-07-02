import openai
import pandas as pd

API_KEY = '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'  # Replace with your actual API key
openai.api_key = API_KEY
model_id = 'gpt-3.5-turbo'

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
        conversation_log = [{'role': 'system', 'content': f'Based on the scope {scope_text} and rules {rules_text}, make params for {tool}.'}]
        conversation_log = chatgpt_conversation(conversation_log)
        params = conversation_log[-1]['content']
        params_list.append(params)

    return params_list

if __name__ == "__main__":
    scope_csv_path = "scope.csv"
    rules_file_path = "rules.txt"
    tools_list = ["nmap", "masscan"]  # Replace with your list of tools

    scope_text = pd.read_csv(scope_csv_path).iloc[:, 0].astype(str).sum()
    rules_text = read_file(rules_file_path)

    params_list = get_params_for_tools(scope_text, rules_text, tools_list)
    print(params_list)