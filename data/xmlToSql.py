from xml.etree import ElementTree
import pymysql

#XML reading configuration options
FILE_NAME = "game_trailers.xml"
XML_SUBDATA_TAG = "Game" 
#XML_TAG = "Youtube" 
XML_TAG = "genre" 
XML_ID =  "GameTitle"


#SQL writing configuration options
SQL_UNIQUE_TABLE = "games"
SQL_OTHER_TABLE = "genres"
SQL_OTHER_COLUMN= "genre"
SQL_RELATION_TABLE = "genres_of_games"
SQL_UNIQUE_COLUMN = "name"
#SQL_NEW_COLUMN = "name"

tree = ElementTree.parse(FILE_NAME)
root = tree.getroot()

conn = pymysql.Connect(host="127.0.0.1",user="atlas",database="gamedb")
curs = conn.cursor()
curs.execute("SELECT DISTINCT "+SQL_UNIQUE_COLUMN+", id FROM "+SQL_UNIQUE_TABLE)
tags = {}
ids = {}
for row in curs:
    ids[row[0]] = row[1]
    tags[row[0]] = []

curs = conn.cursor()
curs.execute("SELECT DISTINCT "+SQL_OTHER_COLUMN+", id FROM "+SQL_OTHER_TABLE)
other_ids = {}
for row in curs:
    other_ids[row[0]] = row[1] 
conn.close()

for piece in root.iter(XML_SUBDATA_TAG):
    if piece.iter(XML_ID) != None:
        for xmlId in piece.iter(XML_ID):
            for xmlTag in piece.iter(XML_TAG):
                if xmlId.text in tags and xmlTag.text not in tags[xmlId.text]:
                    tags[xmlId.text].append(xmlTag.text)

print (tags)

with open(FILE_NAME+".sql","w") as sql:
    visited = {}
    for key, value in tags.items():
        for v in value:
            if v not in other_ids and v not in visited:
                visited[v]=True
                sql.write("INSERT INTO "+SQL_OTHER_TABLE+"\n   ("
                    +SQL_OTHER_COLUMN+") VALUES\n   "
                    +"('"+v.replace("'","\\'")+"');\n")
