#!/bin/ksh

#######################################################################
# Purpose       : Retrieves Json for the respective projectids and    #
#                 parses the json to a csv file                       #
# Created By    : Dharmesh Daula                                      #
# Date          : Jan-2019                                            #
#                                                                     #
#######################################################################
. /u03/informatica/.informatica.env

exec 2> ${INFA_SHARED}/SrcFiles/svc/GPT_API/logs/GPT_API_JSON_PARSE.errlog
exec 1> ${INFA_SHARED}/SrcFiles/svc/GPT_API/logs/GPT_API_JSON_PARSE.log

export GPT_API_SRC=${INFA_SHARED}/SrcFiles/svc/GPT_API
export GPT_API_SCRIPT=${INFA_SHARED}/ScriptFiles/svc/GPT_API
rm -f ${GPT_API_SRC}/*.json
export IFS=","
cat ${GPT_API_SRC}/file.csv | while read a b c; do 
ticket=$(curl -X POST "https://ausdwotcntsvfe1.aus.amer.dell.com/otcs/cs.exe/api/v1/auth" -d "username=EBIAccountDIT&password=dZYu3NCb95vePmzt" --insecure)
token=$(echo "$ticket"|sed 's/{"ticket":"//g'|sed 's/"}//g'|sed 's/\\\//\//g')
url="https://ausdwotcntsvfe1.aus.amer.dell.com/otcs/cs.exe/amcsapi/v1/techspec/solution?projectID=$a&projectRev=$b"
echo $url
#curl -X GET 'https://ausdwotcntsvfe1.aus.amer.dell.com/otcs/cs.exe/amcsapi/v1/techspec/solution?projectID=CORYREGION2&projectRev=01' -H 'OTCSTicket: R8kuq5XgikdWikgBrvJReyxXMfZ1zpUtWY9EUbOB1chNMKkvbx5SJ7Hz0fQKb+1Bk74rBCg7kM5eKjwXGm2yM7QTT8qe5OcIMmqVARFZow2M6yLrdZ9jqg==' -u EBIAccountDIT:dZYu3NCb95vePmzt --insecure --insecure >> test234.json
curl -X GET "https://ausdwotcntsvfe1.aus.amer.dell.com/otcs/cs.exe/amcsapi/v1/techspec/solution?projectID=${a}&projectRev=${b}" -H "OTCSTicket: ${token}" -u EBIAccountDIT:dZYu3NCb95vePmzt --insecure > ${GPT_API_SRC}/$a-$b.json
echo "$a:$b:$token"; done
grep -l "error" ${GPT_API_SRC}/*.json | xargs rm -f
python ${GPT_API_SCRIPT}/Gpt_APi_Json_Parse.py
