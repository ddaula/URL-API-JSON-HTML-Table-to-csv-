#######################################################################
# Purpose       : Parse Json					                      #
# Created By    : Dharmesh Daula                                      #
# Date          : Jan-2019                                            #
#                                                                     #
#######################################################################
import json
import csv
import glob
# In[13]:
json.JSONDecoder()
for file in glob.glob("/u03/informatica/current/server/infa_shared/SrcFiles/svc/GPT_API/*.json"):
    #addrsfile = open(file,"r")
    # In[21]:
    with open(file, 'r') as f2:
        data = f2.read()
        print(file)
      #  print(data)
    # In[22]:
	type(data)
    # In[23]:
    	loaded_json = json.loads(data)
    # In[39]:
    	for i in range (0, len (loaded_json['components'])):
        		for j in range (0, len (loaded_json['components'][i]['qaAttributes'])):
                		db_data=list()
                		print (loaded_json['components'][i]['cid'] )
                		db_data.append(loaded_json['components'][i]['cid'])
                		print (loaded_json['components'][i]['cver'])
                		db_data.append(loaded_json['components'][i]['cver'])
                		print (loaded_json['components'][i]['cmin'])
                		db_data.append(loaded_json['components'][i]['cmin'])
                		print (loaded_json['components'][i]['tid'])
                		db_data.append(loaded_json['components'][i]['tid'])
                		print (loaded_json['project'])
                		db_data.append(loaded_json['project'])
                		print (loaded_json['components'][i]['qaAttributes'][j]['attrid'])
                		db_data.append(loaded_json['components'][i]['qaAttributes'][j]['attrid'])
                		print (loaded_json['components'][i]['qaAttributes'][j]['attrorigid'])
                		db_data.append(loaded_json['components'][i]['qaAttributes'][j]['attrorigid'])
                		print(db_data)
				db_data.append(loaded_json['components'][i]['coreAttributes'][2]['attrvalue'][0])
     				print(db_data)
                		with open('/u03/informatica/current/server/infa_shared/SrcFiles/svc/GPT_API/GPT_API_PARSE.csv', 'a+') as writeFile:
                            		writer = csv.writer(writeFile)
                            		writer.writerow(db_data)
