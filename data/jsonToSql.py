import json

#configuration options
FILE_NAME= "game_logos.json"
TABLE = "games"
NEW_COLUMN = "logo"
NEW_COLUMN_TYPE=NEW_COLUMN+" VARCHAR(511)"
JSON_KEY="name"


data = None
with open(FILE_NAME) as jfile:
    data = json.load(jfile)

print(data["Doom 3"])

#if data!=None:
#    with open(FILE_NAME+".sql","w") as sql:
#        sql.write("ALTER TABLE "+TABLE+"\n   ADD "+NEW_COLUMN_TYPE+";\n")
#        for key in data.keys():
#            sql.write("UPDATE "+TABLE+"\n   SET "+NEW_COLUMN+" = '"+data[key]
#                    +"'\n   WHERE "+JSON_KEY+" = '"+key.replace("'","\\'")+"';\n")
