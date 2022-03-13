import csv
from datetime import datetime
from sqlite3 import Cursor
import xml
from pymongo import MongoClient
import dns
from time import sleep, strftime
import pandas

todb = MongoClient('mongodb+srv://ramayuda:tM8rYl7u5XwJEFlY@rama-cluster.vwaq8.mongodb.net')
 
def insert():
    global todb
    mydb = todb['easybuild']
    mycol = mydb['verifed']
    data = {'nama' : 'rama'}
    x = mycol.insert_one(data)
    print('succes')

def export():
    global todb
    mydb = todb['easybuild']
    mycol = mydb['verifed']
    Cursor = mycol.find()
    mongo_docs = list(Cursor)
    docs = pandas.DataFrame(columns=["_id","name"])
    for num, doc in enumerate( mongo_docs ):
        doc["_id"] = str(doc["_id"])
        doc_id = doc["_id"]
        series_obj = pandas.Series(doc, name=doc_id)
        docs = docs.append( series_obj )
    
    tanggal = datetime.now()
    convert = tanggal.strftime("%H-%M-%S")
    docs.to_csv(convert+'.csv',index=False)


while True :
    try :
        sleep(5)
        export()
        print('succes')
        
    except KeyError:
        print('salah')

