import json

#configuration options
FILE_NAME= "publisher_logos.json"
TABLE = "publishers"
NEW_COLUMN = "logo"
NEW_COLUMN_TYPE=NEW_COLUMN+" VARCHAR(255)"
JSON_KEY="publisher"


data = None
with open(FILE_NAME) as jfile:
    data = json.load(jfile)
if data!=None:
    with open(FILE_NAME+".sql","w") as sql:
        sql.write("ALTER TABLE "+TABLE+"\n   ADD "+NEW_COLUMN_TYPE+";\n")
        for key in data.keys():
            sql.write("UPDATE "+TABLE+"\n   SET "+NEW_COLUMN+" = '"+data[key]
                    +"'\n   WHERE "+JSON_KEY+" = '"+key.replace("'","\\'")+"';\n")
