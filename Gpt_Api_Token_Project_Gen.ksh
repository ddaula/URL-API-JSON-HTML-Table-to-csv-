#!/bin/ksh
#######################################################################
# Purpose       : Generates TOken and Gets projectids from 2 url's    #
#                                                                     #
# Created By    : Dharmesh Daula                                      #
# Date          : Jan-2019                                            #
#                                                                     #
#######################################################################
. /u03/informatica/.informatica.env

exec 2> ${INFA_SHARED}/SrcFiles/svc/GPT_API/logs/GPT_API_TOKEN_GEN.errlog
exec 1> ${INFA_SHARED}/SrcFiles/svc/GPT_API/logs/GPT_API_TOKEN_GEN.log

export GPT_API_SRC=${INFA_SHARED}/SrcFiles/svc/GPT_API
export GPT_API_SCRIPT=${INFA_SHARED}/ScriptFiles/svc/GPT_API

rm -f ${GPT_API_SRC}/project_file.xml ${GPT_API_SRC}/projid.txt ${GPT_API_SRC}/file.csv ${GPT_API_SRC}/error_file.csv ${GPT_API_SRC}/*.json
dateinput="${GPT_API_SCRIPT}/dateinput.txt"
while IFS= read -r var
do
        proj_id_date=$var

done < "$dateinput"

curl -X GET   'https://ausdwotcntsvfe1.aus.amer.dell.com/otcs/cs.exe/api/v1/webreports/GetProjectByDate' -d 'inputlabel1="$proj_id_date"' --insecure -u EBIAccountDIT:dZYu3NCb95vePmzt > ${GPT_API_SRC}/project_file.xml

DATE=`date +%d-%m-%Y`
echo $DATE > ${GPT_API_SCRIPT}/dateinput.txt

#EXTRACT DATA FROM ABOVE XML
cat ${GPT_API_SRC}/project_file.xml | sed 's/\\n/\n/g' | sed 's/\\t/\t/g' | sed 's/\\//g' | awk 'NR>1' | sed 's/\"}//g' | sed -n 's:.*<TD>\(.*\)<\/TD>.*:\1:p' > ${GPT_API_SRC}/projid.txt

input="${GPT_API_SRC}/projid.txt"
#rm -f ${GPT_API_SRC}/file.csv ${GPT_API_SRC}/error_file.csv
while IFS= read -r var
do
        CHARCHK=$(echo "$var" | grep ',' >/dev/null 2>&1)
        COUNT=$(echo $var| tr -cd '-' | wc -c)
        if [ $COUNT -eq "1" ]; then
        #       echo "Found - in string"
                PROJECTID=$(sed 's/^\(.*\)-.*$/\1/' <<< $var)
                VERSION=$(sed 's/^.*-\([^-]*\)$/\1/' <<< $var)
        #       echo "$PROJECTID  "
        #       echo "$VERSION "
                #COUNT=$(echo $var| tr -cd '-' | wc -c)
                printf '%s\n' $PROJECTID $VERSION $COUNT | paste -sd ',' >> ${GPT_API_SRC}/file.csv
        elif [ $COUNT -ne "1" ] && [ "$CHARCHK" = "0" ]; then
                #echo "Couldnt find it"
                printf '%s\n' $var | paste -sd ',' >> ${GPT_API_SRC}/error_file.csv
        fi
done < "$input"
