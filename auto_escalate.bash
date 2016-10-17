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
#Set thresholds
#Flag notifications
#Do Notifications
#Log notifications
#Cleanup
