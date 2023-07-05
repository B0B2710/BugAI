
import pandas as pd
import csv
from bardapi import Bard

#API_KEY = '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'  # Replace with your actual API key

token = 'XwjlF04MT1t5eGHPdg7-YgaoekM_RD9JpccHjGXhDRJpQZTk4L41lJhI1VQZQFVK925JZA.'
bardcode = Bard(token=token)
#tools 
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


def get_text_between_quotes(text):
    #finish this one and run run_scan1 
  """Gets the text between two sets of double quotes."""
  start_index = text.find("'''")
  end_index = text.find("'''", start_index + 3)
  return text[start_index + 3:end_index]

#args list format [nmap -a -b -c -bbc ,masscan -a -b -c -bbc,]
def run_scan1(args_as_list):
    args_string = ' '.join(args_as_list)
    scope_string = extract_identifiers(scope_csv_path)
    subprocess.call(["bash", "scan1.sh",args_string,scope_string])

def get_arg_for_tools(scope_text, rules_text, tools_list):

    arg = bardcode.get_answer(f'based on scope ["{scope_text}"] and rules "{rules_text}" make parms for {tools_list} and answer in this format "nmap (the parms for the command)," instead of saying all the domains u can refer to it as $domain output each tool to $output_dir/tool_name/tool_name.txt')['content']
    return arg

if __name__ == "__main__":
    scope_csv_path = "scope.csv"
    rules_file_path = "rules.txt"
    tools_list = ["nmap", "masscan"]  # Replace with your list of tools

    scope_text = extract_identifiers(scope_csv_path)
    rules_text = read_file(rules_file_path)

    params_list = get_arg_for_tools(scope_text, rules_text, tools_list)
    print(params_list)