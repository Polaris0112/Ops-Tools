#!/usr/bin/env python

import pymongo
import sys

backup_uri = ""
mongo_uri = ""
restore_db = sys.argv[1]
origin_db = sys.argv[2]
restore_table = sys.argv[3]
restore_key = sys.argv[4]
resotre_value = sys.argv[5]

print "Restore data..."

##find backup data
back_con = pymongo.MongoClient(backup_uri)
back_db = back_con[restore_db]
restore_doc =  back_db[restore_table].find_one({restore_key:restore_value})
back_con.close()

##update to origin database
origin_conn = pymongo.MongoClient(mongo_uri)
origin_db = origin_conn[origin_db]
origin_db[resotre_table].remove({restore_key:restore_value})
origin_db[resotre_table].insert(restore_doc)
origin_conn.close()

print "Restore data done."

