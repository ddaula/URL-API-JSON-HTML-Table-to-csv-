#!/bin/ksh
#######################################################################
# Purpose       : Generates TOken and Gets projectids from 2 url's    #
#                                                                     #
# Created By    : Dharmesh Daula                                      #
# Date          : Jan-2019                                            #
#                                                                     #
#######################################################################
. /u03/informatica/.informatica.env

exec 2> ${INFA_SHARED}/SrcFiles/svc/GPT_API/logs/GPT_API_TEMPLATE.errlog
exec 1> ${INFA_SHARED}/SrcFiles/svc/GPT_API/logs/GPT_API_TEMPLATE.log

export GPT_API_SRC=${INFA_SHARED}/SrcFiles/svc/GPT_API
export GPT_API_SCRIPT=${INFA_SHARED}/ScriptFiles/svc/GPT_API

rm -f ${GPT_API_SRC}/Template_Objects.csv ${GPT_API_SRC}/Template_XML.xml
curl -X GET   'https://ausdwotcntsvfe1.aus.amer.dell.com/otcs/cs.exe/api/v1/webreports/GetTemplateObjects' -u EBIAccountDIT:dZYu3NCb95vePmzt --insecure > ${GPT_API_SRC}/Template_XML.xml

rm -f ${GPT_API_SRC}/template.csv
Template_FIle_Ordered=$(cat ${GPT_API_SRC}/Template_XML.xml | sed 's/\\n/\n/g' | sed 's/\\t/\t/g' | sed 's/\\//g')
ATTRIB=0
while IFS= read -r line
do
   #printf "<%s>\n" "$line"
   COUNT=$(echo $line | grep -qi '<TR>' && echo '0')
   #echo $COUNT
   COUNTF=$([ -z "$COUNT" ] && echo '1' || echo '0')
   COUNT2=$(echo $line | grep -qi "<\TR>" && echo '0')
   #echo $COUNT
   COUNTL=$([ -z "$COUNT2" ] && echo '1' || echo '0')

   if [ $ATTRIB -eq 1 ]; then
	ATTRIB1=$(echo $line |  sed -n 's:.*<TD>\(.*\)</TD>.*:\1:p')
	ATTRIB=$((ATTRIB+1))
#	echo first if $ATTRIB1 $ATTRIB
   elif [ $ATTRIB -eq 2 ]; then
        ATTRIB2=$(echo $line |  sed -n 's:.*<TD>\(.*\)</TD>.*:\1:p')
        ATTRIB=$((ATTRIB+1))
#        echo first if $ATTRIB2 $ATTRIB
   elif [ $ATTRIB -eq 3 ]; then
        ATTRIB3=$(echo $line |  sed -n 's:.*<TD>\(.*\)</TD>.*:\1:p')
        ATTRIB=$((ATTRIB+1))
#        echo first if $ATTRIB3 $ATTRIB
   elif [ $ATTRIB -eq 4 ]; then
        ATTRIB4=$(echo $line |  sed -n 's:.*<TD>\(.*\)</TD>.*:\1:p')
        ATTRIB=$((ATTRIB+1))
#        echo first if $ATTRIB4 $ATTRIB
   elif [ $ATTRIB -eq 5 ]; then
        ATTRIB5=$(echo $line |  sed -n 's:.*<TD>\(.*\)</TD>.*:\1:p')
        ATTRIB=$((ATTRIB+1))
#        echo first if $ATTRIB5 $ATTRIB
   elif [ "$COUNTF" -eq "0" ]; then
# 	echo second if $line
        ATTRIB=1
   elif [ $ATTRIB -eq 6 ]; then
        ATTRIB=0
        echo \"$ATTRIB1\",\"$ATTRIB2\",\"$ATTRIB3\",\"$ATTRIB4\",\"$ATTRIB5\" >> ${GPT_API_SRC}/Template_Objects.csv
   fi 
done <<< "$Template_FIle_Ordered"
