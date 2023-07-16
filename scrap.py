import requests
from bs4 import BeautifulSoup
import sys
import json
#domain = sys.argv[1]
domain = "tide.co"
# Define the URL you want to scrape
url="https://www."+domain
Tech_url = "https://builtwith.com/"+domain
# Read the JSON file
with open('db.json', 'r') as file:
    json_data = json.load(file)

def find_item_by_url(url, data):
    # Iterate over the URLs
    for item in data["urls"]:
        if item["url"] == url:
            return item
        
        # Check the suburls
        for subitem in item["suburls"]:
            if subitem["url"] == url:
                return subitem
    
    # If URL is not found, return None
    return None


item = find_item_by_url(url, json_data)

if item:
        
    #******************************************************** Find Technologies



    # Send a GET request to the URL
    response = requests.get(Tech_url)

    # Create a BeautifulSoup object with the response text
    Tech_soup = BeautifulSoup(response.text, "html.parser")

    # Find all <div> elements with class "col-12"
    TECH_divs = Tech_soup.find_all("div", class_="col-12")
    Technologys=[]
    # Iterate over the found <div> elements
    for div in TECH_divs:
        # Find the <h2> element inside the current <div>
        h2 = div.find("h2")
        
        # Check if <h2> element exists
        if h2:
            # Find the <a> tag inside the <h2> element
            a = h2.find("a")
            
            # Check if <a> tag exists
            if a:
                # Get the text of the <a> tag
                item["technologies"].extend([a.get_text()])
    #******************************************************** xss tags
    # List of XSS tags to search for

    response = requests.get(url)

    # Create a BeautifulSoup object with the response text
    Xss_SQL_soup = BeautifulSoup(response.text, "html.parser")





    xss_tags = [
        "script",
        "img",
        "a",
        "div",
        "iframe",
        "svg",
        "body",
        "embed",
        "video",
        "input",
        "button",
        "form",
        "object",
        "style",
        "link",
        "meta",
        "textarea",
        "base",
        "applet",
        "frame",
        "frameset",
        "table",
        "marquee",
        "audio",
        "blink",
        "title",
        "plaintext",
        "xml",
        "xss",
        "alert",
        "svg/onload",
        "img/src=x onerror=alert(1)",
        "a href=javascript:alert(1)",
        "img src='x' onerror='javascript:alert(1)'",
        "img src='x' onmouseover='alert(1)'",
        "a href='#' onclick='alert(1)'",
        "a href='javascript:alert(1)'",
        "img src=x onerror=alert(String.fromCharCode(88,83,83))",
        "img src=x onerror=prompt(1)",
        "img src=x oneonerrorrror=alert(1)"
    ]


    # Find all tags in the XSS list
    XSS_found_tags = Xss_SQL_soup.find_all(xss_tags)

    if XSS_found_tags:
        #update data 
        item ['xss'] = True
    #******************************************************** sql tags
    # List of SQL injection tags to search for
    sql_injection_tags = [
        "input",
        "textarea",
        "select",
        "form",
        "option",
        "optgroup",
        "datalist",
        "keygen",
        "output"
    ]

    # Find all tags in the SQL injection list
    SQL_found_tags = Xss_SQL_soup.find_all(sql_injection_tags)

    # Iterate over the found tags
    if SQL_found_tags:
        #update data 
        item['sql_injection'] = True

    #**********************************************************Must Still in the end
    with open('db.json', 'w') as file:
        json.dump(json_data, file, indent=2)
else:
    print("No matching object found for the URL:", url)