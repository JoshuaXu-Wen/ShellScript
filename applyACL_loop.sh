#!/bin/bash

# set facl for specific user and group
special_user_permissions="/tmp/special_user_permissions.txt"
special_group_permissions="/tmp/special_group_permissions.txt"
#sample patterns: 
 #user:18736:r-x---a---c--s:------I:allow:/data/crp/Sales_Projects/50 (00000 - 01000 TAM-N (North America)/50-00826A PRECorp MPT-IP 10 Sites VHF/Submision/Section 11-2B_MTBF.pdf
 #group:solution:rwxp-D-A---C--:------I:deny:/data/crp/Sales_Projects/54 (00001-00500) TLA/00095 VM Lapierre_Tia Maria/ftp Tia maria Septiembre 2010/Brochures/TP8100/TP8100_brochure_Spanish.pdf
grep "user:" "$1" >$special_user_permissions
grep "group:" "$1" >$special_group_permissions

awk -F ':' '{
      CONVERTPMS = "";
      if (index($3, "r") || index($3, "c") || index($3, "a")) {
            CONVERTPMS = CONVERTPMS "r";
      }
      else {
            CONVERTPMS = CONVERTPMS "-"
      }
      if (index($3, "w") || index($3, "p") || index($3, "d") || index($3, "D")) {
            CONVERTPMS = CONVERTPMS "w";
      }
      else {
            CONVERTPMS = CONVERTPMS "-";
      }
      if (index($3, "D") || index($3, "x")) {
            CONVERTPMS = CONVERTPMS "x";
      }
      else {
            CONVERTPMS = CONVERTPMS "-";
      }
     if (index($4, "f") || index($4, "d")) {
         print "setfacl -m d:u:" $2 ":" CONVERTPMS " " substr($0, index($0, $6));  
     }
     else 
         print "setfacl -m u:" $2 ":" CONVERTPMS " " substr($0, index($0, $6));  
}' $special_user_permissions > /tmp/setUserPermission.sh


awk -F ':' '{
      CONVERTPMS = "";
      if (index($3, "r") || index($3, "c") || index($3, "a")) {
            CONVERTPMS = CONVERTPMS "r";
      }
      else {
            CONVERTPMS = CONVERTPMS "-"
      }
      if (index($3, "w") || index($3, "p") || index($3, "d") || index($3, "D")) {
            CONVERTPMS = CONVERTPMS "w";
      }
      else {
            CONVERTPMS = CONVERTPMS "-";
      }
      if (index($3, "D") || index($3, "x")) {
            CONVERTPMS = CONVERTPMS "x";
      }
      else {
            CONVERTPMS = CONVERTPMS "-";
      }
     if (index($4, "f") || index($4, "d")) {
         print "setfacl -m d:u:" $2 ":" CONVERTPMS " " substr($0, index($0, $6));  
     }
     else 
         print "setfacl -m u:" $2 ":" CONVERTPMS " " substr($0, index($0, $6));  
}' $special_group_permissions > /tmp/setGroupPermission.sh

# while IFS=';' read -r line
# do
#   CONVERTPMS=""
#   USERNAME=$(echo -e "$line" | awk -F':' '{print $2}') # user names in the ACL entries
#   PERMISSIONS=$(echo -e "$line" | awk -F':' '{print $3}') # user privileges of files
#   INHERIT=$(echo -e "$line" | awk -F':' '{print $4}') # the inherit flags
#   SWITCH=$(echo -e "$line" | awk -F':' '{print $5}') # only apply 'allow' entries
#   FILE=$(echo -e "$line" | awk -F':' '{print substr($0, index($0, $6))}') # filename
  
#   if [ "$SWITCH" = "deny" ]
#   then 
# 	break 
#   fi
#   if echo -e "$PERMISSIONS" | grep -E 'r|c|a'
#   then 
# 	CONVERTPMS+='r'
#   fi
#   if echo -e "$PERMISSIONS" | grep -E 'w|p|d|D'
#   then
# 	CONVERTPMS+='w'
#   fi 
#   if echo -e "$PERMISSIONS" | grep -E 'D|x'
#   then 
# 	CONVERTPMS+='x'
#   fi
#   # if no permission is assigned to user
#   if [ $CONVERTPMS = '' ] 
#   then
#         CONVERTPMS='---'
#   fi

#   setfacl -b "$FILE"
#   # whether should set Inherit/default flag
#   if echo -e "$INHERIT" | grep -E 'f|d'
#   then 
#         setfacl -m d:u:"$USERNAME":"$CONVERTPMS" "$FILE"
#   else
#         setfacl -m u:"$USERNAME":"$CONVERTPMS" "$FILE"
#   fi
# done <$special_user_permissions

# while IFS=';' read -r line
# do
#   CONVERTPMS=""
#   GROUPNAME=$(echo -e "$line" | awk -F':' '{print $2}') # group names in the ACL entries
#   PERMISSIONS=$(echo -e "$line" | awk -F':' '{print $3}') # group privileges of files
#   INHERIT=$(echo -e "$line" | awk -F':' '{print $4}') # the inherit flags
#   SWITCH=$(echo -e "$line" | awk -F':' '{print $5}') # only apply 'allow' entries
#   FILE=$(echo -e "$line" | awk -F':' '{print substr($0, index($0, $6))}') # filename

#   if [ "$SWITCH" = 'deny' ]
#   then
#         break
#   fi
#   if echo -e "$PERMISSIONS" | grep -E 'r|c|a' 
#   then
#         CONVERTPMS+='r'
#   fi
#   if echo -e "$PERMISSIONS" | grep -E 'w|p|d|D|o'
#   then
#         CONVERTPMS+='w'
#   fi
#   if echo -e "$PERMISSIONS" | grep -E 'D|x'
#   then
#         CONVERTPMS+='x'
#   fi
#   # if no permission is assigned to user
#   if [ $CONVERTPMS = '' ] 
#   then
#         CONVERTPMS='---'
#   fi
#   # whether should set Inherit/default flag
#   if echo -e "$INHERIT" | grep -E 'f|d'
#   then 
#         setfacl -m d:g:"$GROUPNAME":"$CONVERTPMS" "$FILE"
#   else
#         setfacl -m g:"$GROUPNAME":"$CONVERTPMS" "$FILE"
#   fi 

# done <$special_group_permissions

