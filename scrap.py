import requests

url = 'https://api.tide.co'
myobj = {'api': '1'}

x = requests.post(url, json = myobj)

print(x.text)