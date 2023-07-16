import json

# Read the JSON file
with open('db.json', 'r') as file:
    db = json.load(file)


#update data 
db['xss'] = 'true'




# Write the updated data back to the JSON file
with open('db.json', 'w') as file:
    json.dump(db, file)