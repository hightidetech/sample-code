#!/bin/bash

###################
## auto_escalate ##
###################

#set -x;

IFS='
;'

#Run query to pull filtered case data

sql="SELECT SR_ID, SEVERITY, ACCOUNT, SUPPORT_LEVEL, SUPPORT_TIER, OWNER, \
STATUS, CREATED, CASE WHEN STATUS = 'Closed' THEN TRUNC(24 * ROUND((CLOSED_DATE - CREATED),2)) \
                   ELSE TRUNC(24 * ROUND((SYSDATE - CREATED),2)) \
              END AS "AGE_IN_HOURS" FROM crm.support_tickets  \
      WHERE OWNER IN ('ENG1','ENG2','ENG3','ENG4','ENG5','ENG6','ENG7','ENG8','ENG9','ENG10','ENG11','ENG12') \
      AND PROBLEM = 'Technical Support' \
      AND CREATED> 'October 1, 2016' \
      AND SOURCE NOT LIKE 'Proactive' \
      AND SERVICE_REQUEST_TYPE = 'Customer' \
      AND (SUPPORT_LEVEL NOT LIKE '%Self%') \
      AND RESOLVED_DATE IS NULL \
ORDER BY SEVERITY ASC \
";

###########
## ADD query Lookup here and dump to tab sep'd file
## CASE_TBL = sql.execute > ./unresolved.txt
###########

#Pull relevant vars out of table data

for ENTRY in `cat ./unresolved.txt`; do
  #SR_ID SEVERITY ACCOUNT SUPPORT_LEVEL SUPPORT_TIER OWNER STATUS CREATED
AGE_IN_HOURS
  SR_ID=`echo $ENTRY | awk 'BEGIN {FS="\t"}; {print $1}'`;
  declare -i SEVERITY=`echo $ENTRY | awk 'BEGIN {FS="\t"}; {print $2}'`;
  SUPPORT_LEVEL=`echo $ENTRY | awk 'BEGIN {FS="\t"}; {print $4}'`;
  AGE_IN_HOURS=`echo $ENTRY | awk 'BEGIN {FS="\t"}; {print $9}'`;
  
#Set thresholds

if [[ $SUPPORT_LEVEL =~ Premium* ]]
then
  SEV1TH=0;
  SEV2TH=3;
  SEV3TH=72;
else
  SEV1TH=3;
  SEV2TH=24;
  SEV3TH=72;
fi

#Flag notifications
#Do Notifications
#Log notifications
#Cleanup
